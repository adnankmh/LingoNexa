@extends('layouts.app')
@section('title','Nexa Learning Labs · LingoNexa')
@section('content')
<div class="hero"><span class="pill">🧠 Evidence-informed learning modes</span><h1>Nexa Learning Labs</h1><p>Train {{ $language['flag'] }} {{ $language['nativeName'] }} with short, deliberate sessions built around retrieval, spacing, listening, speech and fluent chunking.</p><div class="pills"><span class="pill">12 learning labs</span><span class="pill">{{ count($phrases) }} aligned phrases available</span><span class="pill">Progress saved to your account</span></div></div>
@php($methods = [
 ['🧠','Active Retrieval','Try to produce the answer before revealing it. Memory strengthens when recall is effortful.'],
 ['🗓️','Spaced Review','Return to material at expanding intervals rather than repeating it in one sitting.'],
 ['🔀','Interleaving Mix','Mix related skills and topics so you learn to choose the right pattern, not only repeat it.'],
 ['✍️','Dictation Studio','Listen, reconstruct the sentence, then compare details in spelling, endings and word order.'],
 ['🧱','Chunk Builder','Learn useful multi-word units as fluent building blocks rather than isolated words.'],
 ['🎧','Shadowing Loop','Listen and speak immediately after the model to train rhythm, linking and pronunciation.'],
 ['🌊','Comprehensible Input','Read and listen slightly above your comfort level while meaning stays understandable.'],
 ['🗣️','Conversation Missions','Complete a communication goal such as asking, clarifying, comparing or solving a problem.'],
 ['🎙️','Pronunciation Focus','Work on one sound, stress or rhythm target inside meaningful phrases.'],
 ['🃏','Memory Decks','Turn weak phrases into a compact review queue and revisit them strategically.'],
 ['🛠️','Error Repair','Correct a sentence, explain the improvement, and produce a fresh example.'],
 ['⚡','Fluency Sprint','Respond quickly with familiar language to reduce hesitation and build automaticity.'],
])
<div class="section-title"><h2>Choose a learning lab</h2><p>Each method has a different cognitive purpose; rotate them instead of using only one exercise type.</p></div>
<div class="grid">
@foreach($methods as $method)
<div class="card hover"><div class="emoji">{{ $method[0] }}</div><h3>{{ $method[1] }}</h3><p class="muted">{{ $method[2] }}</p></div>
@endforeach
</div>
<div class="section-title"><h2>Start a synced session</h2><p>A short web session updates the same account progress used by the mobile application.</p></div>
<div class="card"><form method="post" action="{{ route('app.practice.quick') }}">@csrf<div class="grid two"><div><h3 style="margin-top:0">{{ $language['flag'] }} {{ $language['nativeName'] }} session</h3><p class="muted">Use one of the {{ min(count($phrases),12) }} phrases below, say the answer before revealing it, and finish with a brief recall round.</p></div><div><label class="muted" for="minutes">Session length</label><select class="input" id="minutes" name="minutes"><option value="5">5 minutes</option><option value="10">10 minutes</option><option value="15">15 minutes</option></select><button class="btn" style="margin-top:10px;width:100%">Complete & sync session</button></div></div></form></div>
@if(count($phrases))
<div class="section-title"><h2>Phrase pool</h2><p>Real aligned course content shared with the Flutter learning system.</p></div>
<div class="grid two">@foreach(array_slice($phrases,0,12) as $phrase)<div class="example"><span class="pill" style="background:#e8eaff;color:#5265e8">{{ $phrase['category'] }}</span><strong style="display:block;margin-top:9px">{{ $phrase['target'] }}</strong><span class="muted">{{ $phrase['source'] }}</span></div>@endforeach</div>
@endif
@endsection
