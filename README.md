# Projeto AEX - Caminhada USP

Projeto desenvolvido por estudantes de Ciência da Computação da Universidade de São Paulo.


## Configuração do Backend (Python + FastAPI)

Esta parte do projeto gerencia a lógica de negócios, autenticação e os cálculos geográficos do campus via PostGIS.

### 1. Pré-requisitos
* **Python 3.10+** instalado.
* **Docker** rodando (para o banco de dados).

### 2. Criando o Ambiente Virtual (venv)
O ambiente virtual isola as bibliotecas deste projeto das demais do seu computador, garantindo que todos usem as mesmas versões.

No terminal, dentro da pasta `backend/`, execute:

```bash
python -m venv venv
```

### 3. Ativando o Ambiente Virtual
Sempre que for trabalhar no código ou instalar algo, você deve ativar o ambiente:

#### Windows:
```bash
.\venv\Scripts\activate
```

#### Linux/Mac:
```bash
source venv/bin/activate
```

### 4. Instalando as Dependências
Com o ambiente ativo, instale todas as bibliotecas necessárias de uma só vez:

```bash
pip install -r requirements.txt
```

### 5. Rodando a API (Modo de Desenvolvimento)
Para subir o servidor e testar os endpoints:

```bash
# Dentro da pasta backend
uvicorn app.main:app --reload
```