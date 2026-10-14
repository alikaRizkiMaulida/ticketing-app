import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ticketingapp/core/components/components.dart';
import 'package:ticketingapp/core/constants/colors.dart';

class SyncDialog extends StatelessWidget {
  const SyncDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpaceHeight(40.0),
          SpinKitDualRing(
            color: AppColors.primary,
            size: 80.0,
          ),
          SpaceHeight(25.0),
          Text(
            'Sync Data',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600
            ),
          )
        ],
      ),
    );
  }
}
