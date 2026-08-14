@extends('layouts.app')
@section('title','Specialized Paths · LingoNexa')
@section('content')
<div class="hero"><span class="pill">🧭 Goal-based learning</span><h1>Specialized Paths</h1><p>Move beyond generic vocabulary and organize learning around the situations where you actually need the language.</p></div>
<div class="section-title"><h2>Choose a practical track</h2><p>These tracks reuse the same account language and can grow into dedicated lesson packs.</p></div><div class="grid">@foreach($paths as $path)<div class="card"><div class="emoji">{{ $path['icon'] }}</div><h3>{{ $path['title'] }}</h3><p class="muted">{{ $path['detail'] }}</p><a class="btn secondary" href="{{ route('app.learn') }}">Open learning path</a></div>@endforeach</div>
@endsection
