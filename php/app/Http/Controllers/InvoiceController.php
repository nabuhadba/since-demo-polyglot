<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Auth\TokenGuard;
use App\Services\InvoiceRenderer;
use App\Services\InvoiceTotals;

final class InvoiceController
{
    public function __construct(
        private readonly TokenGuard $guard,
        private readonly InvoiceTotals $totals,
        private readonly InvoiceRenderer $renderer,
    ) {
    }

    /** @return array{0: int, 1: string} status and body */
    public function show(?string $authorization, array $invoice): array
    {
        $user = $this->guard->user($authorization);
        if ($user === null || !in_array('invoices:read', $user['scope'], true)) {
            return [401, 'unauthorized'];
        }

        $totals = $this->totals->compute($invoice['lines'], $invoice['tax_percent']);

        return [200, $this->renderer->render($invoice, $totals)];
    }
}
