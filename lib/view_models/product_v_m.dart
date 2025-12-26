import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:warsha_commerce/models/category_model.dart';
import 'package:warsha_commerce/models/product_model.dart';
import 'package:warsha_commerce/services/products_service.dart';

class ProductVM extends ChangeNotifier {
  final ProductService _productService;

  bool isLoading = false;

  String searchQuery = "";

  List<Product>? allProducts;
  List<CategoryModel>? allCategories;
  final TextEditingController searchController = TextEditingController();

  ProductVM(this._productService) {
    initAllProducts();
    searchController.addListener(() {
      notifyListeners();
    });
  }

  Future<void> initAllProducts () async {
    allProducts = await getAllProducts();
    allCategories = await getAllCategories();
    notifyListeners();
  }

  List<Product>? get filteredProducts {
    if (allProducts == null) return null;
    if (searchQuery.isEmpty) return allProducts;
    return allProducts!.where((p) =>
        p.name.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  Future<List<Product>> getAllProducts() async {
    List<Product> products = [];
    try {
      isLoading = true;
      final response = await _productService.getAllProducts("");
      if (response.statusCode == 200) {
        final productsData = jsonDecode(response.body);
        final List<dynamic> data = productsData;
        products = data.map((item) => Product.fromJson(item)).toList();
      } else {
        debugPrint("Failed to fetch products: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return products;
  }

  Future<List<CategoryModel>> getAllCategories() async {
    List<CategoryModel> categories = [];
    try {
      isLoading = true;
      final response = await _productService.getAllCategories("");
      if (response.statusCode == 200) {
        final categoriesData = jsonDecode(response.body);
        final List<dynamic> data = categoriesData;
        categories = data.map((item) => CategoryModel.fromJson(item)).toList();
      } else {
        debugPrint("Failed to fetch categories: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return categories;
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

}
