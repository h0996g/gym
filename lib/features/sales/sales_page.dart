import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppConstants.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sales', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('Sales & invoices — coming soon.'),
        ],
      ),
    );
  }
}
