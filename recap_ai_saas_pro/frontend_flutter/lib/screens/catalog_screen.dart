import 'package:flutter/material.dart';
import '../widgets/category_chip.dart';
import 'media_detail_screen.dart';

class CatalogItem {
  final int id;
  final String title;
  final String description;
  final String genre;
  final bool flagsCensure;
  final String status;

  CatalogItem({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.flagsCensure,
    required this.status,
  });
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final List<String> _categories = [
    'Tous',
    'Novelas',
    'Romance',
    'Shonen',
    'Action',
    'Hentai',
    'Combat',
    'Espionnage',
    'Seinen',
    'Isekai',
    'Fantasy',
  ];

  String _selectedCategory = 'Tous';
  String _searchQuery = '';

  final List<CatalogItem> _allCatalogItems = [
    CatalogItem(id: 1, title: 'Solo Leveling', description: 'Un chasseur de rang E devient le plus fort.', genre: 'Action', flagsCensure: false, status: 'Uncensored'),
    CatalogItem(id: 2, title: 'Kaguya-sama: Love Is War', description: 'Deux génies en amour.', genre: 'Romance', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 3, title: 'Naruto', description: "L'histoire d'un ninja déterminé.", genre: 'Shonen', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 4, title: 'Secret Romance', description: 'Roman adulte passionné.', genre: 'Hentai', flagsCensure: false, status: 'Uncensored'),
    CatalogItem(id: 5, title: 'Berserk', description: 'Le guerrier noir en quête de vengeance.', genre: 'Seinen', flagsCensure: false, status: 'Uncensored'),
    CatalogItem(id: 6, title: 'La Reina del Sur', description: 'Une telenovela captivante remplie de passion et d\'intrigue.', genre: 'Novelas', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 7, title: 'Teresa', description: 'Un drame mexicain intense et passionnant.', genre: 'Novelas', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 8, title: 'Code Geass', description: 'Lelouch mène la rébellion contre Britannia.', genre: 'Espionnage', flagsCensure: true, status: 'Censored'),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = _allCatalogItems.where((item) {
      final matchesCategory = _selectedCategory == 'Tous' || item.genre.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue Récap AI'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher un titre...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Horizontal Category Filter
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return CategoryChip(
                  label: category,
                  isSelected: _selectedCategory == category,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Catalog Grid / List
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text('Aucun élément trouvé'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isUncensored = item.status == 'Uncensored';
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MediaDetailScreen(
                                mediaId: item.id,
                                title: item.title,
                                description: item.description,
                                genre: item.genre,
                                status: item.status,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Chip(
                                      label: Text(
                                        item.genre,
                                        style: const TextStyle(fontSize: 10, color: Colors.white),
                                      ),
                                      backgroundColor: item.genre == 'Novelas' ? Colors.purple : Colors.blueGrey,
                                      padding: EdgeInsets.zero,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isUncensored ? Colors.redAccent : Colors.green,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.status,
                                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.description,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
