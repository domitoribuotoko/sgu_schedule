<?php

declare(strict_types=1);

/**
 * Кэш HTML на диске ~60 с (ключ = URL), для shared FPM.
 */
final class SguHtmlCache
{
    private const TTL_SEC = 60;

    public static function get(string $url): string
    {
        $path = self::cacheFilePath($url);
        if (is_readable($path)) {
            $raw = @file_get_contents($path);
            if ($raw !== false) {
                $data = json_decode($raw, true);
                if (is_array($data) && isset($data['t'], $data['html'])
                    && (time() - (int) $data['t']) < self::TTL_SEC) {
                    return (string) $data['html'];
                }
            }
        }
        $html = self::fetchUrl($url);
        $dir = dirname($path);
        if (!is_dir($dir)) {
            @mkdir($dir, 0775, true);
        }
        @file_put_contents($path, json_encode(['t' => time(), 'html' => $html], JSON_UNESCAPED_UNICODE));
        return $html;
    }

    private static function cacheFilePath(string $url): string
    {
        $dir = rtrim(sys_get_temp_dir(), DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . 'sgu_schedule_php_cache';
        return $dir . DIRECTORY_SEPARATOR . sha1($url) . '.json';
    }

    private static function fetchUrl(string $url): string
    {
        if (function_exists('curl_init')) {
            $ch = curl_init($url);
            curl_setopt_array($ch, [
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_TIMEOUT => 30,
                CURLOPT_SSL_VERIFYPEER => true,
                CURLOPT_HTTPHEADER => [
                    'User-Agent: Mozilla/5.0 (compatible; SguScheduleParser/1.0; +https://www.sgu.ru)',
                    'Accept: text/html,application/xhtml+xml',
                ],
            ]);
            $body = curl_exec($ch);
            $code = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
            curl_close($ch);
            if ($body === false || $code >= 400) {
                return '';
            }
            return (string) $body;
        }
        $ctx = stream_context_create([
            'http' => [
                'timeout' => 30,
                'header' => "User-Agent: Mozilla/5.0 (compatible; SguScheduleParser/1.0)\r\n",
            ],
            'ssl' => [
                'verify_peer' => true,
            ],
        ]);
        $body = @file_get_contents($url, false, $ctx);
        return $body === false ? '' : (string) $body;
    }
}
