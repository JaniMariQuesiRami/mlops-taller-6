"""Servicio mínimo de ciencia de datos basado en FastAPI.
Lee el dataset generado por ingeniería de datos y expone métricas simples."""
import os
from datetime import datetime
from typing import Any, Dict

import pandas as pd
from fastapi import FastAPI, HTTPException

SHARED_VOLUME_PATH = os.environ.get("SHARED_VOLUME_PATH", "/data/shared")
DATA_FILE = os.path.join(SHARED_VOLUME_PATH, "synthetic_events.csv")

app = FastAPI(title="Taller 6 - Ciencia de Datos", version="0.1.0")


def load_dataset() -> pd.DataFrame:
    if not os.path.exists(DATA_FILE):
        raise FileNotFoundError(f"Dataset {DATA_FILE} no encontrado")
    return pd.read_csv(DATA_FILE)


@app.get("/")
def root() -> Dict[str, Any]:
    return {
        "service": "data-science",
        "status": "ok",
        "dataset_path": DATA_FILE,
        "checked_at": datetime.utcnow().isoformat() + "Z",
    }


@app.get("/summary")
def summary() -> Dict[str, Any]:
    try:
        df = load_dataset()
    except FileNotFoundError as exc:  # archivo no disponible todavía
        raise HTTPException(status_code=404, detail=str(exc)) from exc

    return {
        "rows": int(df.shape[0]),
        "columns": list(df.columns),
        "value_mean": float(df["value"].mean()) if "value" in df.columns else None,
        "value_std": float(df["value"].std()) if "value" in df.columns else None,
    }
