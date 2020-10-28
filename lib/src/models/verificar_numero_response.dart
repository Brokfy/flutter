
import 'dart:convert';

VerificarNumeroResponse verificarNumeroResponseFromJson(String str) => VerificarNumeroResponse.fromJson(json.decode(str));

String verificarNumeroResponseToJson(VerificarNumeroResponse data) => json.encode(data.toJson());

class VerificarNumeroResponse {
  VerificarNumeroResponse({
    this.id,
    this.status,
    this.message,
    this.error,
  });

  String id;
  int status;
  String message;
  bool error;


  factory VerificarNumeroResponse.fromJson(Map<String, dynamic> json) => VerificarNumeroResponse(
    id: json["id"],
    status: json["status"],
    message: json["message"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "message": message,
    "error": error
  };
}
