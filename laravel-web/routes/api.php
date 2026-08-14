<?php
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProgressController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function (): void {
    Route::post('/auth/register', [AuthController::class, 'register'])->middleware('throttle:6,1');
    Route::post('/auth/login', [AuthController::class, 'login'])->middleware('throttle:10,1');

    Route::middleware('auth:sanctum')->group(function (): void {
        Route::get('/me', [AuthController::class, 'me']);
        Route::post('/auth/logout', [AuthController::class, 'logout']);
        Route::get('/progress', [ProgressController::class, 'show']);
        Route::put('/progress', [ProgressController::class, 'update'])->middleware('throttle:120,1');
    });
});
