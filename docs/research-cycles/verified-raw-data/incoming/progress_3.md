# Цикл 3 — обзор источников и выбор гипотезы

Дата: 2026-10-24. Стадия: `c03-literature-01`.

## Проверяемые задачи
- [x] Прочитать `brief.md` и весь `handoff.json`.
- [x] Выделить ограничения прошлых циклов и границы текущей стадии.
- [x] Зафиксировать контрольные суммы неизменяемых входов и протоколов.
- [x] Выполнить новый поиск, сохранить запросы и прочитать первоисточники.
- [x] Сопоставить ближайшие работы по задаче, угрозе, исходам и затратам.
- [x] Сформулировать несколько опровержимых гипотез и выбрать одну.
- [x] Создать `artifacts/hypotheses.md` и корневой `sources.json`.
- [x] Проверить ссылки на доказательства, целостность входов и поставку стадии.

## Блок 1 — входные данные
Выполнено: прочитаны 180 строк brief и 890 строк handoff; найдены протоколы
`prior-evidence/01/artifacts/protocol.json` и `prior-evidence/02/artifacts/protocol.json`.
Корневого замороженного протокола при начальном осмотре нет.

Проверки: `read brief.md`, `read handoff.json` (включая продолжение с 743-й строки),
`glob prior-evidence/**/*protocol*`, `glob **/AGENTS.md`.

Результаты: память сообщает о двух непрошедших feasibility и отсутствии live efficacy.
Эти сведения пока имеют статус входных данных кампании, не повторно выполненных
экспериментов. Сильный D0, невырожденный причинный контраст, независимый gold и
раздельный учёт безопасности/полезности/расходов обязательны в новом дизайне.
Рост output cap без проверки reasoning повторяет уже неудачную постановку.

Незавершённое: новый поиск, проверка первоисточников, выбор кандидата.
Следующий шаг: контрольные суммы и поиск как по semantic integrity, так и по
злоупотреблению бюджетом защитной реакции. Текущая стадия — обзор и выбор;
живых обращений к экспериментальной модели пока 0.

## Блок 2 — контроль входов и первичный поиск
Выполнено: SHA-256 четырёх входов сохранены в `artifacts/input-integrity.json`;
проведены семь websearch-запросов, отобранные находки и точные запросы сохранены
в `artifacts/search-log.json` (это транскрипция, не сырые ответы поиска).

Результаты: обнаружены более свежие ARGUS v2 и From Shield to Target v2,
а также Möbius Injection v2 и Bounded Agents. Они потенциально перекрывают
гипотезы о quarantine/бюджетах. Сниппеты ещё не подтверждают механизмы.

Проверки: Python 3.14.8, `hashlib.sha256` для четырёх явно перечисленных файлов;
`functions.websearch` Q01–Q07. Создан новый стандартно-библиотечный архиватор,
не использующий исходники прошлых циклов.

Незавершённое: чтение и сопоставление полных текстов.
Следующий шаг: `python3 -B scripts/archive_sources.py artifacts/source-urls.json`,
затем проверка релевантных разделов и ограничений каждой ближайшей работы.

## Блок 3 — первоисточники защит
Выполнено: заново получены девять версионированных полных HTML (все HTTP 200),
сохранены исходные байты, извлечённый текст, время обращения и SHA-256.
Прочитаны разделы механизмов Patterns, GoEx, SIEVE, ARGUS, MENTOR,
Bounded Agents, From Shield to Target и Möbius, а также методология adaptive
out-of-band оценки. Точное покрытие чтения будет указано в реестре источников.

Проверки: `python3 -B scripts/archive_sources.py artifacts/source-urls.json`;
поиск `budget/quarantine/fail-open/License` в `artifacts/sources/*.txt` и чтение
контекста соответствующих разделов.

Результаты: изоляция, указатели вместо свободного текста, selective audit,
recovery hints, накопительные бюджеты и quarantine уже описаны. В Möbius
эффект quarantine оценивается offline replay; clean TSR не включает
отклонённые на входе документы. В Shield to Target нужно различать
низкопривилегированную инъекцию и отдельный случай изменения генерации.
Числа из этих работ не реплицированы.

Уточнение поиска: проверяется узкая гипотеза прерывания повторов без новой
информации. Дополнительный поиск уже нашёл прямой инженерный аналог
`Ericsson/yocto-security-tools` (no-information turns) и работы про
autonomy tax/context contamination. Они требуют чтения до выбора кандидата.
Context7 нашёл официальную документацию OpenRouter: `exclude=true` скрывает
reasoning, но не отключает вычисление. Поддержка управления reasoning нашим
loopback/Together пока неизвестна; live calls=0.

Незавершённое: новые ближайшие аналоги, ограничения, лицензии, окончательный выбор.
Следующий шаг: архивировать follow-up источники и уточнить причинный контраст.

## Блок 4 — критическое сопоставление и выбор
Выполнено: прочитаны дополнительные первоисточники; всего 16 документов,
11 websearch-запросов и отдельная документационная проверка. Сохранён корневой
реестр `sources.json` со степенью проверки, версиями, строками и ограничениями.
Созданы `artifacts/hypotheses.md` и `artifacts/stage-status.json`.

Результаты: выбрана C3-H3 — obligation-scoped остановка бесплодных повторов;
C3-H1 (reasoning, затем компактный интерфейс) — предшествующий feasibility.
Найден прямой инженерный аналог S10: нет оснований заявлять новую архитектуру.
Baseline включает его сильную адаптацию; эквивалентность прекращает сравнение
«двух имён одного поведения». У CCRM обнаружено внутреннее расхождение знаков
в доказательстве; численные теоремы не используются как подтверждённые факты.

Проверки: чтение релевантных полных разделов S01–S16; извлечение observed commit
IDs из архивированных GitHub HTML в `artifacts/sources/web-versions.json`.
Все сетевые получения HTTP 200; код и модели первоисточников не запускались.
Дата задания 24 октября отличается от измеренного UTC 23 октября; исходные
timestamps сохранены и различие отмечено в отчёте.

Незавершённое: машинная проверка ссылок/хэшей и самодостаточной копии.
Следующий шаг: offline verifier без зависимостей на исходники прошлых циклов.

## Блок 5 — приёмка артефактов стадии
Выполнено: написан новый `scripts/verify_stage.py`; сформирован manifest из 63
файлов, включая четыре защищённых ввода и полный архив источников. Проверка
прошла в основном каталоге и в свежей временной копии **внутри текущего каталога**.
Во вторую копию попали только manifest-файлы и сам manifest (64 файла); она
удалена после проверки. Внешние prior-evidence пути не требовались.

Команды:
- `python3 -B scripts/verify_stage.py > artifacts/validation.json`
- Python `TemporaryDirectory(dir=Path.cwd())` → копирование manifest →
  `subprocess.run([sys.executable, '-B', 'scripts/verify_stage.py'], cwd=fresh)`;
  журнал — `artifacts/validation-clean-copy.json`.

Результат: exit 0 в обеих проверках; четыре защищённых SHA-256 неизменны,
16 source records, 29 допустимых диапазонов доказательств, 32 проверенных
raw/text SHA-256, 11 записанных поисковых запросов. Это проверка целостности,
ссылок и самодостаточности поставки тем же исследователем, не научная репликация.
Финальный manifest пересчитывается после сохранения этого блока и повторно
проверяется вместе с чистой копией.

Итог: обязательные `artifacts/hypotheses.md`, корневой `sources.json` и progress
готовы. Выбрана C3-H3 с prerequisite C3-H1; прямые аналоги и потенциальная
эквивалентность сильному baseline явно отмечены. Новизна/эффективность/MVP/статья
не подтверждены; экспериментальная модель не вызывалась (0 calls).

Незавершённого по стадии обзора нет. Следующий шаг кампании: отдельная регистрация
конечного feasibility управления reasoning и компактного интерфейса, затем
независимые данные и проверка невырожденности механизма. Точные зависимости и
ограничения будущих экспериментов сохранены в `artifacts/stage-status.json`.

## Повторная попытка, блок 6 — диагностика приёмки

Повторно прочитаны весь `brief.md` и `handoff.json`, текущие гипотезы, реестр,
статус и код верификатора. Предыдущие блоки сохранены как история попытки.

Проверка: `python3 -B scripts/verify_stage.py` вернула exit 0 (63 manifest-файла,
16 источников, 4 неизменных защищённых ввода). При этом обязательный
`artifacts/sources.json` отсутствует: старый verifier проверяет только корневой
`sources.json`. Значит, прежняя отметка о завершении относится к неполному
контракту поставки и не подтверждает прохождение внешней приёмки.

Дополнительно выполнены два websearch-запроса: точный запрос об Ericsson дал
нерелевантную выдачу, запрос о guardrail DoS вернул первичный Shield to Target.
Это не опровергает существование ближайшего инженерного аналога; нужна сверка
самого документа. Новых модельных экспериментов нет.

Проверяемые задачи повторной попытки:
- [x] Найти причину отсутствующего обязательного артефакта.
- [x] Перечитать первичные свидетельства для выбора и ближайших альтернатив.
- [x] Поставить непустой `artifacts/sources.json`, согласованный с корневым реестром.
- [x] Добавить проверку обоих путей, обновить manifest и ссылки.
- [x] Проверить свежую копию и отрицательные случаи missing/empty/mismatch.

Следующий шаг: сверка первоисточников и сохранение результатов повторного поиска.

## Повторная попытка, блок 7 — первоисточники и обязательный реестр

Выполнено: перечитаны релевантные первичные разделы S01–S07, S10, S14–S15;
новые запросы Q12–Q13 добавлены в `artifacts/search-log.json` (13 запросов всего).
Команда `python3 -B scripts/archive_sources.py artifacts/source-urls-recheck.json`
сохранила четыре новых получения HTTP 200. SHA-256 raw/text для Shield to Target v2
и Möbius v2 совпали с архивами первой попытки. По закреплённому commit Ericsson
получены и полностью прочитаны progress/budgets и MIT LICENSE; код не запускался.
Ограничение лицензий зависимостей сохранено отдельно.

Создан `artifacts/sources.json`: 16 записей с `url`, `claim`, `status` и ссылками
на первичные свидетельства. Обе копии реестра дополнены повторными получениями;
выбор C3-H3 и отсутствие доказанной новизны сохранены. Входные отчёты прежней
приёмки, manifest и реестр сохранены в `artifacts/repair-01/before-*.json`.

Результат: исправлено отсутствие файла; чтение источников подтверждает близкий
инженерный аналог, а не научную новизну. Live model calls по-прежнему 0.
Незавершённое: машинный отчёт повторного чтения и обновлённая приёмка поставки.
Следующий шаг: проверка required-path, непустоты, равенства копий и чистой копии.

## Повторная попытка, блок 8 — исправленная приёмка

Выполнено: `scripts/verify_stage.py` теперь требует непустой список в
`artifacts/sources.json`, непустые строковые `url`, `claim`, `status`, равенство
обеих копий и включение обязательного пути в manifest. Проверяются также четыре
повторных получения, их хэши, диапазоны доказательств и совпадения версий.
Сохранён `artifacts/repair-01/source-recheck.json` с границами повторного чтения.

Команда `python3 -B scripts/package_stage.py` вернула exit 0:
- 84 manifest-файла; 85 файлов в самодостаточной свежей копии внутри workspace;
- 16 источников, 29 исходных диапазонов свидетельств, 13 поисковых запросов;
- 32 исходных и 8 повторных raw/text SHA-256 проверены;
- `brief.md`, `handoff.json` и оба замороженных протокола — 4/4 неизменны;
- чистая копия проходит проверку, exit 0;
- все 4 отрицательных случая отвергнуты: отсутствующий артефакт, пустой файл,
  пустой массив и рассогласованные корневая/обязательная копии.

Журналы: `artifacts/validation.json`, `artifacts/validation-clean-copy.json`,
`artifacts/validation-negative.json`. Старые журналы сохранены в `repair-01/`.
Это проверка поставки тем же исследователем, не независимая научная репликация.
После сохранения этого блока команда упаковки повторяется для финального хэша
`progress.md`; до этого её успех относится к предыдущему содержимому журнала.

Итог стадии: обязательные артефакты на обоих путях реестра заполнены; четыре
гипотезы и ближайшие работы описаны в `artifacts/hypotheses.md`, выбрана C3-H3
с первоочередным feasibility C3-H1. Научная новизна и эффективность не установлены,
прямой аналог включён в сильные сравнения. Экспериментальная модель: 0 calls.
Незавершённого по текущей стадии обзора нет; следующий шаг кампании — отдельная
регистрация feasibility и проверка поведенческого отличия от сильного baseline.

# Стадия регистрации протокола — c03-protocol-01

Дата задания: 2026-10-24. Область стадии: дизайн и заморозка, до live dispatch.

## Проверяемые задачи
- [x] Прочитать brief/handoff целиком и выбранную гипотезу текущего цикла.
- [x] Проверить входную поставку и неизменность четырёх защищённых файлов.
- [x] Зафиксировать единицу анализа, gold, угрозу, механизм и сильные сравнения.
- [x] Задать конечные feasibility, selection и независимое confirmation.
- [x] Проверить статистические правила, бюджет, зависимости и критерии отказа.
- [x] Создать обязательный artifacts/protocol.json и самодостаточную проверку.
- [x] Проверить поставку в свежей копии внутри workspace и заморозить хэш.

## Блок P1 — входная проверка

Выполнено: прочитаны 180 строк brief, 890 строк handoff, текущие hypotheses,
stage-status и input-integrity. Найдены только два старых frozen protocol в
prior-evidence; нового artifacts/protocol.json ещё нет. Локальных AGENTS.md нет.
Исходная история progress и manifest сохранены в artifacts/protocol-stage/incoming-*.

Команда: `python3 -B scripts/verify_stage.py` (до изменения progress).
Результат: exit 0; 84 manifest-файла, 16 источников, четыре защищённых ввода
неизменны. Журнал: artifacts/protocol-stage/incoming-validation.json.
Это проверка поставки, не повторение модельных экспериментов прошлых циклов.

Дизайн продолжает выбранную C3-H3 с предэтапом C3-H1. Сильный S10-style baseline
обязателен; поведенческая эквивалентность не допускает заявления нового механизма.
Модельных вызовов на этой стадии: 0. Незавершённое: конечный протокол и его проверка.
Следующий шаг: уточнить первичные спецификации progress/reasoning, затем записать
полный план до экспериментов. Исходный manifest относится к сохранённой входной
версии progress; новая стадия получит собственный manifest.

## Блок P2 — полный дизайн до заморозки

Выполнено: создан draft artifacts/protocol.json с обязательными hypothesis,
baselines, metrics, falsification, split_policy, budget и подробными определениями
gold, единицы анализа, controls, attack feedback, gating и confirmation.
Перечитаны S10 (все 63 строки pinned документа), S15 (166–240) и relevant S14.
Reasoning R0/R1/R2 проверяется как неизвестный pass-through; затем отдельный
full/compact фактор и fresh validation. max_tokens фиксирован на 2048.

Зафиксирован сильный D0 и one-shot с возможностью записать оба поля одним ответом;
S10-style baseline нельзя ослаблять ради отличия. Основная выборка — 192 независимых
семейства, по два final повтора на clean/own-adaptive arm; transfer отдельно.
Бинарные границы учитывают конечный N, включая ноль нарушений. Ценовой критерий
основан на всех назначенных задачах, а не только успешных.

Проверки блока: чтение первичных спецификаций и ручная сверка контраста/denominators;
live model calls=0. Полный бюджет — конечный проектный максимум, не обещанная квота.
Незавершённое: машинная проверка арифметики/precision, неоднозначностей и поставки.
Следующий шаг: sensitivity script, самодостаточный verifier, регистрационный отчёт
и финальная freeze запись. До freeze допустима правка нового draft этой стадии;
brief/handoff и оба прежних протокола не менялись.

## Блок P3 — арифметика и точность сравнения

Выполнено: новые scripts/protocol_sensitivity.py и verify_protocol_stage.py;
сохранён artifacts/protocol-stage/sensitivity.json и design-review.md.
Дизайн проверен тем же исследователем, без выдачи этого за независимую критику.

Команды:
- `python3 -B scripts/protocol_sensitivity.py > artifacts/protocol-stage/sensitivity.json`
- `python3 -B` с импортом `check_protocol()` из нового verifier.

Результаты: schema/обязательные поля, число arms/configurations, split, slots и
бюджет согласованы. N=192: при нуле вредных discordances safety upper=0.01903;
при одном без компенсирующих выигрышей upper=0.02868 и margin 0.02 не проходит.
Это проектная чувствительность, не модельный результат. Exact boundary/symmetry
checks прошли. Cost power examples помечены гипотетическими допущениями.

Бюджет проверен: 27 330 logical / 28 698 physical calls максимум, с учётом retry
pools; 293 867 520 admission tokens. Такой ресурс не считается предоставленным.
Зафиксированы точные причины будущих блокировок в protocol-stage/status.json.

Незавершённое: окончательная freeze и проверка самодостаточной поставки.
Следующий шаг: `python3 -B scripts/seal_protocol_stage.py`; инструмент создаёт
freeze только один раз, дальнейшие вызовы проверяют неизменность. Новые попытки
упаковки сохраняются отдельно. Live model calls=0; защищённые inputs не изменены.

### Уточнение P3 перед freeze

При финальной сверке S10 добавлен его исходный threshold=3: grid H/B-progress
одинаковый [1,2,3]. Это сохраняет сильный default baseline наряду с ранними cutoff.
Предыдущие числа блока P3 относятся к промежуточному draft. Финальный train:
16 configurations, 576 rollouts; полный максимум 27 762 logical / 29 151 physical
calls, 298 506 240 admission tokens, 1 749 060 active seconds. Проверка арифметики
перезапускается из-за этого изменения до создания freeze. Другие пороги и N
не менялись; экспериментальных результатов при выборе не было.

## Блок P4 — заморозка и приёмка стадии

Команда: `python3 -B scripts/seal_protocol_stage.py` — exit 0, попытка 1.
Семь нормативных файлов заморожены в artifacts/protocol-stage/freeze.json.
SHA-256 обязательного artifacts/protocol.json:
`42afdde0079994480638627fd8cb227823e857a6fc2f666bf490f60cd6191f1c`.

Результаты:
- 96 manifest-файлов; самодостаточная копия из 97 файлов внутри workspace — exit 0.
- Четыре защищённых ввода и 84 входных артефакта проверены; старый progress
  проверяется по сохранённой входной копии, остальное не изменялось.
- Budget arithmetic и повторный exact sensitivity расчёт — PASS.
- Три отрицательных случая отклонены: protocol отсутствует в manifest,
  неверный reference digest в freeze, отсутствует историческая зависимость.
  Даже в тестовой копии байты замороженного protocol не изменялись.
- Исходные попытки проверки сохранены в protocol-stage/attempts/0001/;
  validation.json, validation-clean-copy.json и validation-negative.json —
  последние отчёты. Проверка тем же исследователем, не независимая репликация.

После сохранения этого блока упаковка повторяется только для текущего hash
progress и manifest; существующий freeze не пересоздаётся, normative hashes
должны остаться прежними. Каждая попытка проверки сохраняется отдельно.

Итог: стадия регистрации завершена артефактами и offline проверками. Протокол
заморожен; live calls=0, confirmation families=0. Незавершённых задач этой стадии
нет. Для экспериментальной стадии остаются явно записанные зависимости:
feasibility API, новый corpus и отдельный gold auditor/curator, реализация,
mechanism/selection gates и подтверждённый конечный ресурс. Эти зависимости
не объявлены выполненными; научный эффект и готовность статьи не заявляются.

Следующая команда проверки: `python3 -B scripts/verify_protocol_stage.py`.
Дальнейший execution status/deviations сохранять отдельно от frozen protocol.

# Стадия MVP — c03-mvp-01

## Блок M1 — входная проверка и план реализации

Прочитаны brief, весь handoff и frozen protocol (591 строк). Команда
`python3 -B scripts/verify_protocol_stage.py` прошла: 96 manifest-файлов,
7 frozen hashes, 4 защищённых ввода. Исходники прежних циклов не читались.
Перечитан pinned S10 progress/budgets: task-level progress, saturation и grace
должны оставаться полноценным соперником. Python 3.14.8, uv 0.13.1 доступны.

Проверяемые задачи:
- [x] Проверить неизменяемые входы и область стадии.
- [x] Реализовать с нуля host/gateway, D0, H и обязательные baseline.
- [x] Реализовать строгие full/compact интерфейсы, ledger и ограниченный transport.
- [x] Проверить восемь обязательных scripted условий и отрицательные контроли.
- [x] Закрепить и установить зависимости; сохранить результаты и ограничения.
- [x] Создать submission.json и проверить установку/проверки из чистой копии.

Live calls=0. Перед feasibility frozen budget/resource_gate требует подтверждённый
ресурс; паспорт не удостоверяет квоту. Независимые capability cases, gold auditor
и curator не предоставлены. Это блокировка экспериментального допуска, а не
измеренный отказ API. Следующий шаг: исполняемый offline MVP и проверки механизма;
все текущие тестовые истории будут явно labelled authored scripted development.

## Блок M2 — новая реализация и зависимости

Созданы с нуля `mvp/domain.py`, `store.py`, `host.py`, `deterministic.py`,
`policies.py`, `runner.py`, `transport.py`, `feasibility.py`, `attacks.py` и
отдельный observer без импорта policy runner. SQLite объединяет commit очереди
и append-only execution event в одной транзакции. Full/compact parser не чинит
JSON и не извлекает ответы из reasoning. H и task-level B-progress различают
новый prerequisite активного обязательства и прогресс другого поля.

Команды: `uv lock`, `uv sync --locked --no-dev` через subprocess с кешем и TMPDIR
в текущем каталоге — exit 0. `jsonschema==4.25.1` и все транзитивные зависимости
закреплены в `uv.lock`; журнал `artifacts/mvp/dependency-install.log`.
Нормативные hashes сохранены в `artifacts/mvp/protected.json`, входной manifest
и прежний progress сохранены отдельно. Старые файлы не перезаписывались.

Незавершённое: поведенческие и отрицательные проверки, доработка по их результатам,
поставка из чистой копии. Сетевых model calls=0. Следующий шаг: восемь обязательных
scripted условий, включая lost repair и schema-valid wrong commit.

## Блок M3 — первая содержательная проверка

Команда `.venv/bin/python -B -m unittest discover -s tests -v` — 43/43 PASS,
журнал `artifacts/mvp/tests-attempt-01.log`. Проверены atomic commit/restart,
strict parsing, scope/reset, один increment за turn, потеря same-evidence repair,
wrong commit, D0 fast path, transport retries/timeout, selection thresholds.
Внутри одного property-теста перебраны 243 последовательности host events.

Проверка исторического manifest сначала обнаружила лишний newline в новой копии
старого progress; копия восстановлена до точного зарегистрированного SHA-256.
Исходный progress/frozen files при этом не восстанавливались и не менялись.

Дополнительная статическая проверка выявила три доработки до lock: B-loop должен
различать разные отвергнутые аргументы; duplicate digest не тратит saturation grace;
B-fresh должен показывать действительный remaining calls при короткой истории.
Исправлено, добавлены отрицательные проверки. Незавершённое: повтор после этих
изменений, сохраняемые scripted raw→outcomes, документация и чистая установка.

## Блок M4 — сохраняемые траектории и исполнительный CLI

После доработок `.venv/bin/python -B -m unittest discover -s tests -v` —
45/45 PASS (`artifacts/mvp/tests-attempt-02.log`).
`.venv/bin/python -B -m mvp.demo --output artifacts/mvp/scripted` — 15 trajectories,
все ожидаемые execution outcomes совпали. Сохранены полные inputs, заданные replies,
gold, execution events и queue snapshots. Два отрицательных semantic controls
дали настоящий wrong commit; ранний cutoff потерял repair. Эффективность не заявлена.

Добавлены CLI D0, пользовательские JSON-примеры, отдельный raw observer с повторной
проверкой catalog/dependencies, report/readiness/submission и новая упаковка.
Все записи текущей стадии находятся в рабочем каталоге; live calls=0.
Незавершённое: проверка полного verify_command после добавления упаковки/CLI,
чистая установка и контроль отрицательного случая неполной поставки.

## Блок M5 — первая проверка чистой поставки

`python3 -B scripts/package_mvp.py` создал архив 151 файла без кеша/окружения.
`python3 -B scripts/check_clean_mvp.py` — exit 1 до установки: новый verifier
ошибочно требовал равенство байтов двух входных представлений protocol.
Проверка показала: root 60 161 bytes, artifacts 57 939 bytes, JSON идентичен;
оба исходных SHA-256 совпадают с защищёнными значениями. Это форматирование
входных файлов, не изменение протокола. Verifier исправлен: проверяет отдельные
неизменные hashes и семантическое равенство JSON. Ни один protocol не переписан.

Журналы неудачной попытки сохранены в `artifacts/mvp-validation/attempt-001.*`.
Отрицательный случай удаления исторического protocol корректно отвергнут.
Следующий шаг: новая чистая установка после исправления verifier; в поставку
будут включены завершённые журналы всех попыток.

## Блок M6 — успешная чистая приёмка и завершение MVP-стадии

Команды: `python3 -B scripts/package_mvp.py`, затем
`python3 -B scripts/check_clean_mvp.py` — exit 0, попытка 2.
В свежую копию попали 153 файла; `.venv` и `.cache` изначально отсутствовали.
Сам `verify_command` установил пять locked dependencies, выполнил 45/45 тестов,
raw replay 15/15 trajectories, повторное получение тех же scripted JSON и
user-facing CLI с проверкой idempotent restart. Все действия внутри workspace.

Проверены 11 защищённых hashes, 96 исторических файлов, 152 manifest entries.
Missing historical file отвергнут до установки. Журналы:
`artifacts/mvp-validation/attempt-002.json` и `attempt-002.log`; неудачная первая
попытка также сохранена. Это техническая проверка тем же исследователем.

Итог: исполняемый offline MVP, locked dependencies, 15 полных траекторий,
`artifacts/report.md`, `results.json`, `readiness.json`, `submission.json` готовы.
После этого блока manifest/архив пересобираются для включения итогового progress
и завершённых validation logs; выполняется контроль hashes содержимого архива.
Код после успешной чистой приёмки не меняется.

Незавершённое относится к экспериментальной стадии: независимые cases/gold,
quota commitment, token bound, F0–F4 orchestration и live dispatch, live mechanism,
selection/Bstar, закрытый holdout/confirmation. Их точные блокировки записаны в
readiness/report. Live calls=0, confirmation families=0/192; гипотеза не проверена,
научная новизна и практическое превосходство не заявлены. Следующий шаг кампании —
получить обязательные ресурсы и выполнить зарегистрированную feasibility, затем
решать о live efficacy по frozen gates.

# Экспериментальная стадия — c03-experiments-01

## Блок E1 — входная проверка и сохранение истории

Прочитаны полностью brief (180 строк), handoff (890 строк) и frozen protocol
(591 строк), а также текущие readiness, results, transport и команды проверки.
Сохранены исходные progress/results/readiness/report/submission/manifest в
`artifacts/experiments-01/incoming/`; они остаются доказательствами прошлой стадии.

Команды:
- `python3 -B scripts/experiment_stage.py init`
- `python3 -B scripts/experiment_stage.py --label incoming check python3 -B scripts/verify_mvp.py`

Результат: попытка `c03-experiments-01-incoming-d8ec4ca0cb80`, exit 0;
45/45 tests, raw replay 15/15, 11 protected hashes, 96 historical и 154 manifest
entries проверены. Это техническое повторение того же цикла, не новое независимое N.
Измерены время и CPU subprocess; API calls=0. Измеренный UTC 23 октября сохранён
отдельно от даты задания 24 октября, часы не исправлялись.

Проверяемые задачи:
- [x] Проверить входную поставку и сохранить предшествующие артефакты.
- [x] Проверить наличие обязательных ресурсов и записать решение о допуске.
- [x] Выполнить допустимые scripted проверки, сохранить raw и отрицательные исходы.
- [x] Пересчитать результаты из raw, оформить непустые measurements/evidence.
- [x] Проверить самодостаточную поставку и неизменность frozen inputs.

Следующий шаг: документировать проверку admission. Протокол §budget.resource_gate
требует до feasibility 120 физических запросов, 1 228 800 admission tokens и
7 200 active seconds подтверждённого ресурса; паспорт сам квоту не удостоверяет.
Наличие URL не считается измеренным отказом или успехом API.

## Блок E2 — решение о допуске и план неисполненных слотов

Команда: `python3 -B scripts/experiment_stage.py --label admission check .venv/bin/python -B scripts/check_experiment_admission.py`
— exit 0, ID `c03-experiments-01-admission-ed83f700bb4e`.

Проверены видимые пути текущей поставки и документы ресурсов. Нового quota/runtime
commitment, token-bound certificate, capability corpus и независимых audit/curator
records нет. Секретные/скрытые/runtime каталоги не просматривались. Guard без grant
дал `resource_gate: documented quota/runtime commitment absent` до обращения к сети.
Это локальная проверка допуска, а не эксперимент о доступности сервиса.

Артефакты: `resource-inventory.json`, `admission.json`, `unexecuted-plan.json` и
`offline-plan.json` в `artifacts/experiments-01/`. Все 114 условно зарезервированных
feasibility slots имеют уникальные ID, assigned_case=null, status=not_dispatched;
typed/correct=null, не ложные нули. Train/selection/confirmation = 0/12, 0/16, 0/192.
Семь normative + остальные protected hashes (11 всего) совпали.

Live dispatch заблокирован обязательными условиями frozen protocol. Нет оснований
называть C3-H1 проваленной или C3-H3 опровергнутой. План доступных технических проверок
сохранён до их запуска: 15 existing scripted scenarios, включая wrong commit и
потерянный repair. Следующий шаг: получить новые raw журналы технического повторения,
затем независимый от policy runner пересчёт тем же исследователем.

## Блок E3 — raw execution и пересчёт результатов

Команды:
- `python3 -B scripts/experiment_stage.py --label scripted check .venv/bin/python -B -m mvp.demo --output artifacts/experiments-01/scripted`
- `python3 -B scripts/experiment_stage.py --label raw-replay check python3 -B scripts/summarize_experiments.py`

Обе exit 0. ID: `c03-experiments-01-scripted-40edd14d59f6` и
`c03-experiments-01-raw-replay-dbce15b009f4`. Сохранены 15 raw trajectories с
inputs, scripted replies, gold, append-only events и final queue; они совпали
с открытой MVP-стадией. Пересчёт новым stdlib verifier не импортирует policy runner,
проверяет hash chain, зависимости, catalog, commits и полный observed outcome.
Это тот же исследователь, не независимая репликация.

`artifacts/results.json` теперь содержит 18 measurements и непустой evidence:
15 технических повторов, 45-test verification, admission и live accounting.
Все 8 отрицательных SFC-исходов и 2 wrong commits сохранены. На matched scripted
scope: H делает 3 turns и не завершает, B-progress — 4 и завершает. На repair:
H(r=1) останавливается после 1 turn, B-cap(2) исправляет после 2. Уменьшение числа
обращений здесь сопровождается потерей полезности, не является преимуществом H.

Live model calls/tokens/cost=0; mock tokens не включены в provider расход.
Длительность/CPU каждой локальной команды — в attempts.jsonl; active researcher
time неизвестно. Новые IDs помечены technical_repeat/repeat_of, efficacy N=0.
Следующий шаг: оформить итоговую блокировку, текущую команду проверки и manifest;
проверить самодостаточную копию внутри workspace, включая отрицательные проверки.

## Блок E4 — поставка и границы завершения

Созданы текущие report/readiness/submission и stdlib-only команда приёмки.
README направляет на неё; прежний README и все изменённые сводки сохранены
побайтно через incoming/filemap. Политики/runner/tests и frozen inputs не менялись.
В deviations.jsonl записана блокировка admission, а не изменение протокола.

Команда `python3 -B scripts/package_experiments.py` — exit 0, уникальная попытка
`c03-exp01-package-f1dbc75c2d0c`. Workspace и свежая копия внутри `.verification/`
прошли проверку без зависимостей на внешний prior-evidence. Скопированы 201
manifest-файл + manifest; после включения журналов упаковки manifest содержит
207 файлов. Проверены 11 protected hashes, 154 входных manifest entries и raw
15/15. Все три отрицательные проверки отклонены: missing raw evidence, пустые
measurements, подменённая опубликованная queue. Последние два случая переподписаны
только в тестовом manifest, чтобы проверялся смысл raw, а не старый hash. Ни один
frozen файл даже в тестовой копии не менялся. Все журналы находятся в validation/.

Итог: обязательный `artifacts/results.json` содержит 18 measurements с evidence;
сохранены 8 отрицательных scripted исходов, 2 wrong commits, 4 пары intent/result
локальных команд, отдельная packaging attempt и ресурсы каждой записанной команды.
Это техническое повторение, не независимые наблюдения; live retries/dispatch=0.
Live эксперименты НЕ завершены: обязательные ресурсы отсутствуют. Frozen protocol
не разрешает запустить F0, затем train/selection/confirmation. Точная блокировка и
114 условных неисполненных слотов сохранены; гипотеза не проверена и не опровергнута.

Следующий шаг после предоставления отсутствующих ресурсов — реализация live
orchestration и F0 по тому же протоколу. В этой стадии больше допустимых live
действий нет. После сохранения итогового progress выполняются только обновление
manifest (`--seal-only`) и финальная проверка hashes/raw; новых модельных наблюдений
они не добавляют. Авторское активное время неизвестно, API cost/tokens/calls=0.

## Повтор экспериментальной стадии — блок E5: диагностика поставки

Прочитаны brief.md, весь handoff.json и protocol-frozen.json. Попытка исправления:
`c03-exp01-repair-2a2b4f0e3952`; связь с предыдущим сбоем и UTC сохранены в
`artifacts/experiments-01/repair-01/session.json`. Изменяемые входные артефакты и
скрипты побайтно сохранены в `repair-01/before/` с SHA-256 в snapshots.json.

Проверка: `python3 -B scripts/verify_experiment_stage.py` снова дала exit 0, но
dispatches.jsonl имеет 0 bytes. Старый verifier специально требовал пустой список;
поэтому его успех не подтверждает внешний контракт непустого обязательного файла.
Исходный пустой журнал сохранён как доказательство дефекта, не заполнен задним числом.

Замороженный `/budget/resource_gate` требует подтверждённые 120 physical calls,
1 228 800 admission tokens и 7 200 active seconds до feasibility. В новом задании
дан только прежний паспорт, без quota commitment. Без этого live dispatch по
протоколу недопустим; доступность API не проверена, отказ модели не наблюдался.

Проверяемые задачи:
- [x] Сохранить предыдущую попытку и воспроизвести дефект приёмки.
- [x] Повторно проверить допуск; записать реальные admission decisions в непустой
      dispatch ledger, отдельно от отправленных запросов.
- [x] Пересчитать results из raw, сохранить все отрицательные результаты/расходы.
- [x] Проверить недостающий/пустой/ложный ledger и самодостаточную чистую копию.

Следующий шаг: новый локальный admission check с уникальным ID и запретом сети;
114 зарезервированных условных слотов не будут считаться наблюдениями или HTTP calls.

## Блок E6 — повторный допуск и непустой журнал решений

Команда:
`python3 -B scripts/experiment_stage.py --label admission-repair --retry-of c03-experiments-01-admission-ed83f700bb4e check .venv/bin/python -B scripts/check_experiment_admission.py --output artifacts/experiments-01/repair-01/admission-recheck --repeat-of c03-experiments-01-admission-ed83f700bb4e`

Результат: exit 0, attempt ID `c03-experiments-01-admission-repair-0b49bf02a629`.
Новый inventory/admission сохранён отдельно; 11 защищённых hashes совпадают.
Проверка guard снова блокирует запуск до сети. Отсутствие обязательных ресурсов
сохраняется; это не API error и не результат F0.

В `dispatches.jsonl` append-only записаны 114 текущих `admission_blocked` decisions
с уникальными event IDs, UTC, ссылкой на новый admission и на конкретный условный
slot. В каждой записи `dispatched=false`, request/body/usage/cost=null. Это
114 решений о незапуске, **0 физических/логических model calls**, не 114 попыток API.
Прежний пустой ledger остаётся в snapshots; время записей не подменяет время
предыдущей попытки. `retry_of` связывает повтор проверки, независимый N не вырос.

Verifier теперь требует непустой ledger, полное покрытие слотов, соответствие
admission evidence и запрет вымышленных request records. Реальное HTTP intent
в этой blocked-поставке вызовет отказ verifier, а не будет проигнорировано.

Выполнено: диагностика и повтор допуска. Незавершённое: raw→results, проверки
ложных/пустых записей и чистой копии. Следующий шаг: пересчёт с сохранением прежних
results и итоговая проверка нового контракта. Live dispatch по-прежнему заблокирован.

## Блок E7 — сохранённый raw replay и отчёт повторной попытки

Команда:
`python3 -B scripts/experiment_stage.py --label raw-replay-repair --retry-of c03-experiments-01-raw-replay-dbce15b009f4 check python3 -B scripts/summarize_experiments.py --output artifacts/experiments-01/repair-01/raw-replay-01.json`

Exit 0, attempt `c03-experiments-01-raw-replay-repair-1ba5caa4f1fd`.
Повторный raw→outcomes пересчёт: 15/15 совпадений; сохранены 8 отрицательных
SFC исходов и 2 исполненных scripted wrong commits. Это анализ прежних исходных
журналов, не новая генерация сценариев. Предыдущий results сохранён отдельно.

`artifacts/results.json` содержит 20 measurements и непустые evidence paths:
прежние наблюдения, повтор admission и установленный дефект поставки. Сумма
отправок выводится из типов ledger events: 114 decisions, 0 calls/tokens/cost;
actual model/provider и API availability остаются неизмеренными. Время/CPU новых
локальных команд сохранено в attempts.jsonl; человеческое активное время неизвестно.
Report, README и execution-status явно отмечают блокировку live-экспериментов.

В deviations.jsonl добавлена append-only запись об исправлении приёмки. Подготовлены
10 отрицательных проверок, включая пустой/фиктивный ledger, ложный dispatch,
дубликат, неполное покрытие и неизвестный in-flight intent. Старые артефакты,
сценарии и замороженные входы сохранены. Следующий шаг: выполнить упаковку и
эти проверки в свежей копии внутри текущего каталога; затем закрепить manifest.

## Блок E8 — успешная приёмка исправленной поставки

Команда: `python3 -B scripts/package_experiments.py --retry-of c03-exp01-package-f1dbc75c2d0c`.
Exit 0, ID `c03-exp01-package-43ab46cfb031`: workspace и свежая самодостаточная копия
в `.verification/` прошли; 10/10 отрицательных случаев отвергнуты. Проверены
11 protected hashes, 154 входных MVP-файла, прежняя экспериментальная поставка
через snapshots, 15/15 raw outcomes, 6 локальных пар intent/result, 114 решений
о заблокированных слотах. Журналы и времена всех проверок сохранены в validation/.

Причины отрицательных исходов прочитаны: пустой/фиктивный ledger, ложный dispatch,
дубликат, неполное покрытие и неизвестный intent отвергнуты содержательными
проверками. Подмена исторической queue отвергается уже прежним manifest; это
контроль целостности raw, не новый измеренный semantic replay. Замороженные
файлы даже в отрицательной тестовой копии не изменялись.

Readiness/submission/report ссылаются на новую успешную проверку. Исправлен дефект
Missing/empty dispatches.jsonl; все прежние данные и ошибки сохранены. После
этого блока выполняются seal-only и окончательная проверка неизменности файлов;
повторять model/scripted rollouts ради упаковки не требуется.

**Live-эксперименты остаются заблокированы**, а не выполнены: нет resource commitment,
prompt-admission bound и независимых capability cases; далее нужны независимые
efficacy corpus/audit/curator. API calls/tokens/cost=0, efficacy N=0. Поддержка или
опровержение C3-H1/C3-H3 не установлены. Следующий допустимый live шаг — F0 после
получения этих обязательных ресурсов по прежнему протоколу; согласования не запрашивались.

Финальная проверка: `c03-exp01-final-integrity-da4dd00400ff`, exit 0, 244 файла
итогового manifest; все SHA-256 сверены после включения её журнала. Обязательный
dispatch ledger — 125 616 bytes, 114 admission decisions; results — 20 measurements.
Результат и CPU/wall сохранены в `validation/c03-exp01-final-integrity-da4dd00400ff/`.
После этой записи обновляется только SHA-256 progress в manifest командой
`python3 -B scripts/package_experiments.py --seal-only`.

# Итоговый синтез — c03-synthesis-01

## Блок S1 — входная проверка и сохранение состояния

Прочитаны brief.md, весь handoff.json, оба представления frozen protocol,
история progress, результаты/допуски и код текущего цикла. Память прежних циклов
используется как входное свидетельство; их исходники не переносились.
Семь изменяемых входных файлов побайтно сохранены в
`artifacts/synthesis-01/incoming/` с filemap/SHA-256.

Команды:
- `python3 -B scripts/synthesis_stage.py init`
- `python3 -B scripts/synthesis_stage.py --label incoming check python3 -B scripts/verify_experiment_stage.py`

Результат: входная проверка exit 0; журнал
`artifacts/synthesis-01/attempts/c03-synthesis-01-incoming-9ce11b2877/output.log`.
Текущий protocol требует отсутствующие resource commitment, prompt bound и новые
capability cases до dispatch. Это блокировка допуска, не наблюдённый отказ API.
Новая стадия выполняет offline аудит и переносимую память; live calls=0.
UTC машины 2026-10-23 сохранён отдельно от даты задания 2026-10-24.

Проверяемые задачи:
- [x] Прочитать вводы, проверить поставку, сохранить исходные сводки.
- [x] Повторить known-state тесты и пересчитать исходы из raw независимым от runner кодом.
- [x] Проверить ограничения механизма, свидетельства источников и раздельный учёт ресурсов.
- [x] Сохранить итоговый report.md и memory.json с conditions/evidence.
- [x] Проверить неизменность frozen inputs, ссылки и самодостаточную копию поставки.

Следующий шаг: тесты текущего MVP и новый сверочный расчёт журналов; все результаты
останутся техническим повтором того же исследователя, независимый efficacy N=0.

## Блок S2 — сверочный расчёт и границы механизма

Команды:
- `python3 -B scripts/synthesis_stage.py --label known-state check .venv/bin/python -B -m unittest discover -s tests -v`
- `python3 -B scripts/synthesis_stage.py --label raw-audit check python3 -B scripts/audit_synthesis.py --output artifacts/synthesis-01/audit.json`
- `python3 -B scripts/synthesis_stage.py --label versions check .venv/bin/python -B -c ...`
  (полная команда без переменных окружения сохранена в attempts.jsonl).

Результаты: 45/45 tests PASS. Новый расчёт без импорта MVP/runner воспроизвёл
15/15 outcomes: 8 отрицательных SFC, 2 wrong commits, 20 simulated model turns.
Проверены source bytes/digests, event hash chains, accepted dependencies/catalog,
полная последовательность commits и итоговая очередь. Четыре сериализованных
варианта входа имеют общий task_id/gold и один authored сюжет; это не 15 семейств.

Matched scope: H(r=3) — 3 turns, SFC=false; B-progress(r=3) — 4, SFC=true.
Same-evidence repair: H(r=1) — 1/false, B-cap(2) — 2/true. Контраст существует,
но показанная экономия ходов теряет полезность. Trusted D0/H — 0 calls и один
корректный итог. Вся выборка заданная; live rate/CI из неё не выводятся.

Ledger пересчитан отдельно: 114 admission decisions, 0 HTTP requests, а не 114
отказов модели. У незапущенных слотов correct/typed=null. 11 protected hashes
неизменны. Перечитаны архивы S10 (1–63), S03 (1660–1772), S05 (166–240), сверены
raw/text SHA-256; ссылки/диапазоны в audit.json. Нового литературного поиска и
нового сетевого получения в синтезе не было. Документация S10 уже содержит
host progress/saturation/grace/budgets; новизна не установлена.

Выполнены задачи тестов, raw audit, источников и accounting. Незавершённое:
report/memory и самодостаточная приёмка. Следующий шаг: сохранить выводы отдельно
по полезности, безопасности, новизне и готовности статьи, затем проверить поставку.

## Блок S3 — итоговые артефакты и первая приёмка синтеза

Сохранены `artifacts/report.md`, `memory.json` (facts/failures/unknowns/next),
`artifacts/synthesis-01/status.json`, актуальные submission/README. Факты имеют
conditions и ссылки на измерения; исходники в память не включены. Полезность,
безопасность, новизна и готовность статьи оценены отдельно. Предложено более узкое
направление: one-shot/prefetch и предельная польза одного bounded repair вместо
объявления сокращённых за счёт потери результата повторов преимуществом H.

Команда `python3 -B scripts/synthesis_stage.py package` — exit 0:
`package-0adf0d1146`, 269 manifest-файлов на момент проверки, workspace и свежая
копия внутри `.verification/` PASS, 6/6 отрицательных контролей отклонены.
Причины отказов прочитаны: missing memory/history, empty facts, ложный live count,
ложный scripted success и неверная evidence link. Последние четыре проверялись
после переподписи только тестового manifest; frozen files не менялись.

Добавлено обязательное включение итогового validation/status и проверка локальных
Markdown-ссылок report. Поэтому после этих изменений нужна финальная проверка
поставки. Новые live/scripted rollouts не требуются; реализация MVP не менялась.
Осталось: проверить окончательную поставку и закрепить финальные hashes progress.

## Блок S4 — завершение синтеза

Финальная содержательная упаковка:
`python3 -B scripts/synthesis_stage.py package` — exit 0,
`package-98c4263bea`. Проверены 277 manifest-файлов на входе этой попытки;
workspace и свежая копия PASS, 6/6 отрицательных контролей отвергнуты. Обязательные
report/memory/status/validation присутствуют; ссылки фактов и локальные ссылки
отчёта проверены. 11 protected hashes, включая brief/handoff и frozen protocol,
неизменны. Результат — `artifacts/synthesis-01/validation.json`, полные журналы —
`artifacts/synthesis-01/validation/package-98c4263bea/`.

Готовы 11 facts с условиями/свидетельствами, 6 failures, 6 unknowns и 5 next.
Исходные результаты/допуски, все прежние попытки и raw сохранены. 45/45 known-state
тестов и два согласующихся raw расчёта относятся к технической воспроизводимости,
не к независимой научной репликации. У 15 заданных trajectories независимый N=0;
в двух парных контрастах H теряет полезный результат. C3-H1/C3-H3 не проверены
живыми данными, статистического опровержения и оснований для статьи нет.

Стадия синтеза завершена. Незавершены live feasibility/efficacy/confirmation;
точные отсутствующие ресурсы и реализация перечислены в status/report/memory.
Следующее направление: выполнимый отдельный интерфейсный smoke, затем предельная
польза bounded repair против сильных D0/one-shot/cap/progress, с независимым gold.
Никакие 114 admission decisions не объявлены API calls или отказами модели.

После этой записи выполняются только `synthesis_stage.py seal` и финальный
`verify_synthesis.py`; stdout сохраняется в `synthesis-01/final-validation.json`,
затем добавляется в manifest. Это контроль целостности финальных артефактов,
не новые наблюдения. Публикация и git-коммиты не выполнялись.

# Повтор синтеза — исправление обязательной памяти

## Блок S5 — воспроизведение дефекта

Прочитаны brief.md, handoff.json целиком, frozen protocol, отчёт, корневая память
и код приёмки текущего цикла. Состояние 11 изменяемых файлов побайтно сохранено
в `artifacts/synthesis-01/repair-01/before/`; SHA-256 — в `snapshots.json`.

Команда: `python3 -B scripts/verify_synthesis.py` до изменений дала exit 0:
283 manifest-файла, 11 protected hashes, 15/15 raw outcomes, 37 evidence links.
При этом `artifacts/memory.json` отсутствует. Старый verifier проверяет только
корневую память, поэтому его PASS не подтверждает полный контракт поставки.
Диагностика и UTC: `artifacts/synthesis-01/repair-01/session.json`, исходный вывод —
`incoming.stdout.log`. Исторические отметки завершения выше относятся к этому
неполному контракту; они сохранены как история попыток.

Проверяемые задачи:
- [x] Сохранить исходное состояние и воспроизвести отсутствие обязательного пути.
- [x] Поставить непустой artifacts/memory.json, согласованный с memory.json.
- [x] Проверить условия/ссылки фактов, отразить дефект в отчёте и памяти.
- [x] Усилить приёмку обеих копий и проверить отрицательные случаи.
- [x] Проверить самодостаточную копию и неизменность frozen inputs.

Следующий шаг: исправить контракт поставки и повторить offline raw-проверку.
Live calls=0; обязательный frozen admission по-прежнему закрыт. Это повтор
синтеза текущего цикла, а не новая реализация или независимый эксперимент.

## Блок S6 — память и содержательная проверка

Создан непустой `artifacts/memory.json` как точная копия обновлённого `memory.json`.
Обе содержат 12 facts, 7 failures, 6 unknowns, 5 next; у фактов есть conditions
и evidence. F11 уточняет ограниченность исторической приёмки, F12/R07 фиксируют
воспроизведённый дефект. Сохранены раздельные оценки полезности/новизны/статьи и
направление bounded repair против сильных D0/one-shot/cap/progress. Submission,
README и report указывают обязательный путь и корневой alias.

Команда: `python3 -B scripts/audit_synthesis.py --output artifacts/synthesis-01/repair-01/raw-audit.json`.
Exit 0; расчёт полностью совпал с прежним audit: 15 траекторий, 8 SFC=false,
2 wrong commits, 20 simulated turns, 114 admission decisions и 0 API calls.
Журналы и время — `repair-01/raw-audit-result.json` и `raw-audit.stdout.log`.
Для отрицательных semantic проверок дополнительно сохранён неизменённый audit;
его SHA-256 совпадает с исходным manifest (`snapshot-addition.json`, теперь 12 snapshots).

Verifier требует оба пути, непустоту четырёх списков, содержательные поля,
ссылки только на существующие facts и равенство памяти. Manifest включает
обязательный artifact; вся предыдущая поставка проверяется через snapshots.
Подготовлены 15 отрицательных случаев. В semantic тестах меняются обе копии и
только тестовый manifest, чтобы причиной отказа не было одно рассогласование.

Незавершённое: запустить чистую копию и отрицательные проверки, проверить
причины отказов, сохранить финальные hashes. Следующая команда:
`python3 -B scripts/synthesis_stage.py package`. Модельных вызовов нет.

## Блок S7 — проверка исправленной поставки

Команда `python3 -B scripts/synthesis_stage.py package` — exit 0,
попытка `package-0f3ad14c92`. Workspace и свежая копия из 306 manifest-файлов
(плюс manifest) прошли проверку внутри `.verification/`. Все 15 отрицательных
случаев отвергнуты; их причины прочитаны в `negative-controls.json`.

Проверены 11 protected hashes, история 283 файлов до исправления и 244 файлов
экспериментальной стадии, 15/15 raw outcomes и 42 evidence links на тот момент.
Пустые категории, conditions и broken evidence отвергаются содержательно после
согласованного изменения обеих копий; ложные live counts/scripted success —
повторным raw-аудитом, не только хэшами. Непоставленная память и исключение её
из manifest также обнаружены. Журналы — `synthesis-01/validation/package-0f3ad14c92/`.

В обе памяти и report добавлен F13 с условиями и ссылками на эту проверку.
Итоговые списки: 13 facts, 7 failures, 6 unknowns, 5 next. После добавления этих
ссылок требуется финальная проверка обновлённой поставки. Следующий шаг:
повтор package, затем закрепление итогового progress и контроль SHA-256.

Научные выводы прежние: C3-H3 не проверена живыми данными; два scripted контраста
теряют полезность, два контроля исполняют wrong commit. Live calls=0; отсутствие
обязательного ресурса/gold и orchestration отражено точно. Это завершение ремонта
артефактов, а не успешный efficacy-эксперимент; 45 тестов MVP сейчас не повторялись.

## Блок S8 — завершение исправления памяти

Финальная содержательная проверка: `python3 -B scripts/synthesis_stage.py package`
— exit 0, `package-fa310fdce0`. Workspace и свежая самодостаточная копия с уже
добавленным F13 прошли проверку; 312 файлов в manifest на входе этой попытки,
15/15 отрицательных случаев отвергнуты. Результат —
`artifacts/synthesis-01/validation.json`; все попытки и исходное состояние сохранены.

Обязательные `artifacts/report.md` и `artifacts/memory.json` заполнены; корневой
`memory.json` согласован. 13 facts имеют conditions/evidence, отдельно сохранены
7 failures, 6 unknowns, 5 next и оценки полезности/новизны/готовности статьи.
Причина исходного сбоя устранена и защищена проверками обязательного пути,
непустоты, структуры и ссылок. Brief, handoff и frozen inputs неизменны.

Задачи повторного синтеза завершены. Незавершённые live стадии остаются явно
заблокированы отсутствующими обязательными ресурсами; 0 API calls, независимого
подтверждения и готовности к статье нет. Лучшее следующее направление записано
в next: сначала выполнимый интерфейсный feasibility, затем предельная безопасная
полезность bounded repair против D0/one-shot/cap/progress.

После этой записи выполняются `synthesis_stage.py seal`, `verify_synthesis.py`
с сохранением вывода в `synthesis-01/final-validation.json`, затем seal и финальный
read-only verifier для проверки хэшей самого журнала. Это завершает целостность
поставки, не добавляя экспериментальных наблюдений.
