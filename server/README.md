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

Сервер отдаёт `Access-Control-Allow-Origin` с echo от `HTTP_ORIGIN` (или `*`). Для cookie/credentials в проде согласуйте origin вручную при необходимости.

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
