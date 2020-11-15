
class DBRepository {
  static const initScript = [
        '''Create Table Auth (
              access_token Text,
              token_type Text,
              refresh_token Text,
              expires_in Integer,
              scope Text,
              nameAws Text,
              apellidoPaterno Text,
              tokenFirebase Text,
              fechaNacimiento Text,
              nombreCompleto Text,
              sexo Text,
              nombre Text,
              email Text,
              enabled Integer,
              intentos Integer,
              apellidoMaterno Text,
              username Text,
              jti Text
            )''', 
      ];

  static const migrations = [
    '''
    Alter Table Auth Add Column Password Text;
    ''',
  ];
}
