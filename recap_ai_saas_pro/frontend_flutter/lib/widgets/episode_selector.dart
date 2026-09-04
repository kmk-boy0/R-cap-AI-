import 'package:flutter/material.dart';

class Episode {
  final int number;
  final String title;
  final String type; // "video" or "text"
  final String durationOrPages;

  Episode({
    required this.number,
    required this.title,
    required this.type,
    required this.durationOrPages,
  });
}

class EpisodeSelector extends StatefulWidget {
  final List<Episode> episodes;
  final Episode? selectedEpisode;
  final ValueChanged<Episode> onEpisodeSelected;

  const EpisodeSelector({
    Key? key,
    required this.episodes,
    this.selectedEpisode,
    required this.onEpisodeSelected,
  }) : super(key: key);

  @override
  State<EpisodeSelector> createState() => _EpisodeSelectorState();
}

class _EpisodeSelectorState extends State<EpisodeSelector> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEpisodes = widget.episodes.where((ep) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase().trim();
      return ep.title.toLowerCase().contains(q) || ep.number.toString() == q;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAlignment.start,
      children: [
        // Fine Search Bar for Episode / Chapter number
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher un numéro ou titre (ex: "Épisode 45", "112")...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
        ),

        const SizedBox(height: 8),

        // Scrollable Episode/Chapter selector
        SizedBox(
          height: 140,
          child: filteredEpisodes.isEmpty
              ? const Center(child: Text('Aucun épisode ou chapitre trouvé'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredEpisodes.length,
                  itemBuilder: (context, index) {
                    final ep = filteredEpisodes[index];
                    final isSelected = widget.selectedEpisode?.number == ep.number;

                    return GestureDetector(
                      onTap: () => widget.onEpisodeSelected(ep),
                      child: Container(
                        width: 130,
                        margin: const EdgeInsets.only(right: 10, top: 4, bottom: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              ep.type == 'video' ? Icons.play_circle_fill : Icons.article,
                              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ep.title,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ep.durationOrPages,
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected ? Colors.white70 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
