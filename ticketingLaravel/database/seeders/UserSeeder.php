<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('users')->insert([
            array(
                'name' => 'Admin',
                'email' => 'admin@gmail.com',
                'phone' => '081234567890',
                'role' => 'admin',
                'password' => Hash::make('12345678')
            ),
            array(
                'name' => 'User',
                'email' => 'user@gmail.com',
                'phone' => '837482368',
                'role' => 'user',
                'password' => Hash::make('12345678')
            ),
        ]);
    }
}
