from fastapi import APIRouter, HTTPException, Query
from typing import List, Optional, Dict, Any
from pydantic import BaseModel
from app.services.scraper_service import ScraperService

router = APIRouter(prefix="/media", tags=["Media"])

scraper_service = ScraperService()

class EpisodeSchema(BaseModel):
    number: int
    title: str
    type: str
    duration_or_pages: Optional[str] = None

class DirectSourceResponse(BaseModel):
    media_id: int
    episode_number: int
    title: str
    content_type: str  # "video" or "text"
    stream_url: Optional[str] = None
    thumbnail_url: Optional[str] = None
    text_content: Optional[str] = None
    synopsis: Optional[str] = None

@router.get("/{id}/episodes", response_model=List[EpisodeSchema])
def get_media_episodes(
    id: int,
    query: Optional[str] = Query(None, description="Search episode/chapter by number or title (e.g. 'Épisode 45', '112')")
):
    """
    Retrieve episode or chapter list for a given media with optional fine search filtering.
    """
    episodes = scraper_service.fetch_episodes_list(id)
    if query:
        q = query.strip().lower()
        filtered = []
        for ep in episodes:
            if q in ep["title"].lower() or q in str(ep["number"]):
                filtered.append(ep)
        return filtered
    return episodes

@router.get("/{id}/direct-source", response_model=DirectSourceResponse)
def get_direct_source(
    id: int,
    episode: int = Query(1, description="Episode or Chapter number to retrieve directly")
):
    """
    Endpoint /media/{id}/direct-source to retrieve original streaming URL or original text/manga chapter.
    """
    try:
        source_data = scraper_service.extract_direct_source(media_id=id, episode_number=episode)
        return DirectSourceResponse(**source_data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error extracting direct source: {str(e)}")
