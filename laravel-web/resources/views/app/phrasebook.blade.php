@extends('layouts.app')
@section('title','Phrasebook · LingoNexa')
@section('content')
<div class="hero"><span class="pill">💬 {{ $language['flag'] }} {{ $language['nativeName'] }}</span><h1>Smart Phrasebook</h1><p>Search the verified course phrase bank attached to your selected learning language.</p><div class="pills"><span class="pill">{{ count($phrases) }} matching phrases</span><span class="pill">Account language synced</span></div></div>
<div class="section-title"><h2>Find a phrase</h2><p>Search by source phrase, learning-language phrase, or category.</p></div>
<form class="card" method="get"><div style="display:flex;gap:9px;flex-wrap:wrap"><input class="input" style="flex:1;min-width:220px" name="q" value="{{ $query }}" maxlength="100" placeholder="Search the phrasebook"><button class="btn" type="submit">Search</button>@if($query)<a class="btn ghost" href="{{ route('app.phrasebook') }}">Clear</a>@endif</div></form>
<div class="section-title"><h2>Phrase library</h2><p>Tap nothing, memorize nothing blindly: read the complete expression and its aligned meaning.</p></div>
@if(count($phrases))<div class="grid two">@foreach($phrases as $phrase)<div class="example"><span class="pill" style="background:#e8eaff;color:#5265e8">{{ $phrase['category'] }}</span><strong style="display:block;margin-top:9px;font-size:18px">{{ $phrase['target'] }}</strong><div class="muted">{{ $phrase['source'] }}</div></div>@endforeach</div>@else<div class="card"><h3>No matching phrase</h3><p class="muted">Try another word or remove the search filter.</p></div>@endif
@endsection
