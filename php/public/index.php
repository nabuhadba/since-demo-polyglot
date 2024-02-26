<?php

declare(strict_types=1);

require __DIR__ . '/../vendor/autoload.php';

use App\Auth\TokenGuard;
use App\Http\Controllers\InvoiceController;
use App\Services\InvoiceRenderer;
use App\Services\InvoiceTotals;

Dotenv\Dotenv::createImmutable(dirname(__DIR__))->safeLoad();
$config = require __DIR__ . '/../config/services.php';

$controller = new InvoiceController(
    new TokenGuard($config['jwt']['secret']),
    new InvoiceTotals(),
    new InvoiceRenderer(__DIR__ . '/../resources/templates'),
);

// The invoice store moved to the ledger API; until that client lands this serves the sample.
$invoice = json_decode(file_get_contents(__DIR__ . '/../resources/sample-invoice.json'), true);
[$status, $body] = $controller->show($_SERVER['HTTP_AUTHORIZATION'] ?? null, $invoice);

http_response_code($status);
echo $body;
