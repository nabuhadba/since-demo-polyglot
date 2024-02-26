<?php

declare(strict_types=1);

namespace App\Support;

/** Amounts are integer cents; formatting happens only at the edges. */
final class Money
{
    public static function format(int $cents, string $currency = 'USD'): string
    {
        $sign = $cents < 0 ? '-' : '';
        $cents = abs($cents);

        return sprintf('%s%s %d.%02d', $sign, $currency, intdiv($cents, 100), $cents % 100);
    }

    /** Rounds half up, the way the old billing system did. */
    public static function percentOf(int $cents, float $percent): int
    {
        return (int) round($cents * $percent / 100, 0, PHP_ROUND_HALF_UP);
    }
}
