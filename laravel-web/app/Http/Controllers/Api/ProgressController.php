<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserProgress;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

class ProgressController extends Controller
{
    private const ALLOWED = [
        'interfaceLocale', 'themeId', 'onboardingCompleted', 'targetLanguageCode',
        'currentLevel', 'xp', 'streak', 'dailyMinutes', 'dailyGoalMinutes',
        'learningReason', 'countryCode', 'sprintMode', 'downloadedPackCodes',
        'completedLessonIds', 'reviewLessonIds', 'completedExamIds', 'weeklyXp',
        'skillMastery', 'adaptiveReviews',
    ];

    private const TARGET_LANGUAGE_CODES = [
        'en', 'ar', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'tr', 'zh', 'ja', 'ko',
        'hi', 'ur', 'fa', 'he', 'nl', 'sv', 'no', 'da', 'fi', 'pl', 'cs', 'sk',
        'hu', 'ro', 'bg', 'uk', 'el', 'id', 'ms', 'th', 'vi', 'fil', 'sw', 'am',
        'ha', 'yo', 'ig', 'zu', 'af', 'ca', 'eu', 'gl', 'cy', 'ga', 'is', 'sq',
        'hr', 'sr', 'sl', 'mk', 'et', 'lv', 'lt', 'ka', 'hy', 'az', 'kk', 'uz',
        'mn', 'ne', 'bn', 'ta', 'te', 'ml', 'kn',
    ];

    public function show(Request $request): JsonResponse
    {
        $data = $request->user()->progress()->first()?->data ?? UserProgress::defaults();

        return response()->json(['progress' => array_replace(UserProgress::defaults(), $data)]);
    }

    public function update(Request $request): JsonResponse
    {
        $progress = $request->input('progress');
        if (is_array($progress)) {
            $unknown = array_values(array_diff(array_keys($progress), self::ALLOWED));
            if ($unknown !== []) {
                throw ValidationException::withMessages([
                    'progress' => ['Unknown progress fields: '.implode(', ', $unknown).'.'],
                ]);
            }
        }

        $validated = $request->validate([
            'progress' => ['required', 'array'],
            'progress.interfaceLocale' => ['sometimes', Rule::in(['ar', 'en', 'es', 'fr', 'de', 'tr', 'pt', 'it', 'ru', 'zh', 'ja', 'ko'])],
            'progress.themeId' => ['sometimes', Rule::in(['snow', 'royal', 'emerald', 'ocean', 'sunset', 'rose', 'midnight', 'cocoa', 'aurora', 'lavender', 'desert', 'graphite'])],
            'progress.onboardingCompleted' => ['sometimes', 'boolean'],
            'progress.targetLanguageCode' => ['sometimes', Rule::in(self::TARGET_LANGUAGE_CODES)],
            'progress.currentLevel' => ['sometimes', Rule::in(['A1', 'A2', 'B1', 'B2', 'C1', 'C2'])],
            'progress.xp' => ['sometimes', 'integer', 'min:0', 'max:1000000000'],
            'progress.streak' => ['sometimes', 'integer', 'min:0', 'max:100000'],
            'progress.dailyMinutes' => ['sometimes', 'integer', 'min:0', 'max:1440'],
            'progress.dailyGoalMinutes' => ['sometimes', 'integer', 'min:5', 'max:180'],
            'progress.learningReason' => ['sometimes', Rule::in(['Travel', 'Work', 'Study', 'Family', 'Culture', 'Brain training'])],
            'progress.countryCode' => ['sometimes', 'string', 'regex:/^[A-Z]{2}$/'],
            'progress.sprintMode' => ['sometimes', 'boolean'],
            'progress.downloadedPackCodes' => ['sometimes', 'array', 'max:250'],
            'progress.downloadedPackCodes.*' => ['string', 'max:12', 'distinct:strict'],
            'progress.completedLessonIds' => ['sometimes', 'array', 'max:20000'],
            'progress.completedLessonIds.*' => ['string', 'max:120', 'distinct:strict'],
            'progress.reviewLessonIds' => ['sometimes', 'array', 'max:20000'],
            'progress.reviewLessonIds.*' => ['string', 'max:120', 'distinct:strict'],
            'progress.completedExamIds' => ['sometimes', 'array', 'max:1000'],
            'progress.completedExamIds.*' => ['string', 'max:120', 'distinct:strict'],
            'progress.weeklyXp' => ['sometimes', 'integer', 'min:0', 'max:100000000'],
            'progress.skillMastery' => ['sometimes', 'array:reading,listening,speaking,writing,grammar,vocabulary', 'max:6'],
            'progress.skillMastery.*' => ['integer', 'min:0', 'max:100'],
            'progress.adaptiveReviews' => [
                'sometimes', 'string', 'json', 'max:1000000',
                static function (string $attribute, mixed $value, \Closure $fail): void {
                    if (! is_string($value) || ! is_object(json_decode($value))) {
                        $fail('The '.$attribute.' field must contain a JSON object.');
                    }
                },
            ],
        ]);

        $incoming = Arr::only($validated['progress'], self::ALLOWED);
        // Query the relation instead of reading the possibly cached relation property.
        // Multiple sync requests can reuse the same authenticated User instance during
        // a test/request lifecycle; a stale null relation would otherwise reset fields
        // that are intentionally omitted from a partial update.
        $current = $request->user()->progress()->first()?->data ?? UserProgress::defaults();
        $clean = array_replace(UserProgress::defaults(), $current, $incoming);
        $record = UserProgress::updateOrCreate(
            ['user_id' => $request->user()->id],
            ['data' => $clean],
        );
        $request->user()->setRelation('progress', $record);

        return response()->json([
            'message' => 'Progress synchronized.',
            'progress' => $record->data,
        ]);
    }
}
