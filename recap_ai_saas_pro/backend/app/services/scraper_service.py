import logging
from typing import Dict, Any, List, Optional
from app.models.sql_models import MediaFormat

logger = logging.getLogger(__name__)

class ScraperService:
    """
    Scraper service supporting metadata extraction, subtitles, direct streaming links,
    and visual assets for long formats (Dramas, Long-métrages, Novelas) and adult platforms.
    """

    ADULT_FORMATS = {
        MediaFormat.SERIE_PORNO.value,
        MediaFormat.FILM_PORNO.value,
        MediaFormat.HENTAI.value,
    }

    LONG_FORMATS = {
        MediaFormat.KDRAMA.value,
        MediaFormat.DRAMA_CHINOIS.value,
        MediaFormat.DRAMA.value,
        MediaFormat.NOVELAS.value,
        MediaFormat.LONG_METRAGE.value,
    }

    def __init__(self):
        logger.info("Initializing ScraperService with support for extended media formats and 18+ sources.")

    def extract_metadata(
        self,
        url: str,
        media_format: Optional[str] = None,
        is_adult_source: bool = False
    ) -> Dict[str, Any]:
        """
        Extract metadata, subtitles, direct streaming links, and visuals from a target media URL.
        """
        logger.info(f"Extracting content from {url} (format={media_format}, is_adult={is_adult_source})")

        is_adult = is_adult_source or (media_format in self.ADULT_FORMATS)
        is_long = media_format in self.LONG_FORMATS

        # Mocked extraction payload simulating scraped network metadata and links
        metadata: Dict[str, Any] = {
            "source_url": url,
            "media_format": media_format or MediaFormat.LONG_METRAGE.value,
            "is_adult": is_adult,
            "is_long_format": is_long,
            "title": "Extracted Media Title",
            "synopsis": "Extracted narrative description and synopsis from source page.",
            "visuals": {
                "thumbnail_url": f"{url}/assets/poster.jpg",
                "cover_url": f"{url}/assets/cover.jpg",
                "screenshots": [f"{url}/assets/shot1.jpg", f"{url}/assets/shot2.jpg"],
            },
            "subtitles": [
                {"language": "fr", "label": "Français", "url": f"{url}/subtitles/fr.vtt"},
                {"language": "en", "label": "English", "url": f"{url}/subtitles/en.vtt"},
            ],
            "streaming_links": [
                {"quality": "1080p", "type": "direct_m3u8", "url": f"{url}/stream/1080p/index.m3u8"},
                {"quality": "720p", "type": "direct_mp4", "url": f"{url}/stream/720p/video.mp4"},
            ],
            "extracted_episodes": [
                {"episode_number": 1, "title": "Épisode 1", "duration_minutes": 45 if is_long else 20}
            ] if is_long or media_format in {MediaFormat.SERIE_PORNO.value, MediaFormat.ANIME.value, MediaFormat.DESSIN_ANIME.value} else []
        }

        if is_adult:
            metadata["age_rating"] = "18+"
            metadata["content_warnings"] = ["Adult Content", "Explicit Scenes"]
        else:
            metadata["age_rating"] = "12+" if is_long else "ALL"
            metadata["content_warnings"] = []

        return metadata

    def scrape_catalog_feed(self, provider_name: str, category: str) -> List[Dict[str, Any]]:
        """
        Scrape stream feeds for a specified provider and category.
        """
        logger.info(f"Scraping catalog feed from provider {provider_name} for category {category}")
        return [
            {
                "title": f"Scraped {category} Item 1",
                "provider": provider_name,
                "category": category,
                "link": f"https://{provider_name}.com/item/1"
            },
            {
                "title": f"Scraped {category} Item 2",
                "provider": provider_name,
                "category": category,
                "link": f"https://{provider_name}.com/item/2"
            }
        ]
