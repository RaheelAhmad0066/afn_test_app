import 'package:googleapis_auth/auth_io.dart';

class GetServicekey {
  Future<String> getServiceKeyToken() async {
    final scope = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    try {
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "osado-e6198",
          "private_key_id": "08975b6e7e009feb2216141bb6c2c76436ec131a",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC0vQaS8NpFKA4O\nkwLBWKKC8U+A5I090J/u4P2OT7cA9HxPxkRJvtMs9jNVQ0iYm4LO608UCkjBq5ZA\nbB9/U99GKHrrSA+H4Dx22lOmrC9BE1/qhMV9Wi5f6EewevxZwb1JAoKMkaCXya9f\nMTIKGB4h0px8Y2OcKq9cuGTqTvSlSq9d1g8D8SU28LdvKOkReY0HYI5ZeIG393UT\nqEAWDSGIpoj2b7DAmUT79U7THaTSqcw6FE82lngyBmI+EZ2BhzqoD4RiVSbpKNyp\n1IkzbllboUcdAxgvZOW2AvS3J61eH5nPxOq6aR+R127flel8GDFIaJAuzhAmXwgg\n1/XQaSEzAgMBAAECggEAGzw0xmW8Q8Q9F13N13wsw6tAqL1ID12QYXsj75L8PQzv\nwpxaOVFOby22dI22syW+o2xQC/FfdK0PmiubiiCwZNkVahOqIMvd21HGXeJVHer2\nftd9Dwj3iK+Zm0gdHhq/aZtoOBh7E68VBIoxmSsjN0OOcywNnEB5ERwe5jP5p60v\n2ss/qvnjuYeuvIuMts99K3wcKNyQG02bSRtjUdomMV7NZRkpw6sMe0wTUCT9yyur\nbnNK0Mo7f5a1D6xspe1s4uW96CZ6Q8yeXgadjdjwEb+YXbSiriOBFs2gBGoTPxTI\nL7XWgWbZ+TnczgVYA8/mNrMAEyh/i/22q56F6QrcmQKBgQDw+fdMs/UnLIiOdj4X\nwLihwBwe1HhPPD4GQIWnAtNbQmsbQpQESqJZAttM+I7WY3uQxa4UTW6uqC0hYwE3\ng7wsMgB1epElDz2Oae9EUynDTXhhgmYHRkTfGvV6V8Nif7HCmpwD9H8fJwgqZWL4\nddpk43vTMYeNECVRj2T+KAjJxQKBgQDAAaXbM15z97TSmhp0w3RajguUd9tRuR/a\nm8PS106daEbiNWc+Lt1QtyZC5U7FcZaHKXcSneJrm/0qMJPpQu0SRaMP9lmV3nnS\neJ9m7Qsix0Dw8QVrUyjpR5KuGpdyKbuMfKB+IsaZbQjZSHNDL3XIAamoPR/emxRB\nbOBYhfmGlwKBgQCtmKWa0BlPezl0x6G7os5fV/HqE84H5rIX9utRgSuZlqNqI/BV\nlx6VWQV60aS0tT4S8RWS8qVFlUnNv3Dk+TXZ8Lt75iwhsnT53z7Kzc5ML8cFF9dA\nblK3Fsi4tfi/QJZiRtcV0lCxtIChaiB+NQh7nZVac1ffOz5nHxH2Ngj+sQKBgCSD\na7YOw8SL87AlLCjOTp816g/W5zdYXC1nd8rttP6MKQa1nyedI+tImRcZomw72KNl\niEZbDgbmyDMwv8AZQRo7cfIEKC8u+r3CwJWDOJ3phHkNbLlnPB14xfUkC27jbs4d\nmSvDkz70FD214G2DZgOeBVSAI0Ji/Wwft14+RCCLAoGBANARJe+QNmcto4AKOnUJ\nXuWNmMC6VEjRCIYAoRs1p99R7/7GZ4pzu6P8fQnmrec5EihlFqbtcLvZ/WeJHsVh\ncDMIkajhIh4np0Blx7c/TCO6TVpra7jRaLzHef6yTL9Y9OSP0UysV2/LsEBJy7Hv\nYm7JjhbCCBDVzqtLSqimWYwZ\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-fbsvc@osado-e6198.iam.gserviceaccount.com",
          "client_id": "114036408686575394074",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40osado-e6198.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com",
        }),
        scope,
      );
      final accessServerKey = client.credentials.accessToken.data;
      return accessServerKey;
    } catch (e) {
      print('Error retrieving access token: $e');
      return '';
    }
  }
}
