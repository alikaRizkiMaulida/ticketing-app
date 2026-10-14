<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class CategoriesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('categories')->insert([
            array(
                'name' => 'Swim',
                'description' => 'Swim',
            ),
            array(
                'name' => 'Zoo',
                'description' => 'Ragunan',
            ),
            array(
                'name' => 'Musik',
                'description' => 'Enhypen ot6',
            ),
            array(
                'name' => 'Snow',
                'description' => 'Snow',
            ),
        ]);
    }
}
