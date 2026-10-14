// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ticketingapp/core/components/components.dart';
import 'package:ticketingapp/core/constants/colors.dart';
import 'package:ticketingapp/core/core.dart';
import 'package:ticketingapp/presentation/home/bloc/product/product_bloc.dart';

class DeleteTicketDialog extends StatelessWidget {
  final int id;
  const DeleteTicketDialog({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Hapus Data',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SpaceHeight(12.0),
          Text(
            'Apakah anda yakin untuk menghapus data ini?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.black.withOpacity(0.6),
            ),
          ),
          SpaceHeight(10.0),
          Row(
            children: [
              Flexible(
                child: Button.filled(
                  onPressed: () => context.pop(),
                  label: 'Batalkan',
                  textColor: AppColors.black.withOpacity(0.5),
                  color: AppColors.buttonCancel,
                ),
              ),
              SpaceWidth(12.0),
              Flexible(
                child: Button.filled(
                  onPressed: () {
                    context
                        .read<ProductBloc>()
                        .add(ProductEvent.deleteTicket(id));
                        context.pop();
                  },
                  label: 'Hapus',
                  color: AppColors.primary,
                  textColor: AppColors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
