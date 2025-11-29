import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String? description;
  final String category;
  final String priority;
  final bool completed;
  final int? estimatedMinutes;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;

  const TaskCard({
    super.key,
    required this.title,
    this.description,
    required this.category,
    required this.priority,
    required this.completed,
    this.estimatedMinutes,
    this.onTap,
    this.onToggle,
  });

  Color _priorityColor(BuildContext context) {
    switch (priority) {
      case 'high':
        return Colors.red.shade100;
      case 'low':
        return Colors.green.shade100;
      default:
        return Colors.orange.shade100;
    }
  }

  IconData _categoryIcon() {
    switch (category) {
      case 'cleaning':
        return Icons.cleaning_services;
      case 'chores':
        return Icons.check_circle_outline;
      case 'cooking':
        return Icons.restaurant;
      case 'errands':
        return Icons.shopping_cart;
      case 'outdoor':
        return Icons.yard;
      case 'organizing':
        return Icons.folder_outlined;
      case 'maintenance':
        return Icons.build;
      case 'planning':
        return Icons.event_note;
      default:
        return Icons.task_alt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: completed ? 0.5 : 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: completed ? Colors.grey.shade100 : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Checkbox(
                value: completed,
                onChanged: onToggle != null ? (_) => onToggle!() : null,
              ),
              const SizedBox(width: 8),
              Icon(
                _categoryIcon(),
                size: 20,
                color: completed ? Colors.grey : Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: completed ? TextDecoration.lineThrough : null,
                        color: completed ? Colors.grey : null,
                      ),
                    ),
                    if (description != null && description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _priorityColor(context),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            priority,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (estimatedMinutes != null)
                          Row(
                            children: [
                              Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '$estimatedMinutes min',
                                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
