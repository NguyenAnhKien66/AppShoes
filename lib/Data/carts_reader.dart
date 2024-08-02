import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartService(this.userId);

  // Xác nhận nếu thêm sản phẩm vào giỏ hàng thành công
  Future<bool> isConfirmTrue({
    required String productId,
    required String name,
    required String imageUrl,
    required String price,
    required int quantity,
    required String size,
    required int availableQuantity,
    required String sex,
  }) async {
    final cartRef = _firestore.collection('carts').doc(userId);
    final itemsRef = cartRef.collection('items');

    print('Checking item in cart: productId = $productId, size = $size');

    try {
      // Kiểm tra xem sản phẩm đã tồn tại trong giỏ hàng với cùng id và size
      final existingItemQuery = await itemsRef
          .where('productId', isEqualTo: productId)
          .where('size', isEqualTo: size)
          .get();

      if (existingItemQuery.docs.isNotEmpty) {
        final existingItemDoc = existingItemQuery.docs.first;
        final existingQuantity = existingItemDoc['quantity'];

        print('Existing item found: existingQuantity = $existingQuantity');

        if (existingQuantity + quantity > availableQuantity) {
          // Kiểm tra số lượng có vượt quá số lượng có sẵn không
          print('Số lượng yêu cầu vượt quá số lượng có sẵn.');
          return false;
        }

        await existingItemDoc.reference.update({
          'quantity': existingQuantity + quantity,
        });
      } else {
        // Nếu chưa tồn tại, thêm mới sản phẩm vào giỏ hàng
        if (quantity > availableQuantity) {
          // Kiểm tra số lượng có vượt quá số lượng có sẵn không
          print('Số lượng yêu cầu vượt quá số lượng có sẵn.');
          return false;
        }

        await itemsRef.add({
          'productId': productId,
          'name': name,
          'imageUrl': imageUrl,
          'price': price,
          'quantity': quantity,
          'size': size,
          'isSelected': false,
          'sex':sex
        });
      }

      print('Item added to cart successfully.');
      return true;
    } catch (e) {
      print('Error adding item to cart: $e');
      return false;
    }
  }

  // Thêm sản phẩm vào giỏ hàng của người dùng và kiểm tra kết quả
  Future<void> addItemToCart({
    required String productId,
    required String name,
    required String imageUrl,
    required String price,
    required int quantity,
    required String size,
    required int availableQuantity,
    required String sex,
  }) async {
    final isSuccess = await isConfirmTrue(
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      price: price,
      quantity: quantity,
      size: size,
      availableQuantity: availableQuantity,
      sex: sex
    );

    if (isSuccess) {
      print('Product added to cart successfully.');
    } else {
      print('Failed to add product to cart.');
    }
  }

  // Lấy tất cả sản phẩm trong giỏ hàng của người dùng
  Future<List<CartItem>> getCartItems() async {
    final cartRef = _firestore.collection('carts').doc(userId);
    final itemsSnapshot = await cartRef.collection('items').get();

    return itemsSnapshot.docs.map((doc) {
      final data = doc.data();
      return CartItem(
      id: doc.id,
      productId: data['productId'] ?? '',
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'] ?? '0',
      quantity: data['quantity'] ?? 0,
      size: data['size'] ?? '',
      isSelected: data['isSelected'] ?? false,
      sex: data['sex'] ?? 'unknown', 
    );
    }).toList();
  }

  // Cập nhật số lượng sản phẩm
  Future<void> updateItemQuantity(String itemId, int quantity) async {
    final cartRef = _firestore.collection('carts').doc(userId);
    final itemRef = cartRef.collection('items').doc(itemId);

    try {
      await itemRef.update({'quantity': quantity});
      print('Quantity updated successfully.');
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeItemFromCart(String itemId) async {
    final cartRef = _firestore.collection('carts').doc(userId);
    final itemRef = cartRef.collection('items').doc(itemId);

    try {
      await itemRef.delete();
      print('Item removed from cart successfully.');
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }
}

class CartItem {
  String id;
  String productId;
  String name;
  String size;
  String price;
  String imageUrl;
  int quantity;
  bool isSelected;
  int maxQuantity;
  String sex;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    this.isSelected = false,
    this.maxQuantity = 0,
    required this.sex,
  });
}
