import logging
from typing import Dict, Any, List, Optional

logger = logging.getLogger(__name__)

class ScraperService:
    """
    Scraper service for extracting original content sources (video streams or raw text/manga chapters)
    and episode/chapter listings for Novelas and other media catalog items.
    """

    def fetch_synopsis(self, media_id: int) -> str:
        logger.info(f"Scraping synopsis for media_id={media_id}")
        synopses = {
            1: "Solo Leveling - Un chasseur de rang E devient le plus fort grâce à un système unique.",
            2: "Kaguya-sama - Deux génies de l'élite lycéenne s'affrontent dans une guerre psychologique amoureuse.",
            3: "Naruto - L'histoire d'un ninja rejeté qui aspire à devenir Hokage.",
            4: "Secret Romance - Roman dramatique et passionné.",
            5: "Berserk - Le guerrier noir Guts affronte des forces démoniaques.",
            6: "La Reina del Sur - Teresa Mendoza gravit les échelons du trafic de drogue tout en naviguant à travers passion et trahisons.",
            7: "Teresa - Une jeune femme ambitieuse utilise son charme pour s'extirper de la pauvreté dans cette telenovela emblématique."
        }
        return synopses.get(media_id, f"Synopsis original pour le média #{media_id}")

    def fetch_episodes_list(self, media_id: int) -> List[Dict[str, Any]]:
        logger.info(f"Extracting episodes list for media_id={media_id}")
        is_novel_or_video = media_id in [6, 7]  # Novelas
        is_anime = media_id in [1, 2, 3]

        prefix = "Épisode" if (is_novel_or_video or is_anime) else "Chapitre"
        total = 50 if is_novel_or_video else 120

        episodes = []
        for i in range(1, total + 1):
            episodes.append({
                "number": i,
                "title": f"{prefix} {i}",
                "type": "video" if (is_novel_or_video or is_anime) else "text",
                "duration_or_pages": "45 min" if is_novel_or_video else ("24 min" if is_anime else "20 pages")
            })
        return episodes

    def extract_direct_source(self, media_id: int, episode_number: int = 1) -> Dict[str, Any]:
        """
        Extract direct streaming URL or raw text chapter content for a specific episode/chapter.
        """
        logger.info(f"Extracting direct source for media_id={media_id}, episode_number={episode_number}")
        episodes = self.fetch_episodes_list(media_id)
        selected_ep = next((e for e in episodes if e["number"] == episode_number), None)
        if not selected_ep:
            selected_ep = {"number": episode_number, "title": f"Épisode/Chapitre {episode_number}", "type": "video" if media_id in [1, 2, 3, 6, 7] else "text"}

        content_type = selected_ep.get("type", "video")

        if content_type == "video":
            return {
                "media_id": media_id,
                "episode_number": episode_number,
                "title": selected_ep["title"],
                "content_type": "video",
                "stream_url": f"https://cdn.recapai.sample/streams/media_{media_id}_ep_{episode_number}.mp4",
                "thumbnail_url": f"https://cdn.recapai.sample/thumbnails/media_{media_id}_ep_{episode_number}.jpg",
                "synopsis": f"Synopsis original de l'épisode {episode_number} du média #{media_id}."
            }
        else:
            return {
                "media_id": media_id,
                "episode_number": episode_number,
                "title": selected_ep["title"],
                "content_type": "text",
                "text_content": (
                    f"# {selected_ep['title']} - Source Originale\n\n"
                    f"Ceci est le texte/manga brut du chapitre {episode_number} sans génération de résumé.\n\n"
                    f"Le protagoniste avance prudemment dans l'obscurité. Chaque étape résonne dans la pièce silencieuse. "
                    f"L'histoire originale se déroule avec tous ses détails intacts, permettant une lecture directe et immersive sans altération."
                ),
                "synopsis": f"Synopsis du chapitre {episode_number} du média #{media_id}."
            }
