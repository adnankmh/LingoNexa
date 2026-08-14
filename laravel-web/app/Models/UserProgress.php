<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class UserProgress extends Model
{
    protected $table = 'user_progress';
    protected $fillable = ['user_id', 'data'];
    protected function casts(): array { return ['data' => 'array']; }
    public function user(): BelongsTo { return $this->belongsTo(User::class); }

    public static function defaults(): array
    {
        return [
            'interfaceLocale' => 'en', 'themeId' => 'snow',
            'onboardingCompleted' => false,
            'targetLanguageCode' => 'en', 'currentLevel' => 'A1', 'xp' => 0,
            'streak' => 1, 'dailyMinutes' => 0, 'dailyGoalMinutes' => 15,
            'learningReason' => 'Travel', 'countryCode' => 'PS', 'weeklyXp' => 0,
            'sprintMode' => false, 'downloadedPackCodes' => [],
            'completedLessonIds' => [], 'reviewLessonIds' => [], 'completedExamIds' => [],
            'skillMastery' => ['reading'=>42,'listening'=>36,'speaking'=>31,'writing'=>34,'grammar'=>40,'vocabulary'=>45],
            'adaptiveReviews' => '{}',
        ];
    }
}
