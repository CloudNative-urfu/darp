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

- `research` — основная интеграционная ветка (**default**). В неё мержатся PR из веток задач.
- `main` — релизная ветка. Номинальный релизный PR `research → main` делает владелец
  (`axstiz`) по мере релизов; остальным в него ходить не нужно.

## Главное правило: задача ↔ issue ↔ доска

1. Каждая задача живёт как **issue** в `CloudNative-urfu/darp` и находится на доске.
2. У issue **обязательно** есть исполнитель (assignee) из команды.
3. Статус issue на доске отражает, где задача прямо сейчас.

## Жизненный цикл задачи

1. **Issue.** Создаётся issue с исполнителем и добавляется на доску (статус `Backlog`).
2. **Реализация.** Ветка от `research` тем, кто указан исполнителем. Статус → `In progress`.
   См. «Воркфлоу участника» ниже.
3. **PR.** PR в `research`, squash-merge, в описании `Closes #<issue>`. Статус → `In review`.
4. **Мерж.** Статус → `Done`, issue закрывается автоматически по `Closes #N`.

## Воркфлоу участника: ветка под задачу + PR

У каждого issue — ровно одна ветка и ровно один PR. Работать в `research` в контексте задачи
напрямую нельзя: изменения только через ветку и PR.

1. **Возьми issue на доске** и переведи статус в `In progress`.
2. **Создай ветку от свежего `research`:**
   ```bash
   git switch research
   git pull
   git switch -c feat/<номер-issue>-<slug>     # или fix/, docs/, chore/ по смыслу
   ```
   Пример: `feat/6-prod-support-processes` для issue #6.
3. **Работай в ветке.** Коммиты — Conventional Commits (`docs: ...`, `feat: ...`).
   Пуши по мере работы:
   ```bash
   git push -u origin feat/6-prod-support-processes
   ```
4. **Открой PR в `research`** (не в `main`):
   ```bash
   gh pr create --base research --fill
   ```
   В описании обязательно `Closes #<номер-issue>` — такой PR свяжется с issue и сам
   появится у него на доске (поле «Linked pull requests»).
5. **Проверки.** CI `commit-msg` обязан быть зелёным (проверяется заголовок PR — при
   squash он станет итоговым коммитом). Локально хуки должны проходить:
   `pre-commit install --hook-type commit-msg`.
6. **Ревью и мерж.** Squash-merge после аппрува. PR открыт → статус issue `In review`;
   смержено → `Done` (issue закроется сам по `Closes #N`).
7. **Правки после ревью** пушатся в ту же ветку — PR обновляется сам.

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
| Done | `98236657` | смержено в `research` |

## Git

- Ветки от `research`: `feat/<issue>-<slug>`, а также `fix/`, `docs/`, `chore/` по смыслу.
- Коммиты — Conventional Commits: `feat:`, `fix:`, `docs:`, `chore:`, `test:`, `refactor:`.
  Scope по желанию: `infra`, `attack`, `defense`, `env`, `docs`.
- PR — в `research`, **squash-merge**, в описании `Closes #<issue>`.
- Блокирующая проверка CI: `commit-msg` (заголовок PR — conventional). Пока проверка не зелёная,
  PR смержить нельзя.
- Релизы: `research → main` через PR — делает владелец, участникам делать не нужно.

## Делегирование ИИ-агенту

Агенту достаточно дать задачу и напомнить про `AGENTS.md`: он сам заведёт issue с исполнителем
и добавит его на доску. От тебя требуется ревью и утверждение.
