<?php

use App\Http\Controllers\InvoiceController;

return [
    ['GET', '/invoices/{number}', [InvoiceController::class, 'show']],
];
