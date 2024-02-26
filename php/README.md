# invoices

Customer invoices for the portal: totals, the HTML the PDF service prints, and draft cover emails.
Laid out like our Laravel apps (`app/`, `config/`, `routes/`, `public/`) without the framework.

    composer install
    vendor/bin/phpunit

Production runs the `Dockerfile` image (PHP-FPM behind the portal's nginx).
