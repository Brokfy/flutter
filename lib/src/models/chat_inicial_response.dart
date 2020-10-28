
import 'dart:convert';

ChatInicialResponse chatInicialResponseFromJson(String str) => ChatInicialResponse.fromJson(json.decode(str));

String chatInicialResponseToJson(ChatInicialResponse data) => json.encode(data.toJson());

class ChatInicialResponse {
    ChatInicialResponse({
        this.id,
        this.preguntas,
        this.opciones,
    });

    int id;
    List<Pregunta> preguntas;
    List<Opcione> opciones;

    factory ChatInicialResponse.fromJson(Map<String, dynamic> json) => ChatInicialResponse(
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
        this.opcion,
        this.endpoint,
        this.valor,
    });

    int id;
    String opcion;
    String endpoint;
    String valor;

    factory Opcione.fromJson(Map<String, dynamic> json) => Opcione(
        id: json["id"],
        opcion: json["opcion"],
        endpoint: json["endpoint"] == null ? null : json["endpoint"],
        valor: json["valor"] == null ? null : json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "opcion": opcion,
        "endpoint": endpoint == null ? null : endpoint,
        "valor": valor == null ? null : valor,
    };
}

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
