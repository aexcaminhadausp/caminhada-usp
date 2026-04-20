# 1. Usa uma imagem oficial do Python leve
FROM python:3.10-slim

# 2. Instala dependências do sistema necessárias para o PostGIS e Psycopg2
# Isso é essencial para o Python conseguir conversar com o banco de dados
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 3. Define a pasta de trabalho dentro do container
WORKDIR /app

# 4. Copia o arquivo de dependências primeiro (otimiza o cache do Docker)
COPY requirements.txt .

# 5. Instala as bibliotecas do Python
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copia todo o restante do código do projeto para dentro do container
COPY . .

# 7. Expõe a porta que o Render ou o Docker local vão usar
# O Render usa a porta 10000 por padrão, o seu local usa 8000
EXPOSE 8000

# 8. Comando para iniciar a API
# Usamos 0.0.0.0 para que ele aceite conexões externas (como as do seu celular/emulador)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]