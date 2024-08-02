import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  double _minPrice = 0;
  double _maxPrice = 500;
  String _sortOption = 'Giá tăng dần';
  List<String> _selectedSizes = [];
  List<String> _selectedCategories = [];
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadFilterData();
  }

  Future<void> _loadFilterData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _minPrice = prefs.getDouble('minPrice') ?? 0;
      _maxPrice = prefs.getDouble('maxPrice') ?? 500;
      _sortOption = prefs.getString('sortOption') ?? 'Giá tăng dần';
      _selectedSizes = prefs.getStringList('selectedSizes') ?? [];
      _selectedCategories = prefs.getStringList('selectedCategories') ?? [];
      _selectedStatus = prefs.getString('selectedStatus') ?? 'All';
    });
  }

  Future<void> _saveFilterData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('minPrice', _minPrice);
    await prefs.setDouble('maxPrice', _maxPrice);
    await prefs.setString('sortOption', _sortOption);
    await prefs.setStringList('selectedSizes', _selectedSizes);
    await prefs.setStringList('selectedCategories', _selectedCategories);
    await prefs.setString('selectedStatus', _selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bộ Lọc Sản Phẩm'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sort Options
            ListTile(
              title: Text('Sắp xếp theo'),
              subtitle: DropdownButton<String>(
                value: _sortOption,
                items: const [
                  DropdownMenuItem(child: Text('Giá tăng dần'), value: 'Giá tăng dần'),
                  DropdownMenuItem(child: Text('Giá giảm dần'), value: 'Giá giảm dần'),
                  DropdownMenuItem(child: Text('Tên A-Z'), value: 'Tên A-Z'),
                  DropdownMenuItem(child: Text('Tên Z-A'), value: 'Tên Z-A'),
                  DropdownMenuItem(child: Text('Sản Phẩm mới'), value: 'Sản Phẩm mới'),
                  DropdownMenuItem(child: Text('Sản phẩm cũ'), value: 'Sản phẩm cũ'),
                ],
                onChanged: (value) {
                  setState(() {
                    _sortOption = value!;
                  });
                },
              ),
            ),
            // Price Range Slider
            ListTile(
              title: const Text('Giá'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${_minPrice.toStringAsFixed(0)} '),
                      Text('\$${_maxPrice.toStringAsFixed(0)} '),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 500,
                    divisions: 100,
                    labels: RangeLabels(
                      '\$ ${_minPrice.toStringAsFixed(0)} ',
                      '\$ ${_maxPrice.toStringAsFixed(0)} ',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                ],
              ),
            ),
            // Size Filters
            ListTile(
              title: const Text('Kích thước'),
              subtitle: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(7, (index) {
                  String size = (39 + index).toString();
                  return FilterChip(
                    label: Text(size),
                    selected: _selectedSizes.contains(size),
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          _selectedSizes.add(size);
                        } else {
                          _selectedSizes.remove(size);
                        }
                      });
                    },
                  );
                }),
              ),
            ),
            // Category Filters
            ListTile(
              title: const Text('Thể loại'),
              subtitle: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildCategoryChip('Giày Bata'),
                  _buildCategoryChip('Giày Sandal'),
                  _buildCategoryChip('Giày Thể Thao'),
                  _buildCategoryChip('Dép'),
                  _buildCategoryChip('Phụ Kiện'),
                ],
              ),
            ),
            ListTile(
              title: const Text('Trạng thái'),
              subtitle: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildStatusChip('All'),
                  _buildStatusChip('New Products'),
                  _buildStatusChip('Super Promotions'),
                  _buildStatusChip('Best Sellers'),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              // Đặt lại các bộ lọc về giá trị mặc định
              _minPrice = 0;
              _maxPrice = 500;
              _sortOption = 'Giá tăng dần';
              _selectedSizes = [];
              _selectedCategories = [];
              _selectedStatus = 'All';
            });
            _saveFilterData();
          },
          child: const Text('Reset'),
        ),
        TextButton(
          onPressed: () {
            _saveFilterData();
            Navigator.pop(context, {
              'minPrice': _minPrice,
              'maxPrice': _maxPrice,
              'sortOption': _sortOption,
              'sizes': _selectedSizes,
              'categories': _selectedCategories,
              'status': _selectedStatus,
            });
          },
          child: const Text('Áp dụng'),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category) {
    return FilterChip(
      label: Text(category),
      selected: _selectedCategories.contains(category),
      onSelected: (isSelected) {
        setState(() {
          if (isSelected) {
            _selectedCategories.add(category);
          } else {
            _selectedCategories.remove(category);
          }
        });
      },
    );
  }

  Widget _buildStatusChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedStatus == label,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = label;
        });
      },
    );
  }
}
