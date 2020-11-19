
import 'dart:convert';

List<ModelosAutoResponse> modelosAutoResponseFromJson(String str) => List<ModelosAutoResponse>.from(json.decode(str).map((x) => ModelosAutoResponse.fromJson(x)));

String modelosAutoResponseToJson(List<ModelosAutoResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelosAutoResponse {
    ModelosAutoResponse({
        this.id,
        this.nombre,
        this.codModelo,
        this.nomModelo,
    });

    String id;
    String nombre;
    String codModelo;
    String nomModelo;

    factory ModelosAutoResponse.fromJson(Map<String, dynamic> json) => ModelosAutoResponse(
        id: json["codModelo"].toString() != null ? json["codModelo"].toString()
          : json["id"] != null ? json["id"].toString()
          : null,
        nombre: json["nomModelo"] != null ? json["nomModelo"]
          : json["nombre"] != null ? json["nombre"] 
          : null,
    );

    Map<String, dynamic> toJson() => {
        "id": codModelo != null ? codModelo
          : id != null ? id 
          : null,
        "nombre": nomModelo != null ? nomModelo
          : nombre != null ? nombre 
          : null,
    };
}
