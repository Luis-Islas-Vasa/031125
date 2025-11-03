# 1. Imagen base: Python 3.11 slim es ligera y moderna
FROM python:3.11-slim

# 2. Instalar dependencias del sistema (¡CRÍTICO!)
# Pyppeteer necesita un navegador (Chromium) y sus dependencias
# para funcionar. Sin esto, fallará en el contenedor.
RUN apt-get update && apt-get install -y \
    chromium \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    --no-install-recommends \
&& rm -rf /var/lib/apt/lists/*

# 3. Establecer el directorio de trabajo DENTRO del contenedor
WORKDIR /app

# 4. Copiar e instalar dependencias de Python
# Copiamos solo 'requirements.txt' primero para aprovechar
# el caché de capas de Docker.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copiar TODO el código de nuestra aplicación
COPY ./app /app

# 6. Exponer el puerto en el que nuestra API escuchará
EXPOSE 8000

# 7. Comando para ejecutar la API cuando el contenedor inicie
# Usamos el binario de Chromium que instalamos con apt-get
# y le decimos a Pyppeteer que no descargue el suyo.
# El flag --no-sandbox es necesario para correr como root en Docker.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]