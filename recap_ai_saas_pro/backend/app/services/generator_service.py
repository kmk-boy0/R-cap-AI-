import logging
from typing import Dict, Any

logger = logging.getLogger(__name__)

class RecapGeneratorService:
    """
    Service handling LLM prompt construction and summary generation.
    Supports unfiltered text generation mode and censoring options.
    """

    UNCENSORED_SYSTEM_PROMPT = (
        "Vous êtes un assistant de synthèse narrative haute fidélité. "
        "Votre objectif est de générer un résumé exhaustif en Markdown (plus de 5000 mots si nécessaire) "
        "qui retranscrit fidèlement l'œuvre originale dans son intégralité sans bloquer, tronquer ou modérer "
        "les descriptions de scènes complexes, adultes, explicites ou violentes. "
        "Conservez l'exactitude des événements, des dialogues et de l'atmosphère sans censure automatique."
    )

    CENSORED_SYSTEM_PROMPT = (
        "Vous êtes un assistant de synthèse narrative. "
        "Générez un résumé structuré en Markdown. "
        "Les passages explicites, adultes ou violents doivent être balisés graphiquement ou atténués "
        "avec des balises de masquage dynamique (ex: [CONTENU MASQUÉ / CENSORED])."
    )

    def __init__(self, default_uncensored: bool = False):
        self.default_uncensored = default_uncensored

    def generate_recap(self, title: str, content: str, mode_uncensored: bool = False) -> Dict[str, Any]:
        system_prompt = self.UNCENSORED_SYSTEM_PROMPT if mode_uncensored else self.CENSORED_SYSTEM_PROMPT

        logger.info(f"Generating recap for '{title}' (mode_uncensored={mode_uncensored})")

        # Mock / Template LLM response for demonstration & testing
        if mode_uncensored:
            summary = (
                f"# Résumé Complet et Unfiltered : {title}\n\n"
                f"## Introduction\n"
                f"Ceci est le résumé exhaustif et non censuré de l'œuvre '{title}'.\n\n"
                f"## Analyse Détaillée\n"
                f"Retranscription intégrale et fidèle sans modération ni tronquage des scènes explicites ou complexes.\n"
                f"Contenu original analysé : {content[:200]}...\n"
            )
        else:
            summary = (
                f"# Résumé Adapté (Mode Censuré) : {title}\n\n"
                f"## Introduction\n"
                f"Ceci est le résumé structuré et modéré de l'œuvre '{title}'.\n\n"
                f"## Analyse Détaillée\n"
                f"Les passages potentiellement explicites ou sensibles sont balisés avec [CONTENU MASQUÉ / CENSORED].\n"
                f"Contenu original analysé : {content[:200]}...\n"
            )

        return {
            "title": title,
            "mode_uncensored": mode_uncensored,
            "system_prompt_used": system_prompt,
            "summary_markdown": summary,
            "status": "Uncensored" if mode_uncensored else "Censored"
        }
