<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Services\InvoiceTotals;
use InvalidArgumentException;
use PHPUnit\Framework\TestCase;

final class InvoiceTotalsTest extends TestCase
{
    public function testAddsTaxRoundedHalfUp(): void
    {
        $totals = (new InvoiceTotals())->compute([
            ['description' => 'Pallet', 'quantity' => 3, 'unit_cents' => 18500],
            ['description' => 'Liftgate', 'quantity' => 1, 'unit_cents' => 4500],
        ], 8.25);

        $this->assertSame(['subtotal' => 60000, 'tax' => 4950, 'total' => 64950], $totals);
    }

    public function testRejectsEmptyLines(): void
    {
        $this->expectException(InvalidArgumentException::class);
        (new InvoiceTotals())->compute([['description' => 'Nothing', 'quantity' => 0, 'unit_cents' => 100]], 5.0);
    }
}
