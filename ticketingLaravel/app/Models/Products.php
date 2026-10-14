<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Products extends Model
{
    protected $table = 'products';

    protected $fillable = [
        'name',
        'description',
        'price',
        'stock',
        'category_id',
        'status',
        'criteria',
    ];

    public function category(){
        return $this->belongsTo(Categories::class, 'category_id', 'id');
    }

    public function orderItems(){
        return $this->hasMany(OrderItem::class, 'product_id', 'id');
    }
}
