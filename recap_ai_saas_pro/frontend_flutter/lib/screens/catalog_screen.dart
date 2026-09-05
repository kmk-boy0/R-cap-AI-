import 'package:flutter/material.dart';
import '../widgets/category_chip.dart';
import '../widgets/format_filter_bar.dart';

class CatalogItem {
  final int id;
  final String title;
  final String description;
  final String mediaFormat;
  final String genre;
  final bool flagsCensure;
  final String status;
  final bool isAdultContent;

  CatalogItem({
    required this.id,
    required this.title,
    required this.description,
    required this.mediaFormat,
    required this.genre,
    required this.flagsCensure,
    required this.status,
    this.isAdultContent = false,
  });
}

class CatalogScreen extends StatefulWidget {
  final bool isUncensoredMode;

  const CatalogScreen({
    Key? key,
    this.isUncensoredMode = false,
  }) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _formats = [
    'Tous Formats',
    'Kdrama',
    'Drama Chinois',
    'Drama',
    'Novelas',
    'Dessin Animé',
    'Anime',
    'Court-métrage',
    'Long-métrage',
    'Série Porno',
    'Film Porno',
    'Hentai',
  ];

  final List<String> _genres = [
    'Tous',
    'Romance',
    'Shonen',
    'Action',
    'Combat',
    'Espionnage',
    'Seinen',
    'Isekai',
    'Thriller',
    'Fantasy',
    'Sci-Fi',
  ];

  String _selectedFormat = 'Tous Formats';
  String _selectedGenre = 'Tous';
  String _searchQuery = '';
  bool _adultSectionOnly = false;

  final List<CatalogItem> _allCatalogItems = [
    CatalogItem(id: 1, title: 'Solo Leveling', description: 'Un chasseur de rang E devient le plus fort.', mediaFormat: 'Anime', genre: 'Action', flagsCensure: false, status: 'Uncensored'),
    CatalogItem(id: 2, title: 'Kaguya-sama: Love Is War', description: 'Deux génies en amour.', mediaFormat: 'Anime', genre: 'Romance', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 3, title: 'Naruto', description: "L'histoire d'un ninja déterminé.", mediaFormat: 'Anime', genre: 'Shonen', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 4, title: 'Secret Romance', description: 'Roman adulte passionné.', mediaFormat: 'Hentai', genre: 'Hentai', flagsCensure: false, status: 'Uncensored', isAdultContent: true),
    CatalogItem(id: 5, title: 'Berserk', description: 'Le guerrier noir en quête de vengeance.', mediaFormat: 'Anime', genre: 'Seinen', flagsCensure: false, status: 'Uncensored'),
    CatalogItem(id: 6, title: 'Code Geass', description: 'Lelouch mène la rébellion contre Britannia.', mediaFormat: 'Anime', genre: 'Espionnage', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 7, title: 'Crash Landing on You', description: 'Une héritière sud-coréenne atterrit accidentellement en Corée du Nord.', mediaFormat: 'Kdrama', genre: 'Romance', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 8, title: 'The Untamed', description: "Deux cultivateurs d'âmes enquêtent sur de sombres mystères.", mediaFormat: 'Drama Chinois', genre: 'Fantasy', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 9, title: 'Rubi', description: 'Une femme ambitieuse prête à tout pour la richesse.', mediaFormat: 'Novelas', genre: 'Romance', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 10, title: 'Les Minions', description: "Un petit film d'animation drôle.", mediaFormat: 'Dessin Animé', genre: 'Action', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 11, title: 'Inception', description: "Un voleur qui s'infiltre dans les rêves.", mediaFormat: 'Long-métrage', genre: 'Sci-Fi', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 12, title: 'Piper', description: "Un jeune oiseau apprend à surmonter sa peur de l'eau.", mediaFormat: 'Court-métrage', genre: 'Fantasy', flagsCensure: true, status: 'Censored'),
    CatalogItem(id: 13, title: 'Midnight Passion', description: 'Série adulte réservée au public averti.', mediaFormat: 'Série Porno', genre: 'Hentai', flagsCensure: false, status: 'Uncensored', isAdultContent: true),
    CatalogItem(id: 14, title: 'Adult Cinema Night', description: 'Film adulte romantique.', mediaFormat: 'Film Porno', genre: 'Romance', flagsCensure: false, status: 'Uncensored', isAdultContent: true),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _adultSectionOnly = _tabController.index == 1;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _isAdultFormat(String format) {
    return format == 'Série Porno' || format == 'Film Porno' || format == 'Hentai';
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _allCatalogItems.where((item) {
      // 18+ Section Isolation
      if (_adultSectionOnly) {
        if (!item.isAdultContent && !_isAdultFormat(item.mediaFormat)) {
          return false;
        }
      } else {
        // Main General Section: Hide 18+ content unless requested specifically by format or uncensored mode
        if ((item.isAdultContent || _isAdultFormat(item.mediaFormat)) && _selectedFormat == 'Tous Formats') {
          return false;
        }
      }

      // Filter by Format
      if (_selectedFormat != 'Tous Formats' && item.mediaFormat.toLowerCase() != _selectedFormat.toLowerCase()) {
        return false;
      }

      // Filter by Genre
      if (_selectedGenre != 'Tous' && item.genre.toLowerCase() != _selectedGenre.toLowerCase()) {
        return false;
      }

      // Filter by Search Query
      if (_searchQuery.isNotEmpty && !item.title.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // Global Censorship / Mode Switch Rule:
      // If global mode is censored (widget.isUncensoredMode == false), show censored items or mark uncensored content as protected
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue Récap AI'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.movie_outlined), text: 'Général'),
            Tab(icon: Icon(Icons.explicit), text: 'Espace Adulte (18+)'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher un titre, drama, film...',
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

          // Horizontal Format Filter Bar
          FormatFilterBar(
            formats: _formats,
            selectedFormat: _selectedFormat,
            onFormatSelected: (format) {
              setState(() {
                _selectedFormat = format;
              });
            },
          ),

          const SizedBox(height: 8),

          // Horizontal Genre Filter Bar
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: _genres.length,
              itemBuilder: (context, index) {
                final genre = _genres[index];
                return CategoryChip(
                  label: genre,
                  isSelected: _selectedGenre == genre,
                  onTap: () {
                    setState(() {
                      _selectedGenre = genre;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Status & Censorship Info Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _adultSectionOnly ? 'Section Restreinte (18+)' : 'Contenus Grand Public & Séries',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Chip(
                  avatar: Icon(
                    widget.isUncensoredMode ? Icons.lock_open : Icons.lock,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    widget.isUncensoredMode ? 'Mode Uncensored' : 'Mode Censored',
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  backgroundColor: widget.isUncensoredMode ? Colors.redAccent : Colors.green,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Catalog Grid / List
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          _adultSectionOnly
                              ? 'Aucun contenu adulte correspondant trouvé'
                              : 'Aucun contenu trouvé dans cette catégorie',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isUncensoredItem = item.status == 'Uncensored';
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.mediaFormat,
                                        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isUncensoredItem ? Colors.redAccent : Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.status,
                                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Genre: ${item.genre}',
                                style: const TextStyle(fontSize: 11, color: Colors.blueAccent),
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
