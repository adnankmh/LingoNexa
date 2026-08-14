@extends('layouts.app')
@section('title',$ui['grammar'].' · LingoNexa')
@section('content')
<div class="hero"><span class="pill">{{ $language['flag'] }} {{ $language['nativeName'] }}</span><h1>{{ $ui['grammar'] }}</h1><p>{{ $ui['openChapter'] }}</p></div>
<div class="section-title"><h2>A1 → C2</h2><p>54 {{ $ui['chapters'] }}</p></div><div class="book-row">@foreach(['A1','A2','B1','B2','C1','C2'] as $level)<div class="book"><small>LINGONEXA</small><strong style="font-size:25px">{{ $level }}</strong><span style="font-size:11px;opacity:.8">{{ $ui['grammar'] }}</span></div>@endforeach</div>
<div class="section-title"><h2>{{ $ui['chapters'] }}</h2><p>{{ $ui['openChapter'] }}</p></div><div class="grammar-list">@foreach($topics as $index => $topic)<a class="card hover grammar-card" href="{{ route('app.grammar.chapter',$index) }}"><div class="emoji">{{ $topic['emoji'] }}</div><div><small style="font-weight:850;color:var(--primary)">{{ $ui['chapters'] }} {{ $index+1 }} · {{ $topic['level'] }}</small><h3>{{ $topic['title'] }}</h3></div></a>@endforeach</div>
@endsection
