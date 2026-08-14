<?php
use Illuminate\Support\Facades\Artisan;
Artisan::command('lingonexa:status', function (): void {
    $this->info('LingoNexa Laravel backend is ready.');
})->purpose('Check the LingoNexa application command layer');
