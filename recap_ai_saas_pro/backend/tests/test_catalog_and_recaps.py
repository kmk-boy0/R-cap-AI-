import sys
import os
from fastapi.testclient import TestClient
from fastapi import FastAPI

# Add app parent directory to path for imports
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from app.api.v1.endpoints.catalog import router as catalog_router
from app.api.v1.endpoints.recaps import router as recaps_router
from app.api.v1.endpoints.media import router as media_router
from app.services.generator_service import RecapGeneratorService
from app.services.scraper_service import ScraperService

app = FastAPI()
app.include_router(catalog_router)
app.include_router(recaps_router)
app.include_router(media_router)

client = TestClient(app)

def test_get_genres():
    response = client.get("/catalog/genres")
    assert response.status_code == 200
    genres = response.json()
    assert "Novelas" in genres
    assert "Romance" in genres
    assert "Shonen" in genres
    assert "Action" in genres
    assert genres == ['Novelas', 'Romance', 'Shonen', 'Action', 'Hentai', 'Combat', 'Espionnage', 'Seinen', 'Isekai', 'Fantasy']

def test_get_catalog_items_all():
    response = client.get("/catalog/items")
    assert response.status_code == 200
    items = response.json()
    assert len(items) > 0

def test_get_catalog_items_filter_by_novelas_genre():
    response = client.get("/catalog/items?genre=Novelas")
    assert response.status_code == 200
    items = response.json()
    assert len(items) >= 2
    assert all(item["genre"] == "Novelas" for item in items)

def test_get_catalog_items_filter_by_status():
    response = client.get("/catalog/items?status=Uncensored")
    assert response.status_code == 200
    items = response.json()
    assert all(item["status"] == "Uncensored" for item in items)

def test_scraper_service():
    scraper = ScraperService()
    episodes = scraper.fetch_episodes_list(6)
    assert len(episodes) == 50
    assert episodes[0]["title"] == "Épisode 1"
    assert episodes[0]["type"] == "video"

    video_source = scraper.extract_direct_source(6, episode_number=5)
    assert video_source["content_type"] == "video"
    assert "media_6_ep_5.mp4" in video_source["stream_url"]

    text_source = scraper.extract_direct_source(5, episode_number=3)
    assert text_source["content_type"] == "text"
    assert "texte/manga brut" in text_source["text_content"]

def test_media_episodes_and_direct_source_endpoints():
    ep_response = client.get("/media/6/episodes?query=45")
    assert ep_response.status_code == 200
    episodes = ep_response.json()
    assert len(episodes) >= 1
    assert any(ep["number"] == 45 for ep in episodes)

    direct_response = client.get("/media/6/direct-source?episode=45")
    assert direct_response.status_code == 200
    data = direct_response.json()
    assert data["media_id"] == 6
    assert data["episode_number"] == 45
    assert data["content_type"] == "video"
    assert "stream_url" in data

def test_generate_recap_censored():
    payload = {
        "title": "Test Title",
        "content": "A detailed narrative content for testing.",
        "mode_uncensored": False
    }
    response = client.post("/recaps/generate", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["mode_uncensored"] is False
    assert data["status"] == "Censored"
    assert "[CONTENU MASQUÉ / CENSORED]" in data["summary_markdown"]

def test_generate_recap_uncensored():
    payload = {
        "title": "Test Title Uncensored",
        "content": "A detailed explicit narrative content for testing.",
        "mode_uncensored": True
    }
    response = client.post("/recaps/generate", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert data["mode_uncensored"] is True
    assert data["status"] == "Uncensored"
    assert "sans modération ni tronquage" in data["summary_markdown"]

def test_generator_service_prompts():
    service = RecapGeneratorService()
    censored_res = service.generate_recap("Title", "Content", mode_uncensored=False)
    assert "CENSORED_SYSTEM_PROMPT" in service.CENSORED_SYSTEM_PROMPT or "assistant" in censored_res["system_prompt_used"]

    uncensored_res = service.generate_recap("Title", "Content", mode_uncensored=True)
    assert "sans bloquer, tronquer ou modérer" in uncensored_res["system_prompt_used"]
