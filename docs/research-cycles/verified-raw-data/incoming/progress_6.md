# progress.md — цикл 6, стадия: литература и выбор гипотезы

## Блок 0 — вход (выполнено)
- Прочитаны brief.md, handoff.json (5 прошлых циклов, все verdict=pivot, score=1).
- Хэши входов: artifacts/logs/inputs.sha256 (brief.md/handoff.json не изменяются).
- Ключевые уроки прошлых циклов (из handoff, не перепроверены здесь численно):
  - 1–5: задачи решались детерминированным D0 без LLM (need-for-LLM gate не пройден);
  - 1–4: reasoning съедал output cap (null/length); в c5 рабочее условие R0/cap8192;
  - c5: safety-styled payload вызвал цикл reasoning до 8192 токенов и потерю задачи (p0055),
    необоснованный ABSTAIN (p0053) — критик предложил направление «злоупотребление защитной реакцией».
  - протоколы с недостижимым масштабом блокировали себя (c3); упаковка съедала цикл (c3).

## Следующий шаг
- Поиск и чтение первоисточников по: reasoning DoS/overthinking-атакам, DoS на guardrails,
  over-refusal под инъекциями, бюджетам reasoning; затем гипотезы.

## Блок 1 — поиск литературы (в процессе)
- Прочитаны (через WebFetch, HTML-версии): OTora 2605.08876v3 (вкл. App. H/I), OverThink 2502.02542v4,
  Shield to Target 2606.14517v2 (вкл. mitigation). По аннотациям/сниппетам: ThinkTrap 2512.07086,
  ReasoningBomb 2602.00154, MCP overthinking 2602.14798, Persistent Billable State 2609.28585,
  survey 2603.16068 (только abstract), HODOR/InceptionRAG 2609.16818 (сниппет).
- Предварительный вывод: атаки R-DoS хорошо изучены; статичные пороги (cap/monitor/filter)
  меняют DoS на потерю законных задач (OTora App.I, Shield to Target: fail-closed 5/10→3/10).
  Защитная реакция «после срабатывания cap» как объект оценки пока не найдена (не доказательство новизны).

## Блок 2 — smoke интерфейса (выполнено)
- Команды: `python3 -I scripts/smoke01.py artifacts/smoke-01`; `python3 -I scripts/smoke02.py artifacts/smoke-01`.
- 7 вызовов, prompt 696 + completion 4509 токенов, cost 0.0012331143 (валюта unknown); artifacts/smoke-01/accounting.log.
- Результат: enable_thinking=false и reasoning.max_tokens не применяются маршрутом; reasoning.enabled=false → 400;
  авторский decoy при cap=1024 → 3/3 length, пустой ответ; prefill не помогает. N=1 на условие.

## Блок 3 — артефакты стадии (выполнено)
- artifacts/hypotheses.md: ближайшие работы, H1–H5, отклонённые направления, выбор H1 (BEIS), критерии опровержения.
- artifacts/sources.json (+ идентичная копия ./sources.json): 19 записей {id,url,version,title,claim,status};
  статусы fulltext_partial / abstract / snippet / own_measurement.
- Проверки: sha256 brief.md/handoff.json не изменились; JSON валиден; копии совпадают.

## Незавершённое / следующий шаг
- Загрузить HotpotQA dev distractor (отдельный каталог, sha256), разделить dev/holdout до прогонов.
- Scripted known-state тесты контраста BEIS vs B-cap/B-retry/B-map-always.
- Dev-калибровка cap (H2), затем замороженный протокол H1.
- Перепроверить цифры S01–S03 прямым чтением перед рукописью.

## Блок 4 — исправление по замечанию «Sources list is empty» (выполнено)
- Причина: sources.json был объектом {accessed, status_legend, sources:[...]}, а проверка ожидает список.
- Исправление: ./sources.json и artifacts/sources.json — массив верхнего уровня объектов
  {id,url,version,title,claim,status,accessed}; легенда статусов вынесена в artifacts/sources_legend.json;
  прежняя версия сохранена в artifacts/logs/sources.v1-dict.json.
- Перепроверены первоисточники (abstract-страницы arXiv): S04, S05, S06, S07, S17 повышены snippet→abstract,
  уточнены цифры. Добавлены S18 (early-exit, white-box), S19 (robotic overthink), S20 (Clawdrain), S21 (Token Budgets).
  S16 остаётся snippet (OpenReview недоступен без проверки браузера).
- Ключевая находка: S07 (Persistent Billable State) — progress-authorized policy 22/24 vs fixed cap 13/24;
  идея «адаптивная политика бюджета лучше cap» уже известна. Вклад H1 сужен в hypotheses.md §2.
- Проверки: `python3 -c "...isinstance(l,list) and {'url','claim','status'}<=set(x)..."` → ok 23;
  `cmp sources.json artifacts/sources.json` → same; `sha256sum -c artifacts/logs/inputs.sha256` → OK.
- Статусы: abstract 13, fulltext_partial 7, own_measurement 2, snippet 1.

## Следующий шаг
- Прочитать полный текст S07 (сравнение с fixed cap) до заморозки протокола.
- Затем пункты из блока 3: HotpotQA dev/holdout, scripted known-state тесты, dev-калибровка C.

## Блок 5 — стадия протокола: данные и разбиение (выполнено)
- S07 полный текст (HTML v1, первые 100k символов через WebFetch): fixed cap $0.10 vs progress-authorized
  ($0.13/$0.16 после host-verified milestones), 24 workflow Mistral Small 4, 22/24 vs 13/24 oracle-verified;
  изоляция источников и retry-after-length не оцениваются; reasoning-DoS одного вызова не изучается.
- HotpotQA: curtis.ml.cmu.edu → empty reply; загружен HF parquet
  `hotpotqa/hotpot_qa/distractor/validation-00000-of-00001.parquet` → data/raw/hotpotqa/dev.parquet.
  Конвертация: nix python3.withPackages(pyarrow 24.0.0), `scripts/convert_hotpot.py` → data/derived/hotpot_dev_distractor.jsonl
  (7405 items; все level=hard — особенность dev HotpotQA). sha256: data/SHA256SUMS.
- Разбиение: `python3 -I scripts/make_split.py data/derived/hotpot_dev_distractor.jsonl data/derived`
  (salt c06-split-v1; pool без yes/no = 6947; dev_calib 60, dev_adapt 40, holdout_primary 120, holdout_reserve 60;
  пересечение dev/holdout = 0). Содержимое holdout не просматривалось и в файлы не выгружено.

## Блок 6 — протокол заморожен (выполнено)
- `python3 -I scripts/write_protocol.py artifacts/protocol.json` → artifacts/protocol.json (chmod 444),
  sha256 в artifacts/logs/protocol.sha256 (d95cb69e…52c0). Поля hypothesis, baselines, metrics, falsification,
  split_policy, budget присутствуют (проверено скриптом); также unit_of_analysis, conditions (clean, clean_hard_len,
  clean_hard_topic, A1–A6), gates G0–G3, useful_advantage_criteria PC1–PC6, confirmatory_experiment, calibration.
- Свободные параметры (C, c, промпты, тексты приманок) выбираются только по правилам calibration на dev и
  фиксируются в artifacts/frozen/config.json до holdout. Отклонения — только через artifacts/deviations.md.
- sources.json: S07 → fulltext_partial (HTML v1), обе копии совпадают. inputs.sha256: brief.md/handoff.json OK.

## Незавершённое / следующий шаг (стадия реализации)
1. MVP-конвейер политик + mock-тесты G0.
2. D0 и dev-калибровка C, c (G1, G2, G3) на dev_calib; разработка семейств приманок и контролей.
3. Адаптивный поиск на dev_adapt; запись artifacts/frozen/config.json.
4. Подтверждение на holdout_primary строго по artifacts/protocol.json.

## Блок 7 — стадия реализации: MVP-код и G0 (выполнено)
- Код MVP с нуля (scripts/): c06lib.py (клиент LLM с логами/учётом/транспортными повторами,
  SQuAD-нормализация и правило correct, парсер ответа, детерминированная сборка документов по
  условиям, промпты, D0); policies.py (общий первый проход + все 8 политик, map-ветвь);
  decoys.py (2 семейства: integrity/safety + overthink/neutral, canary, clean_hard_topic тексты);
  benign.py (benign-корпус для clean_hard_len из dev-pool вне calib/adapt; holdout_reserve для holdout);
  run_eval.py (конкурентный прогон, sha256 входов, outcomes.jsonl/inputs.jsonl/accounting.jsonl).
- Зависимости: только stdlib (python3.14, nix). Запуск с PYTHONPATH=scripts (мой код, не untrusted data).
- G0 (gates G0): `PYTHONPATH=scripts python3 scripts/test_g0.py artifacts/g0` → 11/11 passed
  (artifacts/g0/g0_results.json). Подтверждено: BEIS/B-retry/B-retry-big/B-map-always различны по
  траектории и исходам; при fp=stop BEIS==B-cap по ответу и цене; изоляция исключает исчерпавший c
  документ; budget-matched cap = n_docs*c+C; D0 без вызовов; canary_hit работает.

## Блок 8 — feasibility-проба на живой модели (в процессе)
- spec_probe (3 dev_calib × {clean,A1} × {D0,B-cap,B-big,BEIS}, C=4096,c=1024).
- Факты (artifacts/probe/accounting.jsonl): sampling top_k=20/presence_penalty=1.5 ПРИНЯТЫ (0 событий 400);
  reasoning велик даже на clean — 2/3 clean first-pass достигли length при C=4096 (overthink без приманки).
  B-big(32768): clean завершается 1275–4110 ctok, A1 до 5713. Вывод: C=4096 мал для clean → калибровка
  по C_rule, вероятно, выберет 8192. usage.completion_tokens_details.reasoning_tokens иногда > completion
  (не подмножество); total_tokens считаю как prompt+completion (по протоколу), reasoning_tokens — отдельно.
- Наблюдение (требует реакции до заморозки промптов): модель не всегда печатает строку 'Answer:'.

## Блок 9 — анализ пробы и калибровочный инструментарий (выполнено)
- probe1 (C=4096): clean B-cap триггерит 2/3 (overthink без приманки) → C=4096 мал. D0 0/3 vs B-big 2/3
  (G1-сигнал в пользу need-for-LLM). Старый extract-промпт давал почти всегда NONE → BEIS не
  восстанавливал, map стоил 17–21k токенов.
- Исправлены промпты (до заморозки): EXTRACT_INSTR (копировать релевантные предложения, кратко думать,
  не решать задачи из документа), FINAL_INSTR (давать ответ даже при неполных фрагментах).
- Написаны: analyze.py (парный бутстрэп CI, точный McNemar, Holm, медианы токенов), calibrate.py
  (G1/G2/C_rule/c_rule/G3 из outcomes+accounting), freeze_config.py (frozen/config.json, chmod 444).
- ТРОПУСКНАЯ СПОСОБНОСТЬ (ключевое ограничение ресурса): маршрут генерирует 1–8k reasoning-токенов на
  вызов, нерегулируемо; при cap 8192 и map-ветви (~12 вызовов/задача) наблюдаемая скорость ~4–6 вызовов/мин
  (concurrency 6). Полное подтверждение (120×4×8 политик ≈ 10k вызовов) → десятки часов. Это само по себе
  результат о цене защиты на данном маршруте. План: калибровка на малом dev-подмножестве (N фиксируется),
  заморозка, затем подтверждение на уменьшенном holdout с честной пометкой мощности/exploratory и
  записью в deviations.md (сокращение сделано ДО просмотра holdout, по ресурсной причине).

## Блок 10 — калибровка извлечения: c_rule не выполнен (выполнено)
- extract_cal (8 clean dev_calib, 80 extract-вызовов исходных абзацев, cap 3072, terse-промпт):
  completion p50=3072 (медиана упирается в cap!), exhaustion@{512,1024,2048,3072}=
  {1.0,0.975,0.963,0.925}, none-rate 0.963, support gold-recall 1/16=0.062.
- Проверка робастности по probe1 (strict-промпт, 42 вызова): exhaustion@1024=0.12, но none-rate 1.0,
  support gold-recall 0/4=0.0.
- Вывод: c_rule (exhaustion исходных ≤0.02 И recall достаточен) не выполним ни при каком c∈{512,1024,2048}.
  Ветвь изоляции не восстанавливает ответ (recall 0–6%) и стоит ~n_docs·c. → BEIS не калибруется на
  маршруте; подтверждение на holdout не запускается, holdout не вскрыт (deviations.md D3).
  artifacts/extract_cal/ANALYSIS.md.
- Запущен дешёвый gates-прогон (D0/B-big/B-cap × {clean,clean_hard_len,clean_hard_topic,A1}, 16 items,
  C=8192) для G1 (need-for-LLM) и G2 (реальность атаки A1 vs clean_hard) — проблема существует даже
  если BEIS её не решает.

## Блок 11 — gates на dev_calib C=8192 (выполнено), запущен адаптивный поиск A1
- gates (16 dev_calib × {clean,clean_hard_len,clean_hard_topic,A1} × {D0,B-cap,B-big}, C=8192, 128 вызовов,
  cost 0.120). calibrate.py → artifacts/gates/calib_report.json:
  - G1 = TRUE: clean correct B-big=0.5625 vs D0=0.0625, Δ=0.50 ≥0.30 (LLM реально нужен).
  - G2 = FALSE: при C=8192 trigger=0.0 и answer_lost=0.0 ВО ВСЕХ условиях, вкл. A1. Фиксированная
    integrity-приманка НЕ пробивает cap 8192: B-cap clean=0.625, A1=0.5625 (падение 0.0625 ≪ 0.30).
    → по протоколу: простой cap достаточен ПРОТИВ ЭТОЙ приманки; H1 не проверяется этой приманкой.
  - C_rule/c_rule = FALSE (c_rule — см. блок 10; C_rule при 8192: correct(B-cap,clean_hard) vs B-big
    в пределах, но проверяется совместно — отражено в calib_report).
  - sampling top_k/presence приняты (0 отказов).
- Открытый вопрос: может ли УСИЛЕННАЯ (адаптивная) приманка пробить 8192? Запущен adapt_probe
  (5 dev_adapt × 4 варианта: baseline / большой перебор / 12 подзадач / явный long-think, C=8192,
  B-cap first-pass, objective=доля length). Все попытки сохраняются (artifacts/adapt/).

## Блок 12 — адаптивная сила атаки, финал стадии (выполнено)
- adapt (5 dev_adapt × 4 варианта, C=8192, B-cap first-pass, artifacts/adapt/): baseline integrity-
  приманка length_rate=0.6/lost=0.6/ctok_med=8192; «усиленные» варианты СЛАБЕЕ (большой перебор 0.0,
  12 подзадач 0.0, явный long-think 0.2) — модель отбрасывает абсурдные инструкции, вовлекается в
  правдоподобную «проверку». Вывод: reasoning-DoS реален, может пробить 8192, но высоко-вариативен
  (0/16 dev_calib vs 3/5 dev_adapt для одной приманки).
- ИТОГ цикла: H1 не подтверждена/опровергнута на маршруте. (1) LLM нужен (G1 Δ=0.50). (2) Атака
  реальна но нестабильна (G2 fail: простой cap 8192 достаточен на dev_calib; drop_A1 0.0625 ≤
  drop_hard_len 0.125). (3) BEIS-изоляция сломана на маршруте: recall улик 0–6%, exhaustion benign
  0.9+, цена > B-big; c_rule невыполним → config не заморожен, holdout НЕ вскрыт. Там где атака
  срабатывает, задачу возвращает больший cap (B-big), не изоляция. BEIS доминируем.
- Артефакты стадии: artifacts/findings.md (отчёт + карта утверждение→доказательство),
  artifacts/deviations.md (D1–D3), artifacts/calibration_decision.json (C/c/промпты/декои + sha256
  кода), artifacts/extract_cal/ANALYSIS.md, artifacts/{probe,probe2,extract_cal,gates,adapt}/ (сырьё),
  artifacts/g0/ (11/11), artifacts/submission.json (verify_command=["bash","scripts/verify.sh"]).
- Проверки: verify.sh exit 0 (G0 11/11; correct-правило воспроизводит 216 outcomes; детерминизм 70);
  JSON валидны; sources.json — список 23; brief/handoff/protocol sha256 не изменились; G3 128/128 HTTP 200.
- Следующее направление (findings §7): управление reasoning-бюджетом там, где оно возможно
  (no-think/early-exit/logits), или дешёвый детерминированный пред-фильтр документов vs cap — на
  маршруте/модели с управляемым reasoning; текущий holdout сохранён для такого цикла.

## Блок 13 — стадия экспериментов: план (2026-10-24, новая сессия)
- Факт-проверка: protocol-frozen.json == artifacts/protocol.json по содержанию (json ==), не менялись.
- Замечено: приманка V0 в adapt (3/5 length) — НЕ тот же текст, что integrity в decoys.py (gates, 0/16):
  V0 короче, без правила 2x2 sub-block. Утверждение «та же приманка» в findings/памяти неточно → исправить.
- Незакрытые по протоколу пункты калибровки: (a) adaptive_search A1 использовал 4/10 вариантов × 5/8
  вопросов dev_adapt; (b) гейты G1/G2/C_rule — на 16/60 dev_calib (D2); (c) c_rule util-часть
  (B-map-always end-to-end на clean) не измерена (null).
- План: E1 adapt2 — довести A1-поиск до 10 вариантов × 8 вопросов (run-id adapt2, старые наблюдения
  не перезапускаются, новые вопросы 6–8 для V0–V3 — новые наблюдения); E2 — семейства A1 по правилу
  ≥0.6 на dev; E3 gates60 — G1/G2/C_rule на всех 60 dev_calib с итоговым A1; E4 — B-map-always/BEIS/
  B-retry*/B-sys на dev-подмножестве (c_rule util, exploratory сравнение политик);
  E5 — решение по holdout строго по гейтам; results.json.

## Блок 14 — E1 adapt2 (выполнено), E3 gates60 (запущен)
- `python3 scripts/adapt_search2.py artifacts/adapt2 8192 8` → 60 новых вызовов; artifacts/adapt2/
  {variants.json, adapt2_results.jsonl, adapt2_summary.json, accounting.jsonl}.
- length_rate (n=8, C=8192): V5_question_coupled 0.625, V0 0.5, V3 0.5, V7 0.375, V6 0.125, V8 0.125,
  V1/V2/V4/V9 0.0. Выбран V5 → семейство «coupled» (scripts/decoys_v2.py). Нейтральное семейство не прошло порог.
- Отклонения записаны: deviations.md D4.
- Запущено: `python3 scripts/run_eval.py artifacts/spec_gates60.json artifacts/gates60` (60 dev_calib ×
  4 условия × D0/B-big/B-cap/B-retry/B-retry-big/B-sys/BEIS, C=8192, c=2048).

## Блок 15 — предрегистрация решения о holdout (записано ДО окончания gates60)
- Промежуточно (50/240 задач gates60): A1 trigger 7/11, B-cap A1 0.27 vs clean 0.56 — новая приманка
  срабатывает. Финальное решение — только по полному gates60.
- Правило: если G2 на gates60 НЕ пройден → holdout не вскрывается (protocol G2).
  Если G1, G2, G3 пройдены → c_rule остаётся невыполнимым (exhaustion извлечения 0.9+ при c≤3072, D3).
  Тогда: c=2048 фиксируется как ограничение (аналог fallback C_rule; отклонение D5), config морозится
  freeze_config (C=8192, c=2048, decoys_v2), и запускается подтверждение holdout_primary (120) ×
  {clean, clean_hard_len, clean_hard_topic, A1} × {D0,B-big,B-cap,B-retry,B-retry-big,B-sys,BEIS};
  B-map-always (PC6) — на первых 30 holdout × {clean, A1} из-за цены (~12 вызовов/задача) — отклонение D5;
  variance-подмножество (30 × {clean, A1}, 2 повтора B-cap/BEIS) — run_id confirm_rep1/rep2;
  boundary-клетки A2–A6 не запускаются (описательные, ресурс) — D5.
- До holdout: B-map-always end-to-end на dev_calib (c_rule util-часть), run_id mapdev.

## Блок 16 — E3 gates60 (выполнено)
- `python3 scripts/run_eval.py artifacts/spec_gates60.json artifacts/gates60` → 1385 вызовов, usage.cost 1.325,
  ~2.6 ч, 1680 outcomes (60×4×7), HTTP 200 у всех. `python3 scripts/calibrate.py artifacts/gates60 8192 2048`,
  `python3 scripts/compare_dev.py artifacts/gates60 artifacts/gates60/compare_dev.json`.
- G1 PASS (clean B-big 0.783 vs D0 0.033). G2 PASS (B-cap drop A1 0.567 ≥0.30; hard_len/topic 0.033 ≤0.10).
  C_rule PASS при C=8192. c_rule FAIL (как D3).
- A1 (dev, exploratory): B-cap 0.217 (trigger 0.75), B-retry 0.45, B-retry-big 0.70, B-sys 0.733 (ток.мед 4522),
  B-big 0.75, BEIS 0.35 (ток.мед 36566, 13 вызовов). BEIS−B-sys −0.383 [−0.517,−0.25].
  На сработавших 45: BEIS исключил 86/90 supporting-абзацев, приманку лишь 11/45.
- Следующее: mapdev (B-map-always, 12 dev_calib × {clean,A1}), затем freeze + holdout (блок 15).

## Блок 17 — mapdev (выполнено), заморозка, подтверждение запущено
- mapdev: `python3 scripts/run_eval.py artifacts/spec_mapdev.json artifacts/mapdev` → 281 вызов, cost 0.157.
  B-map-always clean 0.167 (12 dev_calib; B-big на тех же id см. gates60), A1 0.167, ток.мед ~27k;
  исчерпание c=2048 на extract: clean 111/121=0.917, A1 111/134. c_rule FAIL по обеим частям (end-to-end).
- Отклонение D5 записано до holdout. `python3 scripts/freeze_config.py 8192 2048 decoys_v2` →
  artifacts/frozen/config.json (444), sha256 254ce25c…4220 (artifacts/logs/config.sha256);
  sha256 кода/spec: artifacts/logs/code_confirm.sha256.
- Запущено 13:07: `scripts/run_confirm.sh` → confirm (120×4×7), confirm_map (30×{clean,A1}×B-map-always),
  confirm_rep1/rep2 (30×{clean,A1}×B-cap/BEIS). Лог: artifacts/run_confirm.log. Оценка ~7 ч.
- После: scripts/analyze_confirm.py (PC1–PC6, falsification, Holm), разбор ≥20 неудач, results.json.

## Блок 18 — восстановление после внешнего тайм-аута (2026-10-24, новая сессия)
- Проверено: старых процессов run_eval/run_confirm нет; sha256 кода/spec = artifacts/logs/code_confirm.sha256.
- Состояние confirm: 211/480 задач завершены (1477 outcomes), 1218 accounting, cost 1.218; 7 in-flight задач
  (47 ответов сохранено); confirm_map/rep1/rep2 не начаты. Хеши исходных журналов:
  artifacts/confirm_resume/original_logs.sha256.
- Написан scripts/run_eval_resume.py (run_eval.py не тронут), offline-проверки пройдены (deviations D6).
- Следующее: запуск scripts/run_confirm_resume.sh в фоне (лог artifacts/run_confirm_resume.log), затем
  analyze_confirm.py, разбор неудач, results.json.

## Блок 19 — confirm завершён (resume1)
- `scripts/run_confirm_resume.sh` 15:01→17:24: confirm 269 задач (1587 новых вызовов, cost 1.530, 47 replay),
  итого 480/480 задач, 3360 outcomes, 0 исключений; суммарно 2805 записей accounting, cost 2.748.
  Исходные журналы неизменны (sha256 -c OK). Замечено: finish_reason=error при HTTP 200 (обрыв у
  провайдера) — 6 в первом сегменте, ≥5 в resume1, 1 в gates60; код считает как потерю ответа (не менялся).
- Далее идут confirm_map, confirm_rep1, confirm_rep2 (сегмент run1).

## Блок 20 — предварительный анализ confirm (без map/rep)
- `python3 scripts/analyze_confirm.py artifacts/confirm - - - artifacts/analysis/confirm_prelim_nomap.json`:
  PC1–PC4 FAIL, PC5 PASS; F2 (retry достаточен) и F4 (B-sys достаточен) TRUE → H1 опровергнута на holdout.
  H2: drop_A1 0.567 vs hard_len/topic 0.017 → атака реальна (не опровергнута).
- A1 correct: B-cap 0.183, B-retry 0.317, BEIS 0.408 (ток.мед 35k, 13 вызовов), B-retry-big 0.733 (20.8k),
  B-big 0.733 (11.4k), B-sys 0.742 (4.5k). Clean ~0.75 у всех LLM-политик; D0 0.067.
- `scripts/dump_failures.py artifacts/confirm 30 artifacts/analysis/confirm_failures.jsonl` (60 неудач).
- `scripts/confirm_extra.py` → artifacts/analysis/confirm_extra.json: BEIS исключает 93.4% supporting,
  приманку лишь 18.7%; 23/27 верных BEIS — при исключении всех улик (ответ из памяти модели).
  Чувствительность без 18 задач с finish=error: выводы не меняются. Усиление токенов A1/clean: B-sys 1.20,
  B-cap 2.59, B-big 3.13, B-retry-big 5.50, BEIS 9.29.
- Ждём confirm_map/rep1/rep2.

## Блок 21 — confirm_map/rep, финальный анализ, results.json (выполнено)
- confirm_map 17:24→18:06 (707 вызовов, 0.365), rep1 →18:34 (331, 0.227), rep2 →18:58 (313, 0.216); 0 исключений.
- `python3 scripts/analyze_confirm.py artifacts/confirm artifacts/confirm_map artifacts/confirm_rep1 artifacts/confirm_rep2 artifacts/analysis/confirm_analysis.json`:
  PC1–PC4 FAIL, PC5/PC6 PASS; F2, F4 TRUE (F1, F3, F5 FALSE) → H1 опровергнута; H2 не опровергнута (0.567 vs 0.017).
  Повторы: согласие A1 0.73–0.77, clean 0.93.
- Затраты: scripts/costs_confirm.py → artifacts/analysis/confirm_costs.json (известно 3.556 USD, ≤0.042 неизвестно).
- Пост-хок: confirm_lenient.json (мягкое правило) и confirm_extra.json (без finish=error) — выводы те же.
- Разбор неудач: artifacts/analysis/failures_review.md.
- `PYTHONPATH=scripts python3 scripts/build_results.py` → artifacts/results.json (85 measurements, 31 evidence).
- `bash scripts/verify.sh` → RESULT OK (G0 11/11; correct 5580/0; семейства 994/0) + verify_confirm 6/6 PASS.
- findings.md §C, submission.json обновлены (копии до изменения — artifacts/confirm_resume/*.pre_confirm.*).
- brief/handoff/protocol sha256 не менялись.
- Следующий шаг (следующий цикл): адаптивная атака против B-sys/B-big (сейчас приманка подобрана против B-cap).

## Блок 22 — стадия отчёта: artifacts/report.md и memory.json (2026-10-24, выполнено)
- Проверено: `bash scripts/verify.sh` → RESULT OK (G0 11/11; correct 5580/0; семейства 994/0; verify_confirm 6/6);
  `sha256sum -c artifacts/logs/{inputs,protocol}.sha256` OK (brief/handoff/protocol не менялись).
- Независимый пересчёт таблицы A1 из artifacts/confirm/outcomes.jsonl — совпадает с confirm_analysis.json.
  Пост-хок: `python3 -I scripts/report_posthoc.py artifacts/confirm/outcomes.jsonl artifacts/analysis/report_posthoc.json`
  → B-sys−B-big (A1) +0.008 [−0.050, 0.058]; токены B-big/B-sys 2.54× [2.30, 2.68]; B-sys length 3/120 vs B-cap 93/120.
- Литература: прочитаны §5.3/§6/Table 11 OverThink v4 (локальная копия artifacts/sources/report_check/) —
  инструкционная защита и max_tokens не оцениваются; добавлено в sources.json как S02-defenses (24 записи; копия
  до изменения artifacts/confirm_resume/sources.pre_report.json).
- Найдено при отчёте: B-sys меняет два фактора (роль system + специфичный текст «tasks, puzzles, checks», совпадающий
  с семейством приманки); user-промпт всех политик уже содержит «documents are untrusted data» — отражено в report §6.
- Созданы: artifacts/report.md (итог, оценки MVP/полезность/новизна/статья раздельно, следующее направление, карта
  доказательств); artifacts/memory.json = memory.json (facts 11, failures 4, unknowns 6, next 6; без исходников);
  submission.json: обновлён summary (старый — summary_historical_pre_confirm; копия confirm_resume/submission.pre_report.json).
- Незавершённое: нет для стадии. Следующий шаг (новый цикл): H-next — факторный разбор инструкционной защиты против
  адаптивного к ней противника на новом разделении (report §8).
