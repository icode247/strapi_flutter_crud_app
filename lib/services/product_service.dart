import 'package:dio/dio.dart';
import 'package:flutter_strapi_crud/models/product.dart';

class ProductService {
  final Dio _dio;

  ProductService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'http://localhost:1337/api',
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      final List<dynamic> data = response.data['data'];
      return data.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      throw 'Failed to load products: ${e.toString()}';
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      final response = await _dio.post('/products', data: {
        'data': {
          'name': product.name,
          'description': product.description,
          'price': product.price,
        }
      });
      return Product.fromJson(response.data['data']);
    } catch (e) {
      throw 'Failed to create product: ${e.toString()}';
    }
  }

  Future<Product> updateProduct(String id, Product product) async {
    try {
      print(id);
      final response = await _dio.put('/products/$id', data: {
        'data': {
          'name': product.name,
          'description': product.description,
          'price': product.price,
        }
      });
      return Product.fromJson(response.data['data']);
    } catch (e) {
      throw 'Failed to update product: ${e.toString()}';
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _dio.delete('/products/$id');
    } catch (e) {
      throw 'Failed to delete product: ${e.toString()}';
    }
  }
}
