import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppConstants.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Products', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('Product catalog & inventory — coming soon.'),
        ],
      ),
    );
  }
}
