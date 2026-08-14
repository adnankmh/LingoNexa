@extends('layouts.app')
@section('title','Learn · LingoNexa')
@section('content')
<div class="hero"><span class="pill">{{ $language['flag'] }} {{ $language['nativeName'] }}</span><h1>Your {{ $progress['currentLevel'] ?? 'A1' }} learning path</h1><p>Structured learning with practical topics, aligned language examples, listening, speaking and assessment.</p></div>
<div class="section-title"><h2>CEFR course books</h2><p>Move from beginner foundations to advanced precision.</p></div><div class="book-row">@foreach(['A1','A2','B1','B2','C1','C2'] as $level)<div class="book"><small>LINGONEXA BOOK</small><strong style="font-size:25px">{{ $level }}</strong><span style="font-size:11px;opacity:.8">15 units · 75 lessons</span></div>@endforeach</div>
<div class="section-title"><h2>Real-world tracks</h2><p>Learn language that transfers directly to everyday situations.</p></div><div class="grid"><div class="card"><div class="emoji">✈️</div><h3>Travel & airport</h3><p class="muted">Flights, transport, hotel, directions and problem solving.</p></div><div class="card"><div class="emoji">🩺</div><h3>Health & doctor</h3><p class="muted">Symptoms, pharmacy, appointments and emergencies.</p></div><div class="card"><div class="emoji">💼</div><h3>Work & meetings</h3><p class="muted">Professional conversations, requests and presentations.</p></div></div>
@endsection
