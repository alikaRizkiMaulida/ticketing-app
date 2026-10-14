import 'package:intl/intl.dart';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:ticketingapp/core/core.dart';
import 'package:ticketingapp/data/datasource/auth_local_datasource.dart';
import 'package:ticketingapp/presentation/home/bloc/checkout/model/order_model.dart';

class TransactionsPrint {
  TransactionsPrint._init();

// Kita bikin class untuk kelola print transaksi
// Supaya lebih terstruktur dan gampang di maintain
// Kita bikin singleton supaya kita bisa akses class ini dari mana aja tanpa harus bikin instance baru
// contructor private
  static final TransactionsPrint instance = TransactionsPrint._init();

  // Future<List<int>> printQRCode(String qrCodeString) async {
  //   List<int> bytes = [];

  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm58, profile);

  //   bytes += generator.reset();

  //   bytes += generator.text('TIKET WISATA JAYLA',
  //       styles: const PosStyles(
  //         align: PosAlign.center,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //         bold: true,
  //       ));
  //   bytes += generator.feed(1);
  //   bytes += generator.text(
  //     'Tanggal : ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now())}',
  //     styles: const PosStyles(
  //       align: PosAlign.center,
  //       height: PosTextSize.size2,
  //       width: PosTextSize.size2,
  //       bold: true,
  //     ),
  //   );
  //   bytes += generator.feed(1);

  //   bytes += generator.text('~~~ Tengkyu honey bunbun ~~',
  //   styles: const PosStyles(
  //     bold: true,
  //     align: PosAlign.center,
  //   ));

  //   bytes += generator.feed(3);

  //   return bytes;
  // }

// Karena kita mau print transaksi, kita butuh data transaksi yang udah ada
// Kita ambil data transaksi dari order model yang udah kita buat sebelumnya
  Future<List<int>> printTransaction(OrderModel order) async {
    // Kita bikin list of int untuk nyimpen data yang mau kita print
    // Kita pake list of int karena printer thermal butuh data dalam bentuk bytes
    List<int> bytes = [];

    try {
      // Kita ambil data auth dari local datasource
      // Kita ambil nama kasir dari auth data yang udah kita simpen sebelumnya
      final authData = await AuthLocalDatasource().getAuthData();
      final namaKasir = authData.user?.name ?? 'Ujang Kedu';

      // Kita bikin profile untuk printer thermal
      // ambil pengaturan printer
      final profile = await CapabilityProfile.load();
      // generator sebagai alat bantu untuk membentuk teks yang bisa dibaca oleh printer
      final generator = Generator(PaperSize.mm58, profile);

// Kita mulai print dengan reset printer
      // Ini buat ngatur printer ke pengaturan awal
      bytes += generator.reset();

      // += : menambahkan data baru hasil dari sebelumnya kedalam list bytes
// Analoginya gini
//       List<int> bytes = [1, 2, 3];
// bytes += [4, 5]; // sekarang bytes = [1, 2, 3, 4, 5]

// kalau pake = aja

//  List<int> bytes = [1, 2, 3];
// bytes = [4, 5]; // sekarang bytes = [4, 5]

      // Header
      bytes += generator.text('==================',
          styles: const PosStyles(align: PosAlign.center, bold: true));
      bytes += generator.text('TIKET WISATA JAYLA',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true,
          ), containsChinese: true);
      bytes += generator.text('==================',
          styles: const PosStyles(align: PosAlign.center, bold: true));
      bytes += generator.feed(1);

      // Detail
      bytes += generator.row([
        PosColumn(text: 'No. Transaksi : ', width: 6),
        PosColumn(
            text: order.id != null ? 'TRX-${order.id}' : 'TRX-NEW',
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            )),
      ]);

      bytes += generator.row([
        PosColumn(text: 'Tanggal : ', width: 6),
        PosColumn(
            text: DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),
            width: 6),
      ]);

      bytes += generator.row([
        PosColumn(text: 'Kasir : ', width: 6),
        PosColumn(text: namaKasir, width: 6),
      ]);
      bytes += generator.feed(1);

      // Detail Item
      for (var item in order.orders) {
        bytes += generator.row([
          PosColumn(
            text: item.product.name ?? '',
            width: 8,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: 'x${item.quantity}',
            width: 4,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);

        // Detail Harga
        bytes += generator.row([
          PosColumn(text: '', width: 6),
          PosColumn(
              text: item.product.price!.currencyFormatRp,
              width: 6,
              styles: const PosStyles(
                align: PosAlign.right,
              )),
        ]);
      }

      bytes += generator.text('-------------------',
          styles: const PosStyles(align: PosAlign.center, bold: true));

      // Total harga
      bytes += generator.row([
        PosColumn(text: 'Total : ', width: 6, styles: PosStyles(bold: true)),
        PosColumn(
            text: order.totalPrice.currencyFormatRp,
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
            )),
      ]);

// Baru sampai sini
      // Payment Method
      bytes += generator.feed(1);
      bytes += generator.row([
        PosColumn(text: 'Metode Bayar : ', width: 6),
        PosColumn(
            text: order.paymentMethod,
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            )),
      ]);

      // PENUTUP
      bytes += generator.feed(1);
      bytes += generator.text('~~~ Tengkyu Honey Bunbun ~~~',
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
          ));
      bytes += generator.text('Selamat menikmati wisata anda !',
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
          ));

      bytes += generator.text('==================',
          styles: const PosStyles(align: PosAlign.center, bold: true));

      bytes += generator.feed(1);
      bytes += generator.cut();
      return bytes;
    } catch (e) {
      print('Error print transaksi ');
      rethrow;
    }
  }
}
