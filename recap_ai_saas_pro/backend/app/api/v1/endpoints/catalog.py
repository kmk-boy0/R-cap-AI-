from fastapi import APIRouter, Query, HTTPException
from typing import List, Optional
from pydantic import BaseModel
from app.models.sql_models import Genre, MediaFormat, ContentStatus

router = APIRouter(prefix="/catalog", tags=["Catalog"])

class CatalogItemSchema(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    media_format: str
    genre: str
    flags_censure: bool
    status: str

# In-memory mock database for items
MOCK_CATALOG: List[CatalogItemSchema] = [
    CatalogItemSchema(id=1, title="Solo Leveling", description="Un chasseur de rang E devient le plus fort.", media_format=MediaFormat.ANIME.value, genre=Genre.ACTION.value, flags_censure=False, status=ContentStatus.UNCENSORED.value),
    CatalogItemSchema(id=2, title="Kaguya-sama: Love Is War", description="Deux génies en amour.", media_format=MediaFormat.ANIME.value, genre=Genre.ROMANCE.value, flags_censure=True, status=ContentStatus.CENSORED.value),
    CatalogItemSchema(id=3, title="Naruto", description="L'histoire d'un ninja déterminé.", media_format=MediaFormat.ANIME.value, genre=Genre.SHONEN.value, flags_censure=True, status=ContentStatus.CENSORED.value),
    CatalogItemSchema(id=4, title="Secret Romance", description="Roman adulte passionné.", media_format=MediaFormat.HENTAI.value, genre=Genre.HENTAI.value, flags_censure=False, status=ContentStatus.UNCENSORED.value),
    CatalogItemSchema(id=5, title="Berserk", description="Le guerrier noir en quête de vengeance.", media_format=MediaFormat.ANIME.value, genre=Genre.SEINEN.value, flags_censure=False, status=ContentStatus.UNCENSORED.value),
    CatalogItemSchema(id=6, title="Crash Landing on You", description="Une héritière sud-coréenne atterrit accidentellement en Corée du Nord.", media_format=MediaFormat.KDRAMA.value, genre=Genre.ROMANCE.value, flags_censure=True, status=ContentStatus.CENSORED.value),
    CatalogItemSchema(title="The Untamed", id=7, description="Deux cultivateurs d'âmes enquêtent sur de sombres mystères.", media_format=MediaFormat.DRAMA_CHINOIS.value, genre=Genre.FANTASY.value, flags_censure=True, status=ContentStatus.CENSORED.value),
    CatalogItemSchema(id=8, title="Rubi", description="Une femme ambitieuse prête à tout pour la richesse.", media_format=MediaFormat.NOVELAS.value, genre=Genre.ROMANCE.value, flags_censure=True, status=ContentStatus.CENSORED.value),
    CatalogItemSchema(id=9, title="Les Minions", description="Un petit film d'animation drôle.", media_format=MediaFormat.DESSIN_ANIME.value, genre=Genre.ACTION.value, flags_censure=True, status=ContentStatus.CENSORED.value),
    CatalogItemSchema(id=10, title="Inception", description="Un voleur qui s'infiltre dans les rêves.", media_format=MediaFormat.LONG_METRAGE.value, genre=Genre.SCI_FI.value, flags_censure=True, status=ContentStatus.CENSORED.value),
    CatalogItemSchema(id=11, title="Piper", description="Un jeune oiseau apprend à surmonter sa peur de l'eau.", media_format=MediaFormat.COURT_METRAGE.value, genre=Genre.FANTASY.value, flags_censure=True, status=ContentStatus.CENSORED.value),
    CatalogItemSchema(id=12, title="Midnight Passion", description="Série adulte réservée au public averti.", media_format=MediaFormat.SERIE_PORNO.value, genre=Genre.HENTAI.value, flags_censure=False, status=ContentStatus.UNCENSORED.value),
    CatalogItemSchema(id=13, title="Adult Cinema Night", description="Film adulte romantique.", media_format=MediaFormat.FILM_PORNO.value, genre=Genre.ROMANCE.value, flags_censure=False, status=ContentStatus.UNCENSORED.value),
]

@router.get("/genres", response_model=List[str])
def get_genres():
    """Retrieve all supported catalog genres."""
    return [genre.value for genre in Genre]

@router.get("/formats", response_model=List[str])
def get_formats():
    """Retrieve all supported media formats."""
    return [fmt.value for fmt in MediaFormat]

@router.get("/items", response_model=List[CatalogItemSchema])
def get_catalog_items(
    title: Optional[str] = Query(None, description="Search by title"),
    media_format: Optional[str] = Query(None, description="Filter by media format (Kdrama, Film Porno, etc.)"),
    genre: Optional[str] = Query(None, description="Filter by genre"),
    status: Optional[str] = Query(None, description="Filter by status (Censored or Uncensored)")
):
    """Retrieve catalog items with optional filtering by title, media format, genre, and censorship status."""
    results = MOCK_CATALOG
    if title:
        results = [item for item in results if title.lower() in item.title.lower()]
    if media_format:
        results = [item for item in results if item.media_format.lower() == media_format.lower()]
    if genre:
        results = [item for item in results if item.genre.lower() == genre.lower()]
    if status:
        results = [item for item in results if item.status.lower() == status.lower()]
    return results
