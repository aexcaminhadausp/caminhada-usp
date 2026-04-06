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