// sqflite adalah database lokal di aplikasi mobile
// Dipakai untuk menyimpan data di HP secara offline
//
// Contoh data yang bisa disimpan:
// - produk
// - kategori
// - order
// - order item
//
// Data yang disimpan ke sqflite bentuknya Map<String, dynamic>
//
// Kenapa Map?
// Karena database tabel itu mirip seperti pasangan:
// nama kolom -> isi data
//
// Contoh:
// {
//   'name': 'Tiket Museum',
//   'price': 50000,
//   'stock': 10,
// }
//
// Alur simpannya:
// Object Dart -> Map<String, dynamic> -> disimpan ke sqflite
//
// Alur ambil datanya:
// Data dari sqflite -> Map<String, dynamic> -> Object Dart

import 'package:sqflite/sqflite.dart';
// Import package sqflite
// Package ini dipakai untuk membuat dan mengakses database lokal di HP

import 'package:ticketingapp/data/model/request/order_request_model.dart';
// Import model request order
// Di sini kemungkinan ada OrderItemModel atau model lain yang dipakai untuk order

import 'package:ticketingapp/data/model/response/category_response_model.dart';
// Import Category
// Category dipakai untuk menyimpan dan mengambil data kategori dari database lokal

import 'package:ticketingapp/data/model/response/product_response_model.dart';
// Import Product
// Product dipakai untuk menyimpan dan mengambil data produk dari database lokal

import 'package:ticketingapp/presentation/home/bloc/checkout/model/order_model.dart';
// Import OrderModel
// OrderModel dipakai untuk menyimpan dan mengambil data transaksi/order lokal

class ProductLocalDatasource {
  // Ini class ProductLocalDatasource
  //
  // LocalDatasource artinya sumber data lokal
  // Jadi class ini bertugas mengurus data dari database lokal sqflite
  //
  // Di sini isinya bukan cuma product,
  // tapi juga category, order, dan order item

  ProductLocalDatasource._init();
  // Ini constructor private
  //
  // Tanda _ sebelum init artinya private
  // Jadi constructor ini tidak bisa dipanggil sembarangan dari luar file
  //
  // Tujuannya agar orang tidak membuat object ProductLocalDatasource berkali-kali
  //
  // Bahasa gampang:
  // Kita kunci pintu pembuatan object-nya,
  // supaya cuma ada satu pusat akses database

  static final ProductLocalDatasource instance = ProductLocalDatasource._init();
  // Ini adalah object utama yang dipakai di seluruh aplikasi
  //
  // Ini disebut Singleton Pattern
  //
  // Singleton artinya hanya ada satu object ProductLocalDatasource
  // yang dipakai bersama-sama
  //
  // Jadi kalau butuh akses database, kita cukup pakai:
  // ProductLocalDatasource.instance
  //
  // Analogi:
  // Ini seperti kantor pusat.
  // Semua bagian aplikasi kalau butuh data lokal,
  // cukup datang ke kantor pusat yang sama,
  // bukan bikin kantor pusat baru sendiri-sendiri.

  final String tableProducts = 'products';
  // Nama tabel untuk menyimpan data produk

  final String tableOrder = 'orders';
  // Nama tabel untuk menyimpan data order / transaksi

  final String tableOrderItems = 'order_items';
  // Nama tabel untuk menyimpan detail item dalam order
  //
  // Misalnya 1 order berisi:
  // - Tiket Museum 2 pcs
  // - Tiket Zoo 1 pcs
  //
  // Nah detail itemnya disimpan di tableOrderItems

  final String tableCategories = 'category';
  // Nama tabel untuk menyimpan data kategori

  static Database? _database;
  // Variabel untuk menyimpan object database
  //
  // Pakai tanda ? karena awalnya database belum tentu sudah ada
  //
  // Saat aplikasi baru jalan, _database masih null
  // Nanti kalau database sudah dibuka, hasilnya disimpan ke sini
  //
  // Dengan ini, database tidak perlu dibuka ulang terus-menerus

  Future<void> _createDB(Database db, int version) async {
    // _createDB dipakai untuk membuat tabel-tabel database
    //
    // Function ini akan dipanggil saat database pertama kali dibuat
    //
    // db adalah object database-nya
    // version adalah versi database

    await db.execute('''
       CREATE TABLE $tableProducts (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       productId INTEGER,
       category_id INTEGER,
       name TEXT NOT NULL,
       description TEXT,
       price TEXT,
       image TEXT,
       stock INTEGER,
       status INTEGER,
       is_favorite INTEGER,
       created_at TEXT,
       updated_at TEXT,
       criteria TEXT
       )
''');
    // Membuat tabel products
    //
    // id INTEGER PRIMARY KEY AUTOINCREMENT
    // artinya id utama, otomatis bertambah sendiri
    //
    // productId INTEGER
    // kemungkinan id produk asli dari server/API
    //
    // category_id INTEGER
    // untuk menyimpan id kategori produk
    //
    // name TEXT NOT NULL
    // nama produk, wajib ada
    //
    // description TEXT
    // deskripsi produk
    //
    // price TEXT
    // harga produk
    //
    // image TEXT
    // nama/link gambar produk
    //
    // stock INTEGER
    // stok produk
    //
    // status INTEGER
    // status produk, biasanya 1 aktif, 0 tidak aktif
    //
    // is_favorite INTEGER
    // status favorit, biasanya 1 favorit, 0 bukan favorit
    //
    // created_at dan updated_at TEXT
    // waktu dibuat dan diperbarui
    //
    // criteria TEXT
    // kemungkinan kriteria tiket, misalnya single/group

    await db.execute('''
       CREATE TABLE $tableCategories (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       categoryId INTEGER,
       name TEXT NOT NULL,
       description TEXT,
       image TEXT,
       created_at TEXT,
       updated_at TEXT
       )
       ''');
    // Membuat tabel category
    //
    // id adalah id lokal yang dibuat otomatis oleh sqflite
    //
    // categoryId kemungkinan id kategori asli dari API/server
    //
    // name adalah nama kategori
    //
    // description adalah deskripsi kategori
    //
    // image adalah gambar kategori
    //
    // created_at dan updated_at untuk waktu data dibuat/diperbarui

    await db.execute('''
       CREATE TABLE $tableOrder (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       nominal INTEGER,
       payment_method TEXT,
       payment_amount INTEGER,
       total_price INTEGER,
       total_item INTEGER,
       cashier_id INTEGER,
       cashier_name TEXT,
       transaction_time TEXT,
       is_sync INTEGER DEFAULT 0
)''');
    // Membuat tabel orders
    //
    // Tabel ini menyimpan transaksi utama
    //
    // nominal INTEGER
    // kemungkinan nominal uang yang dimasukkan/dibayar
    //
    // payment_method TEXT
    // metode pembayaran, misalnya cash/qris/transfer
    //
    // payment_amount INTEGER
    // jumlah pembayaran
    //
    // total_price INTEGER
    // total harga transaksi
    //
    // total_item INTEGER
    // total item yang dibeli
    //
    // cashier_id INTEGER
    // id kasir
    //
    // cashier_name TEXT
    // nama kasir
    //
    // transaction_time TEXT
    // waktu transaksi
    //
    // is_sync INTEGER DEFAULT 0
    // untuk menandai apakah order sudah disinkronkan ke server atau belum
    //
    // 0 = belum sync
    // 1 = sudah sync

    await db.execute('''
       CREATE TABLE $tableOrderItems (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       id_order INTEGER,
       id_product INTEGER,
       quantity INTEGER,
       price INTEGER
       )
       ''');
    // Membuat tabel order_items
    //
    // Tabel ini menyimpan detail item dari order
    //
    // id_order INTEGER
    // untuk menghubungkan item ini ke order utama
    //
    // id_product INTEGER
    // id produk yang dibeli
    //
    // quantity INTEGER
    // jumlah produk yang dibeli
    //
    // price INTEGER
    // harga produk saat dibeli
  }

  Future<Database> _initDb() async {
    // _initDb dipakai untuk inisialisasi database
    //
    // Maksudnya:
    // mencari lokasi penyimpanan database,
    // lalu membuka atau membuat database

    final path = await getDatabasesPath();
    // getDatabasesPath() dipakai untuk mengambil lokasi folder database
    // di perangkat HP
    //
    // await dipakai karena proses mengambil path butuh waktu

    final databasepath = '$path/ticket2.db';
    // Ini membuat path lengkap database
    //
    // ticket2.db adalah nama file database-nya
    //
    // Jadi database lokal akan disimpan dengan nama ticket2.db

    return openDatabase(databasepath, version: 1, onCreate: _createDB);
    // openDatabase dipakai untuk membuka database
    //
    // Kalau database belum ada, sqflite akan membuat database baru
    //
    // version: 1 artinya versi database saat ini adalah 1
    //
    // onCreate: _createDB artinya kalau database baru dibuat,
    // jalankan function _createDB untuk membuat tabel-tabelnya
  }

  Future<Database> get database async {
    // Ini getter untuk mengambil database
    //
    // Jadi kalau butuh database, cukup panggil:
    // await instance.database

    if (_database != null) return _database!;
    // Kalau _database sudah ada,
    // langsung pakai database yang sudah ada
    //
    // Tanda ! artinya kita yakin _database tidak null
    // karena sudah dicek sebelumnya

    _database = await _initDb();
    // Kalau _database masih null,
    // maka buka/buat database dulu lewat _initDb()

    return _database!;
    // Setelah database dibuat/dibuka,
    // kembalikan database-nya
  }

  Future<void> insertAllProduct(List<Product> products) async {
    // Function untuk menyimpan banyak produk ke database lokal
    //
    // products adalah list produk dari API/server

    final db = await instance.database;
    // Mengambil database dulu
    //
    // Harus pakai await karena database dibuka secara async

    for (var product in products) {
      // Loop semua produk satu per satu

      await db.insert(
        tableProducts,
        product.toLocalMap(),
        // product.toLocalMap() mengubah object Product menjadi Map<String, dynamic>
        //
        // Kenapa harus jadi Map?
        // Karena sqflite menyimpan data dalam bentuk Map
        //
        // Contoh:
        // Product(name: "Tiket Zoo", price: 50000)
        //
        // Diubah jadi:
        // {
        //   'name': 'Tiket Zoo',
        //   'price': 50000,
        // }

        conflictAlgorithm: ConflictAlgorithm.replace,
        // Kalau data yang dimasukkan konflik dengan data lama,
        // maka data lama akan diganti dengan data baru
      );
    }
  }

  Future<void> removeAllProduct() async {
    // Function untuk menghapus semua data produk lokal

    final db = await instance.database;
    // Mengambil database

    await db.delete(tableProducts);
    // Menghapus semua isi tabel products
    //
    // Karena tidak ada where,
    // semua data di tabel products akan terhapus
  }

  Future<List<Product>> getAllProducts() async {
    // Function untuk mengambil semua data produk dari database lokal
    //
    // Hasilnya adalah List<Product>
    // Artinya kumpulan object Product

    final db = await instance.database;
    // Mengambil database

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
SELECT p.*, c.id as category_id, c.name as category_name, c.description as category_description,
c.image as category_image, c.created_at as category_created_at, c.updated_at as category_updated_at
FROM $tableProducts p
      LEFT JOIN $tableCategories c ON p.category_id = c.id
''');
    // rawQuery dipakai untuk menulis query SQL manual
    //
    // Query ini mengambil data dari tabel products dan category
    //
    // p adalah alias untuk tabel products
    // c adalah alias untuk tabel category
    //
    // SELECT p.*
    // artinya ambil semua kolom dari products
    //
    // c.id as category_id
    // artinya ambil id kategori, lalu namanya dibuat category_id
    //
    // LEFT JOIN dipakai untuk menggabungkan products dengan category
    //
    // ON p.category_id = c.id
    // artinya produk dicocokkan dengan kategori berdasarkan category_id
    //
    // LEFT JOIN artinya:
    // Semua produk tetap diambil,
    // meskipun kategori produk tersebut tidak ditemukan
    //
    // Kalau kategorinya tidak ada,
    // data kategori akan bernilai null

    return List.generate(maps.length, (index) {
      // List.generate dipakai untuk membuat List<Product>
      // dari data maps hasil query
      //
      // maps.length artinya jumlah data hasil query
      //
      // index adalah nomor urutan data

      final productMap = maps[index];
      // Mengambil 1 data produk dari hasil query
      //
      // productMap bentuknya Map<String, dynamic>

      final categoryMap = {
        'id': productMap['category_id'],
        'name': productMap['category_name'],
        'description': productMap['category_description'],
        'image': productMap['category_image'],
        'createdAt': productMap['category_created_at'],
        'updatedAt': productMap['category_updated_at'],
      };
      // Membuat Map khusus untuk kategori
      //
      // Karena data hasil query tadi gabungan antara produk dan kategori,
      // maka data kategori dipisahkan dulu ke categoryMap
      //
      // categoryMap ini nanti diubah menjadi object Category

      return Product.fromLocalMap(productMap)
          .copyWith(category: Category.fromMap(categoryMap));
      // Product.fromLocalMap(productMap)
      // mengubah data Map dari database menjadi object Product
      //
      // .copyWith(category: ...)
      // artinya membuat salinan Product,
      // tapi bagian category-nya diisi dengan object Category
      //
      // Category.fromMap(categoryMap)
      // mengubah Map kategori menjadi object Category
      //
      // Hasil akhirnya:
      // Product yang sudah punya data category
    });
  }

  Future<int> insertOrder(OrderModel order) async {
    // Function untuk menyimpan order/transaksi ke database lokal
    //
    // Hasilnya Future<int>
    // Artinya setelah order disimpan,
    // function ini mengembalikan id order yang baru dibuat

    final db = await instance.database;
    // Mengambil database

    int id = await db.insert(
      tableOrder,
      order.toMapForLocal(),
      // order.toMapForLocal() mengubah object OrderModel
      // menjadi Map<String, dynamic>
      //
      // Map ini yang disimpan ke tabel orders

      conflictAlgorithm: ConflictAlgorithm.replace,
      // Kalau ada konflik data,
      // data lama diganti dengan data baru
    );

    for (var orderItem in order.orders) {
      // Loop semua item yang ada di dalam order
      //
      // Misalnya dalam satu transaksi ada beberapa produk,
      // maka setiap produknya disimpan ke tabel order_items

      await db.insert(
        tableOrderItems,
        orderItem.toMapForLocal(id),
        // orderItem.toMapForLocal(id)
        // mengubah item order menjadi Map
        //
        // id dikirim supaya order item tahu dia milik order yang mana
        //
        // Jadi id order utama disimpan sebagai id_order di tabel order_items

        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return id;
    // Mengembalikan id order yang baru disimpan
    //
    // Id ini bisa dipakai untuk kebutuhan lain,
    // misalnya mengambil detail order item
  }

  Future<List<OrderModel>> getAllOrder() async {
    // Function untuk mengambil semua data order dari database lokal

    final db = await instance.database;
    // Mengambil database

    final result = await db.query('orders', orderBy: 'id DESC');
    // db.query dipakai untuk mengambil data dari tabel
    //
    // 'orders' adalah nama tabel yang diambil
    //
    // orderBy: 'id DESC'
    // artinya data diurutkan berdasarkan id dari paling besar ke paling kecil
    //
    // Jadi order terbaru akan tampil paling atas

    return result.map((e) => OrderModel.fromLocalMap(e)).toList();
    // result bentuknya List<Map<String, dynamic>>
    //
    // map dipakai untuk mengubah setiap Map menjadi OrderModel
    //
    // e adalah 1 data order dalam bentuk Map
    //
    // OrderModel.fromLocalMap(e) mengubah Map menjadi object OrderModel
    //
    // toList() mengubah hasil map menjadi List<OrderModel>
  }

  Future<List<OrderModel>> getOrdersIsSyncFalse() async {
    // Function untuk mengambil order yang belum berhasil sync ke server
    //
    // Biasanya dipakai saat aplikasi offline
    // Lalu ketika online lagi, order yang belum sync dikirim ulang ke server

    final db = await instance.database;
    // Mengambil database

    final result = await db.query('orders', where: 'is_sync = 0');
    // Mengambil data dari tabel orders
    //
    // where: 'is_sync = 0'
    // artinya hanya ambil order yang belum sync
    //
    // 0 = belum sync
    // 1 = sudah sync

    return result.map((e) => OrderModel.fromLocalMap(e)).toList();
    // Mengubah hasil query dari Map menjadi List<OrderModel>
  }

  Future<void> updateOrderIsSync(int id) async {
    // Function untuk mengubah status order menjadi sudah sync
    //
    // id adalah id order yang ingin diupdate

    final db = await instance.database;
    // Mengambil database

    await db.update(
      'orders',
      // Nama tabel yang diupdate

      {'is_sync': 1},
      // Data yang mau diubah
      //
      // is_sync dibuat menjadi 1
      // Artinya order ini sudah berhasil disinkronkan ke server

      where: 'id = ?',
      // where dipakai untuk menentukan data mana yang mau diupdate
      //
      // id = ? artinya cari order yang id-nya sama dengan nilai dari whereArgs
      //
      // Kenapa pakai ?
      // Supaya lebih aman dari SQL Injection
      //
      // SQL Injection itu teknik menyisipkan query berbahaya
      // lewat input yang tidak aman

      whereArgs: [id],
      // whereArgs adalah nilai pengganti tanda ?
      //
      // Jadi ? akan diganti dengan nilai id
    );
  }

  Future<List<OrderItemModel>> getOrderItemsByIdOrder(int idOrder) async {
    // Function untuk mengambil semua order item berdasarkan id order
    //
    // Misalnya order id 5 punya 3 produk,
    // maka function ini mengambil 3 item tersebut

    final db = await instance.database;
    // Mengambil database

    final result = await db.query(
      'order_items',
      where: 'id_order = $idOrder',
    );
    // Mengambil data dari tabel order_items
    //
    // where: 'id_order = $idOrder'
    // artinya ambil order item yang id_order-nya sesuai idOrder
    //
    // Catatan penting:
    // Cara ini masih langsung memasukkan nilai idOrder ke query
    //
    // Lebih aman ditulis seperti ini:
    //
    // final result = await db.query(
    //   'order_items',
    //   where: 'id_order = ?',
    //   whereArgs: [idOrder],
    // );
    //
    // Supaya lebih aman dan konsisten seperti updateOrderIsSync

    return result.map((e) => OrderItemModel.fromMap(e)).toList();
    // Mengubah hasil query dari Map menjadi List<OrderItemModel>
    //
    // e adalah 1 data order item dalam bentuk Map
    //
    // OrderItemModel.fromMap(e)
    // mengubah Map menjadi object OrderItemModel
  }

  Future<void> insertAllCategory(List<Category> categories) async {
    // Function untuk menyimpan banyak kategori ke database lokal
    //
    // categories adalah list kategori dari API/server

    final db = await instance.database;
    // Mengambil database

    for (var category in categories) {
      // Loop semua kategori satu per satu

      await db.insert(
        tableCategories,
        category.toMap(),
        // category.toMap() mengubah object Category
        // menjadi Map<String, dynamic>
        //
        // Karena sqflite menyimpan data dalam bentuk Map

        conflictAlgorithm: ConflictAlgorithm.replace,
        // Kalau data sudah ada,
        // maka diganti dengan data baru
      );
    }
  }

  Future<void> removeAllCategory() async {
    // Function untuk menghapus semua data kategori lokal

    final db = await instance.database;
    // Mengambil database

    await db.delete(tableCategories);
    // Menghapus semua isi tabel category
    //
    // Karena tidak ada where,
    // semua data category akan terhapus
  }
}