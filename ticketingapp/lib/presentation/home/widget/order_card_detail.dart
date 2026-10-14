import 'package:flutter/material.dart';
import 'package:ticketingapp/core/components/components.dart';
import 'package:ticketingapp/core/constants/colors.dart';
import 'package:ticketingapp/core/core.dart';
import 'package:ticketingapp/presentation/home/bloc/checkout/model/order_item.dart';

class OrderCardDetail extends StatelessWidget {
  final OrderItem item;
  const OrderCardDetail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.stroke),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.product.name ?? '',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            item.product.category?.name ?? '',
            style: TextStyle(fontSize: 16.0),
          ),
          SpaceHeight(8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${item.product.price!.currencyFormatRp} x ${item.quantity}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                (item.product.price! * item.quantity).currencyFormatRp,
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}