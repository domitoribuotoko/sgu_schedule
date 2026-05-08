<?php

declare(strict_types=1);

/**
 * Одна строка JSON на запрос. Тело POST не читается — иначе опустошится php://input
 * для обработчиков Telegram.
 */
final class RequestAccessLogger
{
    public static function logIncoming(string $method, string $path): void
    {
        if (!ServerConfig::loggingEnabled()) {
            return;
        }
        $root = dirname(__DIR__);
        $dir = $root . '/logs';
        if (!is_dir($dir)) {
            if (!@mkdir($dir, 0755, true) && !is_dir($dir)) {
                error_log('RequestAccessLogger: cannot create directory ' . $dir);

                return;
            }
        }
        $file = $dir . '/access.log';
        $query = $_GET !== [] ? http_build_query($_GET) : '';
        $line = json_encode(
            [
                'ts' => gmdate('c'),
                'method' => $method,
                'path' => $path,
                'query' => $query,
                'content_length' => (string) ($_SERVER['CONTENT_LENGTH'] ?? ''),
                'ip' => (string) ($_SERVER['REMOTE_ADDR'] ?? ''),
                'x_forwarded_for' => (string) ($_SERVER['HTTP_X_FORWARDED_FOR'] ?? ''),
                'user_agent' => (string) ($_SERVER['HTTP_USER_AGENT'] ?? ''),
            ],
            JSON_UNESCAPED_UNICODE,
        );
        if ($line === false) {
            return;
        }
        @file_put_contents($file, $line . "\n", FILE_APPEND | LOCK_EX);
    }
}
