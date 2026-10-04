<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TargetLanguageValidationTest extends TestCase
{
    use RefreshDatabase;

    public function test_progress_sync_accepts_catalog_languages_and_rejects_unknown_language_codes(): void
    {
        $register = $this->postJson('/api/v1/auth/register', [
            'name' => 'Language Sync User',
            'username' => 'language_sync_user',
            'email' => 'language-sync@example.test',
            'password' => 'StrongPass2026',
            'password_confirmation' => 'StrongPass2026',
        ])->assertCreated();
        $headers = ['Authorization' => 'Bearer '.$register->json('token')];

        foreach (['ar', 'tr', 'fil', 'kn'] as $languageCode) {
            $this->withHeaders($headers)->putJson('/api/v1/progress', [
                'progress' => ['targetLanguageCode' => $languageCode],
            ])->assertOk()->assertJsonPath('progress.targetLanguageCode', $languageCode);
        }

        $this->withHeaders($headers)->putJson('/api/v1/progress', [
            'progress' => ['targetLanguageCode' => 'zz'],
        ])->assertUnprocessable()->assertJsonValidationErrors([
            'progress.targetLanguageCode',
        ]);
    }
}
