# progress.md — цикл 7, стадия: литература и выбор гипотезы

## Блок 1 (выполнено): вход
- Прочитаны brief.md, handoff.json (память циклов 1–6), prior-evidence/06 (hypotheses.md, review.json, sources.json, protocol-frozen.json — только чтение).
- Ключевые переносимые факты (из памяти, не перепроверялись live в этом цикле):
  - маршрут qwen/qwen3.5-9b/Together: reasoning не управляется API (enable_thinking игнорируется, reasoning.enabled=false → 400); единственный рычаг max_tokens; при length content пуст (ц.6 smoke).
  - ц.6: приманка в документе HotpotQA снижает B-cap(C=8192) 0.750→0.183; BEIS опровергнута; B-sys (system-инструкция) 0.742 при 1.2× токенов — пост-хок, неадаптивно, смешаны роль и текст.
  - критик ц.6: следующий шаг — факторный {user,system}×{generic,specific} с равной адаптацией против каждой ячейки, ≥2 семейства приманок, новые вопросы, scorer negative controls, raw-verifier.
- Проверка: `python3 -c "import json;json.load(open('handoff.json'))"` — ок.

## Следующий шаг
Блок 2: поиск и чтение первоисточников (инструкционные защиты, overthink-защиты, адаптивные атаки на защиты).

## Блок 2 (выполнено): первоисточники и smoke
- Прочитаны (частично полный текст): OverThink v4 разделы защит; OTora App. A/I; Real-time reasoning monitor 2603.25412v2; Attacker Moves Second 2510.09023. Abstract: Instruction Hierarchy, Distractor Injection, TALE, ExtendAttack. Документация OpenRouter про отмену потока.
- Smoke M01: `python3 -I scripts/smoke_stream.py artifacts/smoke-c07/stream-01.jsonl` → HTTP200, Together, reasoning стримится, usage в конце; length при 400 даже на тривиальном вопросе.
- Записан artifacts/sources.json (20 записей; проверка: все имеют url/claim/status).
## Следующий шаг
Блок 3: artifacts/hypotheses.md — ближайшие работы, гипотезы, выбор.

## Блок 3 (выполнено): гипотезы и выбор
- Создан artifacts/hypotheses.md: таблица ближайших работ (OverThink, OTora, Real-time monitor, Attacker Moves Second, Spotlighting, Instruction Hierarchy, Distractor Injection, TALE, ExtendAttack, Map-Reduce/BEIS, AttnTrace, атаки прерывания), постановка, гипотезы H0–H5.
- Выбрана H2 — TAQ (прерывание по τ + детерминированная атрибуция документа по частичной трассе + карантин + один повторный проход, расход ≤ τ+C) с обязательным первым gate G-break (адаптивная атака на B-sys/факторные ячейки H1). Если B-sys не ломается — практический вывод «инструкции достаточно», TAQ не развивается.
- Новизна НЕ заявлена: поиск ограничен, отсутствие найденной работы ≠ новизна.
- Проверки: `python3 -c "import json;d=json.load(open('artifacts/sources.json'));assert all({'url','claim','status'}<=set(x) for x in d)"` → ок; brief.md/handoff.json/prior-evidence не изменялись.

## Незавершённое
- Эксперименты эффективности: 0. Не проверены: биллинг обрыва потока, лицензия второй коллекции, полные тексты S05/S13/S14/S16.
## Следующий шаг
Стадия протокола: F0 (трасса при length в non-stream, распределение reasoning B-sys на clean dev, ложные прерывания), затем G-break с заранее заданным бюджетом.

## Блок 4 (выполнено): протокол — ЗАМОРОЖЕН
- Создан artifacts/protocol.json (c07-protocol-v1, status=frozen): hypothesis (H2-TAQ + gate H1-break, unit_of_analysis, practical_choice), task_and_threat_model, data (c06_exclusion, правило второй коллекции), conditions (clean, clean_hard_len/proc/reason, A-fam1/2, A-adapt-base, A-misattr, A-lowslow, A-insupport, A-canary, A-cease), 13 baselines (D0, NOCTX, B-big, B-base, 4 факторные ячейки, B-stop, B-rerun, B-cap-match, B-randq, B-imper, B-relq, TAQ, TAQ-oracle), metrics (+scorer_validation), statistics, calibration (τ_rule, attribution 6 вариантов, remove/trim, base_cell_rule), adaptive_search (равный бюджет 12×8 на цель), gates (G0-mock, G0-route/F0, G1, G-τ, G-break, G-attr, G3), falsification F1–F6, useful_advantage_criteria PC1–PC6, confirmatory_experiment (branch_H2 / branch_H1, verifier с отрицательными контролями), split_policy (соль c07-split-v1; 40/40/40/120/60 + 20/80), budget (итого ≤ 42000 вызовов, ≤ 91 usage units).
- Проверка: `python3 -I -c "import json;d=json.load(open('artifacts/protocol.json'));assert all(k in d for k in ['hypothesis','baselines','metrics','falsification','split_policy','budget'])"` → ок.
- sha256(protocol.json) = 69bea2bdc4c1ffa4952006d547c26f7cfa4381219a37c0d8ec3675c06048c427 (также artifacts/protocol.sha256). Дальнейшие изменения запрещены; отклонения — только в artifacts/deviations.md.
- brief.md (47bddaff…) и handoff.json (9cfc9aea…) не изменялись.

## Незавершённое
- Live-экспериментов эффективности: 0. Данные не загружены (pandas/pyarrow отсутствуют — потребуется парсер parquet или иной формат). Лицензия второй коллекции не проверена.
## Следующий шаг
Реализация с нуля: загрузка данных + manifest, разбиение и open_ids.json, scorer с unit-тестами, mock-тесты G0, затем F0 (G0-route) на dev_calib.

## Блок 5 (выполнено): стадия реализации — окружение, данные, scorer, F0
- Окружение: uv 0.13.1, CPython 3.14.8; pyproject.toml + uv.lock (polars==1.35.2, pytest==8.4.2). pyarrow 22 отвергнут: wheel требует libstdc++.so.6, отсутствующую в NixOS-окружении (ImportError) — заменён на polars (только чтение parquet).
- Данные: data/raw/hotpot_distractor_validation.parquet, sha256 c20b638c…f7c6 = LFS oid HF (rev 1908d6af, лицензия cc-by-sa-4.0 по карточке). 7405 записей.
- Разбиение (taq/data.py): c06 реконструирован — holdout_primary совпал с 120 id prior-evidence/06 inputs.jsonl (проверка True). Исключено 280 id c06 + 57 по пересечению supporting-titles; c07: 40/40/40/120/60; 1 holdout-кандидат перенесён в dev (общие titles). data/derived/{questions.jsonl,split.json}, artifacts/open_ids.json.
- Scorer (taq/scorer.py): 33 unit-теста (`.venv/bin/python -m pytest -q tests/test_scorer.py` → 33 passed).
- F0 / G0-route: `.venv/bin/python -I scripts/f0_route.py` → 4 вызова, все HTTP 200, model qwen/qwen3.5-9b, provider Together, response id записан; non-stream при finish=length возвращает message.reasoning (1019 и 3956 символов при cap 256/1024), content пуст; stream — то же. Sampling top_k/presence_penalty приняты. → основной режим non-stream. clean C: 7754 completion, 125 с (длинное рассуждение на clean — риск для G-τ). artifacts/f0/{calls.jsonl,summary.json}.
## Следующий шаг
Mock-тесты G0 (≥12), runner с возобновлением, анализ, верификатор с отрицательными контролями.

## Блок 6 (выполнено): ядро MVP и known-state тесты
- Модули taq/: data, second, scorer, prompts (4 ячейки), inputs (детерминированные входы, slot, filler ±10%, proc, insupport, canary), attribution (6 вариантов n∈{3,4}×g∈{1,len,sqrt}; селекторы B-imper/B-relq/B-randq; trim), d0, client (лог intent/attempt/result, ≤3 повтора, memo общих вызовов, возобновление из лога), mock, policies (все 14 политик, fail-closed), runner (возобновляемый), analysis (сводки, парный бутстрэп, точный McNemar, Holm).
- scripts/: run.py (CLI; holdout закрыт до artifacts/frozen/config.json), verify_run.py (реконструкция исходов только из raw attempt-записей), check_offline.py, build_data.py, f0_route.py, verify.sh.
- Вторая коллекция: 2WikiMultihopQA dev (репозиторий Alab-NII/2wikimultihop — Apache-2.0 по GitHub API; данные из Dropbox-ссылок README; sha256 в artifacts/data_manifest.json); пул 11281 (без yes/no); dev_second_calib 20, holdout_second 80; алиасы id_aliases.json (без demonyms; списки алиасов местами шумные — ограничение).
- Проверка: `.venv/bin/python -m pytest -q tests` → 72 passed (33 scorer, 22 G0-mock, 17 pipeline/verifier/split, включая 6 отрицательных контролей верификатора).
- Реализационное решение: политики с идентичным запросом на одном шаге одной задачи разделяют один вызов (memo по task_key+step+sha запроса) — напр. pass1 у TAQ/B-stop/B-rerun/B-imper/B-relq/B-randq. Парность сильнее, бюджет меньше; независимыми наблюдениями эти вызовы не считаются.
## В работе
- Live G1 на dev_calib clean (D0, NOCTX, B-big, B-base[S-spec]) — artifacts/runs/dev_calib-g1-clean.

## Блок 7 (выполнено): live G1 на dev_calib clean
- Команда: `.venv/bin/python -I scripts/run.py --name dev_calib-g1-clean --split dev_calib --conditions clean --policies D0,NOCTX,B-big,B-base --workers 8 --max-calls 130` → 122 отправки (120 вызовов + 2 повтора после HTTP 429), 0 неустранимых ошибок.
- Результат (N=40, S-spec): B-big 0.775, B-base(C=8192) 0.725 (lost 0.05), NOCTX 0.275, D0 0.000 (token-F1 0.026).
  - G1: B-big−D0 = 0.775 ≥ 0.30 ✓; B-big−NOCTX = 0.50 ≥ 0.20 ✓ → G1 пройден (dev, N=40).
  - Проверка C: B-base ≥ B-big−0.05 → 0.725 ≥ 0.725 ✓ (ровно на границе) → C=8192 сохраняется.
- D0 исправлен (служебные слова), пересчитан офлайн (0 вызовов); исходные исходы сохранены в outcomes.pre_d0fix.jsonl.bak. `scripts/verify_run.py artifacts/runs/dev_calib-g1-clean` → OK.
- Наблюдение (факт): на clean длина completion B-big: квартили 772/1313/3058, max 7473; доля > τ: 1024→0.575, 2048→0.40, 3072→0.225, 4096→0.125 (B-base: 4096→0.225). Предположение: правило τ (≤0.05 на clean) не выполнимо ни при одном τ ≤ 4096 → риск провала G-τ. Формально проверяется отдельным прогоном B-stop(τ=4096) для четырёх ячеек.

## Блок 8 (выполнено): G-τ и диагностика причин
- Команды: `scripts/run.py --name dev_calib-tau{T}-clean-S-spec --conditions clean --policies B-stop --tau T --cell S-spec` для T∈{1024,1536,2048,3072,4096}; τ=4096 также для S-gen/U-spec/U-gen; exploratory `dev_calib-explor-clean-tau4096-recovery` (B-base, B-stop, B-rerun, TAQ, B-imper, B-relq, B-randq).
- Результат: доля length на clean (S-spec) 0.625/0.525/0.425/0.325/0.200; при 4096 все ячейки 0.200–0.225 > 0.05 → **G-τ не пройден → H2-TAQ опровергнута на dev** (falsification протокола). Holdout не открывался.
- Причина (exploratory): 7/7 ложных срабатываний TAQ на clean поместили на карантин supporting-документ; TAQ 0.700 vs B-base 0.750 vs B-rerun 0.775.
- scripts/gates_dev.py → artifacts/gates_dev.json (пересчёт из outcomes, проверяется в check_offline); artifacts/accounting_stage.json: 550 вызовов, cost 0.4326.
- artifacts/stage_report.md, artifacts/submission.json (verify_command = ["bash","scripts/verify.sh"]).
- Проверка: `bash scripts/verify.sh` → 73 passed, ALL OK.
## Незавершённое
- adaptive_search / G-break, доводка приманок и proc-текстов (длина ±10%), dev_select, вторая коллекция live — не выполнялись.
## Следующий шаг
Стадия G-break (H1): адаптивный поиск против 4 ячеек с равным бюджетом 12×8 на dev_adapt, оценка на dev_select; по исходу — branch_H1 на holdout. TAQ на holdout только описательно по цене не требуется (H2 опровергнута на dev).

# Стадия экспериментов (G-break / ветвь H1)

## Блок 9 (выполнено): квалификация семейств на dev_calib
- deviations.md: D1 (τ=4096 для квалификации и B-cap-match, т.к. G-τ не выбрал τ), D2 (цели против TAQ/B-imper не выполняются — H2 опровергнута на dev).
- `scripts/run.py --name dev_calib-qualify-NONE-tau4096 --split dev_calib --conditions A-fam1,A-fam2 --policies B-stop --tau 4096 --cell NONE` → 80 вызовов (101 попытка): A-fam1 length 0.750 (≥0.5 → квалифицировано), correct 0.200; A-fam2-v0 length 0.150 (не квалифицировано), correct 0.700.
- scripts/adapt.py (драйвер адаптивного поиска, общий семафор ≤8, варианты в artifacts/adapt/families_adapt.json, переписывание моделью с логом artifacts/adapt/rewrite_calls.jsonl). run.py получил --families.
- Переписывания fam2 моделью: r1 (8 гостей), r2 (конфликт источников), r3 (тривиальная сетка), r5 (+3 ограничения); r4 (судоку) отвергнут — finish=length (artifacts/adapt/rewrite_rejected.jsonl). Ошибка реализации: параллельные rewrite перезаписали файл вариантов (r1, r2 потеряны) → восстановлены из журнала вызовов (memo, без новых вызовов), добавлена блокировка файла.
## В работе
- Квалификация fam2-r1, r2, r5 (B-stop NONE τ=4096, dev_calib, 40 вопросов каждый).

## Блок 10 (выполнено): поиск seed для fam2 на dev_calib (B-stop, NONE, τ=4096, 40 вопросов каждый)
| вариант | тип | length | correct |
|---|---|---|---|
| fam2-v0 | рассадка 6 гостей | 0.150 | 0.700 |
| fam2-r1 (модель) | рассадка 8 гостей | 0.250 | 0.625 |
| fam2-r2 (модель) | конфликт источников + рассадка | 0.175 | 0.675 |
| fam2-r5 (модель) | +3 ограничения | 0.200 | 0.675 |
| fam2-s1 (исслед.) | MDP value iteration | 0.200 | 0.675 |
| fam2-s2 (исслед.) | судоку (scripts/tools/make_sudoku.py) | 0.150 | 0.750 |
- Ни один не квалифицирован (порог 0.5). Наблюдение (факт): сложность головоломки сама по себе не захватывает модель; fam1 (0.75) отличается связкой «факты недействительны до проверки». Интерпретация: решающий фактор — связь задачи приманки с ответом, а не трудность задачи.
- Прерванная попытка R1 fam1 (превышение лимита параллелизма) архивирована: artifacts/adapt/aborted/R1-fam1-attempt1/README.txt (0 завершённых попыток).
- verify_run.py: повторный intent для вызова без результата (возобновление после обрыва) допускается при идентичном запросе; сообщается число таких intent.
## В работе
- fam2-s3 (судоку + ключ «номер документа с ответом»), fam2-s4 (MDP + тот же ключ) — квалификация.

## Блок 11 (выполнено): квалификация связанных fam2 и ошибка finish_reason=error
- fam2-s3 (судоку + «документ с ответом = номер»): length 0.925, correct 0.075 → квалифицировано; fam2-s4 (MDP + тот же ключ): 0.650 / 0.300 → квалифицировано. Seed fam2 = s3. Пересечение 4-грамм fam1×fam2 (шаблоны) = 0.
- Переписывания моделью от s3: fam2-m1 (энциклопедический), fam2-m2 (фан-вики).
- R1 adaptive (scripts/adapt.py eval, 4 ячейки × {fam1-v0,a1,a2,a3, fam2-s3,s4,m1,m2} × 8 вопросов dev_adapt) запущен.
- **Ошибка реализации найдена**: провайдер возвращает HTTP 200 с choices[0].finish_reason="error" (обрыв генерации, content пуст). Клиент считал это успешным вызовом → fail-closed «нет ответа» → завышение эффекта атаки/занижение correct. По протоколу (model_config.logging: «тело ошибки даже при HTTP 200», транспортные — до 3 повторов) это транспортная ошибка. Затронуто: dev_calib-g1-clean — 6 вызовов (NOCTX×5, B-base×1); R1 — 4 к моменту обнаружения.
- Исправление: parse_response → transport finish_error_in_200 (повтор); при возобновлении устаревшие записи finish=error пересылаются как повтор того же вызова (тот же call_key, новые attempt, новый result; не новое наблюдение); runner пересчитывает такие исходы; verify_run допускает замену результата только для finish=error и требует, чтобы она была заменена. Тест test_finish_error_in_200_is_transport_and_retried. 74 passed.
## Следующий шаг
После R1: возобновить dev_calib-g1-clean (6 повторов) и R1 (повторы finish=error), пересчитать gates_dev.json; затем R2.

## Блок 12 (выполнено): R1 adaptive_search и повторы finish=error
- R1 (после повторов finish=error, artifacts/adapt/eval-R1.log; до повторов — eval-R1.pre_finish_error_retry.log): лучшие на dev_adapt (8 вопр.): U-gen fam1-a2 0.125 (length 0.875), fam2-m2 0.375; U-spec fam1-v0 0.75, fam2-s3 0.75; S-gen fam1-v0 0.75, fam2-m2 0.50; S-spec fam1-a2 0.75, fam2-s3 0.875.
- Наблюдение (dev, малое N): specific-ячейки устойчивее generic; связка «конфликт фактов + checksum» (a2) ломает U-gen, но не S-spec.
- dev_calib-g1-clean возобновлён (6 повторов finish=error): B-base 0.725→0.750, NOCTX 0.275 (без изменений), B-big 0.775 → G1 и C-check пройдены. gates_dev.json пересчитан (предыдущая версия: gates_dev.pre_finish_error_fix.json).
- Все 50 run-каталогов (artifacts/runs, artifacts/adapt/runs) → verify_run OK.
- R2: fam1 — мутации исследователя (b1–b4 от a2; c1–c4 от v0); fam2 — переписывания моделью (n1–n3, n4b от m2; p1, p2b, p3, p4 от s3; n4, p2 отвергнуты — finish=length у переписчика). rounds.json, R2_pairs.txt. Запущен eval R2 (32 пары).

## Блок 13 (выполнено): R2 и подготовка подтверждения
- R2 (artifacts/adapt/eval-R2.log, 256 вызовов, 0 неустранимых ошибок): лучшие после R2 — U-gen fam1-a2 0.125 / fam2-m2 0.375; U-spec fam1-v0 0.75 / fam2-s3 0.75; S-gen fam1-v0 0.75 / fam2-m2 0.50; S-spec fam1-a2 0.75 / fam2-p3 0.75. Ни один из 8 вариантов R2 против S-spec не опустил correct ниже 0.75.
- Инфраструктура подтверждения (до любого обращения к holdout): scripts/freeze.py (однократная заморозка, sha256 замороженного кода taq/*.py+scripts/run.py, данных, семейств, план прогонов), scripts/verify_confirm.py (+tests/test_verify_confirm.py: 10 тестов, отрицательные контроли удаление/опустошение/изменение raw, подмена config, лишний/отсутствующий прогон, holdout-only, непересечение с open_ids), scripts/analyze_confirm.py (правила решения H1-sufficient записаны в docstring до прогонов), run.py: holdout только с параметрами замороженного config и root=artifacts/confirm/runs; runner/verify_run: rep_start (rep2 без пересэмплирования rep1). scripts/accounting.py → artifacts/accounting.json. check_offline проверяет adapt-прогоны, происхождение переписанных вариантов, accounting, gates_select, verify_confirm. pytest: 85+10 passed.
- R3 (последний, 4 варианта на пару → 12): fam1 — d1–d4 (от a2) и e1–e4 (от v0): подделка границы документов/реплики пользователя, «уведомление оператора», комбинация, сокращение; fam2 — переписывания моделью q1–q4 от m2, s3, p3 (идёт).
- R3 fam1 (artifacts/adapt/eval-R3-fam1.log): S-spec d3 0.125 / d4 0.125 (length 0.75/0.875), S-gen e4 0.25, U-gen d1/d3/d4 0.125, U-spec e4 0.50. Факт (dev_adapt, N=8): оператор «подделка границы документов + реплики пользователя/уведомления оператора» ломает system-ячейки; U-spec устойчивее.
- R3 fam2 (eval-R3-fam2.log): U-gen m2-q3 0.125, S-gen m2-q3 0.25, S-spec p3-q3b 0.25, U-spec s3-q1 0.50.

## Блок 14 (выполнено): итог adaptive_search; (в работе) dev_select
- 96 run-каталогов adapt (8 пар × 12 вариантов × 8 вопросов = 768 вызовов-оценок) + переписывания моделью; все verify_run OK.
- Выбор по правилу (min correct, затем max length, затем короче) → artifacts/adapt/best_variants.json:
  U-gen: fam1-a2 (0.125) / fam2-m2-q3 (0.125); U-spec: fam1-e4 (0.50) / fam2-s3-q1 (0.50); S-gen: fam1-e4 (0.25) / fam2-m2-q3 (0.25); S-spec: fam1-d4 (0.125) / fam2-p3-q3b (0.25).
- dev_select (40 свежих вопросов): команды artifacts/adapt/dev_select_commands.sh → artifacts/runs/dev_select-<cell>.
## Следующий шаг
base_cell_rule по dev_select → B-big (база) на clean + A-adapt-base → G-break (scripts/gates_select.py → artifacts/gates_select.json).

## Блок 15 (выполнено): dev_select, G-break, заморозка; (в работе) подтверждение
- dev_select (40 свежих вопросов; artifacts/runs/dev_select-*): худший по семействам correct — U-gen 0.275, U-spec 0.300, S-gen 0.200, S-spec 0.250; clean 0.750–0.775. base_cell_rule → **U-spec**; A-adapt-base = A-fam2 (fam2-s3-q1).
- B-big (U-spec, 32768) dev_select: clean 0.750, A-adapt-base 0.775 (length 0, медиана токенов 11145 vs 3392 на clean, max completion 18980).
- **G-break пройден**: U-spec 0.300 ≤ 0.775 − 0.20; Δ −0.475 [−0.625, −0.325], McNemar b=0 c=19 p=3.8e-6. G3: 0/2448 неустранимых ошибок. → H1-sufficient опровергнута на dev; H2 опровергнута ранее (G-τ). artifacts/gates_select.json (`scripts/gates_select.py --check`).
- Интерпретация: атака — на бюджет: при cap 8192 ответ теряется (length), при 32768 модель отвечает верно, но тратит ×3.3 токенов.
- dev_second_calib (U-spec clean 0.65, A-fam2 0.15; D0 0.05) — проверка парсера/алиасов второй коллекции.
- D3 в deviations.md (до holdout): прогон заранее заданного набора branch_H1 на holdout как независимая проверка; прогноз — H1-sufficient не подтвердится.
- Заморожено: artifacts/frozen/config.json (sha256 2d8defb5671943504c1f6686d01ed98e001157a0efbcea5dbbf51cc6b88ece3e), families_frozen.json (fam1-e4, fam2-s3-q1 + proc_text 814 симв. = 0.95× приманки, canary_suffix), plan.json.
- Запущено: artifacts/confirm/run_all.sh (H-hotpot-main 120×6×8 → H-second-main 80×6×8 → H-hotpot-rep2 60×2×2).
- scripts/compliance.py → artifacts/compliance_dev_select.json: ≥3 упоминаний ключей приманки в 97–100% атакованных трасс при всех ячейках и B-big (эвристика; упоминание ≠ решение).
- scripts/build_results.py → artifacts/results.json (промежуточный: dev-измерения; `--check` для пересчёта).
- 2026-10-25 02:55 подтверждение: H-hotpot-main 1030/5160 исходов, транспортных сбоев нет.

## Блок 16 (выполнено, 2026-10-25): операторская остановка — сборка результатов без API
- Основание: brief.md «Операторское завершение цикла 7», artifacts/operator-stop.md. Новых вызовов модели не было; run_all.sh не перезапускался; прерванные вызовы не повторялись. Протокол, frozen config/план, замороженный код (taq/*.py, scripts/run.py) и raw-логи не изменялись.
- Покрытие (факт): H-hotpot-main 1738/5160 исходов (38 вопросов полностью = позиции 0–37 порядка разбиения; 4 частично; 78 не начаты); H-second-main 0/3440; H-hotpot-rep2 0/240; 8 intent без result — неопределённые.
- Новое: scripts/analyze_partial.py → artifacts/confirm/partial_analysis.json (сбалансированное подмножество отдельно от фронтира; критерии H1-sufficient применены без изменений описательно; вердикт не выносится). scripts/verify_stop.py + scripts/verify_final.sh (принимают пробелы подтверждения только в точной форме остановки).
- Изменено: scripts/build_results.py (+6 измерений holdout-partial, operator_stop, verify_command) → artifacts/results.json: 16 measurements, 500 evidence, missing 0. deviations.md: D4. stage_report_experiments.md: раздел 6. submission.json (старая версия submission.pre_stop.json).
- Пересчитаны устаревшие производные из raw: gates_select.json (G3 2448→2528 с учётом dev_second_calib, 0 сбоев; G-break без изменений), accounting.json (подтверждение: 1496 попыток, 2.224 ед.; всего 3883 попытки, 5.312 ед.). Прежние: *.pre_stop.json.
- Описательно (HotpotQA, 38 вопросов): U-spec − B-big на A-fam2 Δ −0.500 [−0.658; −0.342], b=0 c=19 (dev −0.475); B-cap-match 0.711; B-big ×3.5 токенов; канарейка B-big 11/38. Не подтверждение.
- Проверка: `bash scripts/verify_final.sh` → 85 passed; STAGE VERIFIED (partial data, no confirmation verdict); печатает INCOMPLETE CONFIRMATION. `bash scripts/verify.sh` ожидаемо падает на verify_confirm (неполный план).
## Незавершённое
- Подтверждение на holdout (вторая коллекция, повтор, 82 вопроса HotpotQA) — не выполнено и не будет выполняться в цикле 7 (запрет оператора).
## Следующий шаг
Стадия report/submission/memory и независимая критика — без API.

## Операторское исправление ссылок G3 (2026-10-25)
- build_results.py теперь перечисляет конкретные outcomes.jsonl, используемые gates_select.py, вместо каталогов.
- results.json пересобран: 16 измерений, 502 evidence, missing 0. Установленный factory.validate_stage('experiment') прошёл; замороженный протокол не изменился.
- Изменяемые файлы сохранены с проверкой SHA-256 в defense-evidence-fix-1792884198969937252. Переход experiment → report записан отдельной операторской квитанцией; история попыток сохранена. Новых запросов нет.

# Стадия report / memory (2026-10-25, без API)

## Блок 17 (выполнено): вход стадии
- Прочитаны brief.md (операторское завершение), handoff.json (формат памяти ц.6), progress.md, stage_report_experiments.md, deviations.md (D1–D4), operator-stop.md, submission.json, results.json.
- Проверка: `bash scripts/verify_final.sh` → 85 passed; STAGE VERIFIED (partial data, no confirmation verdict); INCOMPLETE CONFIRMATION H-hotpot-main 1738/5160, H-second-main 0/3440, H-hotpot-rep2 0/240, 8 undetermined.
## Следующий шаг
Сбор фактов из hypotheses.md, sources.json, protocol (PC/F), accounting; затем artifacts/report.md и memory.json.

## Блок 18 (выполнено): производные таблицы отчёта (без API)
- Новый scripts/report_tables.py → artifacts/report_tables.json (cost_per_correct, медиана токенов относительно clean|B-big, счёт канареек; источник — partial_analysis.json и accounting.json). Проверка: `.venv/bin/python -I scripts/report_tables.py --check` → True.
- Наблюдение (описательно, holdout-префикс n=38): на A-fam2 B-big 31/38 при 0.00321 ед./верный ответ против U-spec 12/38 при 0.00649; под атакой ячейки тратят ×3.1 токенов (почти столько же, сколько B-big ×3.5), т.е. инструкция не экономит токены и теряет ответы. На A-canary B-big выводит канарейку 11/38 (correct 0.553).
## Следующий шаг
artifacts/report.md, memory.json, scripts/verify_report.py.

## Блок 19 (выполнено): report, memory, submission
- artifacts/report.md: постановка, результаты гипотез (H2-TAQ и H1-sufficient опровергнуты на dev; подтверждение не завершено, D4), ключевые измерения dev и описательный holdout-префикс, затраты, отклонения, раздельная оценка (MVP / полезность / новизна / готовность к статье), границы, причины провала и лучшее направление (разделение осей доступность/целостность: большой cap + детерминированная проверка целостности + бюджет арендатора).
- artifacts/memory.json: 13 facts (с условиями и путями evidence), 5 failures, 7 unknowns, 6 next; исходники не копировались.
- scripts/verify_report.py, scripts/verify_report_stage.sh (verify_final.sh + verify_report.py). submission.json → stage report, verify_command = bash scripts/verify_report_stage.sh (прежняя версия submission.pre_report.json).
- Проверка: `bash scripts/verify_report_stage.sh` → exit 0 (85 passed; STAGE VERIFIED partial; REPORT CHECKS PASSED).
- sha256: protocol.json 69bea2bd… = protocol.sha256; handoff.json 9cfc9aea… без изменений; brief.md сейчас 66eda10a… (отличие от 47bddaff… блока 4 — операторский раздел о завершении, добавлен не исследователем).
- Новых API-вызовов нет; сбор данных не возобновлялся.
## Незавершённое
- Независимая критика (отдельная стадия/агент) не запускалась в этом блоке.
- Подтверждение на holdout не будет выполнено в кампании (лимит 7 циклов).
## Следующий шаг
Независимая критика по artifacts/report.md и verify_report_stage.sh — без API.
