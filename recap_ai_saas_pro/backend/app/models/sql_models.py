from datetime import datetime
from typing import Optional
from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text, Enum as SQLEnum
from sqlalchemy.ext.declarative import declarative_base
import enum

Base = declarative_base()

class ContentStatus(str, enum.Enum):
    CENSORED = "Censored"
    UNCENSORED = "Uncensored"

class MediaFormat(str, enum.Enum):
    KDRAMA = "Kdrama"
    DRAMA_CHINOIS = "Drama Chinois"
    DRAMA = "Drama"
    NOVELAS = "Novelas"
    DESSIN_ANIME = "Dessin Animé"
    ANIME = "Anime"
    COURT_METRAGE = "Court-métrage"
    LONG_METRAGE = "Long-métrage"
    SERIE_PORNO = "Série Porno"
    FILM_PORNO = "Film Porno"
    HENTAI = "Hentai"

class Genre(str, enum.Enum):
    ROMANCE = "Romance"
    SHONEN = "Shonen"
    ACTION = "Action"
    HENTAI = "Hentai"
    COMBAT = "Combat"
    ESPIONNAGE = "Espionnage"
    SEINEN = "Seinen"
    ISEKAI = "Isekai"
    THRILLER = "Thriller"
    FANTASY = "Fantasy"
    SCI_FI = "Sci-Fi"

class CatalogItem(Base):
    __tablename__ = "catalog_items"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False, index=True)
    description = Column(Text, nullable=True)
    media_format = Column(String(50), nullable=False, default=MediaFormat.ANIME.value, index=True)
    genre = Column(String(50), nullable=False, index=True)
    flags_censure = Column(Boolean, default=True, nullable=False)
    status = Column(String(20), default=ContentStatus.CENSORED.value, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

class UserSettings(Base):
    __tablename__ = "user_settings"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(255), unique=True, nullable=False, index=True)
    mode_uncensored = Column(Boolean, default=False, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
