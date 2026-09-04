import 'package:flutter/material.dart';
import '../widgets/episode_selector.dart';
import 'direct_reader_screen.dart';

class MediaDetailScreen extends StatefulWidget {
  final int mediaId;
  final String title;
  final String description;
  final String genre;
  final String status;

  const MediaDetailScreen({
    Key? key,
    required this.mediaId,
    required this.title,
    required this.description,
    required this.genre,
    required this.status,
  }) : super(key: key);

  @override
  State<MediaDetailScreen> createState() => _MediaDetailScreenState();
}

class _MediaDetailScreenState extends State<MediaDetailScreen> {
  late List<Episode> _episodes;
  Episode? _selectedEpisode;
  bool _isLoadingRecap = false;
  String? _generatedRecap;

  @override
  void initState() {
    super.initState();
    final isVideoType = widget.genre.toLowerCase() == 'novelas' ||
        widget.genre.toLowerCase() == 'shonen' ||
        widget.genre.toLowerCase() == 'action';

    final prefix = isVideoType ? 'Épisode' : 'Chapitre';
    final total = isVideoType ? 50 : 120;

    _episodes = List.generate(
      total,
      (index) => Episode(
        number: index + 1,
        title: '$prefix ${index + 1}',
        type: isVideoType ? 'video' : 'text',
        durationOrPages: isVideoType ? '45 min' : '20 pages',
      ),
    );

    _selectedEpisode = _episodes.first;
  }

  void _generateRecap() async {
    setState(() {
      _isLoadingRecap = true;
      _generatedRecap = null;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isLoadingRecap = false;
      _generatedRecap =
          "# Résumé Détaillé (+5000 mots) : ${widget.title} - ${_selectedEpisode?.title}\n\n"
          "## Synthèse Narrative Complète\n"
          "Dans cet épisode clé de ${widget.title}, les tensions atteignent leur paroxysme. "
          "Chaque retournement de situation est minutieusement analysé par le moteur RAG/LLM Récap AI.\n\n"
          "## Analyse des Personnages & Intrigues\n"
          "- Les motivations secrètes de l'amoureux/protagoniste.\n"
          "- Résolution du conflit principal et préparation des événements futurs.";
    });
  }

  void _openDirectOriginal() {
    final currentEp = _selectedEpisode ?? _episodes.first;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DirectReaderScreen(
          mediaId: widget.mediaId,
          title: widget.title,
          episodeNumber: currentEp.number,
          contentType: currentEp.type,
          streamUrl: "https://cdn.recapai.sample/streams/media_${widget.mediaId}_ep_${currentEp.number}.mp4",
          textContent: "# ${widget.title} - ${currentEp.title}\n\nContenu original brut du chapitre sans résumé.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Media Genre & Status Badge
            Row(
              children: [
                Chip(
                  label: Text(
                    widget.genre,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: widget.genre == 'Novelas' ? Colors.purple : Colors.blueGrey,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.status == 'Uncensored' ? Colors.redAccent : Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              widget.description,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 20),

            // Episode / Chapter Search & Selector
            const Text(
              "Sélectionner un Épisode / Chapitre",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            EpisodeSelector(
              episodes: _episodes,
              selectedEpisode: _selectedEpisode,
              onEpisodeSelected: (ep) {
                setState(() {
                  _selectedEpisode = ep;
                  _generatedRecap = null;
                });
              },
            ),
            const SizedBox(height: 24),

            // Dual Mode Action Buttons
            Row(
              children: [
                // Button 1: "Générer le Récap (+5000 mots)"
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text(
                      "Générer le Récap\n(+5000 mots)",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _isLoadingRecap ? null : _generateRecap,
                  ),
                ),
                const SizedBox(width: 12),

                // Button 2: "Voir l'Original"
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.redAccent, width: 2),
                      foregroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(_selectedEpisode?.type == 'video' ? Icons.play_arrow : Icons.menu_book),
                    label: const Text(
                      "Voir l'Original\n(Accès Direct)",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _openDirectOriginal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Generated Recap Output Display
            if (_isLoadingRecap)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_generatedRecap != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  _generatedRecap!,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
