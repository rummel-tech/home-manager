import 'package:flutter/material.dart';

class WeeklyTasksPreview extends StatelessWidget {
  final Map<String, dynamic> weeklyData;
  final VoidCallback? onTap;

  const WeeklyTasksPreview({
    super.key,
    required this.weeklyData,
    this.onTap,
  });

  Map<String, List<dynamic>> _groupTasksByDay() {
    final tasks = weeklyData['tasks'] as List<dynamic>? ?? [];
    final grouped = <String, List<dynamic>>{};

    for (var task in tasks) {
      final day = task['day'] as String? ?? 'Unknown';
      if (!grouped.containsKey(day)) {
        grouped[day] = [];
      }
      grouped[day]!.add(task);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedTasks = _groupTasksByDay();
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Weekly Tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                ],
              ),
              const SizedBox(height: 16),
              ...days.take(3).map((day) {
                final dayTasks = groupedTasks[day] ?? [];
                final completed = dayTasks.where((t) => t['completed'] == true).length;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '$completed/${dayTasks.length} completed',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 60,
                        child: LinearProgressIndicator(
                          value: dayTasks.isEmpty ? 0 : completed / dayTasks.length,
                          backgroundColor: Colors.grey.shade200,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              if (days.length > 3) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: onTap,
                    child: const Text('View Full Week'),
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
