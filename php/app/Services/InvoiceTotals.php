<?php

declare(strict_types=1);

namespace App\Services;

use App\Support\Money;
use InvalidArgumentException;

final class InvoiceTotals
{
    /**
     * @param list<array{description: string, quantity: int, unit_cents: int}> $lines
     * @return array{subtotal: int, tax: int, total: int}
     */
    public function compute(array $lines, float $taxPercent): array
    {
        if ($taxPercent < 0 || $taxPercent > 30) {
            throw new InvalidArgumentException("tax rate {$taxPercent} is out of range");
        }

        $subtotal = 0;
        foreach ($lines as $line) {
            if ($line['quantity'] < 1) {
                throw new InvalidArgumentException("line \"{$line['description']}\" has no quantity");
            }
            $subtotal += $line['quantity'] * $line['unit_cents'];
        }

        $tax = Money::percentOf($subtotal, $taxPercent);

        return ['subtotal' => $subtotal, 'tax' => $tax, 'total' => $subtotal + $tax];
    }
}
