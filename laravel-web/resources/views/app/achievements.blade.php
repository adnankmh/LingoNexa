@extends('layouts.app')
@section('title','Achievements · LingoNexa')
@section('content')
<div class="hero"><span class="pill">🏆 Progress that belongs to your account</span><h1>Achievements</h1><p>Milestones are calculated from the same XP, streak, lesson and assessment data synchronized with the Flutter app.</p><div class="pills"><span class="pill">⭐ {{ $progress['xp'] ?? 0 }} XP</span><span class="pill">🔥 {{ $progress['streak'] ?? 1 }} streak</span></div></div>
<div class="section-title"><h2>Your milestones</h2><p>Completed achievements remain visible as your learning record grows.</p></div><div class="grid">@foreach($achievements as $achievement)<div class="card" style="opacity:{{ $achievement['done'] ? '1' : '.58' }}"><div class="emoji">{{ $achievement['icon'] }}</div><h3>{{ $achievement['title'] }} @if($achievement['done']) ✓ @endif</h3><p class="muted">{{ $achievement['detail'] }}</p><div class="pill" style="display:inline-block;background:{{ $achievement['done'] ? '#e8fff7' : '#f0f2f8' }};color:{{ $achievement['done'] ? '#087963' : '#69718a' }}">{{ $achievement['done'] ? 'Unlocked' : 'In progress' }}</div></div>@endforeach</div>
@endsection
