
import 'dart:convert';

List<ChatSubirPolizaResponse> chatSubirPolizaResponseFromJson(String str) => List<ChatSubirPolizaResponse>.from(json.decode(str).map((x) => ChatSubirPolizaResponse.fromJson(x)));

String chatSubirPolizaResponseToJson(List<ChatSubirPolizaResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatSubirPolizaResponse {
    ChatSubirPolizaResponse({
        this.id,
        this.preguntas,
        this.opciones,
    });

    int id;
    List<Pregunta> preguntas;
    List<Opcione> opciones;

    factory ChatSubirPolizaResponse.fromJson(Map<String, dynamic> json) => ChatSubirPolizaResponse(
        id: json["id"],
        preguntas: List<Pregunta>.from(json["preguntas"].map((x) => Pregunta.fromJson(x))),
        opciones: List<Opcione>.from(json["opciones"].map((x) => Opcione.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "preguntas": List<dynamic>.from(preguntas.map((x) => x.toJson())),
        "opciones": List<dynamic>.from(opciones.map((x) => x.toJson())),
    };
}

class Opcione {
    Opcione({
        this.id,
        this.action,
        this.data,
        this.opcion,
    });

    int id;
    int action;
    List<Datum> data;
    String opcion;

    factory Opcione.fromJson(Map<String, dynamic> json) => Opcione(
        id: json["id"],
        action: json["action"] == null ? null : json["action"],
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        opcion: json["opcion"] == null ? null : json["opcion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "action": action == null ? null : action,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
        "opcion": opcion == null ? null : opcion,
    };
}

class Datum {
    Datum({
        this.idAseguradora,
        this.nombre,
        this.telefono,
        this.enabled,
    });

    int idAseguradora;
    String nombre;
    String telefono;
    Enabled enabled;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idAseguradora: json["idAseguradora"],
        nombre: json["nombre"],
        telefono: json["telefono"],
        enabled: enabledValues.map[json["enabled"]],
    );

    Map<String, dynamic> toJson() => {
        "idAseguradora": idAseguradora,
        "nombre": nombre,
        "telefono": telefono,
        "enabled": enabledValues.reverse[enabled],
    };
}

enum Enabled { NO, SI }

final enabledValues = EnumValues({
    "No": Enabled.NO,
    "Si": Enabled.SI
});

class Pregunta {
    Pregunta({
        this.id,
        this.pregunta,
    });

    int id;
    String pregunta;

    factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
        id: json["id"],
        pregunta: json["pregunta"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "pregunta": pregunta,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
