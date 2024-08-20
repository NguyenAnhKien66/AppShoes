import 'package:flutter/material.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';
import 'package:shoesapp/Screens/ControllerPage.dart';
import 'package:shoesapp/Screens/productCategoryScreen.dart';

class SearchScreen extends StatefulWidget {
   final String userId;

  const SearchScreen({super.key, required this.userId}); 
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> _hotKeywords = ['Giày sandal', 'Dép', 'Phụ kiện']; 
  List<String>  _searchHistory = [];
  String userId = SharedPrefsManager.getUserId();
  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  void _loadSearchHistory() async {
    await SharedPrefsManager.init();
    setState(() {
      _searchHistory = SharedPrefsManager.getSearchKeywords(userId);
    });
  }

  void _performSearch() {
  String keyword = _searchController.text.trim();
  if (keyword.isNotEmpty) {
    setState(() {
      if (!_searchHistory.contains(keyword)) {
        _searchHistory.add(keyword);
        SharedPrefsManager.saveStringList('search_keywords', _searchHistory);
      }
    });
    // _searchController.clear();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ControllerPage(searchTerm: keyword),
      ),
    );
  }
}


  void _deleteSearchKeyword(String keyword) {
    setState(() {
      _searchHistory.remove(keyword);
      SharedPrefsManager.saveStringList('search_keywords', _searchHistory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm sản phẩm...',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _performSearch,
            ),
          ),
          onSubmitted: (_) => _performSearch(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Từ khóa hot',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Wrap(
                spacing: 8.0,
                children: _hotKeywords.map((keyword) {
                  return ActionChip(
                    label: Text(keyword),
                    onPressed: () {
                      _searchController.text = keyword;
                      _performSearch();
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Lịch sử tìm kiếm',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Wrap(
                spacing: 8.0,
                children: _searchHistory.map((keyword) {
                  return Chip(
                    label: Text(keyword),
                    onDeleted: () => _deleteSearchKeyword(keyword),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
