<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Services\InvoiceMailer;
use GuzzleHttp\Client;
use GuzzleHttp\Handler\MockHandler;
use GuzzleHttp\HandlerStack;
use GuzzleHttp\Middleware;
use GuzzleHttp\Psr7\Response;
use PHPUnit\Framework\TestCase;

final class InvoiceMailerTest extends TestCase
{
    public function testSendsTheConfiguredModelAndReturnsTheDraft(): void
    {
        $history = [];
        $stack = HandlerStack::create(new MockHandler([
            new Response(200, [], json_encode(['choices' => [['message' => ['content' => "  Hello Acme,\nyour invoice is attached.  "]]]])),
        ]));
        $stack->push(Middleware::history($history));
        $config = require __DIR__ . '/../../config/services.php';

        $draft = (new InvoiceMailer(new Client(['handler' => $stack]), ['key' => 'test-key'] + $config['openai']))
            ->draft('Acme', 'INV-1', 'USD 10.80');

        $this->assertSame("Hello Acme,\nyour invoice is attached.", $draft);
        $sent = json_decode((string) $history[0]['request']->getBody(), true);
        $this->assertSame('gpt-3.5-turbo', $sent['model']);
        $this->assertSame('https://api.openai.com/v1/chat/completions', (string) $history[0]['request']->getUri());
    }
}
