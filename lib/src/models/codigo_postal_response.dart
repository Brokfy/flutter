
import 'dart:convert';

List<CodigoPostalResponse> codigoPostalResponseFromJson(String str) => List<CodigoPostalResponse>.from(json.decode(str).map((x) => CodigoPostalResponse.fromJson(x)));

String codigoPostalResponseToJson(List<CodigoPostalResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CodigoPostalResponse {
    CodigoPostalResponse({
        this.id,
        this.codpostal,
        this.colonia,
        this.municipio,
        this.estado,
    });

    int id;
    String codpostal;
    String colonia;
    String municipio;
    String estado;

    factory CodigoPostalResponse.fromJson(Map<String, dynamic> json) => CodigoPostalResponse(
        id: json["id"],
        codpostal: json["codpostal"],
        colonia: json["colonia"],
        municipio: json["municipio"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "codpostal": codpostal,
        "colonia": colonia,
        "municipio": municipio,
        "estado": estado,
    };
}
