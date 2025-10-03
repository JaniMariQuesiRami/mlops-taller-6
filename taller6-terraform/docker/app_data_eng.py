"""Servicio mínimo de ingeniería de datos.
Genera un CSV sintético y expone un endpoint HTTP simple para verificar el estado."""
import json
import os
from datetime import datetime
from http.server import BaseHTTPRequestHandler, HTTPServer

import pandas as pd

SHARED_VOLUME_PATH = os.environ.get("SHARED_VOLUME_PATH", "/data/shared")
DATA_FILE = os.path.join(SHARED_VOLUME_PATH, "synthetic_events.csv")


def generate_dataset() -> None:
    """Crea un conjunto de datos sintético en el volumen compartido."""
    os.makedirs(SHARED_VOLUME_PATH, exist_ok=True)
    records = [
        {"event_id": idx, "source": "sensor", "value": round(42.0 + idx * 0.5, 2), "ts": datetime.utcnow()}
        for idx in range(1, 6)
    ]
    df = pd.DataFrame(records)
    df.to_csv(DATA_FILE, index=False)


class StatusHandler(BaseHTTPRequestHandler):
    """Servidor HTTP mínimo que confirma la generación del dataset."""

    def do_GET(self) -> None:  # noqa: N802 (mantenemos firma estándar)
        if self.path not in {"/", "/status"}:
            self.send_response(404)
            self.end_headers()
            return

        payload = {
            "service": "data-eng",
            "dataset": os.path.basename(DATA_FILE),
            "generated_at": datetime.utcnow().isoformat() + "Z",
            "output_dir": SHARED_VOLUME_PATH,
        }

        response = json.dumps(payload).encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(response)))
        self.end_headers()
        self.wfile.write(response)

    def log_message(self, format: str, *args) -> None:  # noqa: A003 - firma requerida
        return


def main() -> None:
    generate_dataset()
    server = HTTPServer(("0.0.0.0", 8080), StatusHandler)
    print("[data-eng] dataset generado en", DATA_FILE, flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
