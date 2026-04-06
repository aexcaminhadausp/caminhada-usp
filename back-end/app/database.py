import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
from pathlib import Path


# Constrói o caminho para o arquivo .env na raiz da pasta 'back-end'.
# Isso torna a localização do .env explícita e independente do diretório
# de onde o servidor é iniciado.
env_path = Path(__file__).resolve().parent.parent / '.env'
load_dotenv(dotenv_path=env_path)

db_user = os.getenv("DB_USER")
db_pass = os.getenv("DB_PASSWORD")
db_host = os.getenv("DB_HOST")
db_port = os.getenv("DB_PORT")
db_name = os.getenv("DB_NAME")

# URL de conexão para PostgreSQL síncrono (psycopg2)
SQLALCHEMY_DATABASE_URL = f"postgresql://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}"

# O 'engine' gere o Connection Pool (piscina de conexões físicas TCP/IP)
# TODO: No futuro, migrar para 'create_async_engine' do SQLAlchemy 2.0+ 
# para suportar concorrência nativa sem dependência de Thread Pools.
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# Fábrica de sessões lógicas
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Classe base para todos os modelos do ORM
Base = declarative_base()

def get_db():
    """
    Dependency Provider: Abre uma sessão lógica e garante o fecho
    após o término da requisição HTTP, devolvendo a conexão física ao Pool.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()