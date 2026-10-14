class HistoryModel {
  final String name;
  final int price;
  final DateTime dateTime;

  HistoryModel({
    required this.name,
    required this.price,
    required this.dateTime,
  });
}

List<HistoryModel> histories = [
    HistoryModel(
      name: 'Cileungsi',
      price: 500000,
      dateTime: DateTime(
        2025,
        4,
        20,
        4,
        32,
      ),
    ),
    HistoryModel(
      name: 'MM',
      price: 500000,
      dateTime: DateTime(
        2025,
        4,
        20,
        4,
        32,
      ),
    ),
    HistoryModel(
      name: 'Wizzmie',
      price: 500000,
      dateTime: DateTime(
        2025,
        5,
        20,
        5,
        32,
      ),
    ),
    HistoryModel(
      name: 'Gacoan',
      price: 500000,
      dateTime: DateTime(
        2025,
        3,
        20,
        5,
        32,
      ),
    ),
  ];
