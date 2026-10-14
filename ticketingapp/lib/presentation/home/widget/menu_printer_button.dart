import 'package:flutter/material.dart';
import 'package:ticketingapp/core/core.dart';

class MenuPrinterButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isActive;
  const MenuPrinterButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: context.deviceWidth,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.white : AppColors.stroke,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive ? const [
              BoxShadow(
                color: AppColors.white,
                blurRadius: 2,
                offset: Offset(0, 1),
                spreadRadius: 0,
              )
            ] : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isActive ? AppColors.primary :AppColors.grey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ));
  }
}
