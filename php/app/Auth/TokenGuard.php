<?php

declare(strict_types=1);

namespace App\Auth;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Throwable;

/** Checks the bearer tokens the customer portal sends. */
final class TokenGuard
{
    public function __construct(private readonly string $secret)
    {
    }

    /** @return array{sub: string, scope: list<string>}|null */
    public function user(?string $authorization): ?array
    {
        if ($authorization === null || !str_starts_with($authorization, 'Bearer ')) {
            return null;
        }

        try {
            $claims = JWT::decode(substr($authorization, 7), new Key($this->secret, 'HS256'));
        } catch (Throwable) {
            return null;
        }

        return ['sub' => (string) $claims->sub, 'scope' => explode(' ', (string) ($claims->scope ?? ''))];
    }

    public function issue(string $subject, array $scopes, int $ttl = 3600): string
    {
        $now = time();

        return JWT::encode(['sub' => $subject, 'scope' => implode(' ', $scopes), 'iat' => $now, 'exp' => $now + $ttl], $this->secret, 'HS256');
    }
}
