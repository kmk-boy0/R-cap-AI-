from fastapi import APIRouter, Query, HTTPException
from typing import List, Optional
from pydantic import BaseModel
from app.models.sql_models import Genre, ContentStatus

router = APIRouter(prefix="/catalog", tags=["Catalog"])

class CatalogItemSchema(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    genre: str
    flags_censure: bool
    status: str

# In-memory mock database for items
MOCK_CATALOG: List[CatalogItemSchema] = [
    CatalogItemSchema(id=1, title="Solo Leveling", description="Un chasseur de rang E devient le plus fort.", genre=Genre.ACTION.value, flags_censure=False, status=ContentStatus.UNCENSORED.value),
    CatalogItemSchema(id=2, title="Kaguya-sama: Love Is War", description="Deux génies en amour.", genre=Genre.ROMANCE.value, flags_censure=True, status=ContentStatus.CENSORED.value),
    CatalogItemSchema(id=3, title="Naruto", description="L'histoire d'un ninja déterminé.", genre=Genre.SHONEN.value, flags_censure=True, status=ContentStatus.CENSORED.value),
    CatalogItemSchema(id=4, title="Secret Romance", description="Roman adulte passionné.", genre=Genre.HENTAI.value, flags_censure=False, status=ContentStatus.UNCENSORED.value),
    CatalogItemSchema(id=5, title="Berserk", description="Le guerrier noir en quête de vengeance.", genre=Genre.SEINEN.value, flags_censure=False, status=ContentStatus.UNCENSORED.value),
]

@router.get("/genres", response_model=List[str])
def get_genres():
    """Retrieve all supported catalog genres."""
    return [genre.value for genre in Genre]

@router.get("/items", response_model=List[CatalogItemSchema])
def get_catalog_items(
    title: Optional[str] = Query(None, description="Search by title"),
    genre: Optional[str] = Query(None, description="Filter by genre"),
    status: Optional[str] = Query(None, description="Filter by status (Censored or Uncensored)")
):
    """Retrieve catalog items with optional filtering by title, genre, and censorship status."""
    results = MOCK_CATALOG
    if title:
        results = [item for item in results if title.lower() in item.title.lower()]
    if genre:
        results = [item for item in results if item.genre.lower() == genre.lower()]
    if status:
        results = [item for item in results if item.status.lower() == status.lower()]
    return results
