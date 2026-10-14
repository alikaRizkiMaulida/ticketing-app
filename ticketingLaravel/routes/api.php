<?php

use App\Http\Controllers\Api\AuthContoller;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\OrderItemController;
use App\Http\Controllers\Api\ProductController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/login', [AuthContoller::class, 'login']);
Route::post('/logout', [AuthContoller::class, 'logout'])->middleware('auth:sanctum');
Route::post('/register', [AuthContoller::class, 'register']);


// Route untuk Produk
Route::apiResource('/api-product', ProductController::class)->middleware('auth:sanctum');

// ROute untuk Kategori
Route::apiResource('/api-categories', CategoryController::class)->middleware('auth:sanctum');
// Route untuk order
Route::apiResource('/api-orders', OrderController::class)->middleware('auth:sanctum');
Route::apiResource('/api-orders-items', OrderItemController::class)->middleware('auth:sanctum'); 