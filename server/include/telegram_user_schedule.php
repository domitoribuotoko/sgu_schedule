<?php

declare(strict_types=1);

require_once __DIR__ . '/server_config.php';

/**
 * Валидация Telegram.WebApp.initData и хранение привязки расписания по user.id.
 *
 * Токен бота: только include/config.local.php, ключ telegram_bot_token (см. config.local.example.php).
 */
final class TelegramUserSchedule
{
    private const BINDINGS_FILE = 'telegram_schedule_bindings.json';

    /** Максимальный возраст initData (секунды). */
    private const AUTH_MAX_AGE = 86400;

    public static function botToken(): string
    {
        $local = __DIR__ . '/config.local.php';
        if (!is_readable($local)) {
            return '';
        }
        /** @var array<string, mixed> $cfg */
        $cfg = require $local;

        return trim((string) ($cfg['telegram_bot_token'] ?? ''));
    }

    public static function bindingsPath(): string
    {
        return dirname(__DIR__) . '/data/' . self::BINDINGS_FILE;
    }

    /**
     * Диагностика без PHP error_log: в data/telegram_debug.log при telegram_debug_enabled в config.json.
     *
     * @param array<string, mixed> $context
     */
    private static function telegramDebug(string $event, array $context = []): void
    {
        if (!ServerConfig::telegramDebugEnabled()) {
            return;
        }
        $path = dirname(__DIR__) . '/data/telegram_debug.log';
        $row = json_encode(
            array_merge(['ts' => gmdate('c'), 'event' => $event], $context),
            JSON_UNESCAPED_UNICODE,
        );
        if ($row === false) {
            return;
        }
        @file_put_contents($path, $row . "\n", FILE_APPEND | LOCK_EX);
    }

    /**
     * Безопасный контекст для telegram_debug при невалидном initData (без PII).
     *
     * @param array<string, mixed> $extra
     * @return array<string, mixed>
     */
    private static function invalidInitDebugContext(string $initData, string $reason, array $extra = []): array
    {
        $pairs = self::parseInitDataPairs(trim($initData));
        $keys = array_keys($pairs);
        sort($keys, SORT_STRING);

        return array_merge(
            [
                'reason' => $reason,
                'init_data_length' => strlen(trim($initData)),
                'init_keys' => $keys,
            ],
            $extra,
        );
    }

    /**
     * @param array{ok: false, reason: string, auth_date?: int, server_unix?: int} $failed
     */
    private static function telegramDebugInvalidInit(string $event, string $initData, array $failed): void
    {
        $extra = [];
        if (($failed['reason'] ?? '') === 'auth_too_old') {
            $extra['auth_date'] = $failed['auth_date'] ?? 0;
            $extra['server_unix'] = $failed['server_unix'] ?? time();
        }
        $token = self::botToken();
        $extra['bot_token'] = $token;
        $extra['bot_token_length'] = strlen($token);
        self::telegramDebug($event, self::invalidInitDebugContext($initData, $failed['reason'], $extra));
    }

    /**
     * Детальная причина отказа (для telegram_debug); успех — для обычной работы API.
     *
     * reason при ошибке: empty | no_bot_token | no_hash | hash_mismatch | auth_too_old |
     * user_missing | user_bad_json | user_id_invalid
     *
     * @return (
     *   array{ok: true, user_id: int, pairs: array<string, string>}
     *   |array{ok: false, reason: string, auth_date?: int, server_unix?: int}
     * )
     */
    public static function validateInitDataWithReason(string $initData): array
    {
        $initData = trim($initData);
        if ($initData === '') {
            return ['ok' => false, 'reason' => 'empty'];
        }
        $botToken = self::botToken();
        if ($botToken === '') {
            return ['ok' => false, 'reason' => 'no_bot_token'];
        }

        $pairs = self::parseInitDataPairs($initData);
        $receivedHash = $pairs['hash'] ?? '';
        if ($receivedHash === '') {
            return ['ok' => false, 'reason' => 'no_hash'];
        }

        $keys = array_keys($pairs);
        sort($keys, SORT_STRING);
        $lines = [];
        foreach ($keys as $k) {
            // Только hash исключаем (см. core.telegram.org/bots/webapps + tma init-data validating).
            // Поле signature NEW участвует в цепочке для HMAC; отдельно его проверяет путь third-party (Ed25519).
            if ($k === 'hash') {
                continue;
            }
            $lines[] = $k . '=' . $pairs[$k];
        }
        $dataCheckString = implode("\n", $lines);

        $secretKey = hash_hmac('sha256', $botToken, 'WebAppData', true);
        $calculated = hash_hmac('sha256', $dataCheckString, $secretKey, false);
        if (!hash_equals($calculated, $receivedHash)) {
            return ['ok' => false, 'reason' => 'hash_mismatch'];
        }

        $authDate = isset($pairs['auth_date']) ? (int) $pairs['auth_date'] : 0;
        $serverUnix = time();
        if ($authDate > 0 && ($serverUnix - $authDate) > self::AUTH_MAX_AGE) {
            return [
                'ok' => false,
                'reason' => 'auth_too_old',
                'auth_date' => $authDate,
                'server_unix' => $serverUnix,
            ];
        }

        $userJson = $pairs['user'] ?? '';
        if ($userJson === '') {
            return ['ok' => false, 'reason' => 'user_missing'];
        }
        $user = json_decode($userJson, true);
        if (!is_array($user) || !isset($user['id'])) {
            return ['ok' => false, 'reason' => 'user_bad_json'];
        }
        $userId = (int) $user['id'];
        if ($userId <= 0) {
            return ['ok' => false, 'reason' => 'user_id_invalid'];
        }

        return ['ok' => true, 'user_id' => $userId, 'pairs' => $pairs];
    }

    /**
     * @return array{user_id: int, pairs: array<string, string>}|null
     */
    public static function validateInitData(string $initData): ?array
    {
        $r = self::validateInitDataWithReason($initData);
        if (($r['ok'] ?? false) !== true) {
            return null;
        }

        return ['user_id' => $r['user_id'], 'pairs' => $r['pairs']];
    }

    /**
     * @return array<string, string>
     */
    private static function parseInitDataPairs(string $initData): array
    {
        $out = [];
        foreach (explode('&', $initData) as $part) {
            if ($part === '') {
                continue;
            }
            $eq = strpos($part, '=');
            if ($eq === false) {
                continue;
            }
            $k = rawurldecode(str_replace('+', '%2B', substr($part, 0, $eq)));
            $v = rawurldecode(str_replace('+', '%20', substr($part, $eq + 1)));
            $out[$k] = $v;
        }

        return $out;
    }

    /**
     * @return array<string, mixed>|null
     */
    public static function loadSelection(int $userId): ?array
    {
        $path = self::bindingsPath();
        if (!is_readable($path)) {
            return null;
        }
        $raw = file_get_contents($path);
        if ($raw === false || $raw === '') {
            return null;
        }
        $all = json_decode($raw, true);
        if (!is_array($all)) {
            return null;
        }
        $key = (string) $userId;
        if (!isset($all[$key]) || !is_array($all[$key])) {
            return null;
        }

        return $all[$key];
    }

    /**
     * @param array<string, mixed> $selection
     */
    public static function saveSelection(int $userId, array $selection): bool
    {
        $path = self::bindingsPath();
        $dir = dirname($path);
        if (!is_dir($dir)) {
            self::telegramDebug('save_missing_data_dir', ['dir' => $dir]);

            return false;
        }
        if (file_exists($path) && !is_writable($path)) {
            self::telegramDebug('save_file_not_writable', ['path' => $path]);

            return false;
        }
        if (!file_exists($path) && !is_writable($dir)) {
            self::telegramDebug('save_dir_not_writable', ['dir' => $dir]);

            return false;
        }
        $all = [];
        if (is_readable($path)) {
            $raw = file_get_contents($path);
            if ($raw !== false && $raw !== '') {
                $decoded = json_decode($raw, true);
                if (is_array($decoded)) {
                    $all = $decoded;
                }
            }
        }
        $all[(string) $userId] = $selection;
        $json = json_encode($all, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
        if ($json === false) {
            self::telegramDebug('save_json_encode_failed', ['user_id' => $userId]);

            return false;
        }
        $written = file_put_contents($path, $json, LOCK_EX);
        if ($written === false) {
            self::telegramDebug('save_file_put_failed', ['path' => $path, 'user_id' => $userId]);

            return false;
        }
        self::telegramDebug('save_ok', ['path' => $path, 'user_id' => $userId, 'bytes' => $written]);

        return true;
    }

    public static function handleQuery(): void
    {
        header('Content-Type: application/json; charset=utf-8');
        if (self::botToken() === '') {
            http_response_code(503);
            echo json_encode(['error' => 'Telegram bot token is not configured'], JSON_UNESCAPED_UNICODE);
            return;
        }
        $body = self::readJsonBody();
        $initData = (string) ($body['initData'] ?? '');
        $vr = self::validateInitDataWithReason($initData);
        if (($vr['ok'] ?? false) !== true) {
            /** @var array{ok: false, reason: string, auth_date?: int, server_unix?: int} $vr */
            self::telegramDebugInvalidInit('query_invalid_init', $initData, $vr);
            http_response_code(401);
            echo json_encode(['error' => 'Invalid or expired initData'], JSON_UNESCAPED_UNICODE);
            return;
        }
        /** @var array{ok: true, user_id: int, pairs: array<string, string>} $vr */
        $v = ['user_id' => $vr['user_id'], 'pairs' => $vr['pairs']];
        $saved = self::loadSelection($v['user_id']);
        if ($saved === null || $saved === []) {
            self::telegramDebug('query_no_saved', ['user_id' => $v['user_id']]);
            echo json_encode(['hasSaved' => false], JSON_UNESCAPED_UNICODE);
            return;
        }
        self::telegramDebug('query_has_saved', ['user_id' => $v['user_id']]);
        echo json_encode(
            [
                'hasSaved' => true,
                'selection' => $saved,
            ],
            JSON_UNESCAPED_UNICODE,
        );
    }

    public static function handleSave(): void
    {
        header('Content-Type: application/json; charset=utf-8');
        if (self::botToken() === '') {
            http_response_code(503);
            echo json_encode(['error' => 'Telegram bot token is not configured'], JSON_UNESCAPED_UNICODE);
            return;
        }
        $body = self::readJsonBody();
        $initData = (string) ($body['initData'] ?? '');
        $vr = self::validateInitDataWithReason($initData);
        if (($vr['ok'] ?? false) !== true) {
            /** @var array{ok: false, reason: string, auth_date?: int, server_unix?: int} $vr */
            self::telegramDebugInvalidInit('save_invalid_init', $initData, $vr);
            http_response_code(401);
            echo json_encode(['error' => 'Invalid or expired initData'], JSON_UNESCAPED_UNICODE);
            return;
        }
        /** @var array{ok: true, user_id: int, pairs: array<string, string>} $vr */
        $v = ['user_id' => $vr['user_id'], 'pairs' => $vr['pairs']];
        $sel = $body['selection'] ?? null;
        if (!is_array($sel)) {
            self::telegramDebug('save_missing_selection', ['user_id' => $v['user_id']]);
            http_response_code(400);
            echo json_encode(['error' => 'selection object required'], JSON_UNESCAPED_UNICODE);
            return;
        }
        $normalized = self::normalizeSelection($sel);
        if ($normalized === null) {
            self::telegramDebug('save_bad_selection', ['user_id' => $v['user_id']]);
            http_response_code(400);
            echo json_encode(['error' => 'invalid selection fields'], JSON_UNESCAPED_UNICODE);
            return;
        }
        if (!self::saveSelection($v['user_id'], $normalized)) {
            self::telegramDebug('save_persist_failed', ['user_id' => $v['user_id']]);
            http_response_code(500);
            echo json_encode(['error' => 'Could not persist selection'], JSON_UNESCAPED_UNICODE);
            return;
        }
        echo json_encode(['ok' => true], JSON_UNESCAPED_UNICODE);
    }

    /**
     * @param array<string, mixed> $sel
     * @return array<string, string>|null
     */
    private static function normalizeSelection(array $sel): ?array
    {
        $path = trim((string) ($sel['path'] ?? ''));
        if ($path === '') {
            return null;
        }
        if ($path[0] !== '/') {
            $path = '/' . $path;
        }

        return [
            'facultyId' => (string) ($sel['facultyId'] ?? ''),
            'formId' => (string) ($sel['formId'] ?? ''),
            'groupId' => (string) ($sel['groupId'] ?? ''),
            'groupName' => (string) ($sel['groupName'] ?? ''),
            'path' => $path,
            'fragment' => (string) ($sel['fragment'] ?? ''),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private static function readJsonBody(): array
    {
        $raw = (string) file_get_contents('php://input');
        if ($raw === '') {
            return [];
        }
        $j = json_decode($raw, true);

        return is_array($j) ? $j : [];
    }
}
