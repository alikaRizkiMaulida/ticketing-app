import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketingapp/core/core.dart';
import 'package:ticketingapp/data/model/response/product_response_model.dart';
import 'package:ticketingapp/presentation/home/bloc/product/product_bloc.dart';

class EditTicketDialog extends StatelessWidget {
  final Product item;
  const EditTicketDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: item.name);
    final priceController = TextEditingController(text: '${item.price}');

    int parseCurrency(String text) =>
        int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    priceController.text = parseCurrency(priceController.text).currencyFormatRp;

    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            const SpaceHeight(8.0),
            CustomTextField(
              controller: nameController,
              label: 'Nama Tiket',
            ),
            SpaceHeight(8.0),
            CustomTextField(
              controller: priceController,
              label: 'Harga',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final parsedValue = parseCurrency(value).currencyFormatRp;
                priceController.value = TextEditingValue(
                  text: parsedValue,
                  selection:
                      TextSelection.collapsed(offset: parsedValue.length),
                );
              },
            ),
            SpaceHeight(20.0),
            Row(
              children: [
                Flexible(
                  child: Button.filled(
                    onPressed: () => context.pop(),
                    label: 'Batalkan',
                    borderRadius: 8.0,
                    color: AppColors.buttonCancel,
                    textColor: Colors.black38,
                  ),
                ),
                SpaceWidth(10.0),
                Flexible(
                  child: Button.filled(
                    onPressed: () {
                      context.read<ProductBloc>().add(ProductEvent.updateTicket(
                        Product(
                          id: item.id,
                          name: nameController.text,
                          price: parseCurrency(priceController.text)
                        )
                      ));
                      context.pop();
                    },
                    label: 'Simpan',
                    borderRadius: 8.0,
                    color: AppColors.primary,
                    textColor: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
