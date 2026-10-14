<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('products')->insert([
            array(
                'name' => 'Kursus',
                'description' => 'Kursus',
                'price' => 100000,
                'stock' => 10,
                'status' => 'published',
                'criteria' => 'single',
                'category_id' => 2
            ),
            array(
                'name' => 'Waterboom',
                'description' => 'Berenang cihuy',
                'price' => 3500,
                'stock' => 20,
                'status' => 'published',
                'criteria' => 'grup',
                'category_id' => 1
            ),
            array(
                'name' => 'Jungle Land',
                'description' => 'Capibara aamiin',
                'price' => 1500,
                'stock' => 30,
                'status' => 'published',
                'criteria' => 'single',
                'category_id' => 3
            ),
        ]);
    }
}
