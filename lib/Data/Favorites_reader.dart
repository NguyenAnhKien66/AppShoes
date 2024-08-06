import 'package:cloud_firestore/cloud_firestore.dart';

class Favorites {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Favorites(this.userId);

  // Tải danh sách sản phẩm yêu thích của người dùng
  Future<List<String>> loadListFavorites() async {
    try {
      final snapshot = await _firestore
          .collection('favorites')
          .doc(userId)
          .collection('products')
          .get();

      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Lỗi khi tải danh sách yêu thích: $e');
      return [];
    }
  }

  // Thêm sản phẩm vào danh sách yêu thích
  Future<void> addToFavorites(String productId) async {
    try {
      await _firestore
          .collection('favorites')
          .doc(userId)
          .collection('products')
          .doc(productId)
          .set({});
    } catch (e) {
      print('Lỗi khi thêm vào yêu thích: $e');
    }
  }

  // Xóa sản phẩm khỏi danh sách yêu thích
  Future<void> removeFromFavorites(String productId) async {
    try {
      await _firestore
          .collection('favorites')
          .doc(userId)
          .collection('products')
          .doc(productId)
          .delete();
    } catch (e) {
      print('Lỗi khi xóa khỏi yêu thích: $e');
    }
  }
  // Kiểm tra xem sản phẩm có phải là yêu thích của người dùng hay không
  Future<bool> isFavorite(String productId) async {
    try {
      final doc = await _firestore
          .collection('favorites')
          .doc(userId)
          .collection('products')
          .doc(productId)
          .get();

      return doc.exists;
    } catch (e) {
      print('Lỗi khi kiểm tra yêu thích: $e');
      return false;
    }
  }
}
