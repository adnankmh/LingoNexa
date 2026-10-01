<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Password;

class AdminAccountController extends Controller
{
    public function update(Request $request): JsonResponse
    {
        $user = $request->user();
        abort_unless($user && $user->role === 'administrator', 403);

        $validated = $request->validate([
            'name' => ['required', 'string', 'min:2', 'max:100'],
            'email' => ['required', 'email:rfc', 'max:254', Rule::unique('users', 'email')->ignore($user->id)],
            'current_password' => ['required', 'string', 'current_password'],
            'password' => ['nullable', 'confirmed', Password::min(12)->letters()->mixedCase()->numbers()->symbols()->uncompromised()],
        ]);

        $user->name = trim($validated['name']);
        $user->email = strtolower(trim($validated['email']));

        if (! empty($validated['password'])) {
            $user->password = Hash::make($validated['password']);
            $user->tokens()->where('id', '!=', $user->currentAccessToken()?->id)->delete();
        }

        $user->save();

        return response()->json([
            'message' => 'Administrator account updated.',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
            ],
        ]);
    }
}
