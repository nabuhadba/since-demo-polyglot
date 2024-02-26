<?php

declare(strict_types=1);

namespace App\Services;

use GuzzleHttp\ClientInterface;
use GuzzleHttp\Exception\GuzzleException;
use RuntimeException;

/** Drafts the cover email for an invoice. A person reviews every draft before it is sent. */
final class InvoiceMailer
{
    /** @param array{key: string, model: string, base_uri: string} $openai */
    public function __construct(private readonly ClientInterface $http, private readonly array $openai)
    {
    }

    public function draft(string $customer, string $invoiceNumber, string $total): string
    {
        try {
            $response = $this->http->request('POST', 'chat/completions', [
                'base_uri' => $this->openai['base_uri'],
                'headers' => ['Authorization' => 'Bearer ' . $this->openai['key']],
                'json' => [
                    'model' => $this->openai['model'],
                    'temperature' => 0.3,
                    'max_tokens' => 400,
                    'messages' => [
                        ['role' => 'system', 'content' => 'You write short, polite invoice emails for a freight company.'],
                        ['role' => 'user', 'content' => "Customer: {$customer}\nInvoice: {$invoiceNumber}\nTotal due: {$total}"],
                    ],
                ],
            ]);
        } catch (GuzzleException $e) {
            throw new RuntimeException('draft request failed: ' . $e->getMessage(), 0, $e);
        }

        $body = json_decode((string) $response->getBody(), true, 512, JSON_THROW_ON_ERROR);

        return trim($body['choices'][0]['message']['content'] ?? '');
    }
}
