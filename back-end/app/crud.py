from sqlalchemy.orm import Session
from geoalchemy2.functions import ST_X, ST_Y
from geoalchemy2.elements import WKTElement
from . import models, schemas, utils
from uuid import UUID

# --- OPERAÇÕES DE UTILIZADOR ---

def get_user_by_email(db: Session, email: str):
    """Busca um utilizador pelo email para login ou validação."""
    return db.query(models.User).filter(models.User.email == email).first()

def create_user(db: Session, user: schemas.UserCreate):
    """Cria um novo utilizador com senha criptografada."""
    hashed_password = utils.get_password_hash(user.password)
    db_user = models.User(
        name=user.name,
        email=user.email,
        hash_password=hashed_password
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


# --- PONTOS DE INTERESSE (POSTGIS) ---

def get_pois(db: Session, skip: int = 0, limit: int = 100):
    """
    Retorna os POIs convertendo a geometria do PostGIS para Latitude/Longitude
    """
    results = db.query(
        models.PointOfInterest.id,
        models.PointOfInterest.name,
        models.PointOfInterest.description,
        models.PointOfInterest.created_at,
        ST_Y(models.PointOfInterest.location).label("latitude"),
        ST_X(models.PointOfInterest.location).label("longitude")
        
    ).offset(skip).limit(limit).all()
    
    return results

def create_poi(db: Session, poi: schemas.POICreate):
    """
    Cria um ponto usando o formato WKT (Well-Known Text) do PostGIS
    """
    point_wkt = f'POINT({poi.longitude} {poi.latitude})'
    db_poi = models.PointOfInterest(
        name=poi.name,
        description=poi.description,
        location=WKTElement(point_wkt, srid=4326)
    )
    db.add(db_poi)
    db.commit()
    db.refresh(db_poi)
    
    return {
        "id": db_poi.id,
        "name": db_poi.name,
        "description": db_poi.description,
        "latitude": poi.latitude,
        "longitude": poi.longitude,
        "created_at": db_poi.created_at
    }


# --- OPERAÇÕES DE MAPA (POSTGIS) ---

def get_map_assets(db: Session, skip: int = 0, limit: int = 100):
    """
    Busca os ativos do mapa. 
    Nota técnica: Convertemos a geometria (geom) para texto ou floats 
    para que o JSON consiga transportar os dados.
    """
    assets = db.query(
        models.MapAsset.id,
        models.MapAsset.asset_type,
        models.MapAsset.relevance_score,
        models.MapAsset.is_active,
        models.MapAsset.created_at,
        ST_Y(models.MapAsset.geom).label("latitude"),
        ST_X(models.MapAsset.geom).label("longitude")

    ).offset(skip).limit(limit).all()
    
    return assets


# --- HISTÓRICO DE ROTAS ---

def get_user_history(db: Session, user_id: UUID, skip: int = 0, limit: int = 100):
    """
    Busca o histórico de rotas de um utilizador específico, 
    trazendo junto o nome do Ponto de Interesse (Destino).
    """
    results = db.query(
        models.RouteHistory.id,
        models.RouteHistory.distance,
        models.RouteHistory.rate,
        models.RouteHistory.created_at,
        models.RouteHistory.destination_point_id.label("destination_id"),
        models.PointOfInterest.name.label("destination_name"),
        ST_Y(models.PointOfInterest.location).label("latitude"),
        ST_X(models.PointOfInterest.location).label("longitude")
    ).join(
        models.PointOfInterest, 
        models.RouteHistory.destination_point_id == models.PointOfInterest.id
    ).filter(
        models.RouteHistory.user_id == user_id
    ).order_by(
        models.RouteHistory.created_at.desc()
    ).offset(skip).limit(limit).all()
    
    return [
        {
            "id": str(r.id),
            "destination_id": r.destination_id,
            "destination_name": r.destination_name,
            "latitude": r.latitude,
            "longitude": r.longitude,
            "distance": r.distance,
            "rate": r.rate,
            "created_at": r.created_at.isoformat() if r.created_at else None
        } for r in results
    ]

def create_user_history(db: Session, history: schemas.RouteHistoryCreate, user_id: UUID):
    """Salva um novo trajeto no histórico do utilizador."""
    db_history = models.RouteHistory(
        user_id=user_id,
        destination_point_id=history.destination_id,
        polyline=history.polyline,
        distance=history.distance,
        rate=history.rate
    )
    db.add(db_history)
    db.commit()
    db.refresh(db_history) # Atualiza o objeto para pegar o ID gerado (UUID)
    return db_history

def update_history_rate(db: Session, history_id: UUID, rate: int, user_id: UUID):
    """Atualiza apenas a avaliação (rate) de um trajeto no histórico."""
    db_history = db.query(models.RouteHistory).filter(
        models.RouteHistory.id == history_id,
        models.RouteHistory.user_id == user_id
    ).first()
    
    if db_history:
        db_history.rate = rate
        db.commit()
        db.refresh(db_history)
    return db_history