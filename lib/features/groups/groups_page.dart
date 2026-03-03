import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppConstants.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Groups', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('Training groups management — coming soon.'),
        ],
      ),
    );
  }
}
