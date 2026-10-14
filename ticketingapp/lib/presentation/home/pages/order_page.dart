import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketingapp/core/core.dart';
import 'package:ticketingapp/presentation/home/bloc/category/category_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/product/product_bloc.dart';
import 'package:ticketingapp/presentation/home/pages/like_page.dart';
import 'package:ticketingapp/presentation/home/pages/order_detail.dart';
import 'package:ticketingapp/presentation/home/widget/order_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String searchQuery = '';
  int? selectedCategoryId;

  @override
  void initState() {
    context.read<ProductBloc>().add(ProductEvent.getLocalProducts());
    context.read<CategoryBloc>().add(CategoryEvent.fetch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Penjualan',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: AppColors.primary),
            onPressed: () {
              context.push(LikePages());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search tickets...',
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Category Filter
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 12),
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                return state.maybeWhen(
                  success: (categories) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              selected: selectedCategoryId == null,
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              backgroundColor: Colors.grey[200],
                              label: const Text('ALL'),
                              labelStyle: TextStyle(
                                color: selectedCategoryId == null
                                    ? AppColors.primary
                                    : Colors.black,
                              ),
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedCategoryId = null;
                                });
                              },
                            ),
                          );
                        }

                        final category = categories[index - 1];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: selectedCategoryId == category.id,
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            backgroundColor: Colors.grey[200],
                            label: Text(category.name ?? ''),
                            labelStyle: TextStyle(
                              color: selectedCategoryId == category.id
                                  ? AppColors.primary
                                  : Colors.black,
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCategoryId =
                                    selected ? category.id : null;
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                  orElse: () => const SizedBox(),
                );
              },
            ),
          ),

          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                final products = state
                    .maybeWhen(
                  orElse: () => [],
                  success: (products) => products,
                )
                    .where((product) {
                  bool matchesSearch =
                      product.name.toLowerCase().contains(searchQuery);
                  bool matchesCategory = selectedCategoryId == null ||
                      product.category?.id == selectedCategoryId;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (products.isEmpty) {
                  return Center(
                    child: Text('Tidak ada data tiket!'),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  itemBuilder: (context, index) => OrderCard(
                    item: products[index],
                  ),
                  separatorBuilder: (context, index) => const SpaceHeight(20.0),
                  itemCount: products.length,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(25, 20, 25, 35),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        success: (checkout) {
                          // fold => itu buat mengiterasi semua elemet yang ada di koleksi (List, set)
                          // dan melakukan operasi yang menghasilkan nilai akhir dari semua element yang di proses
                          final total = checkout.fold<int>(
                            // initialValue => nilai awal
                            0,
                            // FUngsi akumulator
                            // previousValue => nilai yang sudah diitung sampai saat itu
                            // element => nilai atau elemt yang sedang di proses
                            // Jadi fungsi akumulator itu berjalan atau bekerja di setiap element untuk mengakumulasi
                            // nilai akhir berdasarkan fungsi yang kita buat
                            (previousValue, element) =>
                                previousValue +
                                element.product.price! * element.quantity,
                          );
                          return Text(
                            total.currencyFormatRp,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          );
                        },
                        orElse: () => Text('0',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
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
                  context.push(
                    OrderDetailPage(),
                  );
                },
                label: 'Process',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
