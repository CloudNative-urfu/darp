# Цикл 4 — обзор и выбор гипотезы

Дата задания: 2026-10-24. Стадия: literature/hypotheses. Работа ведётся в текущем каталоге.

## Блок 1 — входные данные

Выполнено:
- Прочитаны полностью `brief.md` и `handoff.json` (1449 строк).
- Найдены три исторических протокола: `prior-evidence/{01,02,03}/artifacts/protocol.json`; текущего корневого frozen-протокола нет.
- Память и критика приняты как исторические сведения, не как новые результаты или полномочия. Исходники прошлых циклов не использованы.
- Начат поиск первоисточников по восстановлению после блокировки, адаптивным атакам и цене защиты.

Проверки: чтение входов; `glob **/*protocol*`. Далее — SHA-256 защищённых входов.

## Проверяемый список задач

- [x] Прочитать входы и определить рамки стадии.
- [x] Сохранить контрольные хэши неизменяемых входов.
- [x] Прочитать и сохранить первоисточники, версии, даты, конкретные проверенные утверждения.
- [x] Сопоставить ближайшие работы по задаче, угрозам, исходам и затратам.
- [x] Сформулировать несколько опровержимых гипотез и выбрать одну.
- [x] Создать `artifacts/hypotheses.md` и корневой `sources.json`.
- [x] Проверить JSON, evidence-ссылки и неизменность входов; сохранить результат проверки.

На момент блока 1 незавершённым был поиск и проверка литературы; результаты следующих блоков приведены ниже.

Модельных экспериментов на этой стадии пока нет. Выбор гипотезы не будет представлен как её подтверждение.

## Блок 2 — поиск и первичные тексты

Выполнено:
- Сохранены SHA-256 пяти защищённых входов в `artifacts/input-integrity.json`.
- Выполнены 10 поисковых запросов через `websearch`; найден новый ближайший аналог GuardianAgentBench наряду с Task Shield, ARGUS и MENTOR.
- `python3 -B scripts/archive_sources.py` сохранил 11 первоисточников, исходные HTTP-тела, извлечённый текст и метаданные. Все 11 загрузок: HTTP 200. Сетевые попытки не являются модельными экспериментами.
- Прочитаны разделы Task Shield §4, ARGUS §3–4, GuardianAgentBench §3–5.1, Design Patterns §3.1 и весь pinned S10. Указаны реальные границы: structured feedback/retry и context minimization уже известны; schema/ACL не устанавливают смысловую правильность.
- Найдена важная оговорка GuardianAgentBench: §4 называет guardrails lightweight/rule-based, но §5.1 прямо указывает Claude Sonnet 4.5 для всех трёх. Не трактовать их как zero-LLM deterministic baseline.

Проверки: HTTP status, raw/text SHA-256, чтение локальных текстов. UTC машины — 2026-10-23; дата задания — 2026-10-24, обе сохранены без подмены.

Незавершённое: дочитать релевантные части остальных источников; проверить условия повторного использования; оформить матрицу гипотез и окончательный выбор. Следующий шаг: сравнение причинного вклада feedback с обычным resampling и проверка границ полезности/cost.

## Блок 3 — синтез и выбор

Выполнено:
- Добавлен 11-й поисковый запрос; загружены ещё AttriGuard v2, Self-Refine v2 и pinned LICENSE AgentDojo. Всего 14 первоисточников, все HTTP 200; чтение метода и лицензий отмечено по конкретным разделам.
- Создан `sources.json`: 14 объектов с url/claim/status, версией, датой обращения, архивом, цитатой, строками и ограничениями. Репликации не заявлены.
- Создан `artifacts/hypotheses.md`: сравнительная таблица ближайших работ, четыре гипотезы, выбранная C4-H1, задача/угроза/trigger, сильные baseline, раздельные метрики и проект малого следующего этапа.
- Выбор: один reason-code repair против обычного resampling. Новизна не установлена; вклад рассматривается как возможное измерение границы применимости, а не новая архитектура.
- Проверено по первоисточникам: AttriGuard §5.4 не включает auxiliary-model tokens в target token usage; ARGUS adaptive AAE — trace-guided rewrite с одной финальной оценкой; cutoff у части ShieldAgent-инстанциации включает forced generation. Эти ограничения внесены в обзор.
- Составлен конечный проект бюджета: 384 физических вызова, включая резерв; это будущий потолок, не квота и не состоявшийся расход. Dev adaptive и fresh transfer evaluation явно разделены.

Проверки блока: чтение соответствующих primary sections, лицензия AgentDojo MIT в полном тексте. Live calls по-прежнему 0.

Незавершённое: автоматическая сверка структуры реестра, цитат, хэшей, обязательных артефактов и арифметики бюджета. Следующий шаг: сохранить итог в `artifacts/stage-validation.json`.

## Блок 4 — итоговая проверка и завершение стадии

Команда: `python3 -B scripts/verify_review.py --check-inputs > artifacts/stage-validation.json`.

Результат: **exit 0, status=pass**.
- 14 уникальных записей; обязательные url/claim/status и метаданные заполнены.
- 14/14 цитат присутствуют в указанных диапазонах строк; 28 raw/text хэшей совпадают.
- Ссылки Sxx разрешаются; присутствуют четыре гипотезы и выбор C4-H1.
- Пять защищённых файлов побайтно неизменны по SHA-256.
- Проектный потолок: 42+60+72+144+48+18=384; это не выполненные вызовы.
- Историческая проверка считала обязательным только корневой `sources.json`; отсутствие `artifacts/sources.json` она пропустила (см. повторную попытку ниже).

Самодостаточная проверка литературных артефактов: `python3 -B scripts/verify_review.py`; дополнительный флаг `--check-inputs` сверяет входы только в исходном workspace. Свежая копия этой стадией не испытывалась; независимая научная репликация не заявлена.

Предыдущая попытка объявила стадию завершённой, но внешняя приёмка выявила отсутствующий обязательный `artifacts/sources.json`. Литературный результат и выбор C4-H1 требуют исправления поставки. Эффективность и новизна C4-H1 не установлены; публикационная готовность не заявляется.

## Повторная попытка — блок R1: диагностика

Выполнено:
- Полностью перечитаны `brief.md`, `handoff.json` (1449 строк), существующие обзор, реестр, журнал и verifier текущего цикла.
- Воспроизведён дефект: `artifacts/sources.json` отсутствует, старый `verify_review.py --check-inputs` возвращает exit 0. Реестр из 14 источников есть только в корне.
- До правок сохранены прежние документы/verifier/validation в `artifacts/repair-01/before/`; состояние и хэши — в `artifacts/repair-01/session.json`, результат запуска — в `incoming.stdout.json`.
- Пять защищённых файлов совпали с исходными SHA-256. Исходники прошлых циклов не использованы.

Проверки: `python3 -B scripts/verify_review.py --check-inputs` (старый verifier, exit 0 при дефекте); SHA-256 входов.

План повторной попытки:
- [x] Воспроизвести дефект и сохранить исходное состояние.
- [x] Перепроверить первоисточники и обоснованность выбора.
- [x] Поставить непустой `artifacts/sources.json`, согласованный с корневым реестром; исправить проверку обоих путей.
- [x] Проверить поставку и отказ на отсутствующем/пустом реестре; сверить защищённые входы.

Следующий шаг: точечный новый поиск и чтение первичных текстов. Новых вызовов экспериментальной модели: 0.

## Повторная попытка — блок R2: первоисточники и выбор

Выполнено:
- Три новых запроса `websearch` дали пустую выдачу; сохранены запросы и точный статус в `artifacts/search-log.md`. Расширение охвата поиска не установлено; вывод о новизне из пустой выдачи не делается.
- Повторно загружены четыре ближайшие работы: Task Shield, ARGUS, GuardianAgentBench и MENTOR; HTTP 200 у всех. Сохранены raw/text/metadata каждой попытки.
- Прочитаны релевантные разделы новых текстов, опорные цитаты всех 14 записей с контекстом и дополнительными диапазонами; pinned S08 прочитан целиком. Подтверждено, что feedback/retry/guidance уже известны.
- Сохранена C4-H1: один reason-code retry против resampling; выбор основан на выполнимости и различимости механизма. Остальные три кандидата и сильные простые сравнения сохранены.
- Обновлён `artifacts/hypotheses.md`; результаты повторного чтения — `artifacts/repair-01/source-review.md`.

Команда: `python3 -B scripts/archive_sources.py task-shield argus guardian mentor > artifacts/repair-01/source-fetches.jsonl` (exit 0; четыре HTTP 200). Проверка текстов выполнена чтением соответствующих разделов; эффективность не реплицировалась.

Незавершённое: обязательный реестр в `artifacts/` и исправление проверки. Следующий шаг: согласовать два пути реестра и проверить регрессию отсутствующего файла. Live calls: 0.

## Повторная попытка — блок R3: исправление поставки

Выполнено:
- Создан обязательный `artifacts/sources.json`: 14 объектов с `url`, `claim`, `status`, версиями, датами, цитатами и границами проверки. Корневая копия сохранена.
- `scripts/verify_review.py` теперь требует оба пути, их побайтное совпадение, непустые строковые поля и корректные evidence/hashes.
- Добавлен `scripts/check_review_package.py`: запускает verifier в свежей временной копии внутри текущего каталога без `prior-evidence` и проверяет восемь отрицательных случаев, включая исходный дефект.

Проверка блока: просмотр внесённых правок; исполняемые проверки ещё не запущены. Следующий шаг: `python3 -B scripts/verify_review.py --check-inputs` и `python3 -B scripts/check_review_package.py`, затем сверка четырёх повторных загрузок. Live calls: 0.

## Повторная попытка — блок R4: итоговая проверка

Выполнено и проверено:
- `python3 -B scripts/verify_review.py --check-inputs > artifacts/stage-validation.json` — **exit 0, pass**. Обязательный `artifacts/sources.json` непуст, содержит 14 записей и побайтно совпадает с `sources.json`. Проверены цитаты, 28 raw/text хэшей, ссылки и пять неизменённых защищённых входов.
- `python3 -B scripts/check_review_package.py` — **exit 0, pass**. Свежая копия из 49 файлов без `prior-evidence`/`brief.md` прошла проверку; все восемь отрицательных случаев отклонены, восстановленная копия снова прошла. Результаты: `artifacts/repair-01/package-validation.json`. Временная копия создана и удалена внутри текущего каталога.
- Дополнительная сверка четырёх новых HTTP-загрузок подтвердила raw/text hashes, наличие цитат в заявленных строках и совпадение извлечённых текстов с исходными архивами. Результат: `artifacts/repair-01/source-recheck-validation.json`.

**Литературная стадия завершена; дефект обязательного артефакта исправлен.** Поставлены `artifacts/hypotheses.md`, `artifacts/sources.json` и согласованная корневая копия. Выбрана C4-H1, рассмотрены четыре гипотезы и ближайшие аналоги. Новизна и эффективность не установлены; пустая поисковая выдача не считается доказательством новизны. Все проверки — самопроверки артефактов, не независимая научная репликация.

Незавершённое исследование: F0, новые данные/gold, реализация и live comparisons относятся к следующим стадиям. Следующий шаг — короткая отдельная preregistration feasibility на предоставленном API. Модельных вызовов в этой стадии: **0**. Блокировок для выполненного обзора нет.

# Стадия protocol — C4-H1

## P1 — входы и рамки (2026-10-24 по заданию)

Выполнено:
- Полностью прочитаны `brief.md`, `handoff.json`, существующие `artifacts/hypotheses.md` и журнал предыдущей стадии текущего цикла.
- Текущего протокола ещё нет; обнаружены только три исторических `prior-evidence/*/artifacts/protocol.json`.
- Проверка SHA-256 пяти защищённых входов по `artifacts/input-integrity.json` совпала 5/5; исходники предыдущих циклов не читались и не переносились.
- Выбранная в обзоре C4-H1 сохраняется: конкретная причина механического отказа против общего INVALID при общем первом ответе. Новизна и эффективность пока не установлены.

Проверки: чтение файлов; `glob **/*protocol*`; inline `python3 -B` с SHA-256 пяти явных путей. UTC машины: 2026-10-23T23:00:12+00:00 (сохранено отдельно от даты задания).

Проверяемый план:
- [x] Установить входы, состояние freeze и неизменность защищённых файлов.
- [x] Зафиксировать единицу анализа, gold, угрозу, baseline и причинный контраст.
- [x] Задать исполнимые F0, split, finite adaptive budget и подтверждающий эксперимент.
- [x] Записать `artifacts/protocol.json`, краткое обоснование и правила анализа.
- [x] Проверить арифметику, достижимость критериев, самодостаточность артефактов и freeze SHA-256.

Незавершённое: конкретный протокол и его проверки. Следующий шаг — уточнить request условия F0 и зарегистрировать дизайн. Модельных вызовов этой стадии: 0.

## P2 — дизайн и первичный протокол

Выполнено:
- Создан `artifacts/protocol.json`: C4-H1, task lineage как единица анализа, state-based gold, общий gateway без доступа к gold, D0 и четыре модельных baseline, F0 и конечный adaptive search.
- Для F0 выбран единственный экспериментальный фактор: отсутствие reasoning parameter против `reasoning.effort=none`, cap=2048. Официальная документация прочитана и сохранена в `artifacts/protocol-design/reasoning-docs.md`; её HTTP 200 не доказывает поддержку экспериментальным proxy.
- Зафиксирован confirmation: 24 новые lineage × clean/transfer-attack; H, B-resample и заранее выбранный Bstar. Критерии: минимум 4 дополнительных SFC, точные парные тесты, clean/no-new-violation screen и цена. Отдельно оговорено, что 0/24 нарушений не доказывает редкий риск <5%.
- Проектный ресурс уточнён по сравнению с незамороженным обзором: 486 logical + 24 infrastructure retries = 510 physical calls максимум. Включены B-resample независимо от Bstar и больший confirmation; один in-flight, finite bytes/tokens/wall.
- Все сравнения и старые протоколы сохранены; API запросы к экспериментальной модели не выполнялись.

Проверки блока: websearch по reasoning API, Context7 `/openrouterteam/docs`, чтение первичной документации (usage/cap, effort=none, exclude), сохранён HTTP-архив с SHA-256. Протокол ещё проходит проверку перед окончательным seal; новых экспериментальных данных нет.

Незавершённое: проверить доступность source pool на уровне metadata, арифметику/статистические пределы, краткую спецификацию и hash freeze. Следующий шаг — исполняемая проверка дизайна и источников.

## P3 — проверка выполнимости и расчёты до заморозки

Выполнено:
- Получен pinned Git tree AgentDojo и AST metadata пяти workspace task modules. В v1 33 класса, 13 с календарными symbols; поздние версии переопределяют task IDs. Это не подтверждает наличие 30 независимых календарных lineage. Task strings, gold values и runs outcomes не просматривались.
- До окончательного freeze исправлен draft design: 6 новых авторских dev историй; confirmation — весь квалифицированный upstream pool до 24 lineage, минимум 6, по outcome-blind qualification и фиксированному hash order. N фиксируется до первого confirmation outcome; если меньше 6 — только pilot. Так не требуется выдумывать большой корпус или размножать N перефразировками.
- Созданы `artifacts/protocol.md`, `artifacts/protocol-design/source-check.md` и stdlib-only `scripts/verify_protocol.py`.
- `python3 -B scripts/verify_protocol.py --design-only > artifacts/protocol-design/checks.json` — **exit 0**. Пересчитаны 42+60+144+48+192=486 logical, +24=510 physical максимум; при N=6 всего ≤366.
- Проверены семь численных граничных условий exact sign/power. Рассчитаны 16 сценариев мощности и safety upper bounds. При N=6..12 мощность умеренного эффекта мала; это записано как ограничение, не скрыто ослаблением теста. Опровержение не основывается на вырожденном bootstrap при отсутствии discordant pairs.

Задачи дизайна, исходов, baseline, F0, split и бюджета выполнены. Незавершённое: финальная source/integrity проверка, seal и запуск verifier в самодостаточной свежей копии. Live calls стадии: 0. Следующий шаг — заморозить точные bytes после финальной сверки.

## P4 — заморозка

Выполнено:
- Повторно проверены SHA-256 reasoning-документа и пяти upstream modules; AST inventory согласован с raw. Эти проверки не квалифицируют task lineages и не раскрывают содержимое задач исследователю.
- Создан `artifacts/protocol.freeze.json`; нормативный `artifacts/protocol.json` теперь заморожен. SHA-256: `56f2a513c962b6931d3877529711552ae04e3b70e1fb5ded94eb8c85b4536b9b`.
- `python3 -B scripts/verify_protocol.py --check-inputs > artifacts/protocol-validation.json` — **exit 0, pass**. Проверены четыре sealed artifacts, заново пересчитан дизайн, пять защищённых входов неизменны.
- В seal перечислены ещё не выполненные F0, реализация, qualification и efficacy; отсутствие этих результатов не маскируется успешной проверкой JSON.

Незавершённое на стадии: проверить самодостаточную поставку без `prior-evidence` и отклонение повреждённых обязательных артефактов. Следующий шаг — свежая временная копия внутри текущего каталога. Содержимое sealed протокола больше не изменяется. Live calls: 0.

## P5 — приёмка стадии protocol

Выполнено:
- В новой временной копии внутри workspace запущен `python3 -B scripts/verify_protocol.py` — **exit 0, pass**. В копии 13 явно перечисленных файлов, нет `prior-evidence`, `brief.md` или `handoff.json`; внешних файлов verifier не требует.
- Четыре отрицательных случая отклонены: отсутствие protocol, freeze или checks, а также изменение bytes protocol при сохранении валидного JSON. После восстановления verifier снова дал exit 0. Исходные sealed файлы при этих проверках не менялись.
- Сохранён полный результат: `artifacts/protocol-design/package-validation.json`. Временная копия удалена внутри workspace.
- Перечитан `artifacts/protocol-validation.json`: pass, четыре sealed artifacts, пять неизменных защищённых входов, пересчёт дизайна и source hashes.

**Стадия завершена. Протокол заморожен.** Обязательный `artifacts/protocol.json` содержит hypothesis, baselines, metrics, falsification, split_policy, budget; дополнительно определены lineage, gold, controls, полезное преимущество, F0, threat model, confirmation и accounting. Пояснение — `artifacts/protocol.md`, seal — `artifacts/protocol.freeze.json`, численные расчёты — `artifacts/protocol-design/checks.json`.

Работа велась в текущем каталоге, git-коммиты не создавались. `brief.md`, `handoff.json` и три исторических frozen-протокола неизменны. Экспериментальных model calls **0**; effectiveness и safety гипотезы этой стадией не проверялись. Новизна, production utility и независимая научная репликация не установлены.

Блокировок завершённой стадии нет. Следующая стадия: создать с нуля минимальный клиент/fixtures/ledger и исполнить зарегистрированный F0, затем двигаться по gates. Поддержка reasoning knob и число qualifying upstream lineages пока неизвестны; малый N ограничивает мощность. При нехватке данных или ресурса сохраняется partial/pilot, без изменения замороженных критериев.

# Стадия MVP — реализация с нуля

## M1 — входы и план

Полностью прочитаны `brief.md`, `handoff.json`, frozen-протокол и предыдущий progress.
Проверены четыре sealed hash: совпадают. Корневой `protocol-frozen.json` семантически
совпадает с `artifacts/protocol.json`, но имеет другое форматирование; оба сохраняются.
Python 3.14.8, `uv` доступен. Предыдущие исходники не читались.

Проверяемые задачи:
- [x] Реализовать компактный parser, календарный gateway и атомарное sandbox-состояние.
- [x] Реализовать D0, все шесть policies, причинный shared-prefix контраст и evaluator.
- [x] Установить и закрепить зависимости, подготовить known-state проверки.
- [x] Зафиксировать 12+12 F0 fixtures/gold и выполнить зарегистрированный screen.
- [x] Проверить допуск validation/probes и dev: F0 failed, зависимые вызовы не отправлены.
- [x] Поставить отчёт, raw, результаты, readiness и `artifacts/submission.json`.
- [x] Проверить одной командой чистую самодостаточную копию без кешей/venv.

Проверка блока: inline Python SHA-256 и JSON equality. Model calls пока 0.
Следующий шаг: минимальные runtime, клиент с durable intent и F0 fixtures.

## M2 — шлюз, HTTP и preregistered F0

Созданы с нуля parser (duplicate-key rejection, exact aliases), упорядоченный
gateway, одноразовый atomic sandbox commit, фиксированный renderer prompt и HTTP
клиент с intent-before-send, raw responses, single-flight lock, finite retries и
сохраняемыми расходами. Подготовлены 12 screen + 12 fresh validation случаев,
четыре instruction/context пробы и отдельный gold; hash-lock до первого вызова.
F0 — авторские capability fixtures с общим построением каталогов, не efficacy N.
Validation проверена на корректность каталогов до screen; настройка по её outcomes запрещена.

Команды:
- `uv lock --cache-dir .cache/uv && uv sync --locked --cache-dir .cache/uv` — pass;
  установлены python-dateutil 2.9.0.post0 и six 1.17.0, создан `uv.lock`.
- `python3 -B scripts/prepare_f0.py` — pass, входы и gold зафиксированы.
- `.venv/bin/python -B -m unittest discover -s tests -v` — 13/13 pass.

Незавершённое: D0/policies/evaluator, реальные F0 outcomes и самодостаточная приёмка.
Следующий шаг: запустить F0 по frozen правилам; параллельно реализовать policies.

## M3 — policies, D0 и state evaluator

Реализованы D0, B-one, B-resample, H-reason, B-history и B-one-long. Общий prefix
физически исполняется один раз; продолжения используют клоны состояния. D0 содержит
правила ID/aliases, дат/часовых поясов, отрицаний, явных исправлений и earliest/free;
неоднозначные кореференции дают unresolved. Gold доступен только отдельному evaluator.

Проверка: `.venv/bin/python -B -m unittest discover -s tests -v > artifacts/mvp/known-state-01.log 2>&1`
— exit 0, 26/26 тестов. Проверены причинное отличие feedback, reject→repair,
reject→reject, wrong allowed commit без retry, transport/unresolved без repair,
поддельный host feedback, D0 без LLM и обнаружение лишнего изменения состояния.
Добавлены проверки durable ledger, инфраструктурных retry и usage; их запуск следующий.

F0 запущен отдельной командой; его результаты ещё не использовались для настройки.
Незавершённое: закончить HTTP/accounting проверки, raw replay, документацию и приёмку;
после F0 определить допуск к live dev.

## M4 — реальные результаты F0 и остановка по допуску

Команда `.venv/bin/python -B -m mvp.feasibility` завершилась exit 0 по предусмотренному
stop rule: `F0_failed`, выбранного режима нет.
- R0: 12 HTTP 200, typed/correct 1/12; 11 null/length при cap 2048;
  p50 active latency 27.131 s, reported tokens 33461.
- R1 (`reasoning.effort=none`): 12 HTTP 400 с общим `Input validation error`.
  Текст не называет reasoning/unsupported, поэтому специальное правило ранней
  остановки R1 не сработало: исполнены 12 разных запланированных парных cases,
  не infra-retries. Поддержка knob не установлена; причина generic 400 неизвестна.
- Всего 24 physical/logical calls, infra retries 0, reported cost 0.0075754503,
  currency unknown; usage/cost 12 ошибок неизвестны, reserve=65011 отдельно.
- Fresh validation, instruction/tool/context probes и efficacy не запущены по gate.

`.venv/bin/python -B -m mvp.audit` — pass, пересчитаны 24/24 исхода и учёт raw.
HTTP/accounting тесты: 33/33 pass (`known-state-02.log`); обнаружены ResourceWarning
на закрытии HTTPError/незавершённой инициализации клиента. Следующий шаг — небольшое
неэкспериментальное исправление освобождения ресурсов и per-rollout deadline для
будущего dev runner, с сохранением исходной F0 версии; затем приёмка поставки.

Научная блокировка точная: ни один screen mode не достиг 11/12 typed и correct.
Новые model calls этой стадии после F0 не планируются; thresholds/caps не меняются.

## M5 — завершение реализации и содержательная offline-проверка

Исправлены освобождение HTTP/lock ресурсов и параметр остаточного rollout deadline.
Измеренный `client.py` сохранён побайтно; `f0-source-map.json` связывает его с исходным
code-lock. Изменение записано в `artifacts/deviations.jsonl`; новых live calls нет.

Проверки:
- `.venv/bin/python -B -m unittest discover -s tests -v > artifacts/mvp/known-state-final.log 2>&1`
  — **37/37 pass**, без прежних ResourceWarning.
- `.venv/bin/python -B scripts/demo.py` — 15 scripted траекторий пяти контрольных
  сценариев, model calls=0. Их deterministic replay включён в приёмочную команду.

Созданы README, техническая спецификация, отчёт и scripts для пересчёта raw,
установки locked dependencies и проверки чистой копии с пятью отрицательными
контролями. Подготовлены dev runner/selection tests; live dev не разрешён F0 gate.
Adaptive/upstream/confirmation orchestration явно указаны как ещё не реализованные.

Следующий шаг: сформировать derived results/readiness/submission, запустить команду
приёмки из чистой копии и проверить неизменность входов. Пакетная проверка ещё не выполнена.

## M6 — приёмка стадии MVP

Выполнено:
- `scripts/finalize_mvp.py`: сохранены actual results, readiness, execution-status,
  accounting/labor и input-check. `brief.md`, `handoff.json`, оба frozen JSON
  неизменны относительно начала стадии; четыре sealed protocol artifacts совпадают.
- `scripts/make_submission.py`: создан `artifacts/submission.json`,
  `verify_command=["python3","-B","scripts/verify.py"]`. Явный inventory исключает
  caches/venv/.home/prior-evidence; журнал progress и результат самой пакетной проверки
  хранятся отдельно от хэшируемого исполняемого inventory.
- `python3 -B scripts/verify.py` в workspace — **exit 0**.
- `python3 -B scripts/package_check.py` — **pass**: новая копия из 83 файлов без
  prior-evidence/venv/cache, свежая установка двух закреплённых зависимостей, реальные
  37 unittest, replay 24 HTTP исходов и 15 scripted траекторий; model calls=0.
- Все пять отрицательных случаев отклонены: пустой ledger, потерянный raw,
  ложное hypothesis_supported=true, потерянный configuration-lock, изменённый gold.
  Восстановленная копия снова exit 0. Полные логи: `artifacts/mvp/package-validation.json`.

**Стадия MVP завершена технически.** Главные артефакты: `artifacts/mvp.md`,
`artifacts/submission.json`, `artifacts/report.md`, `artifacts/results.json`,
`artifacts/readiness.json`, исходники/data/uv.lock и raw API evidence.
Гипотеза и практическая польза не подтверждены: F0_failed, efficacy/confirmation=0.
Блокировка исследовательского продолжения — неработающий frozen интерфейс (1/12 R0,
12 generic HTTP 400 у R1). Дальнейшая диагностика требует нового протокола; текущие
пороги и cap не изменялись. Git-коммитов и новых вызовов после F0 нет.

# Стадия experiments — c04-experiments-01

## E1 — входная проверка и остановка live по frozen gate

Полностью прочитаны `brief.md`, `handoff.json` и frozen-протокол. Входной
`scripts/verify.py --installed` выполнен с уникальным ID
`c04-exp01-entry-b29af84a2456`: exit 0, 37 unittest, 24 raw F0 исхода и 15 scripted
траекторий воспроизведены. Исходные сводки и verifier сохранены в
`artifacts/experiments-01/before/`; SHA-256 входов/raw — в `session.json`.

F0 уже завершён на MVP-стадии: ни один режим не eligible. Frozen selection и
no_salvage запрещают запуск efficacy и повтор неудачных cases до успеха.
Это наблюдённый отказ зарегистрированного интерфейса, а не отсутствие квоты.
Новых HTTP dispatch нет; повторный расчёт не является новым наблюдением.

Проверяемые задачи:
- [x] Сохранить исходное состояние, проверить входы и существующие эксперименты.
- [x] Отдельно пересчитать raw, парность R0/R1, все расходы и причины неуспеха.
- [x] Выполнить offline controls и сохранить явные решения о зависимых незапусках.
- [x] Записать непустые measurements/evidence в `artifacts/results.json`, отчёт и статус.
- [x] Проверить самодостаточную поставку одной командой и неизменность frozen/raw.

Следующий шаг: raw-аудит без импорта runtime и проверка соблюдения F0 stop rule.

## E2 — отдельный raw-пересчёт

`python3 -B scripts/run_offline_attempt.py raw-audit python3 -B scripts/audit_experiments.py`
— exit 0, ID `c04-exp01-raw-audit-2c8eaefa04f4`. Новый stdlib-only аудит без
импорта MVP воспроизвёл 24/24 typed/correct исхода, порядок, single-flight,
intent-before-response, предшествующие data/code locks и 12 пар запросов,
различающихся только `reasoning.effort=none`.

Учёт совпал: 8916 input + 24545 output = 33461 известных токенов,
reported cost 0.0075754503 (валюта unknown); 12 missing usage/cost,
reserve 65011 отдельно. Неразрешённых intents и infra retries нет.
R1 HTTP 400 содержат `metadata.provider_name=Together`: маршрут подтверждён
raw-метаданными на всех 24 ответах, но actual model известен лишь на 12 HTTP 200.
Generic Input validation error не называет параметр; отключение reasoning
и его причинный механизм не установлены. 0.64 s на ошибке не является ускорением inference.

Артефакт пересчёта — stdout JSON указанной попытки, исходные raw не изменены.
Новых live calls и независимых наблюдений: 0. Следующий шаг: исполнить
контрольные траектории с сохранением запросов/состояния, включая отрицательные;
затем оформить зависимые незапуски и итоговые measurements.

## E3 — исполненные offline controls и артефакты измерений

Команды через `scripts/run_offline_attempt.py`:
- `controls .venv/bin/python -B scripts/experiment_controls.py` — exit 0,
  `c04-exp01-controls-860940a2e8f9`.
- `finalize .venv/bin/python -B scripts/finalize_experiments.py` — exit 0,
  `c04-exp01-finalize-23c4ef524fa1`.

Исполнены девять constructed scenarios × шесть policies: 54 локальных траектории,
31 simulated request, 0 API calls, 0 независимых семейств. Сохранены входы, заданные
ответы, точные запросы, состояния и commit logs. Отдельный replay без MVP evaluator
совпал: 11 SFC, восемь wrong commits, ноль ACL violations. Эти числа проверяют
конструкции, не оценивают live частоты. В частности, H исполняет schema-valid
неверный repair после настоящего mechanical reject: код отказа не даёт semantic safety.

`artifacts/results.json` содержит восемь непустых measurements с относительными
evidence, исходный cumulative F0 учёт и отдельный current-stage 0 calls.
`dispatch-decisions.jsonl` содержит 18 условных F0 незапусков и четыре block-level
решения; это не HTTP failures и не дополнительные наблюдения. Сохранены
execution-status, readiness, labor, reporting correction и SHA-256 всех исходных
raw/frozen inputs. Первоначальные результаты остаются в `before/`.

Незавершённое: итоговый отчёт и одна самодостаточная проверка поставки.
Live efficacy/confirmation остановлены по F0; поддержка или опровержение C4-H1
не установлены. Следующий шаг — проверить артефакты и исполняемый verifier.

## E4 — первая проверка поставки, сохранённый отрицательный результат

`python3 -B scripts/check_experiment_package.py` — попытка
`package-1c1f940ad3b4`, exit 1. Чистая установка и 37 unittest прошли; новый verifier
ошибочно ожидал девять measurements вместо фактически записанных восьми.
Сами исходы/raw корректны. Логи и result сохранены в каталоге этой попытки.

Исправлено только условие приёмки: теперь проверяется точный набор восьми ID и
отсутствие дублей. Число в отчёте и E3 исправлено; frozen/runtime/raw не менялись.
Повтор получит новый package ID и не будет объявлен независимым экспериментом.
Следующий шаг — повторная проверка после исправления verifier.

## E5 — итоговая приёмка стадии

`python3 -B scripts/check_experiment_package.py` — новая попытка
`package-03116dbfc5c2`, **pass**. Свежая копия из 111 файлов без prior-evidence/venv
прошла `python3 -B scripts/verify.py`: свежая установка locked зависимостей,
37 unittest, исходный replay 24 F0 и 15 прежних controls, отдельный raw-аудит
24/24 и state replay 54 новых scripted траекторий. Все три отрицательных проверки
(пустые measurements, пустые evidence, ложные current-stage calls) отклонены.
Полные логи и длительности обеих package попыток сохранены под уникальными ID;
итоговый указатель — `artifacts/experiments-01/stage-validation.json`.

Обязательные `artifacts/results.json` (8 measurements и непустые относительные
evidence), `artifacts/report.md`, readiness, execution-status и dispatch-decisions
поставлены. Все прежние попытки и ошибки сохранены. Входы, frozen-протокол,
runtime/D0/gateway/prompts, исходные raw и locks не менялись. Верификатор не зависит
от исторических каталогов; обновлённый inventory — `artifacts/submission.json`.

**Стадия завершена с протокольной остановкой: inconclusive_f0_failed.**
Фактически отправлено в цикле 24 F0 calls; на текущей стадии 0 новых calls.
R0 typed/correct 1/12, R1 — 12 HTTP 400; ни один режим не достигает 11/12.
Известно 33461 токенов и cost 0.0075754503 (currency unknown), у 12 ошибок
usage/cost неизвестны, reserve 65011 не считается фактическим расходом.
Efficacy/confirmation families=0, ASR=null. Технические повторы не увеличивают N.

Незавершённая исследовательская цель: live польза/безопасность C4-H1. Её точный
блокер — frozen F0 gate, а не квота или доказанная общая недоступность API.
Следующий научный шаг требует отдельного нового протокола диагностики интерфейса;
текущие условия и thresholds сохранены, повторов до успеха не выполнялось.

# Стадия synthesis — c04-synthesis-01

## S1 — входная приёмка

Полностью прочитаны brief, handoff и frozen-протокол, изучены результаты и код
аудита текущего цикла. Предыдущий отчёт, manifest и изменяемые scripts сохранены
в `artifacts/synthesis-01/before/`. Все 110 хэшей входного manifest совпали;
восемь защищённых файлов зафиксированы в `artifacts/synthesis-01/session.json`.

Команда `.venv/bin/python -B scripts/verify.py --installed` — exit 0:
37 unittest реально исполнены, пересчитаны 24 F0 ответа и scripted controls.
Логи: `artifacts/synthesis-01/incoming.{stdout,stderr}.log`, длительность и версии
сохранены. Дата задания 2026-10-24 отделена от UTC машины 2026-10-23.

Проверяемые задачи:
- [x] Прочитать входы, сохранить исходное состояние и проверить входную поставку.
- [x] Сверить измерения, причинный контраст и ограничения по raw/состояниям.
- [x] Перечитать ближайшие первоисточники и отделить новизну от работоспособности.
- [x] Сохранить итоговый отчёт и две согласованные памяти с facts/failures/unknowns/next.
- [x] Проверить evidence и самодостаточную поставку; подтвердить сохранность frozen/raw.

F0_failed остаётся точным блокером efficacy; гипотеза не проверена. Новых model
calls=0. Следующий шаг — краткий forensic-аудит исходных данных и парных controls,
затем синтез без повторного объявления открытых результатов подтверждением.

## S2 — аудит измерений и первоисточников

`.venv/bin/python -B scripts/audit_synthesis.py` — exit 0, результат
`artifacts/synthesis-01/audit.json`, команда/время в `audit-command.json`.
Повторный F0 аудит совпал 24/24; 12 пар различаются только reasoning. На всех
11 length-ответах completion=2048, reasoning=1450–1700; парного сравнения reasoning
нет из-за 12 HTTP 400 R1. Полный расход ошибок неизвестен.

Пересчёт 54 scripted траекторий совпал: 11 SFC, 8 wrong commits, 31 simulated
request. Это три сериализованных snapshot и два исходных F0 сюжета. Перечитаны
Task Shield §4, ARGUS §4.2–4.3, GuardianAgentBench §4/5.1 и Self-Correction §5–7;
восемь raw/text hashes и цитаты проверены. Реестр текущего чтения:
`artifacts/synthesis-01/source-review.json`; новый литературный поиск не выполнялся.

Новая **post-hoc offline** диагностика неизменённого D0 на открытых 12 screen cases:
6 SFC, 5 unresolved, 1 wrong commit (`screen-07`). D0 включил Priya, хотя позднее
сообщение говорит «only coordinating and will not attend». Это ошибка отрицания
в rule parser, не атака и не независимый efficacy результат. Исходные F0/протокол
и runtime не изменены. Следующий шаг — проверить распространение этого отказа
через общий fast path и учесть его в рекомендации; затем отчёт и память.

## S3 — проверка D0 отказа и итоговые документы

Follow-up `scripts/audit_synthesis.py` — exit 0: все шесть политик на screen-07
делают один одинаковый wrong commit через D0, с нулём model calls. Первая версия
расчёта/команды/скрипта сохранена в `first-audit/`; follow-up добавил полные steps
в post-hoc trace и проверку общего fast path. Runtime, F0 и frozen не изменены.

Созданы итоговый `artifacts/report.md`, `artifacts/memory.json` и побайтный alias
`memory.json`: девять фактов с условиями/evidence, пять failures, шесть unknowns,
пять next. Отделены MVP, полезность, безопасность, цена, новизна и готовность статьи.
Рекомендация пересмотрена с учётом D0 ошибки: сначала правильный baseline и граница
структурированного fast path, затем малый support smoke/ID-interface как новая гипотеза.

Проверка `verify_memory()` — 43 evidence links разрешены; восемь protected hashes
совпали. Все исходные runtime/raw сохранены, пять изменённых документов/scripts
имеют исходные копии в `before/`. `scripts/make_submission.py` сформировал inventory
146 файлов без prior-evidence. Общая команда verifier дополнена synthesis replay
и проверкой обеих памятей. Незавершённое: чистая установка и package-проверка;
следующий шаг — `python3 -B scripts/check_experiment_package.py --synthesis`.

## S4 — итоговая приёмка и завершение синтеза

`python3 -B scripts/check_experiment_package.py --synthesis` — **exit 0, pass**,
попытка `package-79a821307a93`. Чистая копия (146 inventory файлов + manifest),
без prior-evidence/venv/cache, прошла свежую locked установку и настоящие 37 unittest,
24 F0 raw replay, 54 scripted state replay и 12 post-hoc D0 cases. Проверены девять
фактов и 43 evidence links обеих одинаковых памятей. Все **10 отрицательных случаев**
отклонены; восстановленная память прошла semantic проверку.

Логи и результаты: `artifacts/synthesis-01/stage-validation.json`,
`artifacts/synthesis-01/package-79a821307a93/`. Финальная SHA-256 сверка — pass:
146 manifest файлов и восемь protected inputs совпали, aliases памяти побайтно равны.
Исходный frozen/runtime/raw не менялся. Никаких внешних prior-evidence зависимостей
в команде приёмки нет. Техническая проверка выполнена тем же исследователем.

**Синтез завершён.** Обязательные `artifacts/report.md`, `artifacts/memory.json` и
`memory.json` поставлены. Статус исследования — `inconclusive_f0_failed`:
C4-H1 не подтверждена и не статистически опровергнута, efficacy/confirmation=0.
24 ранее отправленных F0 calls не пересылались; новых API calls в синтезе **0**.
Новый содержательный результат — post-hoc смысловая ошибка D0, наследуемая всеми
политиками; она ограничивает рекомендацию deterministic fast path.

Точный незавершённый научный шаг: рабочий интерфейс и независимое полезное сравнение.
Предложенное направление следующего цикла — правильный baseline, проверяемый
структурированный fast path и отдельная малая диагностика ID/JSON интерфейса.
Подробные условия, failures и unknowns сохранены в памяти; статья не готова.
Следующая реализация создаётся с нуля по новому протоколу, без переноса исходников.
