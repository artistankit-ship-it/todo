-- Run this once in Supabase: SQL Editor → New query → paste → Run.
-- It creates one row per person holding their whole to-do list,
-- and locks it so only that signed-in person can read or change it.

create table if not exists public.todo_state (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.todo_state enable row level security;
grant select, insert, update on public.todo_state to authenticated;

drop policy if exists "read own list"   on public.todo_state;
drop policy if exists "add own list"    on public.todo_state;
drop policy if exists "update own list" on public.todo_state;

create policy "read own list" on public.todo_state
  for select using (auth.uid() = user_id);

create policy "add own list" on public.todo_state
  for insert with check (auth.uid() = user_id);

create policy "update own list" on public.todo_state
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
