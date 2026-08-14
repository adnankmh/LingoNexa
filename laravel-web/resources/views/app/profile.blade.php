@extends('layouts.app')
@section('title','Profile · LingoNexa')
@section('content')
@php($selectedCountry = collect($countries)->firstWhere('code',$progress['countryCode'] ?? 'PS'))
<div class="hero"><span class="pill">👤 Synced learning identity</span><h1>{{ $user->name }}</h1><p>{{ $user->email }} · @{{ $user->username }} · {{ $selectedCountry['flag'] ?? '🌍' }} {{ $selectedCountry['name'] ?? 'Country' }}</p><div class="pills"><span class="pill">⭐ {{ $progress['xp'] ?? 0 }} XP</span><span class="pill">📘 {{ $progress['currentLevel'] ?? 'A1' }}</span><span class="pill">🔥 {{ $progress['streak'] ?? 1 }}</span></div></div>
<div class="section-title"><h2>Learning preferences</h2><p>These values are stored in your account progress record and are shared with the Flutter app.</p></div>
<form class="card" method="post" action="{{ route('app.profile.update') }}">@csrf
<div class="grid two">
<div class="field"><label>Learning language</label><select class="input" name="targetLanguageCode">@foreach($languages as $item)<option value="{{ $item['code'] }}" @selected($item['code']==($progress['targetLanguageCode'] ?? 'en'))>{{ $item['flag'] }} {{ $item['nativeName'] }} — {{ $item['name'] }}</option>@endforeach</select></div>
<div class="field"><label>Country / region</label><select class="input" name="countryCode">@foreach($countries as $country)<option value="{{ $country['code'] }}" @selected($country['code']==($progress['countryCode'] ?? 'PS'))>{{ $country['flag'] }} {{ $country['name'] }}</option>@endforeach</select></div>
<div class="field"><label>Interface language</label><select class="input" name="interfaceLocale">@foreach($uiLocales as $localeCode)<option value="{{ $localeCode }}" @selected($localeCode==($progress['interfaceLocale'] ?? $uiLocale))>{{ strtoupper($localeCode) }}</option>@endforeach</select></div>
<div class="field"><label>Visual theme</label><select class="input" name="themeId">@foreach(['snow'=>'Snow','royal'=>'Royal','emerald'=>'Emerald','ocean'=>'Ocean','sunset'=>'Sunset','rose'=>'Rose','midnight'=>'Midnight','cocoa'=>'Cocoa','aurora'=>'Aurora','lavender'=>'Lavender','desert'=>'Desert','graphite'=>'Graphite'] as $themeCode=>$themeName)<option value="{{ $themeCode }}" @selected($themeCode==($progress['themeId'] ?? 'snow'))>{{ $themeName }}</option>@endforeach</select></div>
<div class="field"><label>Daily goal (minutes)</label><input class="input" type="number" min="5" max="180" name="dailyGoalMinutes" value="{{ $progress['dailyGoalMinutes'] ?? 15 }}"></div>
<div class="field"><label>Learning goal</label><input class="input" name="learningReason" maxlength="80" value="{{ $progress['learningReason'] ?? 'Travel' }}"></div>
</div><button class="btn">Save & sync preferences</button></form>
<div class="section-title"><h2>Skill profile</h2><p>Current mastery snapshot.</p></div><div class="grid">@foreach(($progress['skillMastery'] ?? []) as $skill=>$value)<div class="card"><div class="metric">{{ (int)$value }}%</div><h3 style="text-transform:capitalize">{{ $skill }}</h3><div class="progress"><span style="width:{{ max(0,min(100,(int)$value)) }}%"></span></div></div>@endforeach</div>
<div class="section-title"><h2>Account</h2></div><div class="card"><p class="muted">Your website session and the mobile API account use the same Laravel user table. Mobile authentication uses Sanctum tokens; web authentication uses secure Laravel sessions.</p><form method="post" action="{{ route('logout') }}">@csrf<button class="btn ghost">Sign out</button></form></div>
@endsection
