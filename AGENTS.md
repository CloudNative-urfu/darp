# AGENTS.md — правила работы для ИИ-агентов

Проект: **DARP (Defense, Attack Research Platform)** — исследовательский полигон для ИИ-агентов в
кибербезопасности. Полное описание — `docs/description.md`.

Репозиторий: `CloudNative-urfu/darp`
Доска проекта: https://github.com/orgs/CloudNative-urfu/projects/1
Спеки: **OpenSpec** (`openspec/`)

Этот файл обязателен к прочтению перед любой работой в репозитории.

## 0. Модель веток

- `develop` — интеграционная ветка (default). Сюда коммитятся **спеки напрямую** и merge'ятся PR с
  кодом.
- `main` — релизная ветка, защищена. Напрямую пушить нельзя; изменения только через PR из `develop`.

## 1. Главное правило: спека ↔ issue ↔ доска

Любая задача на реализацию оформляется **OpenSpec change** в `openspec/changes/<номер-issue>-<slug>/`.

**Change не может существовать без issue.** При создании спеки агент в том же шаге ОБЯЗАН:

1. Создать issue в репозитории `CloudNative-urfu/darp`.
2. Добавить issue на доску `CloudNative-urfu/projects/1` (статус `Backlog`).
3. Назначить исполнителя (**assignee**) — одного из участников команды (см. таблицу ниже).
4. Прописать перекрёстные ссылки: change ссылается на issue (`#N`), тело issue — на путь к change.

Если issue создать нельзя (нет прав, нет доступа к доске) — **не создавай change**. Сообщи о
проблеме и передай управление человеку.

## Команда

| GitHub | Имя |
| --- | --- |
| `axstiz` | Матвей Вахрушев |
| `desmitry` | Dmitry Sergeevich |
| `sser1to` | Никита Лецколюк |
| `BruhWhyMeHaveNoIdea` | Alexander |
| `geekiot-hub` | Kirill Samoylenkov |

Исполнителя агент назначает как **предполагаемого**, исходя из задачи и загруженности. Автор спеки
может изменить исполнителя на этапе ревью.

## Требования к окружению

- GitHub CLI `gh` с scopes `repo` и `project`; проверка `gh auth status`.
- OpenSpec CLI **версии 1.14.2** (обязательна для всех). Установка:
  `npm install -g @fission-ai/openspec@1.14.2`. Вызывай через `command -v openspec`; если не в PATH —
  `$HOME/.npm-global/bin/openspec`.
- `pre-commit` (для commit-msg hook). Установка хука: `pre-commit install --hook-type commit-msg`.
- Если нужных прав/инструментов нет — не обходи ограничение, сообщи человеку.

## Workflow агента

### 1. Проверить, нет ли уже issue/change

```bash
gh issue list -R CloudNative-urfu/darp --state open --search "<ключевые слова>"
"$HOME/.npm-global/bin/openspec" list
```

### 2. Создать issue + change

Быстрый путь — скрипт (делает шаги 2–3 автоматически):

```bash
scripts/propose.sh "<title>" <github-login-исполнителя> <slug>
```

Вручную:

```bash
issue_url=$(gh issue create -R CloudNative-urfu/darp \
  --title "<краткий заголовок>" \
  --body "Спека: \`openspec/changes/<issue>-<slug>/\`" \
  --assignee <github-login-исполнителя>)
```

Далее добавь issue на доску и выставь `Backlog` (см. раздел «Доска»), затем:

```bash
"$HOME/.npm-global/bin/openspec" new change "<номер-issue>-<slug>" --goal "<заголовок>"
```

Обнови тело issue ссылкой на реальный путь: `openspec/changes/<номер-issue>-<slug>/`.

### 3. Заполнить артефакты change

Артефакты схемы `spec-driven`: `proposal`, `specs`, `design`, `tasks`.

```bash
OPENSPEC="$HOME/.npm-global/bin/openspec"
"$OPENSPEC" instructions proposal --change "<change>"   # шаблон и инструкция
"$OPENSPEC" status --change "<change>"                  # что уже готово, что дальше
```

Заполни `openspec/changes/<change>/proposal.md`, `design.md`, `specs/<capability>/spec.md` (deltas
`## ADDED/MODIFIED/REMOVED Requirements` со сценариями) и `tasks.md` (чекбоксы `- [ ]`). Не оставляй
placeholder'ы. В `proposal.md` обязательна ссылка на issue.

### 4. Валидация (обязательно)

```bash
"$OPENSPEC" validate "<change>" --strict
```

Должно проходить без ошибок и предупреждений.

### 5. Коммит спеки в develop

Коммитить и пушить **только по явному запросу человека**. Спека уходит прямым коммитом в `develop`:

```bash
git checkout develop && git pull
git add openspec/changes/<change>
git commit -m "docs(specs): add <change>"
git push origin develop
```

После этого статус issue на доске → `Ready`.

### 6. Реализация

- Ветка от `develop`: `feat/<номер-issue>-<slug>` (либо `fix/`, `docs/`, `chore/`).
- Статус issue на доске → `In progress`.
- Коммиты — Conventional Commits (см. ниже).
- PR **в `develop`**, squash-merge; в описании — `Closes #<номер-issue>`, статус → `In review`.
- Блокирующие проверки CI: `openspec-validate` и `commit-msg`.

### 7. Завершение

После мержа реализации в `develop`:

```bash
OPENSPEC="$HOME/.npm-global/bin/openspec"
"$OPENSPEC" archive "<change>" -y         # обновит openspec/specs/, перенесёт change в archive
git add openspec && git commit -m "docs(specs): archive <change>"
git push origin develop
```

Статус issue на доске → `Done` (issue закрывается сам по `Closes #N`).

## Доска

Issue добавляется на доску **DARP Board** (`projectV2(number: 1)`) и получает статус.

```bash
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

Семантика поля `Status` (id `PVTSSF_lADOFDx2Cs4BmODnzhk37EQ`):

| Статус | option-id | Когда |
| --- | --- | --- |
| Backlog | `f75ad846` | issue создан, спека в работе |
| Ready | `61e4505c` | спека заполнена и в `develop` |
| In progress | `47fc9ee4` | идёт реализация |
| In review | `df73e18b` | открыт PR |
| Done | `98236657` | смержено в `develop`, change заархивирован |

## Соглашение о коммитах

Conventional Commits. Формат `<type>(<scope>): <description>`.

- Типы: `feat`, `fix`, `docs`, `build`, `ci`, `chore`, `test`, `refactor`, `perf`, `style`, `revert`.
- Рекомендуемые scope: `specs`, `infra`, `attack`, `defense`, `env`.
- Примеры: `docs(specs): add 12-llm-switch`, `feat(attack): add nmap tool wrapper`.

Проверка:

- Локально — pre-commit hook `commitizen` (`commit-msg`).
- В CI — workflow `commit-msg` (**блокирующий**). Так как PR мержатся squash'ем, проверяется
  заголовок PR: он должен быть conventional и совпадать с итоговым коммитом.

## Запреты

- Создавать change без привязанного issue.
- Создавать issue без исполнителя из команды.
- Оставлять issue вне доски `CloudNative-urfu/projects/1`.
- Пушить напрямую в `main`.
- Коммитить и пушить без явного запроса человека.
- Читать и изменять файлы секретов (`.env`, `secrets/`, ключи, токены, сертификаты).
