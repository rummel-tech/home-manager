import 'package:flutter/material.dart';
import '../services/home_api_service.dart';
import '../ui_components/task_card.dart';
import '../ui_components/goal_card.dart';
import '../ui_components/weekly_tasks_preview.dart';

class HomeManagerScreen extends StatefulWidget {
  final String userId;
  final VoidCallback? onLogout;

  const HomeManagerScreen({super.key, required this.userId, this.onLogout});

  @override
  State<HomeManagerScreen> createState() => _HomeManagerScreenState();
}

class _HomeManagerScreenState extends State<HomeManagerScreen> {
  final _apiService = HomeApiService();
  bool _loadingTasks = true;
  bool _loadingGoals = true;
  bool _loadingStats = true;
  bool _loadingWeekly = true;
  String? _tasksError;
  String? _goalsError;
  String? _statsError;
  Map<String, dynamic>? _todayTasks;
  Map<String, dynamic>? _goals;
  Map<String, dynamic>? _stats;
  Map<String, dynamic>? _weeklyTasks;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _loadTodayTasks();
    _loadGoals();
    _loadStats();
    _loadWeeklyTasks();
  }

  Future<void> _loadTodayTasks() async {
    setState(() {
      _loadingTasks = true;
      _tasksError = null;
    });
    try {
      final data = await _apiService.getTodayTasks(widget.userId);
      setState(() {
        _todayTasks = data;
        _loadingTasks = false;
      });
    } catch (e) {
      setState(() {
        _tasksError = '$e';
        _loadingTasks = false;
      });
    }
  }

  Future<void> _loadGoals() async {
    setState(() {
      _loadingGoals = true;
      _goalsError = null;
    });
    try {
      final data = await _apiService.getGoals(widget.userId);
      setState(() {
        _goals = data;
        _loadingGoals = false;
      });
    } catch (e) {
      setState(() {
        _goalsError = '$e';
        _loadingGoals = false;
      });
    }
  }

  Future<void> _loadStats() async {
    setState(() {
      _loadingStats = true;
      _statsError = null;
    });
    try {
      final data = await _apiService.getStats(widget.userId);
      setState(() {
        _stats = data;
        _loadingStats = false;
      });
    } catch (e) {
      setState(() {
        _statsError = '$e';
        _loadingStats = false;
      });
    }
  }

  Future<void> _loadWeeklyTasks() async {
    setState(() {
      _loadingWeekly = true;
    });
    try {
      final data = await _apiService.getWeeklyTasks(widget.userId);
      setState(() {
        _weeklyTasks = data;
        _loadingWeekly = false;
      });
    } catch (e) {
      setState(() {
        _loadingWeekly = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadData,
          ),
          if (widget.onLogout != null)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: widget.onLogout,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 1,
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.home)),
                title: const Text('Home Management'),
                subtitle: const Text('Your weekly tasks and goals'),
              ),
            ),
            const SizedBox(height: 16),

            // Stats Section
            if (_loadingStats)
              const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
            else if (_stats != null)
              _buildStatsCard(),

            const SizedBox(height: 16),

            // Today's Tasks
            Text(
              'Today\'s Tasks',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (_loadingTasks)
              const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
            else if (_tasksError != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $_tasksError', style: const TextStyle(color: Colors.red)),
                ),
              )
            else if (_todayTasks != null) ...[
              Text(
                _todayTasks!['day'] ?? 'Today',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              ...(_todayTasks!['tasks'] as List<dynamic>? ?? []).map((task) {
                return TaskCard(
                  title: task['title'] ?? 'Untitled',
                  description: task['description'],
                  category: task['category'] ?? 'general',
                  priority: task['priority'] ?? 'medium',
                  completed: task['completed'] ?? false,
                  estimatedMinutes: task['estimated_minutes'],
                );
              }).toList(),
            ],

            const SizedBox(height: 24),

            // Weekly Preview
            if (!_loadingWeekly && _weeklyTasks != null)
              WeeklyTasksPreview(
                weeklyData: _weeklyTasks!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WeeklyTasksScreen(weeklyData: _weeklyTasks!),
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            // Goals Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Goals',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Goal'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_loadingGoals)
              const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
            else if (_goalsError != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $_goalsError', style: const TextStyle(color: Colors.red)),
                ),
              )
            else if (_goals != null) ...[
              ...(_goals!['goals'] as List<dynamic>? ?? []).map((goal) {
                return GoalCard(
                  title: goal['title'] ?? 'Untitled',
                  description: goal['description'],
                  category: goal['category'] ?? 'general',
                  targetDate: goal['target_date'],
                  progress: goal['progress'] ?? 0,
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    final taskStats = _stats!['tasks'] as Map<String, dynamic>? ?? {};
    final goalStats = _stats!['goals'] as Map<String, dynamic>? ?? {};

    return Card(
      elevation: 2,
      color: Theme.of(context).primaryColor.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _statColumn(
                    'Tasks',
                    '${taskStats['completed']}/${taskStats['total']}',
                    'completed',
                  ),
                ),
                Expanded(
                  child: _statColumn(
                    'Completion',
                    '${taskStats['completion_rate']}%',
                    'rate',
                  ),
                ),
                Expanded(
                  child: _statColumn(
                    'Goals',
                    '${goalStats['active']}',
                    'active',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statColumn(String label, String value, String subtitle) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}

class WeeklyTasksScreen extends StatelessWidget {
  final Map<String, dynamic> weeklyData;

  const WeeklyTasksScreen({super.key, required this.weeklyData});

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Tasks'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: days.map((day) {
          final dayTasks = groupedTasks[day] ?? [];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (dayTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('No tasks for this day', style: TextStyle(color: Colors.grey)),
                    )
                  else
                    ...dayTasks.map((task) {
                      return TaskCard(
                        title: task['title'] ?? 'Untitled',
                        description: task['description'],
                        category: task['category'] ?? 'general',
                        priority: task['priority'] ?? 'medium',
                        completed: task['completed'] ?? false,
                        estimatedMinutes: task['estimated_minutes'],
                      );
                    }).toList(),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
