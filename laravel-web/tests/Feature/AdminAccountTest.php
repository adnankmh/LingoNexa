<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AdminAccountTest extends TestCase
{
    use RefreshDatabase;

    private function user(string $role = 'administrator'): User
    {
        return User::query()->create([
            'name' => 'Admin User',
            'username' => 'admin-'.uniqid(),
            'email' => uniqid().'@example.test',
            'password' => Hash::make('CurrentPassword!42'),
            'role' => $role,
            'provider' => 'password',
        ]);
    }

    public function test_non_administrator_cannot_update_admin_account(): void
    {
        $user = $this->user('learner');
        Sanctum::actingAs($user);

        $this->putJson('/api/v1/admin/account', [
            'name' => 'Learner',
            'email' => $user->email,
            'current_password' => 'CurrentPassword!42',
        ])->assertForbidden();
    }

    public function test_administrator_must_confirm_current_password(): void
    {
        $admin = $this->user();
        Sanctum::actingAs($admin);

        $this->putJson('/api/v1/admin/account', [
            'name' => 'Updated Admin',
            'email' => 'updated@example.test',
            'current_password' => 'WrongPassword!42',
        ])->assertUnprocessable()
            ->assertJsonValidationErrors('current_password');

        $this->assertSame('Admin User', $admin->fresh()->name);
    }

    public function test_administrator_can_update_name_and_email_with_valid_password(): void
    {
        $admin = $this->user();
        Sanctum::actingAs($admin);

        $this->putJson('/api/v1/admin/account', [
            'name' => '  Updated Admin  ',
            'email' => 'UPDATED@example.test',
            'current_password' => 'CurrentPassword!42',
        ])->assertOk()
            ->assertJsonPath('user.name', 'Updated Admin')
            ->assertJsonPath('user.email', 'updated@example.test')
            ->assertJsonPath('user.role', 'administrator');

        $admin->refresh();
        $this->assertSame('Updated Admin', $admin->name);
        $this->assertSame('updated@example.test', $admin->email);
        $this->assertTrue(Hash::check('CurrentPassword!42', $admin->password));
    }
}
