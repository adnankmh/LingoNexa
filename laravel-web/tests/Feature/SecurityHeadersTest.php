<?php

namespace Tests\Feature;

use App\Http\Middleware\SecurityHeaders;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Tests\TestCase;

class SecurityHeadersTest extends TestCase
{
    public function test_middleware_adds_browser_security_headers(): void
    {
        $response = $this->runMiddleware(Request::create('http://localhost/security-check'));

        $this->assertSame('nosniff', $response->headers->get('X-Content-Type-Options'));
        $this->assertSame('DENY', $response->headers->get('X-Frame-Options'));
        $this->assertSame('none', $response->headers->get('X-Permitted-Cross-Domain-Policies'));
        $this->assertSame('same-origin', $response->headers->get('Cross-Origin-Opener-Policy'));
        $this->assertSame('strict-origin-when-cross-origin', $response->headers->get('Referrer-Policy'));
        $this->assertSame('camera=(), geolocation=(), payment=(), usb=()', $response->headers->get('Permissions-Policy'));

        $policy = (string) $response->headers->get('Content-Security-Policy');
        $this->assertStringContainsString("default-src 'self'", $policy);
        $this->assertStringContainsString("object-src 'none'", $policy);
        $this->assertStringContainsString("frame-ancestors 'none'", $policy);
        $this->assertStringContainsString("base-uri 'self'", $policy);
        $this->assertStringContainsString("form-action 'self'", $policy);
        $this->assertStringContainsString("manifest-src 'self'", $policy);
    }

    public function test_hsts_is_only_sent_for_secure_requests(): void
    {
        $httpResponse = $this->runMiddleware(Request::create('http://localhost/security-check'));
        $this->assertFalse($httpResponse->headers->has('Strict-Transport-Security'));

        $httpsResponse = $this->runMiddleware(Request::create('https://localhost/security-check'));
        $this->assertSame(
            'max-age=31536000; includeSubDomains',
            $httpsResponse->headers->get('Strict-Transport-Security')
        );
    }

    private function runMiddleware(Request $request): Response
    {
        return (new SecurityHeaders)->handle(
            $request,
            static fn (Request $request): Response => new Response('ok', 200),
        );
    }
}
