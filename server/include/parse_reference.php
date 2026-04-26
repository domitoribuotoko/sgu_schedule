<?php

declare(strict_types=1);

/**
 * Парсинг https://www.sgu.ru/schedule — факультеты, формы, группы по ссылкам /schedule/{fac}/{form}/{num}.
 */
final class ParseReference
{
    private const INDEX_URL = 'https://www.sgu.ru/schedule';

    /** @var array<string, string> */
    private const FORM_LABELS = [
        'do' => 'Очная',
        'vo' => 'Очно-заочная',
        'oz' => 'Заочная',
        'z' => 'Заочная',
    ];

    public static function indexHtml(): string
    {
        return SguHtmlCache::get(self::INDEX_URL);
    }

    /** @return list<array{id:string,name:string,kind?:string}> */
    public static function faculties(string $html): array
    {
        if ($html === '') {
            return [];
        }
        $map = self::mapFacultySlugToName($html);
        if ($map === []) {
            $map = self::fallbackFacultiesFromLinks($html);
        }
        $out = [];
        foreach ($map as $id => $name) {
            $out[] = ['id' => $id, 'name' => $name];
        }
        usort($out, static fn (array $a, array $b): int => strcmp($a['id'], $b['id']));
        return $out;
    }

    /**
     * h3.accordion__header + первый /schedule/SLUG/ внутри следующего контента.
     *
     * @return array<string, string> slug => name
     */
    private static function mapFacultySlugToName(string $html): array
    {
        $result = [];
        if (!class_exists('DOMDocument')) {
            return [];
        }
        $enc = '<?xml encoding="UTF-8">';
        $doc = new DOMDocument();
        @$doc->loadHTML($enc . $html, LIBXML_NOERROR | LIBXML_NOWARNING);
        $xp = new DOMXPath($doc);
        /** @var DOMNodeList $headers */
        $headers = $xp->query("//h3[contains(concat(' ', normalize-space(@class), ' '), ' accordion__header ')]");
        if ($headers === false) {
            return [];
        }
        foreach ($headers as $h) {
            $name = trim($h->textContent ?? '');
            if ($name === '') {
                continue;
            }
            $wrap = $h->parentNode;
            $content = $wrap?->nextSibling;
            while ($content !== null
                && (!($content instanceof DOMElement) || !str_contains(' ' . $content->getAttribute('class') . ' ', ' accordion__content '))) {
                $content = $content->nextSibling;
            }
            $slug = null;
            if ($content instanceof DOMElement) {
                $sub = $xp->query(
                    ".//a[starts-with(@href, '/schedule/') and not(contains(@href, '/schedule/teacher/'))]",
                    $content
                );
                if ($sub !== false) {
                    foreach ($sub as $a) {
                        if ($a instanceof DOMElement) {
                            $href = (string) $a->getAttribute('href');
                            if (preg_match('#^/schedule/([a-z0-9_-]+)/[a-z0-9]+/#', $href, $m)) {
                                $slug = $m[1];
                                break;
                            }
                        }
                    }
                }
            }
            if ($slug !== null) {
                if (!isset($result[$slug]) || $result[$slug] === '') {
                    $result[$slug] = $name;
                }
            }
        }
        return $result;
    }

    /**
     * @return array<string, string> slug => name
     */
    private static function fallbackFacultiesFromLinks(string $html): array
    {
        if (!preg_match_all('#/schedule/([a-z0-9_-]+)/[a-z0-9]+/[0-9a-z]+#', $html, $m)) {
            return [];
        }
        $slugs = array_unique($m[1]);
        $out = [];
        foreach ($slugs as $s) {
            $out[$s] = $s;
        }
        return $out;
    }

    /**
     * @return list<array{id:string,name:string}>
     */
    public static function studyForms(string $html, string $facultyId): array
    {
        if ($html === '' || $facultyId === '') {
            return [];
        }
        $re = '#href="/schedule/' . preg_quote($facultyId, '#') . '/([a-z0-9_]+)/[0-9a-z]+"#';
        if (!preg_match_all($re, $html, $m)) {
            return [];
        }
        $ids = array_unique($m[1]);
        $out = [];
        foreach ($ids as $id) {
            $name = self::FORM_LABELS[$id] ?? ucfirst($id);
            $out[] = ['id' => $id, 'name' => $name];
        }
        return $out;
    }

    /**
     * @return list<array{id:string,name:string,schedulePath:string}>
     */
    public static function groups(string $html, string $facultyId, string $formId): array
    {
        if ($html === '' || $facultyId === '' || $formId === '') {
            return [];
        }
        $re = '#href="(/schedule/' . preg_quote($facultyId, '#') . '/' . preg_quote($formId, '#') . '/([^"]+))"#u';
        if (!preg_match_all($re, $html, $m, PREG_SET_ORDER)) {
            return [];
        }
        $out = [];
        $seen = [];
        foreach ($m as $row) {
            $path = $row[1];
            $gnum = rawurldecode(trim($row[2]));
            if (isset($seen[$path])) {
                continue;
            }
            $seen[$path] = true;
            $name = trim($gnum);
            $id = 'g_' . $facultyId . '_' . $formId . '_' . $name;
            $out[] = [
                'id' => $id,
                'name' => $name,
                'schedulePath' => $path,
            ];
        }
        return $out;
    }
}
