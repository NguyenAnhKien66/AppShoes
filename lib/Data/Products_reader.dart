import 'package:cloud_firestore/cloud_firestore.dart';

class products {
  String Id;
  String Name;
  bool Status;
  String Description;
  String Catelory;
  String Discount;
  String Image;
  String Price;
  String Size39;
  String Size40;
  String Size41;
  String Size42;
  String Size43;
  String Size44;
  String Size45;
  String Trend;
  bool Favorites;
  String Sex;
  

  products({
    required this.Id,
    required this.Name,
    required this.Description,
    required this.Catelory,
    required this.Discount,
    required this.Image,
    required this.Price,
    required this.Status,
    required this.Size39,
    required this.Size40,
    required this.Size41,
    required this.Size42,
    required this.Size43,
    required this.Size44,
    required this.Size45,
    required this.Trend,
    required this.Favorites,
    required this.Sex
  });

  // Constructor từ JSON
  products.fromJson(Map<String, dynamic> json)
      : Id = json["Id"] ?? '',
        Name = json['Name'] ?? '',
        Status = json['Status'] ?? false,
        Favorites = json['Favorites'] ?? false,
        Catelory = json["Catelory"] ?? '',
        Discount = json["Discount"] ?? '',
        Image = json["Image"] ?? '',
        Price = json["Price"] ?? '',
        Description = json['Description'] ?? '',
        Size39 = json["Size39"] ?? '',
        Size40 = json["Size40"] ?? '',
        Size41 = json["Size41"] ?? '',
        Size42 = json["Size42"] ?? '',
        Size43 = json["Size43"] ?? '',
        Size44 = json["Size44"] ?? '',
        Size45 = json["Size45"] ?? '',
        Sex = json["Sex"] ?? '',
        Trend = json["Trend"] ?? '';

  // Tải tất cả sản phẩm từ Firestore
  // static Future<List<products>> loadData_products() async {
  //   try {
  //     CollectionReference productCollection =
  //         FirebaseFirestore.instance.collection('Products');

  //     QuerySnapshot productSnapshot = await productCollection.get();

  //     return productSnapshot.docs
  //         .map((doc) => products.fromJson(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     print('Error loading data from Firestore: $e');
  //     return [];
  //   }
  // }

  // Tải sản phẩm bán chạy
  static Future<List<products>> loadBestSellingProducts() async {
    try {
      CollectionReference productCollection =
          FirebaseFirestore.instance.collection('Products');

      QuerySnapshot productSnapshot = await productCollection
          .where('Trend', isEqualTo: 'Best Sellers') 
          .get();

      return productSnapshot.docs
          .map((doc) => products.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading best-selling products from Firestore: $e');
      return [];
    }
  }

  // Tải sản phẩm mới
  static Future<List<products>> loadNewProducts() async {
    try {
      CollectionReference productCollection =
          FirebaseFirestore.instance.collection('Products');

      QuerySnapshot productSnapshot = await productCollection
          .where('Status', isEqualTo: true) 
          .get();

      return productSnapshot.docs
          .map((doc) => products.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading new products from Firestore: $e');
      return [];
    }
  }

  // Tải sản phẩm giảm giá lớn
  static Future<List<products>> loadSuperSaleProducts() async {
    try {
      CollectionReference productCollection =
          FirebaseFirestore.instance.collection('Products');

      QuerySnapshot productSnapshot = await productCollection
          .where('Discount', isGreaterThan: '0')
          .get();

      List<products> product = productSnapshot.docs
          .map((doc) => products.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Sắp xếp sản phẩm theo discount giảm dần
      product.sort((a, b) {
        int discountA = int.tryParse(a.Discount) ?? 0;
        int discountB = int.tryParse(b.Discount) ?? 0;
        return discountB.compareTo(discountA); 
      });

      return product;
    } catch (e) {
      print('Error loading super sale products from Firestore: $e');
      return [];
    }
  }
  // phương thức tải sản phẩm yêu thích
static Future<List<products>> loadFavoriteProducts() async {
  try {
    CollectionReference productCollection =
        FirebaseFirestore.instance.collection('Products');

    QuerySnapshot productSnapshot = await productCollection
        .where('Favorites', isEqualTo: true)
        .get();

    return productSnapshot.docs
        .map((doc) => products.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('Error loading favorite products from Firestore: $e');
    return [];
  }
}
// Cập nhật trạng thái Favorites
  Future<void> updateFavoriteStatus(bool isFavorite) async {
    try {
      CollectionReference productCollection = FirebaseFirestore.instance.collection('Products');
      await productCollection.doc(Id).update({'Favorites': isFavorite});
      print('Favorite status updated successfully.');
    } catch (e) {
      print('Error updating favorite status: $e');
    }
  }
   static Future<products> loadProductById(String id) async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance.collection('Products').doc(id).get();
      return products.fromJson(productDoc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error loading product by ID: $e');
      rethrow;
    }
  }
  static Future<void> updateQuantityProduct(String productId, String size, int quantity) async {
    try {
      DocumentReference productRef = FirebaseFirestore.instance.collection('Products').doc(productId);

      DocumentSnapshot productDoc = await productRef.get();

      if (!productDoc.exists) {
        print('Product with ID $productId does not exist.');
        return;
      }

      // Get the current product data
      Map<String, dynamic>? productData = productDoc.data() as Map<String, dynamic>?;

      if (productData == null) {
        print('No data found for product with ID $productId.');
        return;
      }

      String sizeField = '';
      int currentSizeQuantity = 0;

      switch (size) {
        case '39':
          sizeField = 'Size39';
          currentSizeQuantity = int.tryParse(productData[sizeField]) ?? 0;
          break;
        case '40':
          sizeField = 'Size40';
          currentSizeQuantity = int.tryParse(productData[sizeField]) ?? 0;
          break;
        case '41':
          sizeField = 'Size41';
          currentSizeQuantity = int.tryParse(productData[sizeField]) ?? 0;
          break;
        case '42':
          sizeField = 'Size42';
          currentSizeQuantity = int.tryParse(productData[sizeField]) ?? 0;
          break;
        case '43':
          sizeField = 'Size43';
          currentSizeQuantity = int.tryParse(productData[sizeField]) ?? 0;
          break;
        case '44':
          sizeField = 'Size44';
          currentSizeQuantity = int.tryParse(productData[sizeField]) ?? 0;
          break;
        case '45':
          sizeField = 'Size45';
          currentSizeQuantity = int.tryParse(productData[sizeField]) ?? 0;
          break;
        default:
          print('Invalid size specified: $size');
          return;
      }

      // Check if the quantity to reduce is valid
      if (quantity > currentSizeQuantity) {
        print('Not enough stock for size $size of product with ID $productId.');
        return;
      }

      // Update the size quantity in Firestore
      int newSizeQuantity = currentSizeQuantity - quantity;
      await productRef.update({sizeField: newSizeQuantity.toString()});

      print('Quantity for size $size of product with ID $productId updated successfully.');
    } catch (e) {
      print('Error updating product quantity: $e');
    }
  }
  static Future<List<products>> loadProducts({
  required String sex,
  required double minPrice,
  required double maxPrice,
  required List<String> sizes,
  required List<String> categories,
  required String sortOption,
}) async {
  
  try {
    print("Điều kiện lọc được chọn:");
    print("Giới tính: $sex");
    print("Khoảng giá: $minPrice - $maxPrice");
    print("Kích thước: ${sizes.join(', ')}");
    print("Danh mục: ${categories.join(', ')}");
    print("Tùy chọn sắp xếp: $sortOption");
    CollectionReference productCollection = FirebaseFirestore.instance.collection('Products');

    Query query = productCollection;

    // Lọc theo giới tính
    if (sex != 'Tất cả') {
      // Tìm sản phẩm có giới tính được chỉ định hoặc Unisex
      query = query.where('Sex', whereIn: [sex, 'Unisex']);
    } else {
      // Khi sex là "Tất cả," chỉ cần tìm tất cả các sản phẩm có `Sex` khác "Unisex"
      query = query.where('Sex', isNotEqualTo: ''); // Nếu tất cả các sản phẩm đều có giá trị `Sex`, có thể bỏ qua bước này
    }

    // Lấy các sản phẩm từ cơ sở dữ liệu
    QuerySnapshot productSnapshot = await query.get();

    List<products> productsList = productSnapshot.docs
        .map((doc) => products.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    // Lọc theo kích thước trong ứng dụng
    if (sizes.isNotEmpty) {
      productsList = productsList.where((product) {
        bool matches = false;
        if (sizes.contains('39') && int.parse(product.Size39) > 0) matches = true;
        if (sizes.contains('40') && int.parse(product.Size40) > 0) matches = true;
        // Lặp lại cho các kích thước khác...
        return matches;
      }).toList();
    }

    // Lọc theo danh mục trong ứng dụng
    if (categories.isNotEmpty) {
      productsList = productsList.where((product) {
        return categories.contains(product.Catelory);
      }).toList();
    }

    // Áp dụng bộ lọc theo khoảng giá
    productsList = productsList.where((product) {
      double price = double.parse(product.Price);
      return price >= minPrice && price <= maxPrice;
    }).toList();

    // Sắp xếp sản phẩm
    if (sortOption == 'Giá tăng dần') {
      productsList.sort((a, b) => double.parse(a.Price).compareTo(double.parse(b.Price)));
    } else if (sortOption == 'Giá giảm dần') {
      productsList.sort((a, b) => double.parse(b.Price).compareTo(double.parse(a.Price)));
    } else if (sortOption == 'Tên A-Z') {
      productsList.sort((a, b) => a.Name.compareTo(b.Name));
    } else if (sortOption == 'Tên Z-A') {
      productsList.sort((a, b) => b.Name.compareTo(a.Name));
    }

    return productsList;
  } catch (e) {
    print('Error loading products with filters: $e');
    return [];
  }
}


}
