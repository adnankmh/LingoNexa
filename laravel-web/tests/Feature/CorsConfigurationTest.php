<?php

namespace Tests\Feature;

use Tests\TestCase;

class CorsConfigurationTest extends TestCase
{
    public function test_default_cors_origins_are_explicit_and_do_not_use_a_wildcard(): void
    {
        $origins = config('cors.allowed_origins');

        $this->assertSame(
            ['http://localhost', 'http://127.0.0.1'],
            $origins,
        );
        $this->assertNotContains('*', $origins);
    }

    public function test_cors_credentials_remain_disabled_by_default(): void
    {
        $this->assertFalse(config('cors.supports_credentials'));
    }
}
