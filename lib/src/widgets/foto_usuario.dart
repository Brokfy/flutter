import 'package:brokfy_app/src/providers/foto_usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'hex_color.dart';

class FotoUsuario extends StatelessWidget {
  final String url;

  const FotoUsuario({
    Key key, 
    @required this.url
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fotoUsuario = Provider.of<FotoUsuarioProvider>(context);

    return CircleAvatar(
      backgroundColor: HexColor("#0079DE"),
      radius: 55,
      child: CircleAvatar(
        radius: 50,
        child: ClipOval(
          child: fotoUsuario.foto != null ? 
          SizedBox(
            width: 100,
              height: 100,
            child: fotoUsuario.foto
          ):
          SizedBox(
            width: 100,
              height: 100,
            child: FutureBuilder(
              future: http.get(this.url),
              builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
                Widget icon = Icon(
                  Icons.person,
                  size: 100,
                );
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Press button to start.');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return icon;
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return icon;
                    Image img = Image.memory(snapshot.data.bodyBytes, fit: BoxFit.fill,);
                    Future.delayed(Duration(seconds: 1), () {
                      if( fotoUsuario.foto == null ) {
                        fotoUsuario.foto = img;
                      }
                    });
                    return img;
                }
                return null; // unreachable
              },
            ),
          ),
        ),
      ),
    );
  }
}