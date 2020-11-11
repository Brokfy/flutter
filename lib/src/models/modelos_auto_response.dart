
import 'dart:convert';

List<ModelosAutoResponse> modelosAutoResponseFromJson(String str) => List<ModelosAutoResponse>.from(json.decode(str).map((x) => ModelosAutoResponse.fromJson(x)));

String modelosAutoResponseToJson(List<ModelosAutoResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelosAutoResponse {
    ModelosAutoResponse({
        this.id,
        this.nombre,
    });

    String id;
    String nombre;

    factory ModelosAutoResponse.fromJson(Map<String, dynamic> json) => ModelosAutoResponse(
        id: json["id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };
}
