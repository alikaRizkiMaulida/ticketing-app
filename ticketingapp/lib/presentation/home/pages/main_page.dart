import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketingapp/core/assets/assets.dart';
import 'package:ticketingapp/core/constants/colors.dart';
import 'package:ticketingapp/presentation/home/bloc/product/product_bloc.dart';
import 'package:ticketingapp/presentation/home/pages/history_page.dart';
import 'package:ticketingapp/presentation/home/pages/order_page.dart';
import 'package:ticketingapp/presentation/home/pages/qr_scanner.dart';
import 'package:ticketingapp/presentation/home/pages/setting_page.dart';
import 'package:ticketingapp/presentation/home/pages/ticket_page.dart';
import 'package:ticketingapp/presentation/home/widget/nav_item.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final _pages = [
    const OrderPage(),
    const TicketPage(),
    const HistoryPage(),
    const SettingPage(),
    const SettingPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 30,
                blurStyle: BlurStyle.outer,
                spreadRadius: 0,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                  iconPath: Assets.icons.nav.home.path,
                  label: 'Home',
                  isActive: _selectedIndex == 0,
                  onTap: () => _onItemTapped(0)),
              NavItem(
                  iconPath: Assets.icons.nav.ticket.path,
                  label: 'Ticket',
                  isActive: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1)),
              NavItem(
                  iconPath: Assets.icons.nav.history.path,
                  label: 'History',
                  isActive: _selectedIndex == 2,
                  onTap: () => _onItemTapped(2)),
              NavItem(
                  iconPath: Assets.icons.nav.setting.path,
                  label: 'Setting',
                  isActive: _selectedIndex == 3,
                  onTap: () => _onItemTapped(3)),
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const QrScannerPage()));
          },
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.primary),
            child: Assets.icons.nav.scan.svg(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
