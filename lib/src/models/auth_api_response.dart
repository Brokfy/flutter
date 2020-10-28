import 'dart:convert';

AuthApiResponse authApiResponseFromJson(String str) => AuthApiResponse.fromJson(json.decode(str));

String authApiResponseToJson(AuthApiResponse data) => json.encode(data.toJson());

class AuthApiResponse {
    AuthApiResponse({
        // ignore: non_constant_identifier_names
        this.access_token,
        // ignore: non_constant_identifier_names
        this.token_type,
        // ignore: non_constant_identifier_names
        this.refresh_token,
        // ignore: non_constant_identifier_names
        this.expires_in,
        this.scope,
        this.nameAws,
        this.apellidoPaterno,
        this.tokenFirebase,
        this.fechaNacimiento,
        this.nombreCompleto,
        this.sexo,
        this.nombre,
        this.email,
        this.enabled,
        this.intentos,
        this.apellidoMaterno,
        this.username,
        this.jti,
    });

    // ignore: non_constant_identifier_names
    String access_token;
    // ignore: non_constant_identifier_names
    String token_type;
    // ignore: non_constant_identifier_names
    String refresh_token;
    // ignore: non_constant_identifier_names
    int expires_in;
    String scope;
    String nameAws;
    String apellidoPaterno;
    String tokenFirebase;
    DateTime fechaNacimiento;
    String nombreCompleto;
    String sexo;
    String nombre;
    String email;
    int enabled;
    int intentos;
    String apellidoMaterno;
    String username;
    String jti;

    factory AuthApiResponse.fromJson(Map<String, dynamic> json) => AuthApiResponse(
        access_token: json["access_token"] == null ? null : json["access_token"],
        token_type: json["token_type"] == null ? null : json["token_type"],
        refresh_token: json["refresh_token"] == null ? null : json["refresh_token"],
        expires_in: json["expires_in"] == null ? null : json["expires_in"],
        scope: json["scope"] == null ? null : json["scope"],
        nameAws: json["nameAws"] == null ? null : json["nameAws"],
        apellidoPaterno: json["apellidoPaterno"] == null ? null : json["apellidoPaterno"],
        tokenFirebase: json["tokenFirebase"] == null ? null : json["tokenFirebase"],
        fechaNacimiento: json["fechaNacimiento"] == null ? null : DateTime.parse(json["fechaNacimiento"]),
        nombreCompleto: json["NombreCompleto"] == null ? null : json["NombreCompleto"],
        sexo: json["sexo"] == null ? null : json["sexo"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        email: json["email"] == null ? null : json["email"],
        enabled: json["enabled"] == null ? null : (json["enabled"] == true ? 1 : 0),
        intentos: json["intentos"] == null ? null : json["intentos"],
        apellidoMaterno: json["apellidoMaterno"] == null ? null : json["apellidoMaterno"],
        username: json["username"] == null ? null : json["username"],
        jti: json["jti"] == null ? null : json["jti"],
    );

    Map<String, dynamic> toJson() => {
        "access_token": access_token == null ? null : access_token,
        "token_type": token_type == null ? null : token_type,
        "refresh_token": refresh_token == null ? null : refresh_token,
        "expires_in": expires_in == null ? null : expires_in,
        "scope": scope == null ? null : scope,
        "nameAws": nameAws == null ? null : nameAws,
        "apellidoPaterno": apellidoPaterno == null ? null : apellidoPaterno,
        "tokenFirebase": tokenFirebase == null ? null : tokenFirebase,
        "fechaNacimiento": fechaNacimiento == null ? null : "${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}",
        "NombreCompleto": nombreCompleto == null ? null : nombreCompleto,
        "sexo": sexo == null ? null : sexo,
        "nombre": nombre == null ? null : nombre,
        "email": email == null ? null : email,
        "enabled": enabled == null ? null : enabled,
        "intentos": intentos == null ? null : intentos,
        "apellidoMaterno": apellidoMaterno == null ? null : apellidoMaterno,
        "username": username == null ? null : username,
        "jti": jti == null ? null : jti,
    };
}
