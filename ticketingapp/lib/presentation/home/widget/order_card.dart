import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketingapp/core/assets/assets.dart';
import 'package:ticketingapp/core/components/spaces.dart';
import 'package:ticketingapp/core/constants/colors.dart';
import 'package:ticketingapp/core/core.dart';
import 'package:ticketingapp/data/model/response/product_response_model.dart';
import 'package:ticketingapp/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/checkout/model/order_item.dart';
import 'package:ticketingapp/presentation/home/bloc/like/like_bloc.dart';

class OrderCard extends StatefulWidget {
  final Product item;
  const OrderCard({
    super.key,
    required this.item,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.stroke),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.item.name ?? '',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  context.read<CheckoutBloc>().add(
                        CheckoutEvent.removeCheckout(widget.item),
                      );
                },
                child: Assets.icons.reduceQuantity.svg(),
              ),
              BlocBuilder<CheckoutBloc, CheckoutState>(
                  builder: (context, state) {
                final quantity = state.maybeWhen(
                  success: (checkout) => checkout
                      .firstWhere(
                        (e) => e.product.id == widget.item.id,
                        orElse: () =>
                            OrderItem(product: widget.item, quantity: 0),
                      )
                      .quantity,
                  orElse: () => 0,
                );
                return Text(
                  quantity.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              }),
              InkWell(
                onTap: () {
                  context
                      .read<CheckoutBloc>()
                      .add(CheckoutEvent.addCheckout(widget.item));
                },
                child: Assets.icons.addQuantity.svg(),
              ),
              const SizedBox(width: 8),
              BlocConsumer<LikeBloc, LikeState>(
                listenWhen: (previous, current) => 
                  current.maybeWhen(
                    success: (_) => true,
                    successGetLikedProducts: (_) => true,
                    orElse: () => false,
                  ),
                listener: (context, state) {
                  state.maybeWhen(
                    success: (message) {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    successGetLikedProducts: (products) {
                      final isProductLiked = products.any((p) => p.id == widget.item.id);
                      if (isLiked != isProductLiked) {
                        setState(() {
                          isLiked = isProductLiked;
                        });
                      }
                    },
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      if (widget.item.id != null) {
                        context.read<LikeBloc>().add(
                          LikeEvent.toggleLike(widget.item.id!),
                        );
                      }
                    },
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
          const SpaceHeight(8.0),
          Row(
            children: [
              Text(
                'Category: ',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                ),
              ),
              Text(
                widget.item.category?.name ?? 'Unknown',
                style: const TextStyle(fontSize: 12.0),
              ),
            ],
          ),
          const SpaceHeight(8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.item.price!.currencyFormatRp,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              BlocBuilder<CheckoutBloc, CheckoutState>(
                  builder: (context, state) {
                return state.maybeWhen(
                  success: (checkout) {
                    final quantity = checkout
                        .firstWhere(
                          (e) => e.product.id == widget.item.id,
                          orElse: () =>
                              OrderItem(product: widget.item, quantity: 0),
                        )
                        .quantity;
                    return Text(
                      (widget.item.price! * quantity).currencyFormatRp,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    );
                  },
                  orElse: () => Text(
                    '0',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
