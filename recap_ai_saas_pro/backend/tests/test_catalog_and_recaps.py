import sys
import os
from fastapi.testclient import TestClient
from fastapi import FastAPI

# Add app parent directory to path for imports
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from app.api.v1.endpoints.catalog import router as catalog_router
from app.api.v1.endpoints.recaps import router as recaps_router
from app.services.generator_service import RecapGeneratorService
from app.services.scraper_service import ScraperService
from app.models.sql_models import MediaFormat, Genre

app = FastAPI()
app.include_router(catalog_router)
app.include_router(recaps_router)

client = TestClient(app)

def test_get_genres():
    response = client.get("/catalog/genres")
    assert response.status_code == 200
    genres = response.json()
    assert "Romance" in genres
    assert "Shonen" in genres
    assert "Hentai" in genres
    assert "Action" in genres
    assert "Combat" in genres
    assert "Espionnage" in genres
    assert "Seinen" in genres
    assert "Isekai" in genres
    assert "Fantasy" in genres

def test_get_formats():
    response = client.get("/catalog/formats")
    assert response.status_code == 200
    formats = response.json()
    assert "Kdrama" in formats
    assert "Drama Chinois" in formats
    assert "Drama" in formats
    assert "Novelas" in formats
    assert "Dessin Animé" in formats
    assert "Anime" in formats
    assert "Court-métrage" in formats
    assert "Long-métrage" in formats
    assert "Série Porno" in formats
    assert "Film Porno" in formats
    assert "Hentai" in formats

def test_get_catalog_items_all():
    response = client.get("/catalog/items")
    assert response.status_code == 200
    items = response.json()
    assert len(items) >= 13

def test_get_catalog_items_filter_by_format():
    response = client.get("/catalog/items?media_format=Kdrama")
    assert response.status_code == 200
    items = response.json()
    assert len(items) > 0
    assert all(item["media_format"] == "Kdrama" for item in items)

def test_get_catalog_items_filter_by_adult_format():
    response = client.get("/catalog/items?media_format=S%C3%A9rie%20Porno")
    assert response.status_code == 200
    items = response.json()
    assert len(items) > 0
    assert all(item["media_format"] == "Série Porno" for item in items)

def test_get_catalog_items_filter_by_genre():
    response = client.get("/catalog/items?genre=Hentai")
    assert response.status_code == 200
    items = response.json()
    assert all(item["genre"] == "Hentai" for item in items)

def test_get_catalog_items_filter_by_status():
    response = client.get("/catalog/items?status=Uncensored")
    assert response.status_code == 200
    items = response.json()
    assert all(item["status"] == "Uncensored" for item in items)

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

def test_scraper_service_extraction():
    scraper = ScraperService()
    meta = scraper.extract_metadata("https://example.com/kdrama", media_format=MediaFormat.KDRAMA.value)
    assert meta["is_long_format"] is True
    assert meta["is_adult"] is False
    assert len(meta["subtitles"]) > 0
    assert len(meta["streaming_links"]) > 0
    assert "visuals" in meta

def test_scraper_service_adult_extraction():
    scraper = ScraperService()
    meta = scraper.extract_metadata("https://example.com/adult_series", media_format=MediaFormat.SERIE_PORNO.value)
    assert meta["is_adult"] is True
    assert meta["age_rating"] == "18+"
    assert "Adult Content" in meta["content_warnings"]
