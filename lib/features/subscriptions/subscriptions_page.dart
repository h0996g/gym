import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppConstants.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subscriptions', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('Subscription management — coming soon.'),
        ],
      ),
    );
  }
}
