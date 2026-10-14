import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketingapp/presentation/home/bloc/like/like_bloc.dart';
import 'package:ticketingapp/presentation/home/widget/order_card.dart';

class LikePages extends StatefulWidget {
  const LikePages({super.key});

  @override
  State<LikePages> createState() => _LikePagesState();
}

class _LikePagesState extends State<LikePages> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LikeBloc>().add(const LikeEvent.getLikedProducts());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<LikeBloc>().add(const LikeEvent.getLikedProducts());
            },
          ),
        ],
      ),
      body: BlocConsumer<LikeBloc, LikeState>(
        listenWhen: (previous, current) => current is Error,
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $message'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<LikeBloc>()
                          .add(const LikeEvent.getLikedProducts());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            successGetLikedProducts: (products) {
              if (products.isEmpty) {
                return const Center(
                  child: Text('No liked products yet'),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: products.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),                                                         
                itemBuilder: (context, index) {                                                                                                                                                     
                  final product = products[index];
                  return OrderCard(item: product);
                },
              );
            },
            orElse: () => const SizedBox(),
          );
        },
      ),
    );
  }
}
