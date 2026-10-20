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
