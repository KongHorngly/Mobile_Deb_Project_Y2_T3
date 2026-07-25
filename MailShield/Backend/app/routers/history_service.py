"""
Not included in app/main.py yet.

Scan history is currently read/written directly by the Flutter app via
Firestore (frontend/lib/services/firestore_service.dart +
providers/history_provider.dart) — there's no backend round-trip for it
today. This file is scaffolding for if/when you move that logic here;
wire it into main.py with app.include_router(router) once implemented.
"""
from fastapi import APIRouter

router = APIRouter(prefix="/history", tags=["history"])

# Example of what this would look like:
#
# @router.get("", response_model=List[HistoryEntry])
# async def list_history(uid: str):
#     ...
