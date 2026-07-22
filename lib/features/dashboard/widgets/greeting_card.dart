import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/app_colors.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = DateFormat('dd MMMM yyyy').format(now);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(radius: 28, child: Icon(Icons.waving_hand)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(fontSize: 14, color: AppColors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Mari Rojmel',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(date, style: const TextStyle(color: AppColors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
