import 'dart:convert';

List<int> data = [75, 65, 61, 61, 75, 81, 61, 61];
void main() {
  print(data);
  String base64String = utf8.decode(data);
// print(text);
// print(base64Encode(data));
  String init = base64String.substring(0, 4);
  String end =
      base64String.substring(base64String.length - 4, base64String.length);
  print(base64String.length);
  if (init == 'KA==') {
    print("init");
  }
  if (end == 'KQ==') {
    print('final');
  }
}
