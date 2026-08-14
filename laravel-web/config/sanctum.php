<?php
return [
    'stateful' => array_filter(array_map('trim', explode(',', env('SANCTUM_STATEFUL_DOMAINS', 'localhost,localhost:8000,127.0.0.1,127.0.0.1:8000,::1')))),
    'guard' => ['web'],
    'expiration' => (int) env('SANCTUM_TOKEN_EXPIRATION', 43200),
    'token_prefix' => env('SANCTUM_TOKEN_PREFIX', ''),
    'middleware' => [
        'authenticate_session' => Laravel\Sanctum\Http\Middleware\AuthenticateSession::class,
        'encrypt_cookies' => Illuminate\Cookie\Middleware\EncryptCookies::class,
        'validate_csrf_token' => Illuminate\Foundation\Http\Middleware\ValidateCsrfToken::class,
    ],
];
