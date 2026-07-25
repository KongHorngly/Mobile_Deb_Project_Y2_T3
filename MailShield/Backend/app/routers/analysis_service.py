import logging

from fastapi import APIRouter, File, HTTPException, UploadFile

from app.config.settings import settings
from app.models.analysis import AnalysisResult, EmailAnalysisRequest
from app.scanners import clamav, ocr
from app.scanners import risk_engine

logger = logging.getLogger("cybermail.analysis")

router = APIRouter(prefix="/analyze", tags=["analysis"])


@router.post("/email", response_model=AnalysisResult)
async def analyze_email(payload: EmailAnalysisRequest) -> AnalysisResult:
    clam_result = None
    if payload.hasAttachment:
        # No attachment bytes are sent with the pasted-text flow today —
        # this is where you'd scan them once the UI uploads a real file.
        clam_result = None

    return risk_engine.evaluate_email(
        sender_email=payload.senderEmail,
        subject=payload.subject,
        body=payload.body,
        has_attachment=payload.hasAttachment,
        clam=clam_result,
    )


@router.post("/image", response_model=AnalysisResult)
async def analyze_image(image: UploadFile = File(...)) -> AnalysisResult:
    data = await image.read()

    max_bytes = settings.MAX_UPLOAD_SIZE_MB * 1024 * 1024
    if len(data) > max_bytes:
        raise HTTPException(
            status_code=413,
            detail=f"Image exceeds {settings.MAX_UPLOAD_SIZE_MB}MB limit.",
        )
    if not data:
        raise HTTPException(status_code=400, detail="Empty image upload.")

    clam_result = clamav.scan_bytes(data)
    ocr_text = ocr.extract_text(data)

    return risk_engine.evaluate_image(
        ocr_text=ocr_text,
        filename=image.filename or "screenshot.png",
        clam=clam_result,
    )
