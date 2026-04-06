-- 1. Ativar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- 2. Tabela de Usuários
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    hash_password TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Catálogo de Preferências
CREATE TABLE preference_types (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(50) UNIQUE NOT NULL,
    label VARCHAR(100) NOT NULL
);

-- 4. Escolhas dos Usuários
CREATE TABLE user_preferences (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    preference_id INTEGER REFERENCES preference_types(id) ON DELETE CASCADE,
    value TEXT NOT NULL,
    PRIMARY KEY (user_id, preference_id)
);

-- 5. Pontos de Interesse
CREATE TABLE points_of_interest (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    geom_point GEOMETRY(Point, 4326) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- 6. Histórico de Rotas
CREATE TABLE route_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    destination_point_id INTEGER REFERENCES points_of_interest(id),
    polyline TEXT NOT NULL,
    distance FLOAT NOT NULL,
    rate INTEGER CHECK (rate >= 0 AND rate <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Relatos de Usuários
CREATE TABLE user_overrrides_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    incident_type VARCHAR(50) NOT NULL,
    geom_point GEOMETRY(Point, 4326) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'pendente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Regras de Mapa do Admin
CREATE TABLE map_overrides (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    geom_area GEOMETRY(Polygon, 4326) NOT NULL,
    weight_penalty FLOAT DEFAULT 0.0, -- 0.0 = bloqueio total
    is_active BOOLEAN DEFAULT TRUE
);

-- 8. Regras de Mapa de preferências
CREATE TABLE map_assets (
    id SERIAL PRIMARY KEY,
    asset_type VARCHAR(50) NOT NULL, -- 'lighting', 'shade', 'shelter'
    geom GEOMETRY(Geometry, 4326) NOT NULL,
    relevance_score FLOAT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para Performance Geográfica
CREATE INDEX idx_poi_geom ON points_of_interest USING GIST (geom_point);
CREATE INDEX idx_reviews_geom ON user_overrrides_reviews USING GIST (geom_point);
CREATE INDEX idx_overrides_geom ON map_overrides USING GIST (geom_area);