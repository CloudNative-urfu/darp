# Как работать с проектом DARP

Гайд для участников команды. Описание проекта — `docs/description.md`.
Правила для ИИ-агентов — `AGENTS.md`.

- Репозиторий: `CloudNative-urfu/darp`
- Доска: https://github.com/orgs/CloudNative-urfu/projects/1

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
- `pre-commit` для локальных хуков: `pre-commit install --hook-type commit-msg`.

## Модель веток

- `develop` — интеграционная ветка (**default**). Сюда идут PR'ы.
- `main` — релизная ветка. Защищена: только merge из `develop` через PR, прямое пушить нельзя.

## Главное правило: задача ↔ issue ↔ доска

1. Каждая задача живёт как **issue** в `CloudNative-urfu/darp` и находится на доске.
2. У issue **обязательно** есть исполнитель (assignee) из команды.
3. Статус issue на доске отражает, где задача прямо сейчас.

## Жизненный цикл задачи

1. **Issue.** Создаётся issue с исполнителем и добавляется на доску (статус `Backlog`).
2. **Реализация.** Ветка от `develop` тем, кто указан исполнителем. Статус → `In progress`.
3. **PR.** PR в `develop`, squash-merge, в описании `Closes #<issue>`. Статус → `In review`.
4. **Мерж.** Статус → `Done`, issue закрывается автоматически по `Closes #N`.

Создание issue и добавление на доску:

```bash
issue_url=$(gh issue create -R CloudNative-urfu/darp \
  --title "<краткий заголовок>" \
  --assignee <github-login-исполнителя> \
  --body "<описание задачи>")

PROJECT_ID=$(gh api graphql -f query='
  query { organization(login: "CloudNative-urfu") { projectV2(number: 1) { id } } }' \
  --jq '.data.organization.projectV2.id')

ISSUE_ID=$(gh api repos/CloudNative-urfu/darp/issues/<N> --jq '.node_id')

ITEM_ID=$(gh api graphql -f query='
  mutation($project: ID!, $content: ID!) {
    addProjectV2ItemById(input: { projectId: $project, contentId: $content }) {
      item { id }
    }
  }' -f project="$PROJECT_ID" -f content="$ISSUE_ID" \
  --jq '.data.addProjectV2ItemById.item.id')

gh project item-edit --id "$ITEM_ID" --project-id "$PROJECT_ID" \
  --field-id PVTSSF_lADOFDx2Cs4BmODnzhk37EQ \
  --single-select-option-id f75ad846   # Backlog
```

Семантика статуса `Status` (id поля `PVTSSF_lADOFDx2Cs4BmODnzhk37EQ`):

| Статус | option-id | Когда |
| --- | --- | --- |
| Backlog | `f75ad846` | задача создана |
| In progress | `47fc9ee4` | идёт реализация |
| In review | `df73e18b` | открыт PR |
| Done | `98236657` | смержено в `develop` |

## Git

- Ветки от `develop`: `feat/<issue>-<slug>`, а также `fix/`, `docs/`, `chore/` по смыслу.
- Коммиты — Conventional Commits: `feat:`, `fix:`, `docs:`, `chore:`, `test:`, `refactor:`.
  Scope по желанию: `infra`, `attack`, `defense`, `env`, `docs`.
- PR — в `develop`, **squash-merge**, в описании `Closes #<issue>`.
- Блокирующая проверка CI: `commit-msg` (заголовок PR — conventional). Пока проверка не зелёная,
  PR смержить нельзя.
- Релизы: `develop → main` через PR (там требуется 1 ревью).

## Делегирование ИИ-агенту

Агенту достаточно дать задачу и напомнить про `AGENTS.md`: он сам заведёт issue с исполнителем
и добавит его на доску. От тебя требуется ревью и утверждение.
