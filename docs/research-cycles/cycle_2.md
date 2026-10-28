# Цикл 2 — C2-H2: селективный смысловой audit до commit + один repair

Цикл построен вокруг идеи: **селективный смысловой pre-commit audit только несертифицированных полей + максимум один repair**, против сильного соперника.

### 1) Обзор литературы и выбор гипотезы

| Решение | Описание |
|---|---|
| **15 источников** | SIEVE, ARGUS, AttriGuard, From Shield to Target, Patterns, GoEx, MENTOR и др.; 41 цитатный фрагмент, 7 236 699 байт архивов. |
| **Ключевые пересечения** | SIEVE прямо реализует selective deterministic/semantic verification; ARGUS — argument grounding и entailment до исполнения; AttriGuard — counterfactual replay; From Shield to Target — DoS через удлинение reasoning guardrail и дилемма fail-open/fail-closed. Гибрид не новая архитектура. |
| **Выбрана C2-H2** | Semantic reject/repair **до commit** при schema-valid неверном поле — проверка применимости известных механизмов, новизна не заявлена. |

### 2) Протокол (заморожен 2026-10-23T20:11:54Z, defense-c02-h2-v1)

| Решение | Описание |
|---|---|
| **Данные** | 12 train (до двух проходов), 24 selection, **256 confirmation** семейств; чистый и benign-контроль, две адаптивные цели, взаимный перенос атак. |
| **Мощность** | 0.7402 при p_plus=0.20/p_minus=0.05; 0.9793 при 0.25/0.05; при истинных 10 п.п. — лишь 0.1738. |
| **Бюджет (потолок)** | 47 532 logical + 7 130 infra = 54 662 физических попыток; 490 414 080 admission tokens; подтверждение 276 824 064. Аудит труда: 156 h nominal при hard cap 160 h. |
| **Gates** | Восемь readiness gates (G1–G8), включая feasibility и независимый gold-аудит. |

### 3) Реализация MVP

| Решение | Описание |
|---|---|
| **Механизм** | D0 выдаёт значение и проверяемый сертификат для trusted literals; для несертифицированных полей LLM строит типизированное предложение; H отправляет их в свежий semantic audit; verdict accept/reject/unresolved; reject/unresolved — не более одной новой кандидатуры. |
| **Реальная ветвь** | Audit/repair-цикл реализован в коде и отсутствует у B-hybrid; scripted-тесты: `hybrid_wrong → SFC=false`, `H_repair → SFC=true`, wrong accept ведёт к ошибочному commit. |
| **Тесты** | 34 → 36 → **44/44 passed**; 7 scripted траекторий; raw-checker без импорта runtime совпал на всех 36 исходах. |

### 4) Feasibility G1 — провален

| Cap | typed-valid | correct extraction/verdict | attack surface |
|---|---|---|---|
| **768** | 1/12 | 1/8 | 0/4 |
| **2048** | 1/12 | 1/8 | 0/4 |
| **4096** | 8/12 | 7/8 | 1/4 |

- **Ни один cap не удовлетворяет замороженному правилу выбора** (требуется 12/12, 8/8, 4/4) → `selected_cap=null`, G1 blocked.
- **26/36 ответов обрезаны** (finish_reason=length); все 10 завершённых ответов typed-valid — узкое место в доведении генераций.
- **14 аномалий usage**: `reasoning_tokens > completion_tokens`; reasoning повторно не прибавлялся. Управление reasoning протокол заранее исключил.
- **Расход**: 36/36 HTTP 200, 89 413 токенов, reported cost 0.0206459055.
- Замечен дефект поставки: две сериализации протокола различаются байтами (63 135 vs 61 321) при полном равенстве JSON — verifier исправлен на «отдельные хэши + семантическое равенство».

### 5) Итог

- **Статус: `blocked_capability_no_confirmation`.** Train/Selection/Confirmation: **0/12, 0/24, 0/256**. C2-H2 не подтверждена и статистически не опровергнута.
- Новых API-вызовов на стадиях experiments/synthesis — 0; все offline-повторы честно помечены как не новые наблюдения.
- **Побочные продукты**: реальная audit/repair-ветвь, отличная от B-hybrid; 44/44 тестов; негативные проверки контракта (13/13); memory.json (9 facts / 4 failures / 6 unknowns / 5 next).
- **Повтор дефекта поставки**: снова отсутствовали обязательные `artifacts/sources.json` и `artifacts/memory.json` при локальном PASS — исправлено во второй раз подряд.
- **Следующее направление**: компактный typed-интерфейс для минимального D0+extractor при неизменных смысловых требованиях; reasoning/cap-условия — только как новый протокол следующего цикла.
