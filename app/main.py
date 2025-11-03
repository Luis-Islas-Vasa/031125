from fastapi import FastAPI
import os

app = FastAPI(title="Image Composition API")

@app.get("/")
async def root():
    """
    Endpoint raíz para verificar que el servicio está vivo.
    """
    return {
        "status": "ok",
        "message": "Bienvenido a nuestro servicio de composición de imágenes.",
        "pyppeteer_path": os.environ.get("PYPPETEER_EXECUTABLE_PATH")
    }

@app.get("/health")
async def health_check():
    """
    Endpoint simple de 'health check'.
    """
    return {"status": "healthy"}
