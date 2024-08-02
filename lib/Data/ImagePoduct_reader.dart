import 'package:cloud_firestore/cloud_firestore.dart';

class imgProducts {
  String id;
  List<String> img;

  imgProducts({required this.id, required this.img});

  // Định nghĩa phương thức fromJson
  factory imgProducts.fromJson(Map<String, dynamic> json) {
    return imgProducts(
      id: json['Id'] ?? '',
      img: List<String>.from(json['img'] ?? []),
    );
  }

  // Phương thức để tải danh sách hình ảnh dựa trên Id
  static Future<imgProducts> loadImagesById(String id) async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('ImageProduct').doc(id);

      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
        print('Raw JSON data: $data'); // In dữ liệu JSON thô ra console

        return imgProducts.fromJson(data ?? {});
      } else {
        print('No such document!');
        return imgProducts(id: id, img: []);
      }
    } catch (e) {
      print('Error loading images from Firestore: $e');
      return imgProducts(id: id, img: []);
    }
  }
}
