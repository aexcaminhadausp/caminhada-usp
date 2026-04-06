import os
from datetime import datetime, timedelta, timezone
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from dotenv import load_dotenv

# Configuração do Passlib com o esquema Argon2
# Aqui o Passlib atua como o "Gerente" e o Argon2id como o "Motor" de segurança.
# Configuramos os parâmetros diretamente no CryptContext.
pwd_context = CryptContext( schemes=["argon2"], deprecated="auto" )

SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES"))


def get_password_hash(password: str) -> str:

    if not password:
        raise ValueError("A senha não pode estar vazia")
    
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:

    if not plain_password or not hashed_password:
        return False
    
    try:
        return pwd_context.verify(plain_password, hashed_password)
    except Exception:
        # Captura erros de hash mal formatado ou corrompido
        return False
    

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    """Gera um Token JWT assinado."""
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes = ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt