import 'package:flutter/material.dart';
import 'package:shoesapp/Component/BackToTopButton.dart';
import 'package:shoesapp/Component/ButtonSize.dart';
import 'package:shoesapp/Component/PriceText.dart';
import 'package:shoesapp/Component/product_info.dart';
import 'package:shoesapp/Component/size_selector.dart';
import 'package:shoesapp/Component/thumbnail_list.dart';
import 'package:shoesapp/Data/Products_reader.dart';
import 'package:shoesapp/Data/ImagePoduct_reader.dart';
import 'package:shoesapp/Component/Product_Image.dart';
import 'package:shoesapp/Component/NavBottomDetail.dart';
import 'package:shoesapp/Data/carts_reader.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';
import 'package:shoesapp/Screens/CartScreen.dart';
import 'package:shoesapp/Data/Favorites_reader.dart';


class detail_screen extends StatefulWidget {
  final products product;

  detail_screen({super.key, required this.product});

  @override
  State<detail_screen> createState() => _detail_screenState();
}

class _detail_screenState extends State<detail_screen> {
  late String _currentImage;
  String userId = SharedPrefsManager.getUserId(); 
  List<String> _thumbnails = [];
  String _selectedSize = '39';
  String _quantity = '';
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ButtonSizeState> _buttonSizeKey = GlobalKey<ButtonSizeState>();
  bool _isFavorite = false;
  late Favorites _favorites; 
  late CartService _cartService; 

  @override
  void initState() {
    super.initState();
    _currentImage = widget.product.Image;
    _loadThumbnails();
    _updateQuantity();
    _favorites = Favorites(userId);
    _scrollController.addListener(_scrollListener);
    _checkIfFavorite();
    _cartService = CartService(userId); 
  }

  Future<void> _refreshData() async {
    await Future.wait([
  
      _loadThumbnails(),
    ] as Iterable<Future>);
  }

  

  void _scrollListener() {
    setState(() {});
  }

   Future<void> _addToFavorites() async { 
    try {
      if (_isFavorite) {
        await _favorites.removeFromFavorites(widget.product.Id);
      } else {
        await _favorites.addToFavorites(widget.product.Id);
      }
      setState(() {
        _isFavorite = !_isFavorite;
      });
    } catch (e) {
      print('Lỗi khi thêm/xóa khỏi yêu thích: $e');
    }
  }

  Future<void> _addToCart() async {
  final size = _selectedSize;
  final quantity = _buttonSizeKey.currentState?.quantity ?? 1; 
  final availableQuantity = int.tryParse(_quantity) ?? 0; 

  try {
    final isSuccess = await _cartService.isConfirmTrue(
      productId: widget.product.Id,
      name: widget.product.Name,
      imageUrl: widget.product.Image,
      price: double.parse(widget.product.Discount)>0?((double.parse(widget.product.Price) - (double.parse(widget.product.Price)*(double.parse(widget.product.Discount)/100.0)))).toString():widget.product.Price,
      quantity: quantity,
      size: size,
      sex: widget.product.Sex,
      availableQuantity: availableQuantity,
    );

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added to cart successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add product to cart.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An error occurred while adding the product to cart.'),
        backgroundColor: Colors.red,
      ),
    );
    print('Error adding product to cart: $e');
  }
}
 Future<void> _checkIfFavorite() async { 
    final isFavorite = await _favorites.isFavorite(widget.product.Id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  void _loadThumbnails() async {
    try {
      imgProducts imageProduct = await imgProducts.loadImagesById(widget.product.Id);
      setState(() {
        _thumbnails = imageProduct.img;
      });
    } catch (e) {
      setState(() {
        _thumbnails = [];
      });
    }
  }
  
  void _updateCurrentImage(String imageUrl) {
    setState(() {
      _currentImage = imageUrl;
    });
  }

  void _updateQuantity() {
    switch (_selectedSize) {
      case '39':
        _quantity = widget.product.Size39;
        break;
      case '40':
        _quantity = widget.product.Size40;
        break;
      case '41':
        _quantity = widget.product.Size41;
        break;
      case '42':
        _quantity = widget.product.Size42;
        break;
      case '43':
        _quantity = widget.product.Size43;
        break;
      case '44':
        _quantity = widget.product.Size44;
        break;
      case '45':
        _quantity = widget.product.Size45;
        break;
      default:
        _quantity = 'Chưa chọn kích cỡ';
    }
    _buttonSizeKey.currentState?.resetQuantity();
  }

  @override
  Widget build(BuildContext context) {
    int maxQuantity = int.tryParse(_quantity) ?? 0;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.Name),
        actions: [IconButton(
            icon: const Icon(Icons.shopping_cart_sharp, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          ),],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  product_image(
                    currentImage: _currentImage,
                    discount: widget.product.Discount,
                  ),
                  thumbnail_list(
                    thumbnails: _thumbnails,
                    onThumbnailSelected: _updateCurrentImage,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.Name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), softWrap: true),
                        PriceText(price:widget.product.Price, discount: widget.product.Discount),
                        product_info(
                          quantity: _quantity,
                        ),
                        const Text('Chọn kích cỡ:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        size_selector(
                          selectedSize: _selectedSize,
                          onSizeSelected: (size) {
                            setState(() {
                              _selectedSize = size;
                              _updateQuantity();
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        ButtonSize(
                          maxQuantity: maxQuantity,
                          key: _buttonSizeKey,
                        ),
                        const SizedBox(height: 10),
                        Text(widget.product.Description)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BackToTopButton(scrollController: _scrollController),
          ],
        ),
      ),
       
      bottomNavigationBar: nav_bottom_detail(
        onAddToCart: _addToCart,
        onFavoriteToggle: _addToFavorites, isFavorite: _isFavorite,
      ),
    
    );
  }
}
