@extends('layouts.app')
@section('title','Assessment · LingoNexa')
@section('content')
<div class="hero"><span class="pill">📝 Assessment Center</span><h1>Active language check</h1><p>Translate course meanings into {{ $language['nativeName'] }}. A score of 70% or higher records the assessment and awards 100 XP.</p></div>
@if($assessmentResult)
<div class="section-title"><h2>Result</h2><p>Your answer set has been checked server-side.</p></div><div class="card"><div class="metric">{{ $assessmentResult['percent'] }}%</div><h3>{{ $assessmentResult['score'] }} / {{ $assessmentResult['total'] }} correct</h3><p class="muted">{{ $assessmentResult['percent'] >= 70 ? 'Passed — assessment progress and XP were saved to your account.' : 'Review the phrase bank and try another assessment when ready.' }}</p><a class="btn" href="{{ route('app.assessment') }}">Start another assessment</a></div>
@elseif(count($questions))
<div class="section-title"><h2>{{ count($questions) }}-question check</h2><p>Write the learning-language expression. Matching ignores letter case where the script supports it.</p></div><form method="post" class="card">@csrf @foreach($questions as $index=>$question)<div class="field"><label>{{ $index+1 }}. {{ $question['source'] }}</label><input class="input" name="answers[{{ $index }}]" autocomplete="off" required></div>@endforeach<button class="btn" type="submit">Submit assessment</button></form>
@else<div class="card" style="margin-top:24px"><h3>Assessment content is still expanding for this language</h3><p class="muted">Choose a language with a larger verified phrase bank or continue in the Flutter starter course.</p></div>@endif
@endsection
