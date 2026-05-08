<?php

declare(strict_types=1);

/**
 * Читает только server/config.json (сервер файл не изменяет).
 */
final class ServerConfig
{
    private static ?array $cached = null;

    /**
     * @return array{logging_enabled: bool, telegram_debug_enabled: bool}
     */
    public static function all(): array
    {
        if (self::$cached !== null) {
            return self::$cached;
        }
        $file = dirname(__DIR__) . '/config.json';
        if (!is_readable($file)) {
            self::$cached = [
                'logging_enabled' => false,
                'telegram_debug_enabled' => false,
            ];

            return self::$cached;
        }
        $json = json_decode((string) file_get_contents($file), true);
        if (!is_array($json)) {
            self::$cached = [
                'logging_enabled' => false,
                'telegram_debug_enabled' => false,
            ];

            return self::$cached;
        }
        self::$cached = [
            'logging_enabled' => !empty($json['logging_enabled']),
            'telegram_debug_enabled' => !empty($json['telegram_debug_enabled']),
        ];

        return self::$cached;
    }

    public static function loggingEnabled(): bool
    {
        return self::all()['logging_enabled'];
    }

    /** Запись в data/telegram_debug.log (без system error_log). */
    public static function telegramDebugEnabled(): bool
    {
        return self::all()['telegram_debug_enabled'];
    }
}
