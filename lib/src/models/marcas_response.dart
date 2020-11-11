
import 'dart:convert';

List<MarcasResponse> marcasResponseFromJson(String str) => List<MarcasResponse>.from(json.decode(str).map((x) => MarcasResponse.fromJson(x)));

String marcasResponseToJson(List<MarcasResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MarcasResponse {
    MarcasResponse({
        this.nombre,
    });

    String nombre;

    factory MarcasResponse.fromJson(Map<String, dynamic> json) => MarcasResponse(
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
    };
}
