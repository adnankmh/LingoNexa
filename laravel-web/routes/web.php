<?php
use App\Http\Controllers\Web\AppController;
use App\Http\Controllers\Web\AuthController;
use Illuminate\Support\Facades\Route;

Route::get('/', [AppController::class, 'landing'])->name('home');
Route::middleware('guest')->group(function (): void {
    Route::get('/login', [AuthController::class, 'loginForm'])->name('login');
    Route::post('/login', [AuthController::class, 'login'])->middleware('throttle:10,1');
    Route::get('/register', [AuthController::class, 'registerForm'])->name('register');
    Route::post('/register', [AuthController::class, 'register'])->middleware('throttle:6,1');
});
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth')->name('logout');

Route::prefix('app')->middleware('auth')->name('app.')->group(function (): void {
    Route::get('/', [AppController::class, 'dashboard'])->name('dashboard');
    Route::get('/learn', [AppController::class, 'learn'])->name('learn');
    Route::get('/practice', [AppController::class, 'practice'])->name('practice');
    Route::get('/academy', [AppController::class, 'academy'])->name('academy');
    Route::get('/grammar', [AppController::class, 'grammar'])->name('grammar');
    Route::get('/grammar/{index}', [AppController::class, 'grammarChapter'])->whereNumber('index')->name('grammar.chapter');
    Route::get('/labs', [AppController::class, 'labs'])->name('labs');
    Route::get('/community', [AppController::class, 'community'])->name('community');
    Route::get('/phrasebook', [AppController::class, 'phrasebook'])->name('phrasebook');
    Route::match(['get','post'], '/translator', [AppController::class, 'translator'])->name('translator');
    Route::get('/achievements', [AppController::class, 'achievements'])->name('achievements');
    Route::match(['get','post'], '/assessment', [AppController::class, 'assessment'])->name('assessment');
    Route::get('/paths', [AppController::class, 'paths'])->name('paths');
    Route::get('/downloads', [AppController::class, 'downloads'])->name('downloads');
    Route::get('/downloads/language-pack', [AppController::class, 'downloadPack'])->name('downloads.pack');
    Route::get('/profile', [AppController::class, 'profile'])->name('profile');
    Route::post('/profile', [AppController::class, 'updateProfile'])->name('profile.update');
    Route::post('/practice/quick-session', [AppController::class, 'quickSession'])->name('practice.quick');
});
