# Как работать с проектом DARP

Гайд для участников команды. Описание проекта — `docs/description.md`.
Правила для ИИ-агентов — `AGENTS.md`.

- Репозиторий: `CloudNative-urfu/darp`
- Доска: https://github.com/orgs/CloudNative-urfu/projects/1
- Спеки: OpenSpec, каталог `openspec/`

## Команда

| GitHub | Имя |
| --- | --- |
| `axstiz` | Матвей Вахрушев |
| `desmitry` | Dmitry Sergeevich |
| `sser1to` | Никита Лецколюк |
| `BruhWhyMeHaveNoIdea` | Alexander |
| `geekiot-hub` | Kirill Samoylenkov |

## Доступы и окружение

- Нужен доступ **write** к репозиторию. Права выдаёт владелец (`axstiz`).
- Авторизованный `gh` со scopes `repo` и `project`: `gh auth status`.
- OpenSpec CLI **версии 1.14.2** (обязательна): `npm install -g @fission-ai/openspec@1.14.2`.
  Если команда не в PATH, добавь в `~/.bashrc`: `export PATH="$HOME/.npm-global/bin:$PATH"`.
- `pre-commit` для локальных хуков: `pre-commit install --hook-type commit-msg`.

## Модель веток

- `develop` — интеграционная ветка (**default**). Сюда коммитятся спеки напрямую и идут PR'ы с кодом.
- `main` — релизная ветка. Защищена: только merge из `develop` через PR, прямое пушить нельзя.

## Главное правило: задача ↔ issue ↔ change

1. Каждая задача живёт как **issue** в `CloudNative-urfu/darp` и находится на доске.
2. У issue **обязательно** есть исполнитель (assignee) из команды.
3. Задача оформляется **OpenSpec change** в `openspec/changes/<номер-issue>-<slug>/`. Change без
   issue не существует.
4. Ссылки перекрёстные: в change — ссылка на issue, в теле issue — путь к change.

## Жизненный цикл задачи

1. **Issue + change.** Агент создаёт issue с исполнителем, добавляет на доску (`Backlog`) и заводит
   change. Вручную это делает `scripts/propose.sh "<title>" <assignee> <slug>`.
2. **Спека.** Агент заполняет `proposal.md`, `specs/`, `design.md`, `tasks.md` и валидирует
   (`openspec validate <change> --strict`). Спека коммитится в `develop`, статус на доске → `Ready`.
3. **Реализация.** Ветка от `develop` тем, кто указан исполнителем. Статус → `In progress`.
   Работаешь по `tasks.md`, отмечая пункты.
4. **PR.** PR в `develop`, squash-merge, в описании `Closes #<issue>`. Статус → `In review`.
5. **Мерж.** `openspec archive <change> -y` обновляет `openspec/specs/` и переносит change в
   `openspec/changes/archive/`. Статус → `Done`, issue закрывается автоматически.

## Работа со спеками (OpenSpec)

- Список активных change: `openspec list`
- Дашборд: `openspec view`
- Прочитать change: `openspec show <change>`
- Что делать по change (инструкция + чеклист задач): `openspec instructions apply --change <change>`
- Валидация: `openspec validate <change> --strict`

Человеку достаточно прочитать change-фолдер: `proposal.md` (зачем), `specs/` (что именно),
`design.md` (как), `tasks.md` (чеклист работ).

## Git

- Ветки от `develop`: `feat/<issue>-<slug>`, а также `fix/`, `docs/`, `chore/` по смыслу.
- Коммиты — Conventional Commits: `feat:`, `fix:`, `docs:`, `chore:`, `test:`, `refactor:`.
  Scope по желанию: `specs`, `infra`, `attack`, `defense`, `env`.
- PR — в `develop`, **squash-merge**, в описании `Closes #<issue>`.
- Блокирующие проверки CI: `openspec-validate` (валидность спек) и `commit-msg` (заголовок PR —
  conventional). Пока проверки не зелёные, PR смержить нельзя.
- Релизы: `develop → main` через PR (там требуется 1 ревью).

## Делегирование ИИ-агенту

Агенту достаточно дать задачу и напомнить про `AGENTS.md`: он сам заведёт issue с исполнителем,
добавит его на доску и подготовит change по OpenSpec. От тебя требуется ревью и утверждение.
