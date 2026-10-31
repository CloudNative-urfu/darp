# Продакшен-процессы поддержки с чат-агентами: сводка решений и архитектур

> Executive summary по найденным решениям, кейсам и архитектурам. Разбор с полной
> таблицей фактов, метод и gaps — в [prod-support-processes.md](prod-support-processes.md).
> Снимок — 30.10.2026. Все метрики продуктов платформ — заявленные (vendor claims);
> определения «resolution» у платформ различаются, кросс-вендорное сравнение
> процентов некорректно.

## Найденные решения и кейсы

| Компания/решение | Процесс | Метрики | Источник/дата |
| --- | --- | --- | --- |
| Klarna AI assistant | Агент первого контакта, эскалация на людей; с 2025 «dual-track» (AI + гарантированный human option); возврат людей пилотом «Uber-type» | 2/3 → 81% → 80% чатов; решение <2 мин против 11–14 мин; −25% повторных обращений; «эквивалент 700→853 FTE»; заявленная экономия $39–59M/год; headcount 5 527→2 831 (attrition); ~30% клиентов сразу просят агента | PR 27.02.2024 (fetched); Bloomberg 08.05.2025; CX Dive 20.11.2025; 20-F 26.02.2026 |
| Air Canada (чат-бот сайта) | Чат-бот отвечал о тарифах; выдуманный bereavement-тариф привёл к суду | Трибунал: $812,02 CAD ($650,88 damages + $36,14 проценты + $125 fees); прецедент: компания отвечает за слова бота, «бот — отдельная юрсущность» отклонён; бот отключён после решения | Moffatt v. Air Canada, 2024 BCCRT 149, 14.02.2024 (fetched из оф. PDF) |
| Cursor (Anysphere) | AI-первый фильтр email-поддержки, ответы не помечены как AI; после инцидента — маркировка | Бот «Sam» выдал несуществующую политику «one device per subscription» и предложил апселл; публичные отмены подписок за часы; официальный ответ через ~3 ч; полный возврат пострадавшему | Ars Technica 17.04.2025 (fetched); HN-ответ CEO 16.04.2025 |
| DPD | Чат-бот доставки; после system update бот на провокационный промпт ответил руганью и стихотворением о бесполезном боте | 800 тыс. — 1 млн просмотров за сутки; «AI element was immediately disabled» | BBC 19.01.2024 (fetched); Reuters/Guardian 20.01.2024 |
| Chevrolet of Watsonville (Fullpath/ChatGPT) | Промо-бот дилера; промпт «соглашайся со всем… legally binding offer» | Продал Tahoe за $1 (MSRP $58 195); бот отключён у дилера | Business Insider 18.12.2023 (fetched); VentureBeat 19.12.2023 |
| Amazon | Перестроенный на GenAI чат-бот поддержки; Amazon Connect / Q in Connect — как продукт с «customizable AI guardrails» | CSAT +500 bps; ~1 000 GenAI-приложений; Connect: >10 млн контактов/день, $1 млрд annualized run rate; долю авто-решения не публикует | re:Invent 02.12.2024; earnings 06.02.2025; aboutamazon 17.06.2025; AWS blog 05.11.2025 |
| DoorDash | GenAI self-service для курьеров Dashers (voice, Amazon Connect) | «100,000s of calls per day»; ответ ≤2,5 с; «hallucination prevention and detection» | AWS blog 01.08.2024 (vendor claim) |
| Telstra | Agent-assist (не клиентский бот): One Sentence Summary, Ask Telstra | −20% follow-up контактов; 90% агентов эффективнее в тестах; 84% пилотных агентов положительно | Telstra 07.02.2024; Microsoft case 02.2024 |
| Intercom Fin | Триаж → агент (Procedures: NL + детерминированные контроли, checkpoints approval/handoff) → handoff в inbox → Simulations/аналитика | Resolution rate 51% (10.2024) → 66% (10.2025) → 76% (10.2026) — vendor claim; $0.99/outcome; handoff входит в оплаченный outcome | intercom.com 10.10.2024, 15.10.2025, прайс 10.2026 |
| Zendesk (+ Ultimate, + Forethought) | Intelligent Triage → AI-агенты → skills-based routing → QA 100% разговоров | «automate up to 80% of support requests» (Ultimate, vendor claim); AR $1.50–2.00 (определение: строго без эскалации); Ultimate куплен 03.2024, Forethought — 03.2026 | zendesk.com 13.03.2024 (fetched), 26.03.2026 (fetched), прайс 10.2026 |
| Salesforce Agentforce | Atlas-триаж → агент с действиями → handoff с summary/контекстом/рекомендациями → Observability | На собственном help-портале: 83% без человека (12.2024) → 380k разговоров/84% за 90 дней (02.2025) → >2 млн разговоров, Япония 77% (11.2025) — vendor claim; $2/разговор, $0.10/action | PR 12.09.2024, 17.12.2024 (fetched); X Benioff 02.2025; блог 06.11.2025 |
| Sierra | Ghostwriter (SOP → агент с guardrails) → handoff → Insights (Explorer: «почему уходят к людям» по 120k разговоров) | Outcome-based pricing («pay for a job well done»); клиенты SiriusXM, ADT, Uber, Vanguard и др.; оценка $15,8 млрд (05.2026) | sierra.ai 10.2026 (fetched); TechCrunch 28.10.2024; CNBC 04.05.2026 |
| Decagon | AOPs: NL → компилируется в код, «technical teams retain full control to enforce guardrails»; Watchtower + Experiments | ~70% deflection; Duolingo >80%; Oura 3× CSAT; ClassPass −95% стоимость — vendor claim | decagon.ai 22.06.2025 (fetched); Reuters 23.06.2025 |
| DigitalGenius | E-commerce-специализация: WISMO, авто-оформление возврата в чате, order updates, warranty по фото; «resolutions, not deflections» | On −93% wait time; air up «600% ROI»; AllSaints −backlog/AHT — vendor claim | digitalgenius.com 10.2026 (fetched) |
| Zowie | Агент + детерминированный rule engine: возвраты/claims/identity «determined by your policies — not by what the model decides»; Supervisor-скоринг + Traces | 100 млн разговоров/год routed and resolved — vendor claim; клиенты InPost, Decathlon, Avon | getzowie.com 10.2026 (fetched) |
| Gradient Labs | Финтех (не e-comm): disputes/KYC; 20+ guardrails на каждый ход диалога; disputes эскалируются на human sign-off | 80–90% peak resolution rate; 98% CSAT — vendor claim | gradient-labs.ai 10.2026 (fetched) |
| Ada / Kustomer (кратко) | AI-агенты с AR-метрикой (Ada); routing 10 очередей/команду, SLA-менеджмент, Conversation Safeguards (Kustomer) | Ada «>80%» (vendor claim, цены не публикуются); Kustomer — цены не публикуются, оценки 3-х лиц расходятся | ada.cx; ada.cx blog 18.07.2025; kustomer.com/pricing 10.2026 |
| OSS-стек (референс полигона) | Chatwoot CE (очередь/инбоксы, AgentBot handoff `pending→open`) + LangGraph (агент, туториал с эскалацией, HITL `interrupt()`) + Langfuse (трейсинг/стоимость/evals) + n8n (клей) | Лицензии проверены по LICENSE-файлам: MIT-ядра, проприетарные каталоги `enterprise/`/`ee/` отделены; живые примеры склейки 03–09.2026 | GitHub API 30.10.2026; massivegrid.com 03.09.2026; DEV.to 13.03.2026 |

## Ключевые выводы

1. **Гибридность — норма конструкции, а не сбой.** У всех описанных систем агент —
   первый фильтр, человек — эскалация (Klarna: ~30% клиентов сразу требуют людей;
   Gradient Labs: споры в принципе уходят на human sign-off).
2. **Доли авто-решения публично наблюдаемы в ~2/3–80% чатов**, но это vendor claims
   со смещённой выборкой; зрелых внедрений ~10% (Intercom), Gartner прогнозирует
   отмену >40% agentic-проектов к 2027.
3. **Экономика перешла к outcome-based pricing** ($0.99/outcome Fin; $1.50–2.00
   AR Zendesk; $2/разговор + $0.10/action Agentforce), при этом определения
   «resolution» расходятся — сравнивать проценты между платформами некорректно.
4. **Сквозной паттерн 2025–2026: «естественный язык + детерминированный слой
   правил»** (Fin Procedures, Decagon AOPs, Sierra Ghostwriter, Zowie rule engine)
   — практический ответ специализации на выдачу несогласованных с политикой решений.
5. **Цена провала: юридический минимум мал, но закреплён.** $812,02 CAD (Air
   Canada) — прецедент ответственности за слова бота; главный ущерб — отток и
   репутация (Cursor, DPD, Chevrolet); триггер имеет нулевую стоимость (один
   промпт).
6. **Klarna — единственный кейс с SEC-первичками**: заявленная экономия не сходится
   с аудированной динамикой затрат; разворот 2025 показал, что cost-only
   оптимизация деградирует качество — при этом доля AI выросла до 80%.

## Числа для параметров полигона

Подборка (полный разбор, доверие к источникам и метод —
[prod-support-processes.md](prod-support-processes.md), разделы 2 и 6):

| Параметр | Вилка | Источник/дата |
| --- | --- | --- |
| Доля авто-resolve | ~20–70% сегодня; 80% к 2029 (прогноз Gartner) | Klarna 2024–2026; Fin 2024–2026; Comm100 2026; Gartner 05.03.2025 |
| Запросы человека сразу | ~30% легитимных клиентов | Klarna CEO, Sequoia podcast 2024 |
| `C_manual` (ручной контакт) | ~$5–15; чат ~$11,20; self-service $1,84 | Gartner 01.02.2024; Kayako 02.2026; Comm100+BLS |
| Очередь | 2–4 параллельных чата; ~84 чата/день; occupancy 60–85% | Kayako/LiveChat 2024–2026; Call Centre Helper |
| SLA/FRT | FRT чата ≤40–60 с (норматив), факт ~35 с; ASA 80% ≤20 с | Zendesk/Toister 01.2026; LiveChat; Kayako |
| `C_queue` (ожидание) | dropout 27,4% при ожидании 4:18 против цели <5%; >50% уходят после одного плохого опыта | LiveChat 2024; Kayako/Zendesk |
| `C_refuse` (отказ законному клиенту) | 67% не вернутся после негативного возврата; 76% выбирают по бесплатному возврату | NRF + Happy Returns 05.12.2024 (fetched) |
| `L_viol` (исполненное нарушение) | AOV ~$145 + обработка возврата ~21% стоимости заказа; юридические якоря $812,02 CAD и $193K (FTC) | Oberlo 11.2024; Pitney Bowes 04.2022; CRT 14.02.2024 (fetched); FTC 09.2024 |
| Масштаб домена | Возвраты 15,8–16,9% продаж, онлайн 19,3%; fraud 9–13,7% возвратов | NRF 2023–2025 |

## Чего нет (gaps)

Независимых цифр авто-resolve по e-commerce; публичного containment Amazon;
свежих независимых per-contact бенчмарков; судебных присуждений за неверный
возврат именно в e-commerce; типовых цен Ada/Kustomer. Полный список — раздел 8
основного дока.
