@extends('layouts.auth')
@section('title','Sign in')
@section('content')
<h1 style="margin:0 0 6px">Welcome back</h1><p class="muted">Continue your language journey and synchronized progress.</p>
<form method="post" action="{{ route('login') }}" style="margin-top:20px">@csrf
<div class="field"><label>Username or email</label><input class="input" name="identifier" value="{{ old('identifier') }}" autocomplete="username" required></div>
<div class="field"><label>Password</label><input class="input" type="password" name="password" autocomplete="current-password" required></div>
<label style="display:flex;gap:8px;align-items:center;margin:10px 0 16px"><input type="checkbox" name="remember" value="1"> Keep me signed in</label>
<button class="btn" style="width:100%">Sign in</button></form><p class="muted" style="text-align:center;margin-top:16px">New to LingoNexa? <a style="color:var(--primary);font-weight:850" href="{{ route('register') }}">Create an account</a></p>
@endsection
