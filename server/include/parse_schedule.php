<?php

declare(strict_types=1);

/**
 * Парсинг страницы группы: таблица #schedule, колонки = дни недели.
 */
final class ParseSchedule
{
    /**
     * @return array{
     *   view: string,
     *   sourcePath: string,
     *   weeks: list<array{title: string, days: list<array{dateLabel: string, slots: list<array{time: string, title: string, room: string}>}>}>,
     *   session: array{
     *     title: string,
     *     updatedAt: string,
     *     items: list<array{
     *       dateTime: string,
     *       form: string,
     *       discipline: string,
     *       teacher: string,
     *       place: string
     *     }>
     *   }
     * }
     */
    public static function content(string $html, string $path, string $view): array
    {
        $view = in_array($view, ['all', 'lection', 'session'], true) ? $view : 'all';
        if ($html === '') {
            return self::emptyPayload($path, $view);
        }
        if (!class_exists('DOMDocument')) {
            return self::emptyPayload($path, $view);
        }
        $enc = '<?xml encoding="UTF-8">';
        $doc = new DOMDocument();
        @$doc->loadHTML($enc . $html, LIBXML_NOERROR | LIBXML_NOWARNING);
        $xp = new DOMXPath($doc);
        $sessionData = self::parseSession($xp);

        $weekTitle = 'Расписание';
        $h = $xp->query("//h1[contains(@class,'title')] | //h1 | //h2[1]");
        if ($h !== false && $h->length > 0) {
            $t = trim($h->item(0)?->textContent ?? '');
            if ($t !== '') {
                $weekTitle = $t;
            }
        }

        $table = $xp->query("//table[@id='schedule' or contains(concat(' ', normalize-space(@class), ' '), ' schedule-table__wrapper ')]");
        if ($table === false || $table->length === 0) {
            $payload = self::emptyPayload($path, $view);
            $payload['session'] = $sessionData;
            return $payload;
        }
        /** @var DOMElement $tableEl */
        $tableEl = $table->item(0);
        if (!($tableEl instanceof DOMElement)) {
            $payload = self::emptyPayload($path, $view);
            $payload['session'] = $sessionData;
            return $payload;
        }

        $dayLabels = self::readDayHeaders($xp, $tableEl);
        if ($dayLabels === []) {
            $payload = self::emptyPayload($path, $view);
            $payload['session'] = $sessionData;
            return $payload;
        }

        $n = count($dayLabels);
        /** @var list<list<array{time: string, title: string, room: string}>> $perDay */
        $perDay = array_fill(0, $n, []);

        $rows = $xp->query('.//tbody/tr', $tableEl);
        if ($rows === false) {
            $payload = self::emptyPayload($path, $view);
            $payload['session'] = $sessionData;
            return $payload;
        }

        for ($r = 0; $r < $rows->length; $r++) {
            $tr = $rows->item($r);
            if (!($tr instanceof DOMElement)) {
                continue;
            }
            $tds = $xp->query('./td', $tr);
            if ($tds === false || $tds->length === 0) {
                continue;
            }
            $time = self::timeFromRowTh($xp, $tr);
            $tdCount = $tds->length;
            $maxJ = min($n, $tdCount);
            for ($j = 0; $j < $maxJ; $j++) {
                $td = $tds->item($j);
                if (!($td instanceof DOMElement)) {
                    continue;
                }
                $lessons = $xp->query(
                    ".//div[contains(concat(' ', normalize-space(@class), ' '), ' schedule-table__lesson ')]",
                    $td
                );
                if ($lessons === false) {
                    continue;
                }
                for ($k = 0; $k < $lessons->length; $k++) {
                    $node = $lessons->item($k);
                    if (!($node instanceof DOMElement)) {
                        continue;
                    }
                    if ($view === 'lection' && !self::nodeHasLectureType($node)) {
                        continue;
                    }
                    if ($view === 'session' && self::nodeHasLectureType($node)) {
                        continue;
                    }
                    $title = self::textOfRel($node, ".//*[contains(@class,'schedule-table__lesson-name')]");
                    if ($title === '') {
                        continue;
                    }
                    $room = self::textOfRel($node, ".//*[contains(@class,'schedule-table__lesson-room')]");
                    $room = trim(preg_replace('/\s+/', ' ', $room) ?? $room);
                    $perDay[$j][] = [
                        'time' => $time,
                        'title' => trim(preg_replace('/\s+/', ' ', $title) ?? $title),
                        'room' => $room,
                    ];
                }
            }
        }

        $total = 0;
        foreach ($perDay as $slots) {
            $total += count($slots);
        }
        if ($total === 0) {
            $payload = self::emptyPayload($path, $view);
            $payload['session'] = $sessionData;
            return $payload;
        }

        $days = [];
        for ($i = 0; $i < $n; $i++) {
            $days[] = [
                'dateLabel' => $dayLabels[$i],
                'slots' => $perDay[$i],
            ];
        }

        return [
            'view' => $view,
            'sourcePath' => $path,
            'weeks' => [
                [
                    'title' => $weekTitle,
                    'days' => $days,
                ],
            ],
            'session' => $sessionData,
        ];
    }

    /**
     * @return array{
     *   title: string,
     *   updatedAt: string,
     *   items: list<array{dateTime: string, form: string, discipline: string, teacher: string, place: string}>
     * }
     */
    private static function parseSession(DOMXPath $xp): array
    {
        $title = '';
        $updatedAt = '';
        /** @var list<array{dateTime: string, form: string, discipline: string, teacher: string, place: string}> $items */
        $items = [];

        $wrapNodes = $xp->query("//div[contains(concat(' ', normalize-space(@class), ' '), ' schedule__wrap-session ')]");
        if ($wrapNodes === false || $wrapNodes->length === 0) {
            return ['title' => $title, 'updatedAt' => $updatedAt, 'items' => $items];
        }

        /** @var DOMElement $wrap */
        $wrap = $wrapNodes->item(0);
        if (!($wrap instanceof DOMElement)) {
            return ['title' => $title, 'updatedAt' => $updatedAt, 'items' => $items];
        }

        $title = self::firstTextOfRel(
            $xp,
            $wrap,
            ".//*[contains(concat(' ', normalize-space(@class), ' '), ' title__wrap_info ')]"
        );
        $updatedAt = self::firstTextOfRel(
            $xp,
            $wrap,
            ".//*[contains(concat(' ', normalize-space(@class), ' '), ' title__wrap_description ')]"
        );

        $rows = $xp->query('.//table//tbody/tr', $wrap);
        if ($rows === false) {
            return ['title' => $title, 'updatedAt' => $updatedAt, 'items' => $items];
        }

        for ($i = 0; $i < $rows->length; $i++) {
            $row = $rows->item($i);
            if (!($row instanceof DOMElement)) {
                continue;
            }
            $cells = $xp->query('./td', $row);
            if ($cells === false || $cells->length < 4) {
                continue;
            }
            $dateTime = self::normalizeText((string) $cells->item(0)?->textContent);
            $metaCell = $cells->item(1);
            $form = '';
            $discipline = '';
            if ($metaCell instanceof DOMElement) {
                $form = self::firstTextOfRel(
                    $xp,
                    $metaCell,
                    ".//*[contains(concat(' ', normalize-space(@class), ' '), ' schedule-form ')]"
                );
                $discipline = self::firstTextOfRel(
                    $xp,
                    $metaCell,
                    ".//*[contains(concat(' ', normalize-space(@class), ' '), ' schedule-discipline ')]"
                );
                if ($discipline === '') {
                    $discipline = self::normalizeText((string) $metaCell->textContent);
                }
            }
            $teacher = self::normalizeText((string) $cells->item(2)?->textContent);
            $place = self::normalizeText((string) $cells->item(3)?->textContent);
            if ($dateTime === '' && $discipline === '') {
                continue;
            }
            $items[] = [
                'dateTime' => $dateTime,
                'form' => $form,
                'discipline' => $discipline,
                'teacher' => $teacher,
                'place' => $place,
            ];
        }

        return ['title' => $title, 'updatedAt' => $updatedAt, 'items' => $items];
    }

    /**
     * @return list<string>
     */
    private static function readDayHeaders(DOMXPath $xp, DOMElement $table): array
    {
        $theads = $xp->query('./thead', $table);
        if ($theads === false || $theads->length === 0) {
            return [];
        }
        /** @var DOMElement $thead */
        $thead = $theads->item(0);
        if (!($thead instanceof DOMElement)) {
            return [];
        }
        $firstTrs = $xp->query('./tr[1]', $thead);
        if ($firstTrs === false || $firstTrs->length === 0) {
            return [];
        }
        $tr = $firstTrs->item(0);
        if (!($tr instanceof DOMElement)) {
            return [];
        }
        $ths = $xp->query('./th', $tr);
        if ($ths === false) {
            return [];
        }
        $labels = [];
        for ($i = 0; $i < $ths->length; $i++) {
            if ($i === 0) {
                continue;
            }
            $th = $ths->item($i);
            if (!($th instanceof DOMElement)) {
                continue;
            }
            $t = self::textOfRel($th, ".//*[contains(concat(' ', normalize-space(@class), ' '), ' schedule-table__header ')]");
            if ($t === '') {
                $t = trim(preg_replace('/\s+/', ' ', (string) $th->textContent) ?? '');
            }
            if ($t === '') {
                $labels[] = 'День ' . $i;
            } else {
                $labels[] = $t;
            }
        }

        return $labels;
    }

    private static function timeFromRowTh(DOMXPath $xp, DOMElement $tr): string
    {
        $thFirst = $xp->query('./th[1]', $tr);
        if ($thFirst === false || $thFirst->length === 0) {
            return '';
        }
        $th = $thFirst->item(0);
        if (!($th instanceof DOMElement)) {
            return '';
        }
        $t = self::textOfRel($th, ".//*[contains(concat(' ', normalize-space(@class), ' '), ' schedule-table__header ')]");
        if ($t === '') {
            $t = trim(preg_replace('/\s+/', ' ', (string) $th->textContent) ?? '');
        }

        return $t;
    }

    private static function nodeHasLectureType(DOMElement $lesson): bool
    {
        $html = $lesson->ownerDocument?->saveHTML($lesson) ?? '';
        return str_contains($html, 'lesson-prop__lecture') || str_contains($html, 'ЛЕКЦ');
    }

    private static function textOfRel(DOMElement $node, string $q): string
    {
        $doc = $node->ownerDocument;
        if ($doc === null) {
            return '';
        }
        $xp = new DOMXPath($doc);
        $m = $xp->query($q, $node);
        if ($m === false || $m->length === 0) {
            return '';
        }
        return trim($m->item(0)?->textContent ?? '');
    }

    private static function firstTextOfRel(DOMXPath $xp, DOMElement $node, string $q): string
    {
        $m = $xp->query($q, $node);
        if ($m === false || $m->length === 0) {
            return '';
        }
        return self::normalizeText((string) $m->item(0)?->textContent);
    }

    private static function normalizeText(string $text): string
    {
        return trim(preg_replace('/\s+/', ' ', $text) ?? $text);
    }

    private static function emptyPayload(string $path, string $view): array
    {
        return [
            'view' => $view,
            'sourcePath' => $path,
            'weeks' => [],
            'session' => [
                'title' => '',
                'updatedAt' => '',
                'items' => [],
            ],
        ];
    }
}
