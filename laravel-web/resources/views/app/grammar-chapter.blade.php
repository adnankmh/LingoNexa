@extends('layouts.app')
@section('title',$topic['title'].' · LingoNexa')
@section('content')
<div class="hero"><span class="pill">{{ $ui['chapters'] }} {{ $chapterNumber }} · {{ $topic['level'] }}</span><h1>{{ $topic['emoji'] }} {{ $topic['title'] }}</h1><p>{{ $language['flag'] }} {{ $language['nativeName'] }} · {{ $chapterCopy['readingTitle'] }}</p></div>
<div class="section-title"><h2>{{ $chapterCopy['readingTitle'] }}</h2></div>
<div class="card chapter-text">@foreach($chapterCopy['paragraphs'] as $paragraph)<p>{{ $paragraph }}</p>@endforeach</div>
<div class="section-title"><h2>{{ $chapterCopy['examplesTitle'] }}</h2></div>
@if(count($chapterPhrases))<div class="grid two">@foreach($chapterPhrases as $phrase)<div class="example"><span class="pill" style="background:#e8eaff;color:#5265e8">{{ $phrase['category'] }}</span><strong style="display:block;margin-top:8px;font-size:17px">{{ $phrase['target'] }}</strong><div class="muted">{{ $phrase['source'] }}</div></div>@endforeach</div>@endif
<div class="card" style="margin-top:16px"><strong>{{ $ui['readerNote'] }}</strong><p class="muted" style="margin-bottom:0">{{ $chapterCopy['readerNote'] }}</p></div>
@endsection
