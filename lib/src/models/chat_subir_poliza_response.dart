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
        this.url,
        this.opcion,
        this.endpoint,
    });

    int id;
    int action;
    List<Datum> data;
    String url;
    String opcion;
    String endpoint;

    factory Opcione.fromJson(Map<String, dynamic> json) => Opcione(
        id: json["id"],
        action: json["action"] == null ? null : json["action"],
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        url: json["url"] == null ? null : json["url"],
        opcion: json["opcion"] == null ? null : json["opcion"],
        endpoint: json["endpoint"] == null ? null : json["endpoint"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "action": action == null ? null : action,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
        "url": url == null ? null : url,
        "opcion": opcion == null ? null : opcion,
        "endpoint": endpoint == null ? null : endpoint,
    };
}

class Datum {
    Datum({
        this.idAseguradora,
        this.nombre,
        this.telefono,
        this.enabled,
        this.id,
        this.tipo,
        this.anio,
    });

    int idAseguradora;
    String nombre;
    String telefono;
    Enabled enabled;
    int id;
    String tipo;
    int anio;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idAseguradora: json["idAseguradora"] == null ? null : json["idAseguradora"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        telefono: json["telefono"] == null ? null : json["telefono"],
        enabled: json["enabled"] == null ? null : enabledValues.map[json["enabled"]],
        id: json["id"] == null ? null : json["id"],
        tipo: json["tipo"] == null ? null : json["tipo"],
        anio: json["anio"] == null ? null : json["anio"],
    );

    Map<String, dynamic> toJson() => {
        "idAseguradora": idAseguradora == null ? null : idAseguradora,
        "nombre": nombre == null ? null : nombre,
        "telefono": telefono == null ? null : telefono,
        "enabled": enabled == null ? null : enabledValues.reverse[enabled],
        "id": id == null ? null : id,
        "tipo": tipo == null ? null : tipo,
        "anio": anio == null ? null : anio,
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
        this.anexos,
    });

    int id;
    String pregunta;
    String anexos;

    factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
        id: json["id"],
        pregunta: json["pregunta"],
        anexos: json["anexos"] == null ? null : json["anexos"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "pregunta": pregunta,
        "anexos": anexos == null ? null : anexos,
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
