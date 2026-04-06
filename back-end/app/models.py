import uuid
from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, DateTime, Text, Float
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from geoalchemy2 import Geometry
from .database import Base

class User(Base):
    """Mapeamento da tabela 'users' do PostgreSQL."""
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(255), nullable=False)
    email = Column(String(255), unique=True, nullable=False)
    hash_password = Column(Text, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relacionamento bidirecional: permite acessar as preferências a partir do usuário
    preferences = relationship("UserPreference", back_populates="user", cascade="all, delete-orphan")

class PointOfInterest(Base):
    """Mapeamento da tabela 'points_of_interest' para POIs no mapa."""
    __tablename__ = "points_of_interest"

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    location = Column('geom_point', Geometry(geometry_type='POINT', srid=4326), nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class MapAsset(Base):
    """Mapeamento de ativos (postes, árvores, etc.) com suporte PostGIS."""
    __tablename__ = "map_assets"

    id = Column(Integer, primary_key=True)
    asset_type = Column(String(50), nullable=False)
    geom = Column(Geometry(geometry_type='GEOMETRY', srid=4326), nullable=False)
    relevance_score = Column(Float)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class PreferenceType(Base):
    """Catálogo de Preferências."""
    __tablename__ = "preference_types"

    id = Column(Integer, primary_key=True)
    slug = Column(String(50), unique=True, nullable=False)
    label = Column(String(100), nullable=False)

class UserPreference(Base):
    """Preferências de rota de cada utilizador da AEX."""
    __tablename__ = "user_preferences"

    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    preference_id = Column(Integer, ForeignKey("preference_types.id", ondelete="CASCADE"), primary_key=True)
    value = Column(Text, nullable=False)

    # Relacionamento reverso
    user = relationship("User", back_populates="preferences")
    preference_type = relationship("PreferenceType")
