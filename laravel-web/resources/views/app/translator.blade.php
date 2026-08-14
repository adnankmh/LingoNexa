@extends('layouts.app')
@section('title','Translator · LingoNexa')
@section('content')
<div class="hero"><span class="pill">🌐 Course-bank translator</span><h1>Translate with trusted course entries</h1><p>This tool searches the same aligned phrase bank used by LingoNexa lessons. It intentionally avoids pretending to be an unrestricted machine translator when no external translation provider is configured.</p></div>
<div class="section-title"><h2>English → {{ $language['nativeName'] }}</h2><p>Enter a phrase already covered by the current verified course bank.</p></div>
<form class="card" method="post">@csrf<div class="field"><label>Text</label><textarea class="input" name="text" rows="4" maxlength="240" placeholder="Example: Hello">{{ $translationQuery }}</textarea></div><button class="btn" type="submit">Translate from course bank</button></form>
@if(request()->isMethod('post'))<div class="section-title"><h2>Result</h2></div>@if($translationResult)<div class="card"><span class="pill" style="background:#e8eaff;color:#5265e8">{{ $translationResult['category'] }}</span><div class="metric" style="margin-top:12px">{{ $translationResult['target'] }}</div><p class="muted">{{ $translationResult['source'] }}</p></div>@else<div class="card"><h3>Not in the verified bank yet</h3><p class="muted">Use the Phrasebook to see available entries. A production translation provider can later be connected without changing this page structure.</p></div>@endif @endif
@endsection
