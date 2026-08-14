<?php
namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\UserProgress;
use App\Support\UiCopy;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class AppController extends Controller
{
    public function landing(): View|RedirectResponse
    {
        if (auth()->check()) return redirect()->route('app.dashboard');
        return view('landing', ['languages' => array_slice($this->languages(), 0, 12)]);
    }

    public function dashboard(Request $request): View { return view('app.dashboard', $this->common($request)); }
    public function learn(Request $request): View { return view('app.learn', $this->withPhrases($request)); }
    public function academy(Request $request): View { return view('app.academy', $this->common($request)); }

    public function grammar(Request $request): View
    {
        $data = $this->common($request);
        $topics = $this->json('grammar_topics.json');
        $titles = $this->json('grammar_topic_titles.json')[$data['uiLocale']] ?? [];
        foreach ($topics as $index => &$topic) {
            if (isset($titles[$index])) $topic['title'] = $titles[$index];
        }
        unset($topic);
        $data['topics'] = $topics;
        return view('app.grammar', $data);
    }

    public function grammarChapter(Request $request, int $index): View
    {
        $topics = $this->json('grammar_topics.json');
        abort_unless(isset($topics[$index]), 404);
        $data = $this->withPhrases($request);
        $titles = $this->json('grammar_topic_titles.json')[$data['uiLocale']] ?? [];
        $topic = $topics[$index];
        if (isset($titles[$index])) $topic['title'] = $titles[$index];
        $pack = $this->json('textbook_copy.json')[$data['uiLocale']] ?? $this->json('textbook_copy.json')['en'];
        $profile = UiCopy::languageProfile($data['uiLocale'], $data['language']['nativeName']);
        $fill = fn (string $line): string => str_replace(
            ['{topic}','{level}','{language}','{profile}'],
            [$topic['title'],$topic['level'],$data['language']['nativeName'],$profile],
            $line
        );
        $data['topic'] = $topic;
        $data['chapterNumber'] = $index + 1;
        $data['chapterPhrases'] = $this->rotatedPhrases($data['phrases'], $index * 12, 12);
        $data['chapterCopy'] = [
            'readingTitle' => $fill($pack['readingTitle']),
            'examplesTitle' => $fill($pack['examplesTitle']),
            'readerNote' => $fill($pack['readerNote']),
            'paragraphs' => array_map($fill, $pack['paragraphs']),
        ];
        return view('app.grammar-chapter', $data);
    }

    public function labs(Request $request): View { return view('app.labs', $this->withPhrases($request)); }
    public function practice(Request $request): View { return view('app.practice', $this->withPhrases($request)); }
    public function community(Request $request): View { return view('app.community', $this->common($request)); }

    public function phrasebook(Request $request): View
    {
        $data = $this->withPhrases($request);
        $query = mb_strtolower(trim((string) $request->query('q', '')));
        if ($query !== '') {
            $data['phrases'] = array_values(array_filter($data['phrases'], static fn (array $item): bool =>
                str_contains(mb_strtolower($item['source'].' '.$item['target'].' '.$item['category']), $query)
            ));
        }
        $data['query'] = $query;
        return view('app.phrasebook', $data);
    }

    public function translator(Request $request): View
    {
        $data = $this->withPhrases($request);
        $data['translationQuery'] = trim((string) $request->input('text', ''));
        $data['translationResult'] = null;
        if ($request->isMethod('post')) {
            $request->validate(['text' => ['required','string','max:240']]);
            $needle = mb_strtolower($data['translationQuery']);
            $exact = collect($data['phrases'])->first(static fn (array $item): bool => mb_strtolower($item['source']) === $needle || mb_strtolower($item['target']) === $needle);
            $partial = $exact ?? collect($data['phrases'])->first(static fn (array $item): bool => str_contains(mb_strtolower($item['source']), $needle));
            $data['translationResult'] = $partial;
        }
        return view('app.translator', $data);
    }

    public function achievements(Request $request): View
    {
        $data = $this->common($request);
        $xp = (int) ($data['progress']['xp'] ?? 0);
        $streak = (int) ($data['progress']['streak'] ?? 1);
        $lessons = count($data['progress']['completedLessonIds'] ?? []);
        $exams = count($data['progress']['completedExamIds'] ?? []);
        $data['achievements'] = [
            ['icon'=>'🌱','title'=>'First Steps','done'=>$xp >= 100,'detail'=>'Earn 100 XP'],
            ['icon'=>'🔥','title'=>'Consistency','done'=>$streak >= 7,'detail'=>'Reach a 7-day streak'],
            ['icon'=>'📘','title'=>'Lesson Builder','done'=>$lessons >= 10,'detail'=>'Complete 10 lessons'],
            ['icon'=>'🧠','title'=>'Deep Practice','done'=>(int)($data['progress']['weeklyXp'] ?? 0) >= 300,'detail'=>'Earn 300 XP this week'],
            ['icon'=>'🏅','title'=>'Assessment Ready','done'=>$exams >= 1,'detail'=>'Complete a level assessment'],
            ['icon'=>'🚀','title'=>'Power Learner','done'=>$xp >= 2500,'detail'=>'Earn 2,500 XP'],
        ];
        return view('app.achievements', $data);
    }

    public function assessment(Request $request): View
    {
        $data = $this->withPhrases($request);
        if ($request->isMethod('post')) {
            $expected = $request->session()->pull('assessment_expected', []);
            abort_unless(is_array($expected) && $expected !== [], 419);
            $answers = (array) $request->input('answers', []);
            $score = 0;
            foreach ($expected as $index => $answer) {
                $candidate = trim((string) ($answers[$index] ?? ''));
                if ($candidate !== '' && mb_strtolower($candidate) === mb_strtolower((string) $answer)) $score++;
            }
            $total = count($expected);
            $percent = $total > 0 ? (int) round(($score / $total) * 100) : 0;
            $progress = $request->user()->progress?->data ?? $this->defaultProgress();
            if ($percent >= 70) {
                $id = 'web-assessment-'.date('Ymd');
                $progress['completedExamIds'] = array_values(array_unique([...($progress['completedExamIds'] ?? []), $id]));
                $progress['xp'] = ((int) ($progress['xp'] ?? 0)) + 100;
                UserProgress::updateOrCreate(['user_id'=>$request->user()->id], ['data'=>$progress]);
                $data['progress'] = $progress;
            }
            $data['assessmentResult'] = ['score'=>$score,'total'=>$total,'percent'=>$percent];
            $data['questions'] = [];
            return view('app.assessment', $data);
        }

        $pool = array_slice($data['phrases'], 0, 10);
        $expected = array_values(array_map(static fn (array $p): string => $p['target'], $pool));
        $request->session()->put('assessment_expected', $expected);
        $data['questions'] = $pool;
        $data['assessmentResult'] = null;
        return view('app.assessment', $data);
    }

    public function paths(Request $request): View
    {
        $data = $this->common($request);
        $data['paths'] = [
            ['icon'=>'✈️','title'=>'Travel','detail'=>'Airports, hotels, directions, transport and emergencies.'],
            ['icon'=>'🩺','title'=>'Healthcare','detail'=>'Symptoms, appointments, medication and patient communication.'],
            ['icon'=>'💼','title'=>'Work & Business','detail'=>'Meetings, email, negotiation, presentations and professional register.'],
            ['icon'=>'🎓','title'=>'Study','detail'=>'Academic vocabulary, lectures, discussion and writing.'],
            ['icon'=>'🏡','title'=>'Daily Life','detail'=>'Shopping, food, family, services and neighborhood conversations.'],
            ['icon'=>'🤝','title'=>'Social Fluency','detail'=>'Small talk, opinions, invitations, disagreement and politeness.'],
        ];
        return view('app.paths', $data);
    }

    public function downloads(Request $request): View
    {
        $data = $this->withPhrases($request);
        $data['packCount'] = count($data['phrases']);
        return view('app.downloads', $data);
    }

    public function downloadPack(Request $request): JsonResponse
    {
        $data = $this->withPhrases($request);
        $payload = [
            'product'=>'LingoNexa','language'=>$data['language'],'generatedAt'=>now()->toIso8601String(),
            'phrases'=>$data['phrases'],
        ];
        $response = response()->json($payload, 200, [], JSON_UNESCAPED_UNICODE|JSON_PRETTY_PRINT);
        $response->headers->set('Content-Disposition', 'attachment; filename="lingonexa-'.$data['language']['code'].'-pack.json"');
        return $response;
    }

    public function profile(Request $request): View
    {
        $data = $this->common($request);
        $data['countries'] = $this->json('countries.json');
        return view('app.profile', $data);
    }

    public function updateProfile(Request $request): RedirectResponse
    {
        $languageCodes = array_column($this->languages(), 'code');
        $countryCodes = array_column($this->json('countries.json'), 'code');
        $validated = $request->validate([
            'targetLanguageCode' => ['required', Rule::in($languageCodes)],
            'countryCode' => ['required', Rule::in($countryCodes)],
            'interfaceLocale' => ['required', Rule::in(UiCopy::SUPPORTED)],
            'themeId' => ['required', Rule::in(['snow','royal','emerald','ocean','sunset','rose','midnight','cocoa','aurora','lavender','desert','graphite'])],
            'dailyGoalMinutes' => ['required', 'integer', 'min:5', 'max:180'],
            'learningReason' => ['required', 'string', 'max:80'],
        ]);
        $progress = $request->user()->progress?->data ?? $this->defaultProgress();
        foreach ($validated as $key => $value) $progress[$key] = $value;
        UserProgress::updateOrCreate(['user_id' => $request->user()->id], ['data' => $progress]);
        $request->session()->put('ui_locale', $validated['interfaceLocale']);
        return back()->with('success', 'Learning preferences updated.');
    }

    public function quickSession(Request $request): RedirectResponse
    {
        $validated = $request->validate(['minutes' => ['nullable','integer','min:3','max:30']]);
        $minutes = (int) ($validated['minutes'] ?? 5);
        $earned = max(20, $minutes * 6);
        $user = $request->user();
        $progress = $user->progress?->data ?? $this->defaultProgress();
        $progress['xp'] = ((int) ($progress['xp'] ?? 0)) + $earned;
        $progress['weeklyXp'] = ((int) ($progress['weeklyXp'] ?? 0)) + $earned;
        $progress['dailyMinutes'] = ((int) ($progress['dailyMinutes'] ?? 0)) + $minutes;
        $progress['reviewLessonIds'] = array_values(array_unique([
            ...($progress['reviewLessonIds'] ?? []), 'web-'.date('Ymd-His')
        ]));
        UserProgress::updateOrCreate(['user_id' => $user->id], ['data' => $progress]);
        return back()->with('success', "Practice saved: +{$earned} XP and +{$minutes} minutes.");
    }

    private function withPhrases(Request $request): array
    {
        $data = $this->common($request);
        $code = $data['language']['code'];
        $data['phrases'] = array_values(array_filter(array_map(function (array $concept) use ($code): ?array {
            $translation = $concept['translations'][$code] ?? null;
            if (! is_string($translation) || $translation === '') return null;
            return ['source' => $concept['source'], 'target' => $translation, 'category' => $concept['category']];
        }, $this->json('phrase_concepts.json'))));
        return $data;
    }

    private function rotatedPhrases(array $phrases, int $offset, int $count): array
    {
        if ($phrases === []) return [];
        $result = [];
        $total = count($phrases);
        for ($i = 0; $i < $count; $i++) $result[] = $phrases[($offset + $i) % $total];
        return $result;
    }

    private function common(Request $request): array
    {
        $requestedLocale = (string) $request->query('ui', '');
        if (in_array($requestedLocale, UiCopy::SUPPORTED, true)) {
            $request->session()->put('ui_locale', $requestedLocale);
        }
        $progress = $request->user()->progress?->data ?? $this->defaultProgress();
        $savedLocale = (string) ($progress['interfaceLocale'] ?? 'en');
        $uiLocale = (string) $request->session()->get('ui_locale', $savedLocale);
        if (! in_array($uiLocale, UiCopy::SUPPORTED, true)) $uiLocale = 'en';
        if ($requestedLocale !== '' && in_array($requestedLocale, UiCopy::SUPPORTED, true) && $requestedLocale !== ($progress['interfaceLocale'] ?? '')) {
            $progress['interfaceLocale'] = $requestedLocale;
            UserProgress::updateOrCreate(['user_id' => $request->user()->id], ['data' => $progress]);
        }
        $code = (string) ($progress['targetLanguageCode'] ?? 'en');
        $languages = $this->languages();
        $language = collect($languages)->firstWhere('code', $code) ?? ($languages[0] ?? ['code'=>'en','name'=>'English','nativeName'=>'English','flag'=>'🇬🇧']);
        return [
            'user' => $request->user(), 'progress' => $progress,
            'languages' => $languages, 'language' => $language,
            'uiLocale' => $uiLocale, 'ui' => UiCopy::get($uiLocale),
            'uiLocales' => UiCopy::SUPPORTED, 'direction' => UiCopy::direction($uiLocale),
        ];
    }

    private function defaultProgress(): array { return UserProgress::defaults(); }

    private function languages(): array { return $this->json('languages.json'); }
    private function json(string $file): array
    {
        $path = resource_path('data/'.$file);
        if (! is_file($path)) return [];
        return json_decode((string) file_get_contents($path), true, flags: JSON_THROW_ON_ERROR);
    }
}
