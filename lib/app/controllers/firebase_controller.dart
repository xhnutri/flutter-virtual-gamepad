import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirebaseController extends GetxController {
  var db = FirebaseFirestore.instance;

  getData() async {
    // db.collection("gamepad1").get().then((event) {
    //   for (var doc in event.docs) {
    //     print("${doc.id} => ${doc.data()}");
    //   }
    // });
    await db.collection("gamepad1").doc('self').update({'data': '+++++++'});
    // print();
  }

  Map<String, String> selectChange(idControl) {
    if (idControl == 1) {
      return {'name': 'gamepad1', 'id': 'V1aPAGhLLMkvn3GWT9Oe'};
    } else if (idControl == 2) {
      return {'name': 'gamepad2', 'id': 'MbHmDkK0j8As1vmSGvw0'};
    } else if (idControl == 3) {
      return {'name': 'gamepad3', 'id': 'Hq9HLmbLqrtQQdSzTFFo'};
    }
    return {};
  }
}
