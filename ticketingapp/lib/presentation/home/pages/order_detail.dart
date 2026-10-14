import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketingapp/core/core.dart';
import 'package:ticketingapp/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/checkout/model/order_item.dart';
import 'package:ticketingapp/presentation/home/bloc/order/order_bloc.dart';
import 'package:ticketingapp/presentation/home/dialog/payment_cash_dialog.dart';
import 'package:ticketingapp/presentation/home/dialog/payment_qris_dialog.dart';
import 'package:ticketingapp/presentation/home/widget/order_card_detail.dart';
import 'package:ticketingapp/presentation/home/widget/payment_method.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  int totalPrice = 0;
  List<OrderItem> orderItems = [];
  @override
  Widget build(BuildContext context) {
    int paymentButtonIndex = 0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Detail Pesanan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Assets.images.back.image(),
          ),
        ),
      ),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          final products = state.maybeWhen(
            orElse: () => [],
            success: (checkout) => checkout,
          );
          return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              itemBuilder: (context, index) {
                return OrderCardDetail(item: products[index]);
              },
              separatorBuilder: (context, index) => const SpaceHeight(20.0),
              itemCount: products.length);
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatefulBuilder(
            builder: (context, setState) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: PaymentMethodWidget(
                      iconPath: Assets.icons.payment.qris.path,
                      label: 'QRIS',
                      isActive: paymentButtonIndex == 0,
                      onPressed: () => setState(() => paymentButtonIndex = 0),
                    ),
                  ),
                  SpaceWidth(5.0),
                  Expanded(
                    child: PaymentMethodWidget(
                      iconPath: Assets.icons.payment.tunai.path,
                      label: 'Tunai',
                      isActive: paymentButtonIndex == 1,
                      onPressed: () => setState(() => paymentButtonIndex = 1),
                    ),
                  ),
                  SpaceWidth(5.0),
                  Expanded(
                    child: PaymentMethodWidget(
                      iconPath: Assets.icons.payment.transfer.path,
                      label: 'Transfer',
                      isActive: paymentButtonIndex == 2,
                      onPressed: () => setState(() => paymentButtonIndex = 2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SpaceHeight(24.0),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10.0,
                    spreadRadius: 0,
                    offset: Offset(0, -2),
                    color: AppColors.black.withOpacity(0.3),
                    blurStyle: BlurStyle.outer),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      BlocBuilder<CheckoutBloc, CheckoutState>(
                        builder: (context, state) {
                          return state.maybeWhen(
                            success: (checkout) {
                              orderItems = checkout;
                              final total = checkout.fold<int>(
                                0,
                                (previousValue, element) =>
                                    previousValue +
                                    element.product.price! * element.quantity,
                              );
                              totalPrice = total;
                              return Text(
                                total.currencyFormatRp,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              );
                            },
                            orElse: () => Text(
                              '0',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Button.filled(
                    onPressed: () {
                      if (paymentButtonIndex == 0) {
                        showDialog(
                            context: context,
                            builder: (context) => const PaymentQrisDialog());
                      } else if (paymentButtonIndex == 1) {
                        context.read<OrderBloc>().add(
                            OrderEvent.addPaymentMethod('Tunai', orderItems));
                        showDialog(
                            context: context,
                            builder: (context) =>
                                PaymentCashDialog(totalPrice: totalPrice, ));
                      }
                    },
                    label: 'Process',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
