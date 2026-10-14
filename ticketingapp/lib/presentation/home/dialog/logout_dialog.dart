import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketingapp/core/components/components.dart';
import 'package:ticketingapp/core/constants/colors.dart';
import 'package:ticketingapp/core/core.dart';
import 'package:ticketingapp/data/datasource/auth_local_datasource.dart';
import 'package:ticketingapp/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:ticketingapp/presentation/auth/pages/splash_screen.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Logout',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            'Apakah kamu yakin mau keluar dari Ticketing App?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: AppColors.black.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Button.filled(
                  onPressed: () => context.pop(),
                  label: 'Batal',
                  borderRadius: 8,
                  color: AppColors.buttonCancel,
                  textColor: Colors.blueGrey,
                  height: 44.0,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Button.filled(
                  onPressed: () async {
                    context.pop();
                    await AuthLocalDatasource().removeAuthData();
                    context.pushReplacement(SplashScreen());
                  },
                  label: 'Logout',
                  borderRadius: 8,
                  color: AppColors.primary,
                  textColor: Colors.white,
                  height: 44.0,
                  fontSize: 16.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
