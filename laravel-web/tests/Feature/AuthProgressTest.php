<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthProgressTest extends TestCase
{
    use RefreshDatabase;

    public function test_mobile_account_can_register_and_sync_progress(): void
    {
        $register = $this->postJson('/api/v1/auth/register', [
            'name' => 'Lingo Learner',
            'username' => 'lingo_learner',
            'email' => 'learner@example.test',
            'password' => 'StrongPass2026',
            'password_confirmation' => 'StrongPass2026',
        ])->assertCreated()->assertJsonStructure(['token', 'user']);

        $token = $register->json('token');
        $headers = ['Authorization' => 'Bearer '.$token];
        $this->withHeaders($headers)->putJson('/api/v1/progress', [
            'progress' => [
                'targetLanguageCode' => 'tr', 'currentLevel' => 'A2',
                'xp' => 420, 'streak' => 6, 'dailyMinutes' => 18,
                'dailyGoalMinutes' => 20, 'countryCode' => 'PS',
                'completedLessonIds' => ['tr_A1_0_0'],
            ],
        ])->assertOk()->assertJsonPath('progress.xp', 420);

        $this->withHeaders($headers)->getJson('/api/v1/progress')
            ->assertOk()->assertJsonPath('progress.targetLanguageCode', 'tr');
    }

    public function test_registration_requires_a_strong_password(): void
    {
        $this->postJson('/api/v1/auth/register', [
            'name' => 'Weak User', 'username' => 'weak_user',
            'email' => 'weak@example.test', 'password' => '123456',
            'password_confirmation' => '123456',
        ])->assertUnprocessable();
    }

    public function test_progress_validation_rejects_invalid_types_and_partial_updates_preserve_existing_data(): void
    {
        $register = $this->postJson('/api/v1/auth/register', [
            'name' => 'Sync User', 'username' => 'sync_user',
            'email' => 'sync@example.test', 'password' => 'StrongPass2026',
            'password_confirmation' => 'StrongPass2026',
        ])->assertCreated();
        $headers = ['Authorization' => 'Bearer '.$register->json('token')];

        $this->withHeaders($headers)->putJson('/api/v1/progress', [
            'progress' => ['xp' => 700, 'themeId' => 'aurora', 'interfaceLocale' => 'ar'],
        ])->assertOk()->assertJsonPath('progress.themeId', 'aurora');

        $this->withHeaders($headers)->putJson('/api/v1/progress', [
            'progress' => ['dailyGoalMinutes' => 25],
        ])->assertOk()->assertJsonPath('progress.xp', 700)
            ->assertJsonPath('progress.interfaceLocale', 'ar');

        $this->withHeaders($headers)->putJson('/api/v1/progress', [
            'progress' => ['xp' => -5, 'themeId' => 'unknown-theme'],
        ])->assertUnprocessable();
    }

    public function test_progress_sync_rejects_unknown_fields_without_mutating_existing_progress(): void
    {
        $register = $this->postJson('/api/v1/auth/register', [
            'name' => 'Strict Sync User', 'username' => 'strict_sync_user',
            'email' => 'strict-sync@example.test', 'password' => 'StrongPass2026',
            'password_confirmation' => 'StrongPass2026',
        ])->assertCreated();
        $headers = ['Authorization' => 'Bearer '.$register->json('token')];

        $this->withHeaders($headers)->putJson('/api/v1/progress', [
            'progress' => ['xp' => 900, 'currentLevel' => 'B1'],
        ])->assertOk();

        $this->withHeaders($headers)->putJson('/api/v1/progress', [
            'progress' => ['xp' => 1200, 'isAdmin' => true],
        ])->assertUnprocessable()->assertJsonValidationErrors(['progress']);

        $this->withHeaders($headers)->getJson('/api/v1/progress')
            ->assertOk()
            ->assertJsonPath('progress.xp', 900)
            ->assertJsonPath('progress.currentLevel', 'B1');
    }
}
