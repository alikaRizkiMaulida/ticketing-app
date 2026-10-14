import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketingapp/core/assets/assets.dart';
import 'package:ticketingapp/core/components/spaces.dart';
import 'package:ticketingapp/core/constants/colors.dart';
import 'package:ticketingapp/data/model/response/product_response_model.dart';
import 'package:ticketingapp/presentation/home/bloc/product/product_bloc.dart';
import 'package:ticketingapp/presentation/home/dialog/add_ticket_dialog.dart';
import 'package:ticketingapp/presentation/home/widget/ticket_widget.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  void initState() {
    context.read<ProductBloc>().add(ProductEvent.getProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text(
              'Ticket Page',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context, builder: (context) => AddTicketDialog());
                },
                icon: Assets.icons.plus.svg(),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            List<Product> products = state.maybeWhen(
              orElse: () => [],
              success: (products) => products,
            );
            return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) => TicketCardWidget(
                      item: products[index],
                    ),
                separatorBuilder: (context, index) => const SpaceHeight(20.0),
                itemCount: products.length);
          },
        ));
  }
}
