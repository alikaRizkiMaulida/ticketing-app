<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'transaction_time' => 'required|date',
            'total_price' => 'required|integer',
            'total_item' => 'required|integer',
            'payment_amount' => 'required|integer',
            'cashier_name' => 'required|string',
            'payment_method' => 'required|string',
            'cashier_id' => 'required|integer',
            'order_items' => 'required',
        ]);

        Order::create([
            'transaction_time' => $request->transaction_time,
            'total_price' => $request->total_price,
            'total_item' => $request->total_item,
            'payment_amount' => $request->payment_amount,
            'cashier_name' => $request->cashier_name,
            'payment_method' => $request->payment_method,
            'cashier_id' => $request->cashier_id
        ])->orderItems()->createMany($request->order_items);
       
        $order = Order::with('orderItems.product')->latest()->first();

        return response()->json([
           'Status' => 'Sukses menambahkan data order',
           'data' => $order 
        ], 201);
        // 201 itu buat kode respon berhasil di proses da
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
