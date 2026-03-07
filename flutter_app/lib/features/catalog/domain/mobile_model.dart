class MobileSpecs {
  final String ram;
  final String storage;
  final String camera;
  final String battery;

  MobileSpecs({
    required this.ram,
    required this.storage,
    required this.camera,
    required this.battery,
  });

  factory MobileSpecs.fromJson(Map<String, dynamic> json) => MobileSpecs(
        ram: json['ram'],
        storage: json['storage'],
        camera: json['camera'],
        battery: json['battery'],
      );
}

class MobileModel {
  final String id;
  final String brand;
  final String model;
  final double price;
  final String stockStatus;
  final MobileSpecs specs;

  MobileModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.price,
    required this.stockStatus,
    required this.specs,
  });

  factory MobileModel.fromJson(Map<String, dynamic> json) => MobileModel(
        id: json['id'],
        brand: json['brand'],
        model: json['model'],
        price: (json['price'] as num).toDouble(),
        stockStatus: json['stock_status'],
        specs: MobileSpecs.fromJson(json['specs']),
      );
}