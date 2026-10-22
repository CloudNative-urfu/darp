# DARP — Defense, Attack Research Platform

Исследовательский полигон для ИИ-агентов в кибербезопасности: изолированная gym-подобная среда,
атакующая сторона (Kali Linux) и защитная сторона (open-source мониторинг), переключаемые LLM.
Текущее направление — оценка применимости существующих гвардрейлов в бизнес-процессе чатового
агента: полигон с конфигурациями гвардрейлов и атакующей стороной, которая взаимодействует с
защищаемым агентом только через текстовый канал.

## Документация

- Текущее направление исследования: `docs/guardrails-business-value.md`
- Исходная карточка проекта (история): `docs/description.md`
- Как работать (для команды): `CONTRIBUTING.md`
- Правила для ИИ-агентов: `AGENTS.md`
- Спеки (OpenSpec): `openspec/`

## Ветки и доска

- `develop` — интеграционная ветка (default), спеки и PR с кодом.
- `main` — релизная ветка, только через PR из `develop`.
- Доска: https://github.com/orgs/CloudNative-urfu/projects/1

## Быстрый старт

```bash
npm install -g @fission-ai/openspec@1.14.2  # OpenSpec (точная версия)
export PATH="$HOME/.npm-global/bin:$PATH"   # если команда не в PATH
pre-commit install --hook-type commit-msg   # локальная проверка коммитов
openspec view                               # дашборд спек
```
