# Цикл 9 — спецификация 6 сценариев; критик не завершил проверку

Цикл построен вокруг идеи: **собрать спецификацию 6 сценариев на 6 harness-классах, чтобы перенести идеи циклов 1–8 на финальный полигон**.

### 1) Операторское изменение критика (из brief)

| Решение | Описание |
|---|---|
| **Смена критика** | Во время цикла 8 модель критика `openai/gpt-6-astra#xhigh` перестала отвечать: лимит подписки ChatGPT (`subscription_sharing_usage_limit_exceeded`). Критик переключён на Claude Opus — **тот же бэкенд, что у исследователя**. |
| **Последствие** | Критика перестала быть кросс-модельной. Независимость обеспечивается раздельной ролью/сессией и только чтением, но не разными моделями — зафиксировано как ограничение. |

### 2) Стадия candidates (выполнена)

| Решение | Описание |
|---|---|
| **Входы** | brief, handoff (lessons c1-issue0…c7-issue1, scenario_history ц.1–8), workflow-contract, prior-evidence/08. Ключевые факты ц.8: need_for_llm провален (runbook 0.8 vs LLM 0.6), атака редко достижима, Progent настроен слабее deny-списка. |
| **Поиск гвардрейлов** | PIGuard/InjecGuard, GuardDog, G-Safeguard, CodeShield/LlamaFirewall, AgentSpec (кода не найдено), memory-guards, BrowseSafe, PromptArmor (официального кода нет), nono, sandbox-runtime. Проверки: git ls-remote, PyPI, arXiv API; снимки на закреплённых commit. |
| **Неприменимые** | BrowseSafe (30.5B параметров) на CPU неприменим; PromptGuard-2 gated=manual — недоступен. |
| **Лицензии** | Уточнены по LICENSE на commit: AgentDojo MIT, A-MemGuard MIT, LlamaFirewall/CodeShield MIT (корень PurpleLlama — Llama 3.2 license). |
| **Ресурсы** | 20 CPU, 15 GB RAM, Python 3.14.8, uv, bwrap, node 24, socat, rg, strace. |

### 3) Артефакты стадии

| Артефакт | Содержание |
|---|---|
| **sources.json** | **45 записей** (url, claim, status, accessed, version, evidence). |
| **candidates.json** | **6 идей** по 6 средам (browser / office / persistent_memory / multi_agent / operations / coding), все 6 семейств защит; pool_notes с поведенческими различиями и исключёнными гвардрейлами. |
| **lesson_plan** | На все **17 уроков** handoff (все action=test; c6-issue1 применима к MAS). |
| **hypotheses.md** | Гипотезы, метрики, правила сравнения, опровержения, сравнение с историей, риски. |
| **Валидация** | `validate_candidates.py` → ok=true; хэши защищённых входов зафиксированы. |

### 4) Что не сделано

| Решение | Описание |
|---|---|
| **idea_review критиком** | Не задокументирован: в `09/early/idea_review-00/` есть только brief; нет progress/итогов проверки. Победитель не выбран, MVP не писался. |
| **Модельные вызовы** | **0** за весь цикл. |

### 5) Итог

- **Цикл не завершён**: стадия candidates готова и проверена автопроверками, но выбор идей критиком не состоялся — кампания остановилась до финального полигона.
- **Побочный продукт**: самая полная спецификация сценариев за кампанию — 6 harness-классов, все 6 семейств защит, 45 источников с пинами, lesson_plan на все 17 уроков.
- **Открытые риски, зафиксированные в hypotheses.md**: совместимость гвардрейлов с qwen/darkbloom — только план (compatibility_probe), не факт.
