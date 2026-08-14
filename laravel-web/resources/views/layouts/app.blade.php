<!doctype html>
<html lang="{{ $uiLocale ?? 'en' }}" dir="{{ $direction ?? 'ltr' }}" data-theme="{{ $progress['themeId'] ?? 'snow' }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'LingoNexa')</title>
    <link rel="stylesheet" href="{{ asset('css/lingonexa.css') }}">
</head>
<body>
<div class="shell">
    <aside class="side"><div class="side-card"><a class="brand" href="{{ route('app.dashboard') }}">LN</a><nav class="nav">
        <a class="{{ request()->routeIs('app.dashboard') ? 'active' : '' }}" href="{{ route('app.dashboard') }}"><span class="ico">🏠</span>{{ $ui['home'] }}</a>
        <a class="{{ request()->routeIs('app.learn') ? 'active' : '' }}" href="{{ route('app.learn') }}"><span class="ico">🧭</span>{{ $ui['learn'] }}</a>
        <a class="{{ request()->routeIs('app.practice') ? 'active' : '' }}" href="{{ route('app.practice') }}"><span class="ico">⚡</span>{{ $ui['practice'] }}</a>
        <a class="{{ request()->routeIs('app.academy') || request()->routeIs('app.grammar*') || request()->routeIs('app.labs') ? 'active' : '' }}" href="{{ route('app.academy') }}"><span class="ico">🎓</span>{{ $ui['academy'] }}</a>
        <a class="{{ request()->routeIs('app.community') ? 'active' : '' }}" href="{{ route('app.community') }}"><span class="ico">👥</span>{{ $ui['community'] }}</a>
        <a class="{{ request()->routeIs('app.profile') ? 'active' : '' }}" href="{{ route('app.profile') }}"><span class="ico">👤</span>{{ $ui['profile'] }}</a>
    </nav></div></aside>
    <main class="main">
        <header class="topbar"><strong>LingoNexa</strong><span class="muted hide-mobile">{{ $ui['tagline'] }}</span><div class="grow"></div>
            <form method="get" action="{{ url()->current() }}" style="display:flex;gap:6px;align-items:center"><select class="input" name="ui" aria-label="{{ $ui['interface'] }}" style="padding:8px 31px 8px 10px;border-radius:999px;width:auto">@foreach($uiLocales as $localeCode)<option value="{{ $localeCode }}" @selected($localeCode===$uiLocale)>{{ strtoupper($localeCode) }}</option>@endforeach</select><button class="btn secondary" type="submit" aria-label="{{ $ui['interface'] }}" style="padding:8px 11px">↻</button></form>
            <div class="user-pill">{{ $language['flag'] ?? '🌍' }} {{ $user->name ?? auth()->user()->name }}</div>
        </header>
        <div class="page">@if(session('success'))<div class="success">{{ session('success') }}</div>@endif @if($errors->any())<div class="error">{{ $errors->first() }}</div>@endif @yield('content')</div>
    </main>
</div>
<nav class="bottom-nav"><a href="{{ route('app.learn') }}"><span class="ico">🧭</span>{{ $ui['learn'] }}</a><a href="{{ route('app.practice') }}"><span class="ico">⚡</span>{{ $ui['practice'] }}</a><a href="{{ route('app.academy') }}"><span class="ico">🎓</span>{{ $ui['academy'] }}</a><a href="{{ route('app.community') }}"><span class="ico">👥</span>{{ $ui['community'] }}</a><a href="{{ route('app.profile') }}"><span class="ico">👤</span>{{ $ui['profile'] }}</a></nav>
</body></html>
