import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config.firebase import init_firebase
from app.config.settings import settings
from app.routers import analysis_service

logging.basicConfig(level=logging.INFO)

app = FastAPI(title=settings.APP_NAME)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(analysis_service.router, prefix=settings.API_PREFIX)


@app.on_event("startup")
async def on_startup():
    init_firebase()


@app.get("/")
async def root():
    return {"service": settings.APP_NAME, "status": "ok"}


@app.get("/health")
async def health():
    return {"status": "ok"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("app.main:app", host=settings.HOST, port=settings.PORT, reload=True)
