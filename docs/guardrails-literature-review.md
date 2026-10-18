# Литературный обзор: гвардрейлы в бизнес-процессе агента

> Задача обзора — не перечислить всё, а показать, какие ингредиенты
> нашей постановки уже существуют по отдельности и какой комбинации в литературе нет.

## 1. Назначение

Обзор отвечает на три вопроса:

1. Что уже измеряют существующие работы по гвардрейлам и чего они не измеряют.
2. Какие ближайшие работы сильнее всего угрожают новизне нашей постановки.
3. Какую именно комбинацию измерений мы можем защитить как research gap.

Главный вывод: **отдельные ингредиенты нашей постановки уже описаны** — детекционные
бенчмарки, атаки на доступность гвардрейлов, модели эскалации, стоимость инференса,
отдельные бизнес-кейсы. **Не описана их совместная оценка**: конфигурация гвардрейла
внутри бизнес-процесса агента, при двусторонней нагрузке (атакующий + легитимные запросы),
с исходом в виде исполненного нарушения и порогом окупаемости по стоимости нарушения.

## 2. Метод

### 2.1. Поисковая стратегия=

Обзор полусистематический: запросы к arXiv API, отбор по релевантности и свежести,
затем snowballing по ссылкам и цитированиям ближайших работ. Для каждого запроса
просматривались до 30 свежих записей; часть запросов дала меньше записей.

| № | Запрос | Найдено | Просмотрено |
| --- | --- | --- | --- |
| 1 | `all:"guardrail" AND all:"LLM"` | 711 | 30 |
| 2 | `all:"prompt injection" AND all:"defense"` | 464 | 30 |
| 3 | `all:"over-refusal" OR all:"false refusal"` | 242 | 30 |
| 4 | `all:"denial of service" AND all:"LLM"` | 65 | 30 |
| 5 | `all:"human-in-the-loop" AND all:"LLM" AND all:"queue"` | 1 | 1 |
| 6 | `all:"StepShield"` | 2 | 2 |
| 7 | `all:"guardrails" AND all:"cost"` | 136 | 30 |
| 8 | `all:"security economics" AND all:"LLM"` | 0 | 0 |
| 9 | `all:"escalation" AND all:"LLM" AND all:"human"` | 191 | 25 |
| 10 | `all:"moderation" AND all:"queue"` | 73 | 25 |
| 11 | `all:"cost-benefit" AND all:"security"` | 46 | 25 |
| 12 | `all:"guardrail" AND all:"availability"` | 135 | 25 |
| 13 | `all:"false positive" AND all:"guardrail"` | 52 | 25 |
| 14 | `all:"agent" AND all:"safety" AND all:"cost"` | 583 | 25 |
| 15 | `all:"queueing" AND all:"LLM"` | 165 | 25 |

Запрос 8 важен как отрицательный сигнал: связка «security economics + LLM» почти не
встречается в заголовках и абстрактах. Это не доказывает отсутствие экономической
рамки, но показывает, что она не стала общим языком поля.

### 2.2. Критерии включения и исключения

Включались работы, которые:

- оценивают гвардрейл, детектор, защиту агента или инфраструктуру вокруг них;
- сообщают хотя бы одно из: качество детекции, полезность, latency/tokens/деньги,
  доступность, эскалацию, бизнес-исход;
- написаны на английском и доступны через arXiv или площадку.

Для LLM-специфичных работ окно — 2023–2026. Классика по экономике безопасности и
теории очередей добавлена вручную, вне окна.

Исключались: чистый alignment и обучение моделей без гвардрейла; capability-бенчмарки
без защиты; позиционные тексты без измерений; дубликаты, где arXiv-версия устарела
относительно площадки.

### 2.3. Ограничения

- Это не PRISMA-обзор: нет двойного слепого отбора и формальной оценки качества.
- Для большинства работ прочитаны заголовок, абстракт и метаданные; полный текст —
  только для ближайших.
- Поле движется быстрее, чем обзор стареет: снимок зафиксирован на 15.10.2026.
- arXiv-центричность: часть индустриальных отчётов и вендорских бенчмарков могла
  остаться вне корпуса.
- Нулевой результат запроса 8 — сигнал, а не доказательство.

## 3. Рамка анализа: четыре оси

Чтобы не сравнивать несравнимое, работы раскладываются по четырём осям.

| Ось | Значения | Что фиксирует | Наша позиция |
| --- | --- | --- | --- |
| Единица анализа | детектор → конфигурация → процесс | что именно оценивается | конфигурация внутри процесса |
| Модель угрозы | статическая → адаптивная → двусторонняя | кто действует и как | двусторонняя, общий бюджет |
| Исход | метка → действие → состояние → деньги | что считается результатом | состояние + деньги |
| Стоимость | latency/tokens → деньги → потеря процесса | как считается цена | все три + spillover |

Большинство работ живёт в левом верхнем углу: один детектор, статический набор атак,
метка «safe/unsafe». Наша постановка — правый нижний угол: конфигурация, двусторонняя
нагрузка, исполненное состояние, деньги. Именно расстояние между этими углами и есть
пространство для вклада.

## 4. Тематический обзор

### 4.1. Гвардрейлы как класс систем

Гвардрейл перестал быть одним классификатором на входе. NeMo Guardrails задаёт
программируемые rails и оркестрацию [2310.10501]; Llama Guard, WildGuard и Granite
Guardian дают готовые модели-модераторы [2312.06674; 2406.18495; 2412.07724]; GLiNER
Guard и SentGuard оптимизируют encoder- и streaming-режимы [2605.05277; 2606.02041];
RouteGuard маршрутизирует запросы между специализированными модераторами [2605.30693];
AgentDoG и MAS-Guard расширяют рамку на агентские и мультиагентные системы
[2601.18491; 2610.28397]; VEPA и Persona Guardrail добавляют формальные политики и
персональные ограничения [2610.12813; 2610.03434].

Тренд: от монолитного детектора к **композиции** — routing, каскады, streaming,
формальные политики, персонализация. Это усиливает необходимость оценивать именно
конфигурацию, а не отдельную модель: свойство композиции не выводится из свойств
компонентов.

### 4.2. Оценка детекции: бенчмарки и метрики

Здесь поле созрело быстрее всего.

- **BELLS-O** сравнивает 28 систем от 17 поставщиков и показывает, что на content
  moderation специализированные гвардрейлы доминируют: сопоставимая детекция
  (~95% против 94%) при FP ≤2%, в 5–10 раз быстрее и примерно в 10 раз дешевле; на
  jailbreak-детекции frontier-LLM дают более высокую детекцию и меньший FP, но в
  10–50 раз дороже и в 5–10 раз медленнее [2606.20668]. Это ближайшая к нам работа по
  оси стоимости, но в ней нет бизнес-процесса, двусторонней нагрузки и break-even.
- **Gate AI** систематизирует методологию: 16 публичных бенчмарков, 12 111 сэмплов,
  глобальная рабочая точка, диагностика утечек и переносимости порогов
  [2606.02959]. Методологический урок: без фиксации рабочей точки и проверки на
  загрязнение сравнение детекторов бессмысленно.
- **SoK по jailbreak-гвардрейлам** вводит рамку Security–Efficiency–Utility и
  показывает, что трёхосевая оценка уже принята сообществом [2506.10597]. Мы
  добавляем к этим осям процесс и деньги.
- **SafePyramid** проверяет следование in-context политикам на 61 тыс. правил
  [2606.29887]; **RouteGuard** — на 32 тыс. примеров и 15 категориях, с учётом
  вмешательства в целевую задачу [2605.30693]; **AgentDoG/ATBench** — на агентских
  траекториях [2601.18491].
- **PIAtlas** декомпозирует пространство prompt injection: 5 000+ payload'ов,
  42 механизма, 2 800 payload'ов для адаптивных атак; адаптивные атаки чаще бьют по
  недопредставленным механизмам, а не по тем, где выше средний ASR [2610.24999].
- **INFUSE** показывает нестабильность поверхностей: 10 фреймворков, 1 440 «капель»,
  8 000+ взаимодействий, 562 прохождения, 302 триггера, 757 безопасных
  взаимодействий; результат заметно варьируется между прогонами, а обновление модели
  меняет безопасность [2610.20776].
- **GABench** даёт 580 сценариев и три фреймворка, лучший результат — 74,8%
  [2607.20982].
- **Policy Is Not Capability** показывает, что часть «небезопасного» — это вопрос
  определения политики, а не способности модели; 2 850+ примеров на правило и
  11 prompt-based моделей [2610.25060].
- **ATOM** фиксирует главный дефект метрики ASR: 21,7% прогонов выглядят
  «безопасными», хотя задача не выполнена, потому что инъекция **проигнорирована**, а
  не **отклонена** [2610.23254].
- **StepShield** добавляет время: 9 583 траектории, 6 доменов, 62,5% атакующих,
  86% recall, но EIR близок к случайному; преждевременные вмешательства — 12,7%,
  запоздалые — 21,4% [2601.22136].

**Что это значит для нас.** Бенчмарки сильны в метках и всё чаще измеряют
latency/стоимость, но единицей остаётся промпт или траектория, а не бизнес-процесс.
ATOM и StepShield показывают, что одной метрики детекции недостаточно: нужны
«проигнорировано / отклонено / задача завершена» и время вмешательства. Мы берём это
в словарь исходов.

### 4.3. Безопасность агентов: атаки и защиты

Классическая линия — indirect prompt injection [2302.12173], бенчмарки AgentDojo и
InjecAgent [2406.13352; 2403.02691]. Защиты делятся на несколько семейств:

- **по дизайну**: instruction hierarchy, StruQ, CaMeL [2404.13208; 2402.06363;
  2503.18813];
- **политики и reasoning**: ShieldAgent, GuardAgent [2503.22738; 2406.09187];
- **формальная верификация**: runtime verification на AgentDojo и STAC даёт 71,8%
  обнаруженных цепочек атак, 70,1% нарушений политик и 29,3% ложных срабатываний на
  benign-трафике [2610.09793];
- **information flow и доступ**: SPIDES, RATION [2610.24277; 2610.24311];
- **активации и пробы**: CounterSteer, prompt-injection probes, SingProbe, RAISED
  [2609.36570; 2610.18408; 2608.30703; 2610.06401].

Отдельная линия — **композиционные атаки**: option-channel заставляет typed decision
model выбирать из предложенных вариантов [2610.12292]; BRANCH обходит multi-scanner
гвардрейлы с block rate выше 90% [2610.10742]; Local Allow, Global Deny показывает,
что per-action авторизация не композируется и отказ в одном вызове не мешает
реализовать общую цель [2610.27620]; SpanGuard разделяет локализацию инструкции и
авторизацию [2610.26013]; carryover-атаки сохраняются после ухода атакующего
[2610.28425]; окно решения находится в reasoning, а не в моменте инъекции
[2610.24048]; approval-механизмы можно превратить в источник привилегий
[2610.22987]; polarity blindness обходит лексические фильтры [2610.27908].

**Что это значит для нас.** Защиты оцениваются по ASR/utility, композиция — по
покрытию и устойчивости. Экономического порога нет: никто не спрашивает, окупается ли
конкретная конфигурация по сравнению с baseline. Композиционные работы важны как
источник режима `T`: они показывают, что атакующий может выбирать не только payload,
но и канал обхода.

### 4.4. Доступность: атаки на гвардрейлы и цена ложных тревог

Это самая близкая к нашей новизне линия — и самая опасная для неё.

- **Sponge examples** — классика energy-latency атак [2006.03463].
- **False positives как DoS**: короткий промпт (<30 символов) блокирует более 97%
  пользовательских запросов на Llama Guard 3 [2410.02916]. То есть гвардрейл — не
  только защита, но и поверхность атаки.
- **MutedRAG**: индуцирование гвардрейла приводит к DoS в RAG, ASR выше 60%, один
  образец влияет на несколько запросов [2504.21680].
- **From Shield to Target**: reasoning-loop DoS на агентских гвардрейлах; 13–63×
  токенов, 148× latency; общая инфраструктура гвардрейла голодает у соседних агентов
  [2606.14517]. Это прямой аргумент в пользу класса `spillover`.
- **Resource amplification**: tool-calling chains усиливают расход ресурсов
  [2601.10955]; over-generation как DoS [2512.23779]; атака на serving framework, а
  не на модель [2602.07878]; бесконечные агентские циклы [2607.01641]; обзор
  latency-атак [2609.36732]; soft-failure в RAG [2604.18663].

**Что это значит для нас.** Литература уже доказала, что гвардрейл может быть
убыточным каналом. Но она измеряет **успех атаки и задержку**, а не **чистый исход
бизнес-процесса**. Наш вклад не в том, чтобы повторить «гвардрейлы можно
использовать для DoS», а в том, чтобы измерить, когда защита окупается с учётом этой
атаки, и отделить `self-limited` / `defender-borne` / `spillover`.

### 4.5. Ложные отказы, полезность и «проигнорировано»

XSTest и OR-Bench задают измерение over-refusal [2308.01263; 2405.20947]; WildGuard
даёт открытый moderation-стек [2406.18495]. Policy Is Not Capability напоминает, что
часть «отказов» — это разные определения политики [2610.25060]. ATOM показывает, что
низкий ASR может скрывать игнорирование инъекции и незавершённую задачу
[2610.23254]. StepShield добавляет своевременность вмешательства [2601.22136].

**Что это значит для нас.** Полезность в литературе измеряется на уровне задачи
(task success, refusal rate), а не на уровне процесса (потерянная выручка, очередь,
ручная обработка). Наши `ΔR·C_refuse` и `ΔQ·C_queue` — это попытка перевести
ложный отказ и задержку в деньги процесса.

### 4.6. Решения, эскалация и ёмкость человека

- **From Detection to Decision**: детектор должен выбирать allow / block / defer;
  при 1% FNR до 91,8% случаев уходит на эскалацию [2610.20907]. Это ключевой
  аргумент, что порог детекции — не единственная ручка.
- **Act or Escalate**: модель выбирает между действием и эскалацией по ожидаемой
  стоимости; пороги зависят от модели, SFT улучшает поведение [2604.08588].
- **LLM Performance Predictors**: cost-aware selective classification для гибридной
  модерации [2601.07006].
- **Oversight Has a Capacity**: человек-ревьюер устаёт, согласие низкое (Fleiss'
  kappa 0,52), оптимальный гвардрейл отличается от brute-force, зависимость
  «пропуск–нагрузка» имеет перевёрнутую U-форму; возможна flooding-атака на очередь
  [2606.08919].
- **QUEST**: симуляция очереди для модерации в масштабе [2103.16816]; обзор
  queueing + LLM [2503.07545]; fairness изоляции в multi-tenant serving [2609.18112];
  сертификаты selective prediction [2609.22048].

**Что это значит для нас.** Decision-theoretic эскалация уже существует, но стоимость
в ней обычно скаляр, а не очередь; нет конфигураций гвардрейлов относительно baseline;
нет состояния бизнес-процесса; нет порога `L*`. Наша модель добавляет конечную
ёмкость и spillover.

### 4.7. Экономика и стоимость

Классика задаёт язык: Anderson объясняет, почему безопасность — не техническая, а
экономическая задача [Anderson 2001]; Gordon–Loeb показывает, что оптимальная
инвестиция в безопасность не «всё или ничего», а маргинальная [Gordon & Loeb 2002].

В LLM-литературе стоимость уже измеряется: BELLS-O даёт деньги на 1 000 запросов
[2606.20668]; RAGWarrant — quality/cost/latency/risk-констрейнты для promotion
политик, Spearman 0,81 и 0,04 с на решение [2609.34179]; AGO — evidence-first release
gate, 1 373 кейса, 83,6% против 76,5% у answer-only baseline [2610.01218];
EcoAgent-Bench — бюджетные решения агентов, 159 инструментов, 45% безопасного
завершения [2608.05519]; payments dispute — best-of-N оркестрация гвардрейлов,
+11 п.п. compliance score, 8 400 наборов документов в день [2606.01513]; образовательные
тьюторы — прямые trade-offs: NeMo 0% bypass / 16,22% FPR / 1,5 с против Prompt Guard
38,48% / 3,60% [2605.06669].

**Что это значит для нас.** Стоимость измеряют, но не превращают в **порог на
стоимость нарушения**. Нет работы, которая спрашивает: при какой цене исполненного
нарушения конфигурация гвардрейла окупается? Это и есть наша формула `L*`.

### 4.8. Бизнес-процесс как единица анализа

Доменные кейсы уже есть: SOC/XDR через NeMo-proxy — 100% enforcement, 63%
авто-ремедиации, −30% алертов [2610.09906]; payments dispute [2606.01513];
финансовые торговые агенты — 15 сценариев, 56 вариантов, 5 сценариев со 100%
компрометацией и 88,64% критических [2610.26438]; образовательные тьюторы
[2605.06669]; BOA — рамка измерения агентской безопасности по стадиям
collection/release/deployment/production [2605.01644].

**Что это значит для нас.** Бизнес-кейсы существуют, но ни один не соединяет
двустороннюю нагрузку, конфигурации гвардрейлов, исполненное состояние и break-even.
Они либо системные (SOC, payments), либо измеряют качество/безопасность без
экономического порога.

## 5. Research gap

### 5.1. Формулировка

Литература закрывает три шага из четырёх:

1. **Детекция** — да: бенчмарки, метрики, стоимость, latency.
2. **Доступность гвардрейла** — да: FP→DoS, MutedRAG, Shield-to-Target, resource
   amplification.
3. **Решение и эскалация** — да: allow/block/defer, expected cost, ёмкость человека,
   очередь.
4. **Окупаемость в бизнес-процессе** — **нет**.

В доступном корпусе мы не нашли работы, которая одновременно:

- оценивает **конфигурации** гвардрейлов (а не отдельный детектор) внутри одного
  бизнес-процесса агента;
- подаёт **двустороннюю нагрузку**: атакующий и легитимные запросы делят конечную
  ёмкость гвардрейла и очереди;
- фиксирует исход на уровне **исполненного нарушения** и завершённости задачи, а не
  метки;
- переводит результат в **порог окупаемости** `L*` по стоимости нарушения.

Короткая формула гэпа:

> Известно, что гвардрейлы ловят атаки, стоят денег и сами могут быть использованы
> для DoS. Неизвестно, при какой стоимости исполненного нарушения конкретная
> конфигурация гвардрейла окупается в бизнес-процессе агента при двусторонней
> нагрузке.

### 5.2. Пять компонентов гэпа

| Компонент | Что уже есть | Чего нет | Почему важно |
| --- | --- | --- | --- |
| 1. Конфигурация | BELLS-O, SoK, RouteGuard, Shield-to-Target | Сравнения конфигураций в одном процессе при общем бюджете и baseline `g0` | Без этого нельзя атрибутировать эффект и выбрать конфигурацию |
| 2. Бизнес-исход | payments, SOC, tutors, RAGWarrant, AGO | Исполненное нарушение + завершённость задачи + денежная стоимость в одном прогоне | Метрики детекции не переводятся в деньги |
| 3. Двусторонняя ёмкость | Shield-to-Target, FP-DoS, MutedRAG, Oversight | Легитимный трафик + атакующий + очередь гвардрейла в одной модели, со spillover | Потеря доступности — главная скрытая стоимость |
| 4. Break-even | Gordon–Loeb, Act-or-Escalate, RAGWarrant | Формула `L*` и эмпирическая оценка для конфигураций гвардрейлов | Решает, разворачивать ли защиту вообще |
| 5. Словарь исходов | ATOM, StepShield, BOA | Единый словарь `ignored/refused/completed` + `self-limited/defender-borne/spillover` | Иначе результаты несравнимы, а отрицательный результат невидим |

### 5.3. Матрица ближайших работ

Обозначения: `✓` — есть, `~` — частично, `—` — нет.

| Работа | Конфигурации | Бизнес-процесс | Исход состояния | Двусторонняя нагрузка | Ёмкость/очередь | Деньги | Break-even |
| --- | --- | --- | --- | --- | --- | --- | --- |
| BELLS-O [2606.20668] | ✓ | — | — | — | ~ | ✓ | — |
| Gate AI [2606.02959] | ~ | — | — | — | — | — | — |
| SoK [2506.10597] | ✓ | — | — | ~ | ~ | ~ | — |
| SafePyramid [2606.29887] | ~ | — | — | — | — | — | — |
| RouteGuard [2605.30693] | ✓ | ~ | — | — | — | ~ | — |
| AgentDoG [2601.18491] | ~ | ~ | ~ | — | — | — | — |
| ATOM [2610.23254] | — | ~ | ✓ | — | — | — | — |
| StepShield [2601.22136] | — | ~ | ✓ | — | — | — | — |
| Detection→Decision [2610.20907] | — | — | ~ | — | ~ | ~ | — |
| Act or Escalate [2604.08588] | — | ~ | ~ | — | — | ✓ | ~ |
| Oversight Capacity [2606.08919] | — | ~ | ~ | ✓ | ✓ | ~ | — |
| Shield to Target [2606.14517] | ✓ | — | — | ✓ | ✓ | ~ | — |
| MutedRAG [2504.21680] | ~ | ~ | ~ | ✓ | ~ | — | — |
| FP-DoS [2410.02916] | ~ | — | — | ✓ | ✓ | — | — |
| RAGWarrant [2609.34179] | ✓ | ✓ | ~ | — | — | ✓ | ~ |
| AGO [2610.01218] | ~ | ✓ | ~ | — | — | ✓ | ~ |
| Payments dispute [2606.01513] | ✓ | ✓ | ~ | — | — | ✓ | — |
| Educational tutors [2605.06669] | ✓ | ~ | ~ | — | ~ | ~ | — |
| **Наша постановка** | **✓** | **✓** | **✓** | **✓** | **✓** | **✓** | **✓** |

### 5.4. Что закроет гэп

Гэп хрупкий: его может закрыть инкрементальная работа, а не только конкурирующая
статья. Достаточно:

- добавить бизнес-процесс и исполненное нарушение к BELLS-O — частичное закрытие;
- добавить очередь/spillover и деньги к Shield-to-Target — частичное закрытие;
- добавить конфигурации гвардрейлов и break-even к Act-or-Escalate — почти полное
  закрытие;
- добавить двустороннюю нагрузку и break-even к RAGWarrant/AGO — закрытие.

Отсюда два следствия. Первое: заявлять уникальность нужно **точно**, через комбинацию,
а не через «первый бенчмарк». Второе: окно уязвимо, поэтому pre-registration и ранняя
фиксация claim'а важны (см. `docs/guardrails-research-risks.md`, §6–7).

### 5.5. Что мы заявляем и что не заявляем

**Заявляем:**

- измерение окупаемости конфигураций гвардрейлов в бизнес-процессе агента;
- двустороннюю нагрузку с общей конечной ёмкостью и spillover;
- исход в виде исполненного нарушения и порог `L*`;
- словарь `ignored/refused/completed` и три класса вреда.

**Не заявляем:**

- первый бенчмарк гвардрейлов;
- первый DoS на гвардрейлах;
- первую модель эскалации;
- SOTA-детектор;
- cross-lingual переносимость: эмпирика English-only;
- универсальность за пределами выбранного процесса и корпуса.

## 6. Что литература меняет в дизайне

1. **Фиксировать политику.** Policy Is Not Capability [2610.25060] требует явного
   определения «небезопасного»; иначе измеряется формулировка, а не защита.
2. **Фиксировать рабочую точку и проверять утечки.** Gate AI [2606.02959] показывает,
   что пороги и загрязнение меняют выводы.
3. **Считать `ignored/refused/completed`.** ATOM [2610.23254] показывает, что низкий
   ASR скрывает незавершённые задачи.
4. **Мерить время вмешательства.** StepShield [2601.22136] отделяет преждевременное
   вмешательство от запоздалого.
5. **Моделировать ёмкость ревьюера.** Oversight Has a Capacity [2606.08919] даёт
   усталость, низкое согласие и flooding.
6. **Использовать симуляцию очереди.** QUEST [2103.16816] — готовый язык для
   moderation-очередей.
7. **Разделять успех атаки и потерю бизнеса.** Shield-to-Target [2606.14517] и FP-DoS
   [2410.02916] доказывают, что это разные величины.
8. **Применять логику Gordon–Loeb.** Инвестиция маргинальна; вопрос не «включить
   защиту», а «сколько и где».
9. **Проводить парные прогоны.** Spillover нельзя оценить по одному прогону: нужен
   парный дизайн `g` vs `g0` на одном трафике.
10. **Pre-register.** Гипотезы, `L*`, правила остановки и метрики фиксируются до
    основных прогонов.

## 7. Библиография

Маркер `★` — работа, использованная в матрице гэпа (§5.3).

### 7.1. Системы и модели-гвардрейлы

| ID | Первый автор | Год | Название |
| --- | --- | --- | --- |
| 2310.10501 | T. Rebedea | 2023 | NeMo Guardrails: A Toolkit for Controllable and Safe LLM Applications with Programmable Rails |
| 2312.06674 | H. Inan | 2023 | Llama Guard: LLM-based Input-Output Safeguard for Human-AI Conversations |
| 2406.18495 | S. Han | 2024 | WildGuard: Open One-Stop Moderation Tools for Safety Risks, Jailbreaks, and Refusals of LLMs |
| 2412.07724 | I. Padhi | 2024 | Granite Guardian |
| 2605.05277 | B. Minko | 2026 | GLiNER Guard: Unified Encoder Family for Production LLM Safety and Privacy |
| 2606.02041 | J. Yu | 2026 | SentGuard: Sentence-Level Streaming Guardrails for Large Language Models |
| 2605.30693 ★ | W. J. Mo | 2026 | Triaging Threats to Specialized Guardrails (RouteGuard) |
| 2601.18491 ★ | D. Liu | 2026 | AgentDoG: A Diagnostic Guardrail Framework for AI Agent Safety and Security |
| 2610.28397 | M. Kachuee | 2026 | MAS-Guard: Unified Guardrails from Individual Agents to Multi-Agent LLM Systems |
| 2610.12813 | D. Nguyen | 2026 | VEPA: Verified Evolving Formal Policy for Lifelong LLM Agent Guardrails |
| 2610.03434 | B. Pal | 2026 | Persona Guardrail: A Production-Grade Defense Framework for Agentic Systems |
| 2610.08923 | M. K. Rad | 2026 | AdaGuard: Enhancing Safety and Policy Compliance with Reasoning-Enabled LLM-As-A-Judge Guardrails |

### 7.2. Бенчмарки и методология оценки

| ID | Первый автор | Год | Название |
| --- | --- | --- | --- |
| 2506.10597 ★ | X. Wang | 2025 | SoK: Evaluating Jailbreak Guardrails for Large Language Models |
| 2606.20668 ★ | L. Waibl | 2026 | BELLS-O: Evaluating the Operational Trade-offs of LLM Supervision Systems |
| 2606.02959 ★ | R. Goehausen | 2026 | Gate AI: LLM Security Benchmark Evaluation Methodology and Results |
| 2606.29887 ★ | J. Zhang | 2026 | SafePyramid: A Hierarchical Benchmark for In-context Policy Guardrailing |
| 2610.24999 | S. Damianakis | 2026 | SoK: PIAtlas: Decomposing the Unbounded Prompt Injection Attack Space |
| 2610.20776 | T. D. Nguyen | 2026 | INFUSE: A Unified Surface Benchmark for Indirect Prompt Injection in Agentic Systems |
| 2607.20982 | V. I. Naik | 2026 | GuardianAgentBench: Where Agents Fail and How to Guard Them |
| 2610.25060 ★ | V. Jebraeeli | 2026 | Policy Is Not Capability: Some Safety Benchmarks Measure Which Definition of "Unsafe" You Trained On |
| 2308.01263 | P. Röttger | 2023 | XSTest: A Test Suite for Identifying Exaggerated Safety Behaviours in Large Language Models |
| 2405.20947 | J. Cui | 2024 | OR-Bench: An Over-Refusal Benchmark for Large Language Models |
| 2610.23254 ★ | F. Zarif | 2026 | Ignored, Not Refused: What Low Prompt-Injection Success Rates Hide in Small Tool-Using Agents |
| 2601.22136 ★ | G. Felicia | 2026 | StepShield: When, Not Whether to Intervene on Rogue Agents |
| 2605.01644 | S. Lin | 2026 | Toward a Principled Framework for Agent Safety Measurement |
| 2604.15579 | Y. Hong | 2026 | Don't Make Models Guess Security and Safety: Symbolic Guardrails for Domain-Specific AI Agents |
| 2609.22048 | P. Priye | 2026 | Available Guardrails: Certifying Selective Prediction across ML Systems |
| 2606.05805 | Y. Sun | 2026 | From Risk Classification to Action Plan Remediation: A Guardrail Feedback Driven Framework for LLM Agents |

### 7.3. Агентская безопасность: атаки и защиты

| ID | Первый автор | Год | Название |
| --- | --- | --- | --- |
| 2302.12173 | K. Greshake | 2023 | Not what you've signed up for: Compromising Real-World LLM-Integrated Applications with Indirect Prompt Injection |
| 2403.02691 | Q. Zhan | 2024 | InjecAgent: Benchmarking Indirect Prompt Injections in Tool-Integrated Large Language Model Agents |
| 2406.13352 | E. Debenedetti | 2024 | AgentDojo: A Dynamic Environment to Evaluate Prompt Injection Attacks and Defenses for LLM Agents |
| 2402.06363 | S. Chen | 2024 | StruQ: Defending Against Prompt Injection with Structured Queries |
| 2404.13208 | E. Wallace | 2024 | The Instruction Hierarchy: Training LLMs to Prioritize Privileged Instructions |
| 2503.18813 | E. Debenedetti | 2025 | Defeating Prompt Injections by Design (CaMeL) |
| 2503.22738 | Z. Chen | 2025 | ShieldAgent: Shielding Agents via Verifiable Safety Policy Reasoning |
| 2406.09187 | Z. Xiang | 2024 | GuardAgent: Safeguard LLM Agents by a Guard Agent via Knowledge-Enabled Reasoning |
| 2610.09793 | N. Kekatos | 2026 | Formal Runtime Verification for Tool-Using LLM Agents: An Offline Same-Benchmark Study on AgentDojo and STAC |
| 2610.24277 | E. Zverev | 2026 | SPIDES: Information-Flow Control for Browser Agents |
| 2610.24311 | Y. Du | 2026 | RATION: Towards Quantitative Risk-Based Access Control for AI Agents |
| 2610.10742 | W. Hackett | 2026 | BRANCH: Bypassing Multi-Scanner AI Guardrails |
| 2610.12292 | S. Azizi | 2026 | One Word Opens the Gate: The Option-Channel Attack on Typed Decision Models as Agent Guardrails |
| 2610.27620 | A. Pandey | 2026 | Local Allow, Global Deny: Why Per-Action Authorization Does Not Compose in LLM Agents |
| 2610.26013 | Y. Wang | 2026 | SpanGuard: Decoupling Instruction Localization from Authorization for Lightweight IPI Defense |
| 2610.28425 | Z. Xu | 2026 | After the Attacker Leaves: Benchmarking Carryover Attacks on LLM Agents |
| 2610.24048 | H. Jia | 2026 | The Window Is in the Reasoning: When LLM Agents Decide to Follow Prompt Injections |
| 2610.22987 | X. Yang | 2026 | From Approval to Abuse: Privilege Escalation Attacks on Harness-Protected Coding Agents |
| 2610.27908 | D. M. Lozano | 2026 | Polarity Blindness in LLM Safety: A Systematic Study of Negation, Antonym Substitution, and Adversarial Framing |
| 2609.36570 | M. Russinovich | 2026 | CounterSteer: Suppressing Indirect Prompt Injection with Activation Steering |
| 2610.18408 | K. Kale | 2026 | Prompt-Injection Probes Learn the Conversation, Not Just the Injection |
| 2608.30703 | Sing Team | 2026 | SingProbe Technical Report |
| 2610.06401 | M. Dhouib | 2026 | RAISED: Self-Distillation for Robustness to Prompt Injection in LLM Agents |

### 7.4. Доступность и DoS

| ID | Первый автор | Год | Название |
| --- | --- | --- | --- |
| 2006.03463 | I. Shumailov | 2020 | Sponge Examples: Energy-Latency Attacks on Neural Networks |
| 2410.02916 ★ | Q. Zhang | 2024 | LLM Safeguard is a Double-Edged Sword: Exploiting False Positives for Denial-of-Service Attacks |
| 2504.21680 ★ | P. Suo | 2025 | Hoist with His Own Petard: Inducing Guardrails to Facilitate Denial-of-Service Attacks on Retrieval-Augmented Generation of LLMs |
| 2606.14517 ★ | Y. Zhou | 2026 | From Shield to Target: Denial-of-Service Attacks on LLM-Based Agent Guardrails |
| 2601.10955 | K. Zhou | 2026 | Beyond Max Tokens: Stealthy Resource Amplification via Tool Calling Chains in LLM Agents |
| 2512.23779 | Manu | 2025 | Prompt-Induced Over-Generation as Denial-of-Service: A Black-Box Attack-Side Benchmark |
| 2602.07878 | T. Wang | 2026 | Rethinking Latency Denial-of-Service: Attacking the LLM Serving Framework, Not the Model |
| 2607.01641 | X. Hou | 2026 | When Agents Do Not Stop: Uncovering Infinite Agentic Loops in LLM Agents |
| 2609.36732 | Z. Gu | 2026 | Deep Learning Latency Attacks and Defenses: A Cross-Domain Survey of Availability Threats |
| 2604.18663 | W. Zhang | 2026 | Beyond Explicit Refusals: Soft-Failure Attacks on Retrieval-Augmented Generation |
| 2609.18112 | D. Bali | 2026 | Token Latency Fairness: Performance Isolation for Multi-Tenant LLM Serving |

### 7.5. Решения, эскалация, очередь

| ID | Первый автор | Год | Название |
| --- | --- | --- | --- |
| 2610.20907 ★ | Q. Lan | 2026 | From Detection to Decision: Calibration and Deferral for Prompt-Injection Detection |
| 2604.08588 ★ | M. DosSantos DiSorbo | 2026 | Act or Escalate? Evaluating Escalation Behavior in Automation with Language Models |
| 2601.07006 | O. Bachar | 2026 | LLM Performance Predictors: Learning When to Escalate in Hybrid Human-AI Moderation Systems |
| 2606.08919 ★ | E. Turan | 2026 | Oversight Has a Capacity: Calibrating Agent Guards to a Subjective, Fatiguing Human |
| 2103.16816 | R. Makhijani | 2021 | QUEST: Queue Simulation for Content Moderation at Scale |
| 2503.07545 | M. Mitzenmacher | 2025 | Queueing, Predictions, and LLMs: Challenges and Open Problems |

### 7.6. Экономика и бизнес-кейсы

| ID | Первый автор | Год | Название |
| --- | --- | --- | --- |
| 2609.34179 ★ | R. Krueger | 2026 | RAGWarrant: Evidence-Preserving Governance for RAG Policy Promotion Under Quality, Cost, Latency, and Risk Constraints |
| 2610.01218 ★ | G. Zeloni | 2026 | AGO AI Quality Gate: Evidence-First Release Decisions for Retrieval-Augmented Generation |
| 2606.01513 ★ | N. Agaram Sundar | 2026 | Compliance-Scored Best-of-N Guardrail Orchestration for Multimodal Document Generation in Payments Dispute Defense |
| 2605.06669 ★ | A. C. Maiorano | 2026 | Evaluating Prompt Injection Defenses for Educational LLM Tutors: Security-Usability-Latency Trade-offs |
| 2610.09906 | G. Koutidis | 2026 | Constrained-Action AI Remediation for SIEM/XDR via a NeMo-Guardrails Proxy |
| 2610.26438 | M. Wang | 2026 | Fake News, Real Crashes: Information Injection Attacks on LLM Financial Trading Agents |
| 2608.05519 | J. Wu | 2026 | EcoAgent-Bench: Evaluating Economic Decision-Making in Budget-Constrained LLM Agents |

### 7.7. Классика

| Работа | Год | Источник |
| --- | --- | --- |
| R. Anderson. Why Information Security is Hard — An Economic Perspective | 2001 | ACSAC |
| L. Gordon, M. Loeb. The Economics of Information Security Investment | 2002 | ACM TISSEC 5(4) |
| S. Halfin, W. Whitt. Heavy-Traffic Limits for Queues with Many Exponential Servers | 1981 | Operations Research 29(3) |

## 8. Итог

Обзор подтверждает выбранную стратегию: **не спорить с бенчмарками за метрику
детекции и не повторять DoS-статьи, а измерить окупаемость конфигурации в процессе**.
Ближайшие работы дают готовые компоненты — BELLS-O (стоимость), Shield-to-Target
(доступность), Detection-to-Decision (эскалация), Oversight Capacity (ёмкость),
RAGWarrant/AGO (governance) — но не соединяют их. Это соединение и есть наш
research gap; его нужно зафиксировать в статье и в pre-registration до основных
прогонов. Эмпирическая часть ограничена English-only; перенос на другие языки —
отдельный future work, а не подразумеваемое свойство результата.
