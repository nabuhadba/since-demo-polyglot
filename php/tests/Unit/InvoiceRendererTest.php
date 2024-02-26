<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Services\InvoiceRenderer;
use PHPUnit\Framework\TestCase;

final class InvoiceRendererTest extends TestCase
{
    public function testRendersNotesAsEscapedMarkdown(): void
    {
        $html = (new InvoiceRenderer(__DIR__ . '/../../resources/templates'))->render(
            ['number' => 'INV-1', 'customer' => 'Acme <Freight>', 'notes' => "**Net 30** <script>alert(1)</script>"],
            ['subtotal' => 1000, 'tax' => 80, 'total' => 1080],
        );

        $this->assertStringContainsString('<strong>Net 30</strong>', $html);
        $this->assertStringContainsString('Acme &lt;Freight&gt;', $html);
        $this->assertStringNotContainsString('<script>', $html);
        $this->assertStringContainsString('USD 10.80', $html);
    }
}
