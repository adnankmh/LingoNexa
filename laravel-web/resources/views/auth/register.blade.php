@extends('layouts.auth')
@section('title','Create account')
@section('content')
<h1 style="margin:0 0 6px">Create your account</h1><p class="muted">Your learning profile will be available on the website and connected Flutter app.</p>
<form method="post" action="{{ route('register') }}" style="margin-top:20px">@csrf
<div class="field"><label>Display name</label><input class="input" name="name" value="{{ old('name') }}" autocomplete="name" required></div>
<div class="field"><label>Username</label><input class="input" name="username" value="{{ old('username') }}" autocomplete="username" required></div>
<div class="field"><label>Email</label><input class="input" type="email" name="email" value="{{ old('email') }}" autocomplete="email" required></div>
<div class="field"><label>Password</label><input class="input" type="password" name="password" autocomplete="new-password" required></div>
<div class="field"><label>Confirm password</label><input class="input" type="password" name="password_confirmation" autocomplete="new-password" required></div>
<p class="muted" style="font-size:12px">Use 10+ characters with upper/lowercase letters and a number.</p><button class="btn" style="width:100%">Create account</button></form><p class="muted" style="text-align:center;margin-top:16px">Already registered? <a style="color:var(--primary);font-weight:850" href="{{ route('login') }}">Sign in</a></p>
@endsection
