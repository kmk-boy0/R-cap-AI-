import 'package:flutter/material.dart';

class DirectReaderScreen extends StatelessWidget {
  final int mediaId;
  final String title;
  final int episodeNumber;
  final String contentType; // "video" or "text"
  final String? streamUrl;
  final String? textContent;

  const DirectReaderScreen({
    Key? key,
    required this.mediaId,
    required this.title,
    required this.episodeNumber,
    required this.contentType,
    this.streamUrl,
    this.textContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isVideo = contentType == 'video';

    return Scaffold(
      appBar: AppBar(
        title: Text('$title - Épisode/Chapitre $episodeNumber'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              // Header Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isVideo ? Colors.redAccent : Colors.indigo,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isVideo ? Icons.videocam : Icons.menu_book,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isVideo ? "Lecteur Vidéo Stream Original" : "Lecteur Web/Texte Épuré",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Automatic switch between video player and clean text viewer
              if (isVideo) ...[
                // Video Player UI Container
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_circle_fill, size: 64, color: Colors.redAccent),
                          const SizedBox(height: 12),
                          Text(
                            "$title - Épisode $episodeNumber",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            streamUrl ?? "https://cdn.recapai.sample/streams/stream.mp4",
                            style: const TextStyle(color: Colors.white54, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Information de lecture",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Lecture en streaming haute qualité directe depuis la source originale Novelas / Média.",
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ] else ...[
                // Clean Text / Manga Reader UI
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Text(
                        "$title - Chapitre $episodeNumber",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Divider(height: 24),
                      Text(
                        textContent ??
                            "Ceci est le texte brut du chapitre $episodeNumber original. "
                                "Déroulement direct de la scène sans aucune censure ni résumé IA.",
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                          fontFamily: 'Serif',
                        ),
                      ),
                    ],
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
