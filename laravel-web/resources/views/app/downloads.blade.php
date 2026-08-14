@extends('layouts.app')
@section('title','Downloads · LingoNexa')
@section('content')
<div class="hero"><span class="pill">⬇️ Portable course data</span><h1>{{ $language['flag'] }} {{ $language['nativeName'] }} language pack</h1><p>Export the currently verified web phrase bank as UTF-8 JSON for inspection, backup, testing or future offline/PWA workflows.</p><div class="pills"><span class="pill">{{ $packCount }} phrase records</span><span class="pill">Unicode-safe JSON</span></div></div>
<div class="section-title"><h2>Available download</h2><p>The exported file is generated from the same Laravel data source used by the site.</p></div><div class="card"><div class="emoji">📦</div><h3>{{ $language['nativeName'] }} course phrase pack</h3><p class="muted">Includes language metadata, generation timestamp, source meanings, target expressions and categories.</p><a class="btn" href="{{ route('app.downloads.pack') }}">Download JSON pack</a></div>
@endsection
