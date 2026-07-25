"""
Firebase Admin scaffolding.

Not wired into any route yet. Today the Flutter app talks to Firebase
Auth + Firestore directly via the client SDK (see frontend/lib/services/
auth_service.dart and firestore_service.dart) — that's why auth/history
work already without this backend's involvement.

If you later want to move auth verification or history writes server
side, initialize here with a service account and import `firebase_app`
in your routers. Left optional so the API still boots without a
service-account key present.
"""
import logging
import os

logger = logging.getLogger("cybermail.firebase")

firebase_app = None

_SERVICE_ACCOUNT_PATH = os.getenv("FIREBASE_SERVICE_ACCOUNT", "")


def init_firebase():
    global firebase_app
    if not _SERVICE_ACCOUNT_PATH:
        logger.info(
            "FIREBASE_SERVICE_ACCOUNT not set — skipping Firebase Admin init "
            "(auth/history are currently handled client-side by the Flutter app)."
        )
        return None

    try:
        import firebase_admin
        from firebase_admin import credentials

        cred = credentials.Certificate(_SERVICE_ACCOUNT_PATH)
        firebase_app = firebase_admin.initialize_app(cred)
        logger.info("Firebase Admin initialized.")
    except Exception as exc:  # pragma: no cover - optional integration
        logger.warning("Firebase Admin init failed, continuing without it: %s", exc)
        firebase_app = None

    return firebase_app
