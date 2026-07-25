"""
Not included in app/main.py yet.

The current Result screen (frontend/lib/screens/analysis/result_screen.dart)
doesn't have an export button, so nothing calls this. Left here as
scaffolding matching the original proposal's PDF-report feature; wire it
into main.py + add a button in the Flutter app when you're ready to build it.
"""
from fastapi import APIRouter

router = APIRouter(prefix="/reports", tags=["reports"])

# Example of what this would look like (needs e.g. `reportlab` or
# `weasyprint` added to requirements.txt):
#
# @router.get("/{history_id}/pdf")
# async def export_pdf(history_id: str):
#     ...
