import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketingapp/core/assets/assets.dart';
import 'package:ticketingapp/core/constants/colors.dart';
import 'package:ticketingapp/data/datasource/product_local_datasource.dart';
import 'package:ticketingapp/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:ticketingapp/presentation/auth/pages/login_page.dart';
import 'package:ticketingapp/presentation/home/bloc/category/category_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/product/product_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/sync_order/sync_order_bloc.dart';
import 'package:ticketingapp/presentation/home/dialog/logout_dialog.dart';
import 'package:ticketingapp/presentation/home/pages/profile_page.dart';
import 'package:ticketingapp/presentation/home/pages/setting_printer_page.dart';
import 'package:ticketingapp/presentation/home/widget/setting_button.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: EdgeInsets.all(24.0),
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        children: [
          SettingButton(
            iconPath: Assets.icons.settings.printer.path,
            title: 'Printer',
            subtitle: 'Kelola Printer',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => const SettingPrinterPage());
            },
          ),
          // Bloc Consumer itu kombinasi antara bloc Builder dan bloc listener
          // Digunakan jika butuh untuk dengerin perubahan state dn bangun UI di satu tempat
          BlocConsumer<LogoutBloc, LogoutState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: () {
                  // Langsung navigasi ke LoginPage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              );
            },
            builder: (context, state) {
              return SettingButton(
                iconPath: Assets.icons.settings.logout.path,
                title: 'Logout',
                subtitle: 'Keluar dari aplikasi',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const LogoutDialog(),
                  );
                },
              );
            },
          ),

          BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.red,
                    ));
                  },
                  success: (categories) {
                    ProductLocalDatasource.instance.removeAllCategory();
                    ProductLocalDatasource.instance
                        .insertAllCategory(categories);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Sync Kategori berhasil'),
                      backgroundColor: AppColors.primary,
                    ));
                  });
            },
            builder: (context, state) {
              return state.maybeWhen(
                loading: () {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                orElse: () {
                  return SettingButton(
                    iconPath: Assets.icons.settings.syncData.path,
                    title: 'Sync Category',
                    subtitle: 'Sync Data Kategori',
                    onPressed: () {
                      context.read<CategoryBloc>().add(CategoryEvent.fetch());
                    },
                  );
                },
              );
            },
          ),
          BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.red,
                    ));
                  },
                  success: (products) {
                    ProductLocalDatasource.instance.removeAllProduct();
                    ProductLocalDatasource.instance.insertAllProduct(products);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Sync Produk berhasil'),
                      backgroundColor: AppColors.primary,
                    ));
                  });
            },
            builder: (context, state) {
              return state.maybeWhen(
                loading: () {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                orElse: () {
                  return SettingButton(
                    iconPath: Assets.icons.settings.syncData.path,
                    title: 'Sync Product',
                    subtitle: 'Sync Data Produk',
                    onPressed: () {
                      context
                          .read<ProductBloc>()
                          .add(ProductEvent.getProducts());
                    },
                  );
                },
              );
            },
          ),
          BlocConsumer<SyncOrderBloc, SyncOrderState>(
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.red,
                    ));
                  },
                  success: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Sync Data Order Berhasil'),
                      backgroundColor: AppColors.primary,
                    ));
                  });
            },
            builder: (context, state) {
              return state.maybeWhen(
                loading: () {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                orElse: () {
                  return SettingButton(
                    iconPath: Assets.icons.settings.syncData.path,
                    title: 'Sync Orders',
                    subtitle: 'Sync Data Order',
                    onPressed: () {
                      context
                          .read<SyncOrderBloc>()
                          .add(const SyncOrderEvent.syncOrder());
                    },
                  );
                },
              );
            },
          ),
          SettingButton(
            iconPath: Assets.icons.settings.printer.path,
            title: 'Profile',
            subtitle: 'Kelola Profile',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => const ProfilePage());
            },
          ),
        ],
      ),
    );
  }
}
