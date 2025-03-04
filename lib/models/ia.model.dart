class MensajeIA {
  String idMensaje;
  String idUsuario;
  String mensajeUsuario;
  String respuestaIA;
  DateTime timestamp;

  MensajeIA({
    required this.idMensaje,
    required this.idUsuario,
    required this.mensajeUsuario,
    required this.respuestaIA,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        "idMensaje": idMensaje,
        "idUsuario": idUsuario,
        "mensajeUsuario": mensajeUsuario,
        "respuestaIA": respuestaIA,
        "timestamp": timestamp.toIso8601String(),
      };

  factory MensajeIA.fromJson(Map<String, dynamic> json) => MensajeIA(
        idMensaje: json["idMensaje"],
        idUsuario: json["idUsuario"],
        mensajeUsuario: json["mensajeUsuario"],
        respuestaIA: json["respuestaIA"],
        timestamp: DateTime.parse(json["timestamp"]),
      );
}
