<?php
namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserProgress;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;
use Illuminate\View\View;

class AuthController extends Controller
{
    public function loginForm(): View { return view('auth.login'); }
    public function registerForm(): View { return view('auth.register'); }

    public function login(Request $request): RedirectResponse
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
            return back()->withErrors(['identifier' => 'Incorrect username, email, or password.'])->onlyInput('identifier');
        }

        Auth::login($user, $request->boolean('remember'));
        $request->session()->regenerate();
        return redirect()->intended(route('app.dashboard'));
    }

    public function register(Request $request): RedirectResponse
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
        Auth::login($user);
        $request->session()->regenerate();
        return redirect()->route('app.dashboard');
    }

    public function logout(Request $request): RedirectResponse
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return redirect()->route('login');
    }
}
