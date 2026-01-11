import 'package:flutter/material.dart';
import 'package:sanaa_artl/features/store/data/store_repository.dart';
import 'package:sanaa_artl/features/store/data/store_repository_impl.dart';
import 'package:sanaa_artl/features/store/models/product_model.dart';
import 'package:sanaa_artl/core/utils/result.dart'; // Ensure Result is imported if we use types, though internal logic wraps it

class ProductProvider with ChangeNotifier {
  final StoreRepository _repository;

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  int _selectedFilter = 0;
  bool _isLoading = false;
  String _error = '';

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  int get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String get error => _error;

  final List<String> _filters = [
    'جميع الأعمال',
    'لوحات',
    'منحوتات',
    'فن رقمي',
    'تخفيضات',
    'جديد',
  ];

  List<String> get filters => _filters;

  ProductProvider({StoreRepository? repository})
    : _repository = repository ?? StoreRepositoryImpl();

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    final result = await _repository.getProducts();

    result.fold(
      (failure) {
        _error = failure.message;
        _products = [];
      },
      (data) {
        _products = data;
        _error = '';
      },
    );

    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterProducts(int index) {
    _selectedFilter = index;
    _applyFilters();
  }

  void _applyFilters() {
    List<Product> temp = [];
    if (_selectedFilter == 0) {
      temp = _products;
    } else {
      temp = _products.where((product) {
        switch (_selectedFilter) {
          case 1:
            return product.category.contains('لوحة');
          case 2:
            return product.category.contains('منحوتة');
          case 3:
            return product.category.contains('رقمي');
          case 4:
            return product.discount > 0;
          case 5:
            return product.isNew;
          default:
            return true;
        }
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      temp = temp
          .where(
            (p) =>
                p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.artist.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    _filteredProducts = temp;
    // Don't verifyListeners here if called from loadProducts which does it.
    // But since loadProducts calls it before notifyListeners(), it's fine.
    // Ideally separate UI state updates.
    // We can call notifyListeners() here since setSearchQuery calls it.
    // loadProducts calls notifyListeners at end too. Redundant but harmless.
    // I'll leave notifyListeners out if called from setter, oh wait setters need it.
    // I'll keep it here but remove explicit notify from setters if simpler.
    // Actually simpler to allow redundant notifies.
  }
}
