<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserProgress;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;
use Illuminate\Validation\Rule;

class ProgressController extends Controller
{
    private const ALLOWED = [
        'interfaceLocale', 'themeId', 'onboardingCompleted', 'targetLanguageCode',
        'currentLevel', 'xp', 'streak', 'dailyMinutes', 'dailyGoalMinutes',
        'learningReason', 'countryCode', 'sprintMode', 'downloadedPackCodes',
        'completedLessonIds', 'reviewLessonIds', 'completedExamIds', 'weeklyXp',
        'skillMastery', 'adaptiveReviews',
    ];

    public function show(Request $request): JsonResponse
    {
        $data = $request->user()->progress?->data ?? UserProgress::defaults();
        return response()->json(['progress' => array_replace(UserProgress::defaults(), $data)]);
    }

    public function update(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'progress' => ['required', 'array'],
            'progress.interfaceLocale' => ['sometimes', Rule::in(['ar','en','es','fr','de','tr','pt','it','ru','zh','ja','ko'])],
            'progress.themeId' => ['sometimes', Rule::in(['snow','royal','emerald','ocean','sunset','rose','midnight','cocoa','aurora','lavender','desert','graphite'])],
            'progress.onboardingCompleted' => ['sometimes', 'boolean'],
            'progress.targetLanguageCode' => ['sometimes', 'string', 'regex:/^[a-z]{2,3}$/'],
            'progress.currentLevel' => ['sometimes', Rule::in(['A1','A2','B1','B2','C1','C2'])],
            'progress.xp' => ['sometimes', 'integer', 'min:0', 'max:1000000000'],
            'progress.streak' => ['sometimes', 'integer', 'min:0', 'max:100000'],
            'progress.dailyMinutes' => ['sometimes', 'integer', 'min:0', 'max:1440'],
            'progress.dailyGoalMinutes' => ['sometimes', 'integer', 'min:5', 'max:180'],
            'progress.learningReason' => ['sometimes', 'string', 'max:80'],
            'progress.countryCode' => ['sometimes', 'string', 'size:2'],
            'progress.sprintMode' => ['sometimes', 'boolean'],
            'progress.downloadedPackCodes' => ['sometimes', 'array', 'max:250'],
            'progress.downloadedPackCodes.*' => ['string', 'max:12'],
            'progress.completedLessonIds' => ['sometimes', 'array', 'max:20000'],
            'progress.completedLessonIds.*' => ['string', 'max:120'],
            'progress.reviewLessonIds' => ['sometimes', 'array', 'max:20000'],
            'progress.reviewLessonIds.*' => ['string', 'max:120'],
            'progress.completedExamIds' => ['sometimes', 'array', 'max:1000'],
            'progress.completedExamIds.*' => ['string', 'max:120'],
            'progress.weeklyXp' => ['sometimes', 'integer', 'min:0', 'max:100000000'],
            'progress.skillMastery' => ['sometimes', 'array', 'max:12'],
            'progress.skillMastery.*' => ['integer', 'min:0', 'max:100'],
            'progress.adaptiveReviews' => ['sometimes', 'string', 'max:1000000'],
        ]);

        $incoming = Arr::only($validated['progress'], self::ALLOWED);
        $current = $request->user()->progress?->data ?? UserProgress::defaults();
        $clean = array_replace(UserProgress::defaults(), $current, $incoming);
        $record = UserProgress::updateOrCreate(
            ['user_id' => $request->user()->id],
            ['data' => $clean],
        );

        return response()->json([
            'message' => 'Progress synchronized.',
            'progress' => $record->data,
        ]);
    }
}
