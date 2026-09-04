import sys
import os
from fastapi.testclient import TestClient
from fastapi import FastAPI

# Add app parent directory to path for imports
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from app.api.v1.endpoints.catalog import router as catalog_router
from app.api.v1.endpoints.recaps import router as recaps_router
from app.services.generator_service import RecapGeneratorService

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

def test_get_catalog_items_all():
    response = client.get("/catalog/items")
    assert response.status_code == 200
    items = response.json()
    assert len(items) > 0

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
