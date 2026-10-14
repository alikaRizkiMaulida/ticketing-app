import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:ticketingapp/core/constants/colors.dart';
import 'package:ticketingapp/core/core.dart';
import 'package:ticketingapp/presentation/home/widget/menu_printer_button.dart';
import 'package:ticketingapp/presentation/home/widget/menu_printer_content.dart';

class SettingPrinterPage extends StatefulWidget {
  const SettingPrinterPage({super.key});

  @override
  State<SettingPrinterPage> createState() => _SettingPrinterPageState();
}

class _SettingPrinterPageState extends State<SettingPrinterPage> {
  int selectedIndex = 0;

  String _info = "";
  String macName = '';
  String _msj = '';
  bool connected = false;
  List<BluetoothInfo> items = [];

  bool _progress = false;
  String _msjprogress = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    int porcentbatery = 0;

    try {
      platformVersion = await PrintBluetoothThermal.platformVersion;
      porcentbatery = await PrintBluetoothThermal.batteryLevel;
    } on PlatformException {
      platformVersion = "Failed to get platform version";
    }

    if (!mounted) return;

    final bool bluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;

    setState(() {
      _info = "$platformVersion ($porcentbatery% battery)";
      _msj = bluetoothEnabled
          ? "Bluetooth aktif, silakan search printer"
          : "Bluetooth belum aktif, nyalakan Bluetooth dulu";
    });
  }

  Future<bool> requestBluetoothPermission() async {
    if (!Platform.isAndroid) return true;

    final bluetoothScanStatus = await Permission.bluetoothScan.request();
    final bluetoothConnectStatus = await Permission.bluetoothConnect.request();

    // Beberapa device/package masih butuh location untuk baca paired devices
    final locationStatus = await Permission.location.request();

    final isGranted = bluetoothScanStatus.isGranted &&
        bluetoothConnectStatus.isGranted &&
        locationStatus.isGranted;

    if (!isGranted) {
      if (!mounted) return false;

      setState(() {
        _msj =
            "Permission Bluetooth belum aktif. Aktifkan Nearby devices dan Location di Settings.";
      });

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Permission dibutuhkan"),
            content: const Text(
              "Aplikasi butuh izin Nearby devices dan Location agar bisa membaca printer Bluetooth POS58B.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Nanti"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                child: const Text("Buka Settings"),
              ),
            ],
          );
        },
      );

      return false;
    }

    return true;
  }

  Future<void> getBluetooth() async {
    final permissionGranted = await requestBluetoothPermission();

    if (!permissionGranted) {
      return;
    }

    final bool bluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;

    if (!bluetoothEnabled) {
      if (!mounted) return;
      setState(() {
        _msj = "Bluetooth belum aktif. Nyalakan Bluetooth dulu.";
      });
      return;
    }

    setState(() {
      _progress = true;
      _msjprogress = "Mencari printer...";
      items = [];
      _msj = "";
    });

    try {
      final List<BluetoothInfo> listResult =
          await PrintBluetoothThermal.pairedBluetooths;

      if (!mounted) return;

      setState(() {
        _progress = false;
        items = listResult;
        _msj = listResult.isEmpty
            ? "Tidak ada printer. Pair printer dari Settings Bluetooth HP dulu."
            : "Pilih printer untuk connect.";
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _progress = false;
        _msj = "Gagal mencari printer: $e";
      });
    }
  }

  Future<void> connect(String mac) async {
    final permissionGranted = await requestBluetoothPermission();

    if (!permissionGranted) {
      return;
    }

    setState(() {
      _progress = true;
      _msjprogress = "Menghubungkan printer...";
      connected = false;
    });

    try {
      final bool result =
          await PrintBluetoothThermal.connect(macPrinterAddress: mac);

      if (!mounted) return;

      setState(() {
        _progress = false;
        connected = result;
        macName = mac;
        _msj = result
            ? "Printer berhasil terhubung"
            : "Gagal connect printer. Pastikan printer menyala dan sudah paired.";
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _progress = false;
        connected = false;
        _msj = "Gagal connect printer: $e";
      });
    }
  }

  Future<void> disconnect() async {
    try {
      final bool status = await PrintBluetoothThermal.disconnect;

      if (!mounted) return;

      setState(() {
        connected = false;
        macName = '';
        _msj = status ? "Printer berhasil disconnect" : "Gagal disconnect";
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        connected = false;
        _msj = "Error disconnect: $e";
      });
    }
  }

  Future<void> testPrint() async {
    final permissionGranted = await requestBluetoothPermission();

    if (!permissionGranted) {
      return;
    }

    final bool isConnected = await PrintBluetoothThermal.connectionStatus;

    if (!isConnected) {
      if (!mounted) return;

      setState(() {
        connected = false;
        _msj = "Printer belum terhubung. Pilih printer dulu sebelum test print.";
      });

      return;
    }

    setState(() {
      _progress = true;
      _msjprogress = "Mencetak test print...";
    });

    try {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);

      List<int> bytes = [];

      bytes += generator.text(
        'TICKETING APP',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );

      bytes += generator.text(
        'Test Printer POS58B',
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      bytes += generator.hr();

      bytes += generator.text('Status : Berhasil connect');
      bytes += generator.text('Printer: $macName');

      bytes += generator.hr();

      bytes += generator.text(
        'Terima kasih',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
        ),
      );

      bytes += generator.feed(2);
      bytes += generator.cut();

      final bool result = await PrintBluetoothThermal.writeBytes(bytes);

      if (!mounted) return;

      setState(() {
        _progress = false;
        _msj = result ? "Test print berhasil" : "Test print gagal";
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _progress = false;
        _msj = "Error test print: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Kelola Printer',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Assets.images.back.image(),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.stroke,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: MenuPrinterButton(
                    label: 'Search',
                    onPressed: () async {
                      setState(() {
                        selectedIndex = 0;
                      });
                      await getBluetooth();
                    },
                    isActive: selectedIndex == 0,
                  ),
                ),
                Expanded(
                  child: MenuPrinterButton(
                    label: 'Disconnect',
                    onPressed: () async {
                      setState(() {
                        selectedIndex = 1;
                      });
                      await disconnect();
                    },
                    isActive: selectedIndex == 1,
                  ),
                ),
                Expanded(
                  child: MenuPrinterButton(
                    label: 'Test',
                    onPressed: () async {
                      setState(() {
                        selectedIndex = 2;
                      });
                      await testPrint();
                    },
                    isActive: selectedIndex == 2,
                  ),
                ),
              ],
            ),
          ),

          const SpaceHeight(20.0),

          Text(
            "Info: $_info",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),

          const SpaceHeight(8.0),

          Text(
            _msj,
            style: TextStyle(
              fontSize: 13,
              color: connected ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),

          if (_progress) ...[
            const SpaceHeight(16.0),
            Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _msjprogress,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],

          const SpaceHeight(28.0),

          _Body(
            macName: macName,
            data: items,
            clickHandler: (mac) async {
              await connect(mac);
            },
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String macName;
  final List<BluetoothInfo> data;
  final Function(String) clickHandler;

  const _Body({
    required this.data,
    required this.macName,
    required this.clickHandler,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: AppColors.stroke,
          ),
        ),
        child: const Center(
          child: Text(
            'Tidak ada data printer',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 30.0,
            spreadRadius: 0,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: ListView.separated(
        itemBuilder: (context, index) {
          final item = data[index];

          return InkWell(
            onTap: () {
              clickHandler(item.macAdress);
            },
            child: MenuPrinterContent(
              isSelected: macName == item.macAdress,
              data: item,
            ),
          );
        },
        separatorBuilder: (context, index) => const SpaceHeight(16.0),
        itemCount: data.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}