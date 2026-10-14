import 'package:flutter/material.dart';
import 'package:ticketingapp/core/assets/assets.dart';
import 'package:ticketingapp/core/components/components.dart';
import 'package:ticketingapp/core/constants/colors.dart';
import 'package:ticketingapp/core/core.dart';
import 'package:ticketingapp/data/model/response/product_response_model.dart';
import 'package:ticketingapp/presentation/home/dialog/delete_ticket_dialog.dart';
import 'package:ticketingapp/presentation/home/dialog/edit_ticket_dialog.dart';

class TicketCardWidget extends StatelessWidget {
  final Product item;
  const TicketCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.stroke),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name ?? '', style: TextStyle(fontSize: 16.0),),
                    Text(item.category!.name ?? '', style: TextStyle(fontSize: 12.0),),
                  ],
                ),),
                IconButton(onPressed: () {
                  showDialog(context: context, builder: (context) =>  DeleteTicketDialog(id: item.id!,));
                }, icon: Assets.icons.delete.svg(),),
                
                IconButton(onPressed: () {
                  showDialog(context: context, builder: (context) => EditTicketDialog(item: item,));
                }, icon: Assets.icons.edit.svg(),),
            ],
          ),
          SpaceHeight(8.0),
          Text(item.price!.currencyFormatRp, style: TextStyle(fontWeight: FontWeight.w800),)
        ],
      ),
    );
  }
}