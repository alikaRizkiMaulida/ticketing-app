<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Products;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $produk = Products::with('category')
            ->orderBy('id', 'ASC')
            ->get();
        return response()->json([
            'Status' => 'Sukses mengambil data produk slebew',
            'data' => $produk
        ], 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string',
            'price' => 'required|integer',
            'stock' => 'required|integer',
            'category_id' => 'required|integer',
            'criteria' => 'required',
        ]);

        Products::create([
            'name' => $request->name,
            'price' => $request->price,
            'stock' => $request->stock,
            'category_id' => $request->category_id,
            'criteria' => $request->criteria
        ]);

        $produk = Products::with('category')->latest()->first();
        return response()->json([
            'Status' => 'Sukses menambahkan data produk',
            'data' => $produk
        ], 200);
    }

    /**
     * Display the specified resource.
     */
    public function show($name)
    {
        $produk = Products::where('name', $name)->first();
        if (!$produk) {
            return response()->json([
                'Status'  => 'Gagal mencari produk',
                'Pesan' => 'Produk tidak ditemukan'
            ]);
        }

        return response()->json([
            'Status' => 'Sukses',
            'data' => $produk
        ], 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $produk = Products::find($id);
        if (!$produk) {
            return response()->json([
                'Status'  => 'Gagal mengupdate produk',
                'Pesan' => 'Produk tidak ditemukan'
            ]);
        }

        $produk->update([
            $produk->name = $request->name,
            $produk->price = $request->price,
        ]);

        $produk = Products::with('category')->find($produk->id);

        return response()->json([
            'Status' => 'Sukses mengupdate produk',
            'data' => $produk
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $produk = Products::find($id);
        if (!$produk) {
            return response()->json([
                'Status'  => 'Gagal menghapus produk',
                'Pesan' => 'Produk tidak ditemukan'
            ], 404);
        }

        $produk->delete();

        return response()->json([
            'Status' => 'Sukses',
            'Pesan' => 'Sukses menghapus produk',
        ], 200);
    }
}
