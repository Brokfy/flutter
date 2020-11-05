class AdminModel {
  AdminModel({
    this.id,
    this.nombre,
    this.apellidoPaterno,
    this.apelldioMaterno,
    this.image,
  });

  String id;
  String nombre;
  String apellidoPaterno;
  String apelldioMaterno;
  String image;

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        id: json["id"],
        nombre: json["nombre"],
        apellidoPaterno: json["apellidoPaterno"],
        apelldioMaterno: json["apelldioMaterno"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellidoPaterno": apellidoPaterno,
        "apelldioMaterno": apelldioMaterno,
        "image": image,
      };
}
