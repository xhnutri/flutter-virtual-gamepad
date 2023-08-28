import 'dart:convert';
import 'dart:async';
import 'dart:io';

// Future<Map> getTurnCredential(String host, int port) async {
//   HttpClient client = HttpClient(context: SecurityContext());
//   print("1");
//   client.badCertificateCallback =
//       (X509Certificate cert, String host, int port) {
//     print('getTurnCredential: Allow self-signed certificate => $host:$port. ');
//     return true;
//   };
//   var url = 'http://$host:$port/?service=turn&username=new&password=r3l86lf1';
//   print("2");
//   var request = await client.getUrl(Uri.parse(url));
//   print("3");
//   var response = await request.close();
//   print("4");
//   var responseBody = await response.transform(Utf8Decoder()).join();
//   print('getTurnCredential:response => $responseBody.');
//   Map data = JsonDecoder().convert(responseBody);
//   return data;
// }
