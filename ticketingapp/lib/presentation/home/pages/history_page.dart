import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketingapp/core/core.dart';
import 'package:ticketingapp/presentation/home/bloc/checkout/model/order_model.dart';
import 'package:ticketingapp/presentation/home/bloc/history/history_bloc.dart';
import 'package:ticketingapp/presentation/home/widget/history_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    context.read<HistoryBloc>().add(HistoryEvent.getHistories());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Transaction History',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          return state.maybeWhen(
            success: (orders) {
              if (orders.isEmpty) {
                return const Center(
                  child: Text('Tidak ada data transaksi'),
                );
              }

              // Grouping orders by month and year
              Map<String, List<OrderModel>> groupedOrders = {};
              for (var order in orders) {
                final dateTime = DateTime.parse(order.transactionTime);
                final monthYear = '${dateTime.toFormattedMonth()} ${dateTime.year}';
                if (!groupedOrders.containsKey(monthYear)) {
                  groupedOrders[monthYear] = [];
                }
                groupedOrders[monthYear]!.add(order);
              }

              return ListView(
                padding: EdgeInsets.all(16.0),
                children: groupedOrders.entries.map((entry) {
                  final monthYear = entry.key;
                  final data = entry.value;
                  final total = data.fold(0, (prev, order) => prev + order.totalPrice);

                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              monthYear,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              total.currencyFormatRp,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 3.0,
                          color: AppColors.primary,
                          endIndent: context.deviceHeight - 60,
                        ),
                        ...data.map((item) => HistoryCard(item: item)).toList(),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            orElse: () => Center(child: Text('Tidak ada data')),
          );
        },
      ),
    );
  }
}


