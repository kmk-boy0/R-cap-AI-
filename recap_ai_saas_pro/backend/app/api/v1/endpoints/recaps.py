from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional
from app.services.generator_service import RecapGeneratorService

router = APIRouter(prefix="/recaps", tags=["Recaps"])

generator_service = RecapGeneratorService()

class GenerateRecapRequest(BaseModel):
    title: str
    content: str
    mode_uncensored: bool = False

class GenerateRecapResponse(BaseModel):
    title: str
    mode_uncensored: bool
    system_prompt_used: str
    summary_markdown: str
    status: str

@router.post("/generate", response_model=GenerateRecapResponse)
def generate_recap(request: GenerateRecapRequest):
    """
    Generate a summary/recap for a given work.
    Respects mode_uncensored setting to bypass or apply safety filters.
    """
    if not request.title or not request.content:
        raise HTTPException(status_code=400, detail="Title and content are required.")

    result = generator_service.generate_recap(
        title=request.title,
        content=request.content,
        mode_uncensored=request.mode_uncensored
    )
    return GenerateRecapResponse(**result)
