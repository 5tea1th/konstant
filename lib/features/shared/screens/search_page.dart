import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [
    'mache balls',
    'kashmir vases',
    'jute bags',
    'terracotta',
    'bamboo weave craft',
  ];

  void _addSearch(String query) {
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        // Optional: Limit the number of recent searches
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      });
    }
  }

  void _removeSearch(String query) {
    setState(() {
      _recentSearches.remove(query);
    });
  }

  void _clearAllSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: EdgeInsets.zero,
          ),
          onSubmitted: (query) {
            _addSearch(query);
            // TODO: Implement actual search functionality here
            _searchController.clear();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implement search cancellation
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent searches',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton(
                  onPressed: _clearAllSearches,
                  child: const Text(
                    'Clear all',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _recentSearches.length,
                itemBuilder: (context, index) {
                  final item = _recentSearches[index];
                  return ListTile(
                    leading: const Icon(Icons.history, color: Colors.grey),
                    title: Text(item),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => _removeSearch(item),
                    ),
                    onTap: () {
                      // TODO: Implement search when tapping a recent item
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
