import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final String title;
  final String? description;
  final String category;
  final String? targetDate;
  final int progress;
  final VoidCallback? onTap;

  const GoalCard({
    super.key,
    required this.title,
    this.description,
    required this.category,
    this.targetDate,
    required this.progress,
    this.onTap,
  });

  IconData _categoryIcon() {
    switch (category) {
      case 'cleaning':
        return Icons.cleaning_services;
      case 'organizing':
        return Icons.folder_outlined;
      case 'cooking':
        return Icons.restaurant;
      case 'outdoor':
        return Icons.yard;
      default:
        return Icons.flag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      _categoryIcon(),
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (targetDate != null)
                          Text(
                            'Target: $targetDate',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '$progress%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Colors.grey.shade200,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              if (description != null && description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  description!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
