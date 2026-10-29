# AGENTS.md — правила работы для ИИ-агентов

Проект: **DARP (Defense, Attack Research Platform)** — исследовательский полигон для ИИ-агентов в
кибербезопасности. Полное описание — `README.md` и главный док `docs/guardrails-as-a-vector-of-attack.md`.

Репозиторий: `CloudNative-urfu/darp`
Доска проекта: https://github.com/orgs/CloudNative-urfu/projects/1

Этот файл обязателен к прочтению перед любой работой в репозитории.

## 0. Модель веток

- `research` — интеграционная ветка (default). Сюда merge'ятся PR с изменениями.
- `main` — релизная ветка, защищена. Напрямую пушить нельзя; изменения только через PR из `research`.

## 1. Главное правило: issue ↔ доска

Любая задача оформляется **issue** в репозитории `CloudNative-urfu/darp` и добавляется на доску.

Issue не может существовать вне доски. При создании issue агент в том же шаге ОБЯЗАН:

1. Добавить issue на доску `CloudNative-urfu/projects/1` (статус `Backlog`).
2. Назначить исполнителя (**assignee**) — одного из участников команды (см. таблицу ниже).

Если issue создать нельзя (нет прав, нет доступа к доске) — сообщи об этом и передай управление
человеку.

## Команда

| GitHub | Имя |
| --- | --- |
| `axstiz` | Матвей Вахрушев |
| `desmitry` | Dmitry Sergeevich |
| `sser1to` | Никита Лецколюк |
| `BruhWhyMeHaveNoIdea` | Alexander |
| `geekiot-hub` | Kirill Samoylenkov |

Исполнителя агент назначает как **предполагаемого**, исходя из задачи и загруженности. Автор задачи
может изменить исполнителя.

## Требования к окружению

- GitHub CLI `gh` со scopes `repo` и `project`; проверка `gh auth status`.
- `pre-commit` (для commit-msg hook). Установка хука: `pre-commit install --hook-type commit-msg`.
- Если нужных прав/инструментов нет — не обходи ограничение, сообщи человеку.

## Workflow агента

Задачи на реализацию берём из статуса **`Ready`**, не из `Backlog`. В `Backlog` — входящие
и ещё несформулированные задачи.

### 1. Проверить, нет ли уже issue

```bash
gh issue list -R CloudNative-urfu/darp --state open --search "<ключевые слова>"
```

### 2. Создать issue + добавить на доску

```bash
issue_url=$(gh issue create -R CloudNative-urfu/darp \
  --title "<краткий заголовок>" \
  --body "<описание задачи>" \
  --assignee <github-login-исполнителя>)

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

### 3. Реализация

- Ветка от `research`: `feat/<номер-issue>-<slug>` (либо `fix/`, `docs/`, `chore/`).
  Задача делается только в ветке; прямой пуш в `research` в контексте задачи запрещён
  (исключение — по явному запросу человека).
- Статус issue на доске → `In progress`.
- Коммиты — Conventional Commits (см. ниже).
- PR **в `research`**, squash-merge; в описании — `Closes #<номер-issue>`, статус → `In review`.
  С `Closes #N` PR свяжется с issue и сам появится у него на доске («Linked pull requests»).
- Блокирующая проверка CI: `commit-msg`.

### 4. Завершение

После мержа PR в `research`:

- Статус issue на доске → `Done` (issue закрывается сам по `Closes #N`).

## Доска

Issue добавляется на доску **DARP Board** (`projectV2(number: 1)`) и получает статус. Команды —
см. раздел «Workflow агента» выше.

Семантика поля `Status` (id `PVTSSF_lADOFDx2Cs4BmODnzhk37EQ`):

| Статус | option-id | Когда |
| --- | --- | --- |
| Backlog | `f75ad846` | issue создан, ещё не готов к взятию |
| Ready | `61e4505c` | задача сформулирована, дедлайн проставлен, ждёт исполнителя |
| In progress | `47fc9ee4` | идёт реализация |
| In review | `df73e18b` | открыт PR |
| Done | `98236657` | смержено в `research` |

## Соглашение о коммитах

Conventional Commits. Формат `<type>(<scope>): <description>`.

- Типы: `feat`, `fix`, `docs`, `build`, `ci`, `chore`, `test`, `refactor`, `perf`, `style`, `revert`.
- Рекомендуемые scope: `infra`, `attack`, `defense`, `env`, `docs`.
- Примеры: `docs: add literature review notes`, `feat(attack): add nmap tool wrapper`.

Проверка:

- Локально — pre-commit hook `commitizen` (`commit-msg`).
- В CI — workflow `commit-msg` (**блокирующий**). Так как PR мержатся squash'ем, проверяется
  заголовок PR: он должен быть conventional и совпадать с итоговым коммитом.

## Запреты

- Создавать issue без исполнителя из команды.
- Оставлять issue вне доски `CloudNative-urfu/projects/1`.
- Пушить напрямую в `main`.
- Пушить напрямую в `research` в контексте задачи — только ветка под задачу + PR
  (исключение — по явному запросу человека).
- Коммитить и пушить без явного запроса человека.
- Читать и изменять файлы секретов (`.env`, `secrets/`, ключи, токены, сертификаты).
