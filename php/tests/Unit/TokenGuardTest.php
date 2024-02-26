<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Auth\TokenGuard;
use PHPUnit\Framework\TestCase;

final class TokenGuardTest extends TestCase
{
    private const SECRET = 'test-secret-not-used-anywhere-else-0123456789';

    public function testReadsATokenItIssued(): void
    {
        $guard = new TokenGuard(self::SECRET);
        $token = $guard->issue('customer-17', ['invoices:read']);

        $this->assertSame(['sub' => 'customer-17', 'scope' => ['invoices:read']], $guard->user('Bearer ' . $token));
    }

    public function testRejectsATokenSignedWithAnotherKey(): void
    {
        $token = (new TokenGuard('another-secret-0123456789-0123456789'))->issue('customer-17', ['invoices:read']);

        $this->assertNull((new TokenGuard(self::SECRET))->user('Bearer ' . $token));
    }

    public function testRejectsAMissingHeader(): void
    {
        $this->assertNull((new TokenGuard(self::SECRET))->user(null));
    }
}
