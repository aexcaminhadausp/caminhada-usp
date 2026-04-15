from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from sqlalchemy import text, select
from fastapi.middleware.cors import CORSMiddleware
from datetime import timedelta
from . import models, schemas, crud, database, utils
from jose import JWTError, jwt
from typing import List
from uuid import UUID


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")



app = FastAPI(
    title="Caminhada USP API",
    description="Backend para Atividade Extensionista (AEX) - Caminhada USP.",
    version="0.1.0"
)

# Configuração do CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Em produção, substitua "*" pelos domínios reais permitidos
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# ------------------------ATENCAO----------------------------

# Atualmente, o FastAPI gere estas rotas síncronas num Thread Pool.

# ------------------------------------------------------------


# --- DEPENDÊNCIA: OBTER UTILIZADOR ATUAL ---

def get_current_user(db: Session = Depends(database.get_db), token: str = Depends(oauth2_scheme)):
    """
    Esta função corre em cada rota protegida. 
    Ela abre o Token, verifica se é válido e devolve o objeto do utilizador.
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Não foi possível validar as credenciais",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        #Decodificar o Token JWT
        payload = jwt.decode(token, utils.SECRET_KEY, algorithms=[utils.ALGORITHM])
        email: str = payload.get("sub")

        if email is None:
            raise credentials_exception
        
        token_data = schemas.TokenData(email=email)

    except JWTError:
        raise credentials_exception
    
    #Procurar o utilizador no banco pelo email extraído do Token
    user = crud.get_user_by_email(db, email=token_data.email)

    if user is None:
        raise credentials_exception
    
    return user

# --- ROTAS PÚBLICAS ---


@app.get("/")
def read_root():
    return {"message": "API Caminhada USP Online"}

@app.get("/health")
def health_check(db: Session = Depends(database.get_db)):
    """Verifica a integridade da conexão com o Docker/PostGIS."""
    try:
        db.execute(text("SELECT 1"))
        return {"status": "ok", "database": "connected"}
    except Exception as e:
        return {"status": "error", "detail": str(e)}
    
@app.post("/users/", response_model=schemas.UserResponse, status_code=status.HTTP_201_CREATED)
def create_user(user: schemas.UserCreate, db: Session = Depends(database.get_db)):
    """Teste de criação de usuário: Recebe dados, faz hash e salva no banco."""
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email já cadastrado")
    return crud.create_user(db=db, user=user)



@app.post("/login", response_model=schemas.Token)
def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(), 
    db: Session = Depends(database.get_db)
):
    """
    Verifica as credenciais e devolve um Token JWT.
    Nota: O OAuth2PasswordRequestForm espera 'username' (que será o email) e 'password'.
    """
    # 1. Procurar o utilizador pelo email (que vem no campo username do form)
    user = crud.get_user_by_email(db, email=form_data.username)
    
    # 2. Verificar se existe e se a senha coincide (usando Passlib+Argon2 no utils)
    if not user or not utils.verify_password(form_data.password, user.hash_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou senha incorretos",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # 3. Gerar o tempo de expiração e o Token
    access_token_expires = timedelta(minutes = utils.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = utils.create_access_token(data = {"sub": user.email}, expires_delta=access_token_expires)
    
    return {"access_token": access_token, "token_type": "bearer"}


# --- ROTAS PROTEGIDAS ---

@app.get("/users/me", response_model=schemas.UserResponse)
def read_users_me(current_user: models.User = Depends(get_current_user)):
    """
    Retorna os dados do utilizador que está autenticado no momento.
    O 'Depends(get_current_user)' faz toda a magia da segurança.
    """
    return current_user

@app.get("/users/", response_model=list[schemas.UserResponse])
def read_users(current_user: models.User = Depends(get_current_user), db: Session = Depends(database.get_db), skip: int = 0, limit: int = 100):
    """
    Apenas utilizadores logados podem listar outros utilizadores.
    """
    users = db.query(models.User).offset(skip).limit(limit).all()
    return users


# --- ROTAS DE MAPA (Pontos de Interesse) ---

@app.get("/map/pois", response_model=List[schemas.POIResponse])
def read_pois(db: Session = Depends(database.get_db), current_user: models.User = Depends(get_current_user)):
    """Lista todos os pontos de interesse cadastrados no Campus."""
    return crud.get_pois(db)

@app.post("/map/pois", response_model=schemas.POIResponse, status_code=status.HTTP_201_CREATED)
def add_poi(poi: schemas.POICreate, db: Session = Depends(database.get_db), current_user: models.User = Depends(get_current_user)):
    """Adiciona um novo ponto de interesse (Apenas para testes do grupo)."""
    return crud.create_poi(db, poi)


# --- ROTAS DE MAPA (Historico) ---


@app.post("/history")
async def save_history(
    history_data: schemas.RouteHistoryCreate, 
    current_user: models.User = Depends(get_current_user), 
    db: Session = Depends(database.get_db)
):
    new_entry = crud.create_user_history(db, history=history_data, user_id=current_user.id)
    return {"status": "success", "id": str(new_entry.id)}

# --- ENDPOINT PARA ATUALIZAR AVALIAÇÃO (PATCH) ---
@app.patch("/history/{history_id}/rate")
async def update_history_rate(
    history_id: UUID,
    rate_data: schemas.RouteRateUpdate,
    current_user: models.User = Depends(get_current_user),
    db: Session = Depends(database.get_db)
):
    updated_history = crud.update_history_rate(db, history_id=history_id, rate=rate_data.rate, user_id=current_user.id)
    if not updated_history:
        raise HTTPException(status_code=404, detail="Histórico não encontrado ou não pertence ao usuário.")
    return {"status": "success", "id": str(updated_history.id), "rate": updated_history.rate}

# --- ENDPOINT PARA LISTAR HISTÓRICO (GET) ---
@app.get("/history", response_model=list[schemas.RouteHistoryResponse])
async def get_history(
    current_user: models.User = Depends(get_current_user), 
    db: Session = Depends(database.get_db)
):
    # A lógica de busca e formatação foi delegada para o crud.py
    return crud.get_user_history(db, user_id=current_user.id)
