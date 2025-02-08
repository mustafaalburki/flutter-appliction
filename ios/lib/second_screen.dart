import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_filter_app/theme_provaider.dart';
import '../theme/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isFilterEnabled = false;
  String _filterText = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter App'),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter Filter Text',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _textController.clear();
                    setState(() {
                      _filterText = '';
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _filterText = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Enable Filter'),
                const SizedBox(width: 8),
                Switch(
                  value: _isFilterEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isFilterEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_isFilterEnabled && _filterText.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Filter applied: $_filterText'),
                    ),
                  );
                }
              },
              child: const Text('Apply Filter'),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Filter Enabled: $_isFilterEnabled'),
                    Text('Current Filter: ${_filterText.isEmpty ? "None" : _filterText}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
