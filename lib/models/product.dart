class Products {
  int? id;
  String? name;
  String? image;
  int? price;
  String? unitMeasurement;

  Products({
    this.id,
    this.name,
    this.image,
    this.price,
    this.unitMeasurement,
  });

  Map<String, dynamic> toMap(){
    return {
      'id':id,
      'name':name,
      'image':image,
      'price':price,
      'unit_measurement':unitMeasurement
    };
  }
}