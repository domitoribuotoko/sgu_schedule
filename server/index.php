<?php

declare(strict_types=1);

/**
 * JSON API, совпадающий с lib/data/network/sgu_schedule_api.dart.
 * Роутер: путь /v1/schedule/... и POST /v1/telegram/... (через .htaccess → этот файл).
 */

require __DIR__ . '/include/server_config.php';
require __DIR__ . '/include/request_access_logger.php';
require __DIR__ . '/include/http_cache.php';
require __DIR__ . '/include/parse_reference.php';
require __DIR__ . '/include/parse_schedule.php';
require __DIR__ . '/include/telegram_user_schedule.php';

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

$rawPath = (string) (parse_url($_SERVER['REQUEST_URI'] ?? '', PHP_URL_PATH) ?? '/');
$base = rtrim(str_replace('\\', '/', dirname((string) ($_SERVER['SCRIPT_NAME'] ?? '/'))), '/');
$path = $rawPath;
if ($base !== '' && $base !== '/' && str_starts_with($rawPath, $base)) {
    $path = (string) (substr($rawPath, strlen($base)) ?: '/');
}

RequestAccessLogger::logIncoming($method, $path);

$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
header('Access-Control-Allow-Origin: ' . ($origin !== '' ? $origin : '*'));
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Accept');
header('Access-Control-Allow-Credentials: true');
if ($method === 'OPTIONS') {
    http_response_code(204);
    exit;
}

$jsonHeader = static function (): void {
    header('Content-Type: application/json; charset=utf-8');
};

if ($method === 'POST') {
    if (preg_match('#/v1/telegram/schedule-selection/query/?$#', $path)) {
        TelegramUserSchedule::handleQuery();
        exit;
    }
    if (preg_match('#/v1/telegram/schedule-selection/save/?$#', $path)) {
        TelegramUserSchedule::handleSave();
        exit;
    }
    http_response_code(404);
    $jsonHeader();
    echo json_encode(['error' => 'Not found', 'path' => $path], JSON_UNESCAPED_UNICODE);
    exit;
}

if ($method !== 'GET') {
    http_response_code(405);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['error' => 'Method not allowed'], JSON_UNESCAPED_UNICODE);
    exit;
}

if (preg_match('#/v1/schedule/faculties/?$#', $path)) {
    $html = ParseReference::indexHtml();
    $items = ParseReference::faculties($html);
    $jsonHeader();
    echo json_encode(['items' => $items], JSON_UNESCAPED_UNICODE);
    exit;
}

if (preg_match('#/v1/schedule/faculties/([^/]+)/study-forms/?$#', $path, $m)) {
    $facultyId = $m[1];
    $html = ParseReference::indexHtml();
    $items = ParseReference::studyForms($html, $facultyId);
    $jsonHeader();
    echo json_encode(['items' => $items], JSON_UNESCAPED_UNICODE);
    exit;
}

if (preg_match('#/v1/schedule/faculties/([^/]+)/study-forms/([^/]+)/groups/?$#', $path, $m)) {
    $facultyId = $m[1];
    $formId = $m[2];
    $html = ParseReference::indexHtml();
    $items = ParseReference::groups($html, $facultyId, $formId);
    $jsonHeader();
    echo json_encode(['items' => $items], JSON_UNESCAPED_UNICODE);
    exit;
}

if (preg_match('#/v1/schedule/content/?$#', $path) || str_ends_with($path, 'schedule/content')) {
    $qPath = (string) ($_GET['path'] ?? '');
    $qView = (string) ($_GET['view'] ?? 'all');
    if ($qPath === '') {
        $jsonHeader();
        http_response_code(400);
        echo json_encode(
            ['error' => 'query parameter path is required', 'view' => 'all', 'sourcePath' => '', 'weeks' => []],
            JSON_UNESCAPED_UNICODE
        );
        exit;
    }
    if ($qPath[0] !== '/') {
        $qPath = '/' . $qPath;
    }
    $html = SguHtmlCache::get('https://www.sgu.ru' . $qPath);
    $data = ParseSchedule::content($html, $qPath, $qView);
    $jsonHeader();
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

http_response_code(404);
$jsonHeader();
echo json_encode(['error' => 'Not found', 'path' => $path], JSON_UNESCAPED_UNICODE);
