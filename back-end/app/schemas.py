from pydantic import BaseModel, EmailStr, ConfigDict
from typing import Optional, List
from datetime import datetime
from uuid import UUID

# --- SCHEMAS DE UTILIZADOR ---

#Campos comuns para utilizadores
class UserBase(BaseModel):
    name: str
    email: EmailStr


#Dados necessários para criar um usuario
class UserCreate(UserBase):
    password: str


#Dados que a API devolve ao Flutter (Sem a senha)
class UserResponse(UserBase):
    id: UUID
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)



# --- SCHEMAS DE AUTENTICAÇÃO ---

#Resposta de login com o token de acesso
class Token(BaseModel):
    access_token: str
    token_type: str

#Dados contidos dentro do token
class TokenData(BaseModel):
    email: Optional[str] = None



# --- SCHEMAS DE PONTOS DE INTERESSE ---
class POIBase(BaseModel):
    name: str
    description: Optional[str] = None

class POICreate(POIBase):
    latitude: float
    longitude: float

class POIResponse(POIBase):
    id: int
    latitude: float
    longitude: float
    created_at: datetime
    
    model_config = ConfigDict(from_attributes=True)



# --- SCHEMAS DE MAPA (POSTGIS) ---

#Campos comuns para ativos do mapa
class MapAssetBase(BaseModel):
    asset_type: str
    relevance_score: Optional[float] = None
    is_active: Optional[bool] = True

#Retorno de um ativo
class MapAssetResponse(MapAssetBase):
    id: int
    latitude: float
    longitude: float
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


# --- SCHEMAS DE HISTÓRICO ---

class RouteHistoryCreate(BaseModel):
    destination_id: int
    polyline: str
    distance: float
    rate: Optional[int] = None

class RouteHistoryResponse(BaseModel):
    id: UUID
    destination_id: int
    destination_name: str
    latitude: float
    longitude: float
    distance: float
    rate: Optional[int] = None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

class RouteRateUpdate(BaseModel):
    rate: int
