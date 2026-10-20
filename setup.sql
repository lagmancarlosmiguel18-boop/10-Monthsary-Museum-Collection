-- Run once in a fresh Supabase project's SQL Editor.
begin;
create table public.museum_rooms(id uuid primary key default gen_random_uuid(),owner uuid not null references auth.users(id) on delete cascade,invite_code text unique not null default replace(gen_random_uuid()::text,'-',''),created_at timestamptz not null default now());
create table public.museum_members(room_id uuid references public.museum_rooms(id) on delete cascade,user_id uuid references auth.users(id) on delete cascade,primary key(room_id,user_id));
create table public.museum_exhibits(id uuid primary key default gen_random_uuid(),room_id uuid not null references public.museum_rooms(id) on delete cascade,title text not null check(char_length(title) between 1 and 100),kind text not null check(kind in ('image','video')),path text unique not null,created_at timestamptz not null default now(),check(split_part(path,'/',1)=room_id::text));
create table public.museum_players(room_id uuid references public.museum_rooms(id) on delete cascade,user_id uuid references auth.users(id) on delete cascade,name text not null check(char_length(name) between 1 and 24),color text not null check(color ~ '^#[a-fA-F0-9]{6}$'),x double precision not null check(x between -11 and 11),z double precision not null check(z between -67 and 17),yaw double precision not null check(yaw between -100000 and 100000),heart bigint not null default 0,updated_at timestamptz not null default now(),primary key(room_id,user_id));
create index museum_exhibits_room_idx on public.museum_exhibits(room_id,created_at);
create index museum_members_user_idx on public.museum_members(user_id);
create function public.museum_is_member(r uuid) returns boolean language sql stable security definer set search_path='' as $$ select exists(select 1 from public.museum_members where room_id=r and user_id=auth.uid()); $$;
create function public.museum_is_owner(r uuid) returns boolean language sql stable security definer set search_path='' as $$ select exists(select 1 from public.museum_rooms where id=r and owner=auth.uid()); $$;
create function public.museum_create_room() returns public.museum_rooms language plpgsql security definer set search_path='' as $$
declare r public.museum_rooms;
begin
 if auth.uid() is null then raise exception 'Sign in first'; end if;
 if (select count(*) from public.museum_rooms where owner=auth.uid())>=5 then raise exception 'You already own five museums. Rejoin an existing museum using its code.'; end if;
 insert into public.museum_rooms(owner) values(auth.uid()) returning * into r;
 insert into public.museum_members values(r.id,auth.uid()); return r;
end; $$;
create function public.museum_join_room(code text) returns public.museum_rooms language plpgsql security definer set search_path='' as $$
declare r public.museum_rooms;
begin
 if auth.uid() is null then raise exception 'Sign in first'; end if;
 if code !~ '^[a-f0-9]{32}$' then raise exception 'Invalid invitation'; end if;
 select * into r from public.museum_rooms where invite_code=code for update;
 if not found then raise exception 'Invitation not found'; end if;
 if exists(select 1 from public.museum_members where room_id=r.id and user_id=auth.uid()) then return r; end if;
 if (select count(*) from public.museum_members where room_id=r.id)>=2 then raise exception 'This museum already has its two members'; end if;
 insert into public.museum_members values(r.id,auth.uid()); return r;
end; $$;
create function public.museum_stamp_player() returns trigger language plpgsql set search_path='' as $$ begin new.updated_at=now(); return new; end; $$;
create trigger museum_stamp_player before insert or update on public.museum_players for each row execute function public.museum_stamp_player();
create function public.museum_limit_exhibits() returns trigger language plpgsql security definer set search_path='' as $$
begin
 perform 1 from public.museum_rooms where id=new.room_id for update;
 if (select count(*) from public.museum_exhibits where room_id=new.room_id)>=24 then raise exception 'All 24 frames are filled'; end if;
 return new;
end; $$;
create trigger museum_limit_exhibits before insert on public.museum_exhibits for each row execute function public.museum_limit_exhibits();
alter table public.museum_rooms enable row level security;
alter table public.museum_members enable row level security;
alter table public.museum_exhibits enable row level security;
alter table public.museum_players enable row level security;
create policy museum_room_read on public.museum_rooms for select to authenticated using(public.museum_is_member(id));
create policy museum_members_read on public.museum_members for select to authenticated using(public.museum_is_member(room_id));
create policy museum_exhibit_read on public.museum_exhibits for select to authenticated using(public.museum_is_member(room_id));
create policy museum_exhibit_add on public.museum_exhibits for insert to authenticated with check(public.museum_is_owner(room_id));
create policy museum_exhibit_remove on public.museum_exhibits for delete to authenticated using(public.museum_is_owner(room_id));
create policy museum_player_read on public.museum_players for select to authenticated using(public.museum_is_member(room_id));
create policy museum_player_add on public.museum_players for insert to authenticated with check(user_id=auth.uid() and public.museum_is_member(room_id));
create policy museum_player_update on public.museum_players for update to authenticated using(user_id=auth.uid() and public.museum_is_member(room_id)) with check(user_id=auth.uid() and public.museum_is_member(room_id));
create policy museum_player_remove on public.museum_players for delete to authenticated using(user_id=auth.uid());
revoke all on public.museum_rooms,public.museum_members,public.museum_exhibits,public.museum_players from anon,authenticated;
grant select on public.museum_rooms,public.museum_members to authenticated;
grant select,insert,delete on public.museum_exhibits to authenticated;
grant select,insert,update,delete on public.museum_players to authenticated;
revoke all on function public.museum_is_member(uuid),public.museum_is_owner(uuid),public.museum_create_room(),public.museum_join_room(text),public.museum_stamp_player(),public.museum_limit_exhibits() from public,anon;
grant execute on function public.museum_is_member(uuid),public.museum_is_owner(uuid),public.museum_create_room(),public.museum_join_room(text) to authenticated;
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values('museum-media','museum-media',false,26214400,array['image/jpeg','image/png','image/webp','video/mp4']);
create policy museum_media_read on storage.objects for select to authenticated using(bucket_id='museum-media' and exists(select 1 from public.museum_rooms r where r.id::text=(storage.foldername(name))[1] and public.museum_is_member(r.id)));
create policy museum_media_add on storage.objects for insert to authenticated with check(bucket_id='museum-media' and exists(select 1 from public.museum_rooms r where r.id::text=(storage.foldername(name))[1] and public.museum_is_owner(r.id)));
create policy museum_media_remove on storage.objects for delete to authenticated using(bucket_id='museum-media' and exists(select 1 from public.museum_rooms r where r.id::text=(storage.foldername(name))[1] and public.museum_is_owner(r.id)));
commit;

-- Existing museum installations: run this ONCE (safe to rerun).
-- Allows the owner to edit ONLY the title column, not room IDs or file paths.
begin;
drop policy if exists museum_exhibit_edit_title on public.museum_exhibits;
create policy museum_exhibit_edit_title on public.museum_exhibits
for update to authenticated
using(public.museum_is_owner(room_id))
with check(public.museum_is_owner(room_id));
grant update(title) on public.museum_exhibits to authenticated;
commit;

-- Run on an existing museum project. Safe to rerun.
begin;
create table if not exists public.museum_music (
 room_id uuid primary key references public.museum_rooms(id) on delete cascade,
 title text not null check(char_length(title) between 1 and 100),
 path text unique not null,
 check(split_part(path,'/',1)=room_id::text)
);
alter table public.museum_music enable row level security;
revoke all on public.museum_music from anon,authenticated;
grant select,insert,update,delete on public.museum_music to authenticated;
drop policy if exists museum_music_read on public.museum_music;
create policy museum_music_read on public.museum_music for select to authenticated using(public.museum_is_member(room_id));
drop policy if exists museum_music_add on public.museum_music;
create policy museum_music_add on public.museum_music for insert to authenticated with check(public.museum_is_owner(room_id));
drop policy if exists museum_music_edit on public.museum_music;
create policy museum_music_edit on public.museum_music for update to authenticated using(public.museum_is_owner(room_id)) with check(public.museum_is_owner(room_id));
drop policy if exists museum_music_remove on public.museum_music;
create policy museum_music_remove on public.museum_music for delete to authenticated using(public.museum_is_owner(room_id));
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
values('museum-music','museum-music',false,26214400,array['audio/mpeg','audio/mp4','audio/ogg','audio/wav'])
on conflict(id) do update set public=false,file_size_limit=excluded.file_size_limit,allowed_mime_types=excluded.allowed_mime_types;
drop policy if exists museum_song_read on storage.objects;
create policy museum_song_read on storage.objects for select to authenticated using(bucket_id='museum-music' and exists(select 1 from public.museum_rooms r where r.id::text=(storage.foldername(name))[1] and public.museum_is_member(r.id)));
drop policy if exists museum_song_add on storage.objects;
create policy museum_song_add on storage.objects for insert to authenticated with check(bucket_id='museum-music' and exists(select 1 from public.museum_rooms r where r.id::text=(storage.foldername(name))[1] and public.museum_is_owner(r.id)));
drop policy if exists museum_song_remove on storage.objects;
create policy museum_song_remove on storage.objects for delete to authenticated using(bucket_id='museum-music' and exists(select 1 from public.museum_rooms r where r.id::text=(storage.foldername(name))[1] and public.museum_is_owner(r.id)));
commit;
