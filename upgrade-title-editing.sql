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
