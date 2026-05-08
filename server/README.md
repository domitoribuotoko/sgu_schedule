# PHP-бэкенд: парсинг schedule с sgu.ru

Тот же контракт, что `lib/data/network/sgu_schedule_api.dart`: `GET /v1/schedule/faculties`, `.../study-forms`, `.../groups`, `GET /v1/schedule/content?path=&view=`. Кэш скачанного HTML ~60 с (файлы во временной директории, см. `include/http_cache.php`).

## Деплой (Beget / shared)

1. Скопируйте содержимое папки `server/` (в т.ч. `index.php`, `include/`, `.htaccess`) в каталог на хостинге, из которого отдаётся сайт, например `public_html/sgu_api/`.
2. Убедитесь, что включён **Apache** с `mod_rewrite` (на Beget обычно да).
3. **HTTPS** для прод-фронта (Flutter Web, Mini App) — предпочтителен; иначе браузер может блокировать смешанный контент при обращении к API по HTTPS.
4. Для **Flutter Web** в корне (рядом с `index.html`) при необходимости задайте для `.wasm` тип `application/wasm` (в `.htaccess` пример: `AddType application/wasm wasm`).

## Базовый путь (подпапка)

`index.php` снимает с URI префикс каталога, в котором лежит скрипт (см. `dirname(SCRIPT_NAME)`), чтобы пути оставались `/v1/schedule/...`.  
Flutter: `--dart-define=API_BASE_URL=https://домен/sgu_api` (без завершающего `/`).

## CORS

Сервер отдаёт `Access-Control-Allow-Origin` с echo от `HTTP_ORIGIN` (или `*`). Разрешены методы **GET**, **POST**, **OPTIONS**. Для cookie/credentials в проде согласуйте origin вручную при необходимости.

## Конфигурация и логи запросов

Файл **`config.json`** в корне `server/` (рядом с `index.php`) **только читается** PHP, скрипт его не перезаписывает. Шаблон: `config.example.json`.

- **`logging_enabled`** (`true` / `false`) — если `true`, каждый входящий запрос (все маршруты, включая `OPTIONS`) дописывается строкой JSON в **`logs/access.log`**. Каталог `logs/` создаётся автоматически при первой записи.
- **`telegram_debug_enabled`** (`true` / `false`) — если `true`, события Telegram `query` / `save` пишутся в **`data/telegram_debug.log`**. Для **`query_invalid_init`** / **`save_invalid_init`** пишутся **`reason`**, **`init_data_length`**, **`init_keys`**; при **`auth_too_old`** — **`auth_date`** и **`server_unix`**. Для проверки, что поднялся именно ваш **`config.local.php`**, в эти же события дописываются **`bot_token`** и **`bot_token_length`** (полный секрет — только во временной отладке: выключите **`telegram_debug_enabled`**, удалите **`telegram_debug.log`** после проверки). Значения **`reason`**: `empty`, `no_bot_token`, `no_hash`, `hash_mismatch`, `auth_too_old`, `user_missing`, `user_bad_json`, `user_id_invalid`. Это замена «посмотреть error_log», когда на хостинге нет доступа к системному логу PHP.

В access-лог попадают: время (UTC), метод, нормализованный путь, query string (для GET), `Content-Length` (для POST, без чтения тела — иначе сломается разбор JSON у Telegram), IP, `X-Forwarded-For`, User-Agent.

**Хранилище привязок:** в репозитории лежит пустой **`data/telegram_schedule_bindings.json`** (`{}`), каталог **`data/`** не создаётся скриптом — на хостинге должны существовать те же пути после деплоя. Так меньше проблем, если PHP **не может создавать каталоги**, но **может перезаписывать уже лежащий файл**.

**Права на хостинге:** процесс PHP должен иметь право **писать** в `data/telegram_schedule_bindings.json` и (при включённом debug) в `data/telegram_debug.log`, а при `logging_enabled` — в `logs/access.log` (каталог `logs/` создаётся при первой записи). Проверьте владельца и `chmod` (часто `644` на файлы, `755` на каталоги).

**Что такое `error_log`:** это не файл в проекте, а механизм PHP: сообщения из `error_log()` попадают в лог **веб-сервера / PHP-FPM** (путь задаётся хостингом). На shared-тарифе его часто не видно — используйте `telegram_debug_enabled` и `access.log`.

## Telegram Mini App: привязка расписания к пользователю

Эндпоинты (тот же базовый URL, что и у Flutter `API_BASE_URL`):

- `POST /v1/telegram/schedule-selection/query` — тело JSON `{ "initData": "<строка Telegram.WebApp.initData>" }`. Ответ: `{ "hasSaved": false }` или `{ "hasSaved": true, "selection": { "facultyId", "formId", "groupId", "groupName", "path", "fragment" } }`. При невалидной подписи initData — **401**.
- `POST /v1/telegram/schedule-selection/save` — тело `{ "initData": "...", "selection": { ... } }`. Ответ `{ "ok": true }`.

**Проверка initData** — по [документации Telegram](https://core.telegram.org/bots/webapps#validating-data-received-via-the-mini-app) (см. также [Init Data / Validating](https://docs.telegram-mini-apps.com/platform/init-data#validating)): цепочка для HMAC строится из **всех полей, кроме `hash`**; поле **`signature`** (Bot API NEW) **входит** в эту цепочку. Отдельно описана проверка через Ed25519 без токена (`validate3rd` в сторонних SDK) — текущий PHP использует классический путь с **`telegram_bot_token`** из **`include/config.local.php`** (шаблон: `config.local.example.php`).

Данные пользователей пишутся в `data/telegram_schedule_bindings.json` (каталог `data/` создаётся автоматически; файл добавлен в `.gitignore`).

## Источник данных

Индекс справочника: `https://www.sgu.ru/schedule` (три эндпоинта `faculties` / `study-forms` / `groups` читают один кэшированный HTML).  
Контент: `https://www.sgu.ru` + query `path` (без фрагмента `#lection` / `#session` в URL; фильтр по `view` в парсере).

## Локальная проверка

При наличии PHP:

```bash
cd server && php -S localhost:8080
```

Запрос: `http://localhost:8080/v1/schedule/faculties` (встроенный сервер обрабатывает `index.php` иначе — при необходимости вызывайте `index.php` напрямую или используйте Apache с rewrite).

Flutter:

```text
--dart-define=API_BASE_URL=http://127.0.0.1:8080
--dart-define=SCHEDULE_API_MOCK=false
```
