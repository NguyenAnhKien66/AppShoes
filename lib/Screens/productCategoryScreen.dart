import 'package:flutter/material.dart';
import 'package:shoesapp/Component/DialogFillter.dart';
import 'package:shoesapp/Component/ProductList.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';

class ProductCategoryScreen extends StatefulWidget {
  final String? searchTerm;

  ProductCategoryScreen({this.searchTerm});

  @override
  _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> _filters = {};
  String userId = SharedPrefsManager.getUserId();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void _openFilterDialog() async {
    final filters = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FilterDialog(),
    );

    if (filters != null) {
      setState(() {
        _filters = filters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
           padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 80,
                            child: Text('Tất cả', textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 80,
                            child: Text('Nam', textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 80,
                            child: Text('Nữ', textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 100,
                            child: Text('Bé trai', textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 100,
                            child: Text('Bé gái', textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ],
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.zero,
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.white),
                  onPressed: _openFilterDialog,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ProductList(sex: 'Tất cả', filters: _filters, searchTerm: widget.searchTerm),
                ProductList(sex: 'Nam', filters: _filters, searchTerm: widget.searchTerm),
                ProductList(sex: 'Nữ', filters: _filters, searchTerm: widget.searchTerm),
                ProductList(sex: 'Bé trai', filters: _filters, searchTerm: widget.searchTerm),
                ProductList(sex: 'Bé gái', filters: _filters, searchTerm: widget.searchTerm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
