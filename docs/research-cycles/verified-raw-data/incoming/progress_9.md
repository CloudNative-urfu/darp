# progress.md — цикл 09, стадия идей (candidates)

## Блок 1 (выполнено): чтение входов
- Прочитаны brief.md, handoff.json (lessons c1-issue0…c7-issue1, scenario_history ц.1–8, model), workflow-contract.json, prior-evidence/08 (review, idea_review, pilot_results, candidates, sources).
- Ключевые факты из ц.8 (prior-evidence/08): маршрут darkbloom/fp4, provider=Darkbloom; tools в режиме auto работают; reasoning off даёт 0 reasoning_tokens; кэш cached_tokens возвращается; need_for_llm провален (runbook 0.8 vs LLM 0.6), атака редко достижима (инъекция не в обязательном канале), Progent настроен слабее deny-списка.
- Память агента пуста (MEMORY.md отсутствует).

## Следующий шаг
- Поиск готовых гвардрейлов (websearch → репозиторий/документация/статья), фиксация commit/лицензии/зависимостей в artifacts/sources.json.
- Затем candidates.json (6 идей, 6 сред), hypotheses.md, lesson_plan.

## Блок 2 (выполнено): поиск готовых гвардрейлов
- WebSearch: PIGuard/InjecGuard, GuardDog, G-Safeguard, CodeShield/LlamaFirewall, AgentSpec (кода не найдено), memory-guards, BrowseSafe, PromptArmor (официального кода нет), nono, sandbox-runtime.
- Проверка: `git ls-remote` HEAD/tags → artifacts/source_checks/ls-remote-heads.txt, ls-remote-tags.txt; PyPI → source_checks/pypi.txt; arXiv API → source_checks/arxiv_batch.xml.
- Снимки pyproject/LICENSE/README/ключевых модулей на закреплённых commit → artifacts/source_snapshots/ (не исполнялись).
- Локально: 20 CPU, 15 GB RAM, Python 3.14.8, uv, bwrap, node 24, socat, rg, strace. BrowseSafe (30.5B параметров) на CPU неприменим; PromptGuard-2 gated=manual — недоступен.
## Следующий шаг: sources.json → candidates.json → hypotheses.md → валидация по контракту.

## Блок 3 (выполнено): артефакты стадии
- artifacts/sources.json — 45 записей (url, claim, status, accessed, version, evidence); генератор artifacts/build/make_sources.py.
- artifacts/candidates.json — 6 идей (browser/office/persistent_memory/multi_agent/operations/coding), 6 направлений, все 6 семейств защит; lesson_plan на все 17 уроков handoff (все action=test, c6-issue1 — применимо к MAS); pool_notes с поведенческими различиями и исключёнными гвардрейлами. Генераторы: build/cands_part1..3.py, build/assemble.py.
- artifacts/hypotheses.md — гипотезы, метрики, правила сравнения, опровержения, сравнение с историей, риски.
- Лицензии уточнены по LICENSE на commit: AgentDojo MIT, A-MemGuard MIT, LlamaFirewall/CodeShield MIT (корень PurpleLlama — Llama 3.2 license).
- Проверка: `python3 -I artifacts/build/validate_candidates.py` → ok=true (source_checks/validate_candidates.log); хэши защищённых входов → source_checks/input_hashes.txt.
- Модельных вызовов: 0. Победитель не выбран, MVP не писался.

## Незавершённое / следующий шаг
- idea_review (критик) выбирает 1–2 идеи; затем pilot_plan.json с budget ≤ 100 запросов / 1800 с через research-experiment.
- Совместимость всех гвардрейлов с qwen/darkbloom/harness — только план (compatibility_probe), не факт.
