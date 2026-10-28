# Цикл 4 — C4-H1: один reason-code repair против resampling + инвентаризация AgentDojo

Цикл построен вокруг идеи: **конкретная причина механического отказа (reason-code) против общего INVALID при общем первом ответе** — проверка, даёт ли типизированный repair преимущество перед обычным resampling.

### 1) Обзор литературы и выбор гипотезы

| Решение | Описание |
|---|---|
| **14 источников** | Task Shield, ARGUS, GuardianAgentBench (новый ближайший аналог), MENTOR, AttriGuard v2, Self-Refine v2, LICENSE AgentDojo (MIT) и др. |
| **Важная оговорка** | GuardianAgentBench §4 называет guardrails lightweight/rule-based, но §5.1 прямо указывает Claude Sonnet 4.5 для всех трёх — их нельзя трактовать как zero-LLM deterministic baseline. |
| **Выбрана C4-H1** | Один reason-code retry против resampling; вклад — возможное измерение границы применимости, не новая архитектура. |

### 2) Протокол (заморожен)

| Решение | Описание |
|---|---|
| **F0 — единственный фактор** | Отсутствие reasoning parameter против `reasoning.effort=none`, cap=2048. |
| **Confirmation** | Весь квалифицированный upstream pool до 24 lineage (минимум 6), по outcome-blind qualification и фиксированному hash order; N фиксируется до первого confirmation-исхода. |
| **Инвентаризация AgentDojo** | Получен pinned Git tree; **AST-метаданные пяти workspace task modules: 33 класса в v1, 13 с календарными символами**. Это не подтверждает 30 независимых календарных lineage. Task strings, gold values и runs outcomes не просматривались. |
| **Бюджет (потолок)** | 486 logical + 24 infrastructure = 510 физических вызовов максимум. |

### 3) Реализация MVP

| Решение | Описание |
|---|---|
| **Код с нуля** | Компактный parser (duplicate-key rejection, exact aliases), упорядоченный gateway, одноразовый atomic sandbox commit, HTTP-клиент с intent-before-send. |
| **Политики** | D0 (правила ID/aliases, дат/часовых поясов, отрицаний, явных исправлений), B-one, B-resample, H-reason, B-history, B-one-long; общий prefix исполняется один раз, продолжения — на клонах состояния. |
| **Тесты** | 13 → 26 → **37/37 passed**; 15 scripted траекторий пяти контрольных сценариев, model calls=0. |

### 4) F0 — провален

| Режим | Результат |
|---|---|
| **R0** | 12 HTTP 200, typed/correct **1/12**; 11 null/length при cap 2048; p50 active latency 27.131 s. |
| **R1 (`reasoning.effort=none`)** | **12 × HTTP 400** с общим `Input validation error` — текст не называет параметр, поддержка knob не установлена. |

- **Ни один screen mode не достиг 11/12 typed и correct** → stop rule `F0_failed`; fresh validation, probes и efficacy не запускались по gate.
- **Расход**: 24 вызова, 33 461 токен, reported cost 0.0075754503; usage/cost 12 ошибок неизвестны.

### 5) Offline-контролы и пост-хок находка

| Решение | Описание |
|---|---|
| **54 траектории** | 9 constructed scenarios × 6 политик: 11 SFC, 8 wrong commits, 0 ACL violations. Проверяют конструкции, не live-частоты. |
| **Ключевой факт** | H исполняет **schema-valid неверный repair после настоящего mechanical reject**: код отказа не даёт semantic safety. |
| **Post-hoc ошибка D0** | На открытом screen-07 D0 включил Priya, хотя позднее сообщение говорит «only coordinating and will not attend» — **ошибка отрицаний в rule parser**. Все шесть политик делают одинаковый wrong commit через общий D0 fast path, с нулём model calls. Это ограничивает рекомендацию deterministic fast path. |

### 6) Итог

- **Статус: `inconclusive_f0_failed`.** C4-H1 не подтверждена и не опровергнута; efficacy/confirmation = 0. Блокировка — неработающий frozen интерфейс (1/12 в R0, 12 generic HTTP 400 в R1), а не квота.
- **Побочные продукты**: исполняемый MVP, AST-инвентаризация задач AgentDojo без подсматривания условий (зафиксированы URL/SHA-256), post-hoc аудит ошибки D0 с полным trace, memory.json (9 facts / 5 failures / 6 unknowns / 5 next).
- **Повтор дефекта поставки**: снова отсутствовал обязательный `artifacts/sources.json` — исправлено с восемью негативными случаями.
- **Следующее направление**: правильный baseline, проверяемый структурированный fast path и отдельная малая диагностика ID/JSON интерфейса.
