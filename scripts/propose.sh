#!/usr/bin/env bash
set -euo pipefail

REPO="CloudNative-urfu/darp"
PROJECT_OWNER="CloudNative-urfu"
PROJECT_NUMBER=1
STATUS_FIELD_ID="PVTSSF_lADOFDx2Cs4BmODnzhk37EQ"
STATUS_BACKLOG_ID="f75ad846"

usage() {
	cat >&2 <<'EOF'
Usage: scripts/propose.sh "<title>" <assignee-login> <slug>

Пример:
  scripts/propose.sh "Переключение LLM в полигоне" axstiz llm-switch

Создаёт issue в CloudNative-urfu/darp, добавляет его на доску (Backlog)
и заводит OpenSpec change <issue>-<slug>.
EOF
	exit 1
}

[ "$#" -eq 3 ] || usage
title="$1"
assignee="$2"
slug="$3"

command -v gh >/dev/null 2>&1 || {
	echo "gh не найден в PATH" >&2
	exit 1
}
gh auth status >/dev/null 2>&1 || {
	echo "gh не авторизован" >&2
	exit 1
}

OPENSPEC="${OPENSPEC:-$(command -v openspec || true)}"
[ -n "$OPENSPEC" ] || OPENSPEC="$HOME/.npm-global/bin/openspec"
[ -x "$OPENSPEC" ] || {
	echo "openspec не найден: $OPENSPEC" >&2
	exit 1
}

EXPECTED_OPENSPEC_VERSION="1.14.2"
found_version=$("$OPENSPEC" --version 2>/dev/null || echo "unknown")
if [ "$found_version" != "$EXPECTED_OPENSPEC_VERSION" ]; then
	echo "warning: ожидается OpenSpec ${EXPECTED_OPENSPEC_VERSION}, найдено ${found_version}" >&2
fi

echo "==> Создаю issue..."
issue_url=$(gh issue create -R "$REPO" \
	--title "$title" \
	--body "Спека: \`openspec/changes/<issue>-${slug}/\`" \
	--assignee "$assignee")
issue_number="${issue_url##*/}"
change="${issue_number}-${slug}"
echo "    issue #${issue_number}: ${issue_url}"

gh issue edit "$issue_number" -R "$REPO" \
	--body "Спека: \`openspec/changes/${change}/\`" >/dev/null

echo "==> Добавляю на доску..."
project_id=$(gh api graphql -f query='
  query($owner: String!, $number: Int!) {
    organization(login: $owner) { projectV2(number: $number) { id } }
  }' -f owner="$PROJECT_OWNER" -F number="$PROJECT_NUMBER" \
	--jq '.data.organization.projectV2.id')

issue_id=$(gh api "repos/${REPO}/issues/${issue_number}" --jq '.node_id')
item_id=$(gh api graphql -f query='
  mutation($project: ID!, $content: ID!) {
    addProjectV2ItemById(input: { projectId: $project, contentId: $content }) {
      item { id }
    }
  }' -f project="$project_id" -f content="$issue_id" \
	--jq '.data.addProjectV2ItemById.item.id')

gh project item-edit --id "$item_id" --project-id "$project_id" \
	--field-id "$STATUS_FIELD_ID" \
	--single-select-option-id "$STATUS_BACKLOG_ID" >/dev/null
echo "    добавлено на доску (статус Backlog)"

echo "==> Создаю OpenSpec change..."
"$OPENSPEC" new change "$change" --goal "$title"

cat <<EOF

Готово.
  issue:  ${issue_url}
  change: openspec/changes/${change}/

Дальше: заполнить proposal.md, specs/, design.md, tasks.md,
затем "${OPENSPEC} validate ${change} --strict"
и закоммитить в develop (только по явному запросу человека).
EOF
