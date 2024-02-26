<?php

declare(strict_types=1);

namespace App\Services;

use App\Support\Money;
use League\CommonMark\CommonMarkConverter;

/** Turns an invoice into the HTML the PDF service prints. Notes are customer-written Markdown. */
final class InvoiceRenderer
{
    private CommonMarkConverter $markdown;

    public function __construct(private readonly string $templateDir)
    {
        $this->markdown = new CommonMarkConverter([
            'html_input' => 'escape',
            'allow_unsafe_links' => false,
        ]);
    }

    /**
     * @param array{number: string, customer: string, notes: string} $invoice
     * @param array{subtotal: int, tax: int, total: int} $totals
     */
    public function render(array $invoice, array $totals): string
    {
        $template = file_get_contents($this->templateDir . '/invoice.html');
        $notes = (string) $this->markdown->convert($invoice['notes']);

        return strtr($template, [
            '{{number}}' => htmlspecialchars($invoice['number']),
            '{{customer}}' => htmlspecialchars($invoice['customer']),
            '{{subtotal}}' => Money::format($totals['subtotal']),
            '{{tax}}' => Money::format($totals['tax']),
            '{{total}}' => Money::format($totals['total']),
            '{{notes}}' => $notes,
        ]);
    }
}
