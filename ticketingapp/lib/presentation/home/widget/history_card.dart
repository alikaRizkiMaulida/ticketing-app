import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:ticketingapp/presentation/home/bloc/checkout/model/order_model.dart';

import '../../../../../core/core.dart';

class HistoryCard extends StatelessWidget {
  final OrderModel item;
  const HistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.stroke),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 6.0,
              spreadRadius: 2.0,
              offset: Offset(0, 4.0),
            )
          ]),
      child: Row(
        children: [
          Assets.icons.plus.svg(),
          const SpaceWidth(10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiket ${item.id.toString()}',
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SpaceHeight(5.0),
              Text(
                // ubah date format jadi objek DateTTime
                DateFormat('dd MMMM yyyy').format(DateTime(
                  // buat ngambil tahun
                    int.parse(item.transactionTime.substring(0, 4)),
                    // buat ngambil bulan
                    int.parse(item.transactionTime.substring(5, 7)),
                    // buat ngambil tanggal
                    int.parse(item.transactionTime.substring(8, 10)))),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            item.totalPrice.currencyFormatRp,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
