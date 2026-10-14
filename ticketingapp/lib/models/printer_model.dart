class PrinterModel {
  final String name;
  final int address;

  PrinterModel({
    required this.name,
    required this.address,
  });
}

final printers = [
  PrinterModel(
    name: 'Samsung',
    address: 27352635,
  ),
  PrinterModel(
    name: 'Vivo',
    address: 3868383,
  ),
  PrinterModel(
    name: 'Oppo',
    address: 82947294,
  ),
];
