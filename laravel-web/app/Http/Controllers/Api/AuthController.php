<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserProgress;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

class AuthController extends Controller
{
    public function register(Request $request): JsonResponse
    {
        $request->merge([
            'email' => mb_strtolower(trim((string) $request->input('email', ''))),
            'username' => mb_strtolower(trim((string) $request->input('username', ''))),
            'name' => trim((string) $request->input('name', '')),
        ]);
        $validated = $request->validate([
            'name' => ['required', 'string', 'min:2', 'max:80'],
            'username' => ['required', 'alpha_dash', 'min:3', 'max:40', 'unique:users,username'],
            'email' => ['required', 'email', 'max:190', 'unique:users,email'],
            'password' => ['required', 'confirmed', Password::min(10)->mixedCase()->numbers()],
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'username' => $validated['username'],
            'email' => mb_strtolower($validated['email']),
            'password' => $validated['password'],
        ]);
        UserProgress::create(['user_id' => $user->id, 'data' => UserProgress::defaults()]);

        return response()->json([
            'message' => 'Account created.',
            'token' => $user->createToken('lingonexa-app')->plainTextToken,
            'user' => $this->userPayload($user),
        ], 201);
    }

    public function login(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'identifier' => ['required', 'string', 'max:190'],
            'password' => ['required', 'string', 'max:200'],
        ]);

        $identifier = mb_strtolower(trim($validated['identifier']));
        $user = User::query()
            ->whereRaw('LOWER(email) = ?', [$identifier])
            ->orWhereRaw('LOWER(username) = ?', [$identifier])
            ->first();

        if (! $user || ! Hash::check($validated['password'], $user->password)) {
            return response()->json(['message' => 'Incorrect username, email, or password.'], 422);
        }

        $user->tokens()->where('name', 'lingonexa-app')->delete();

        return response()->json([
            'message' => 'Signed in.',
            'token' => $user->createToken('lingonexa-app')->plainTextToken,
            'user' => $this->userPayload($user),
        ]);
    }

    public function me(Request $request): JsonResponse
    {
        return response()->json(['user' => $this->userPayload($request->user())]);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()?->currentAccessToken()?->delete();
        return response()->json(['message' => 'Signed out.']);
    }

    private function userPayload(User $user): array
    {
        return [
            'id' => (string) $user->id,
            'name' => $user->name,
            'displayName' => $user->name,
            'username' => $user->username,
            'email' => $user->email,
            'role' => $user->role,
            'provider' => $user->provider,
        ];
    }
}
