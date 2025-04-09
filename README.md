# Configuração do Synapse Local via Fork para Desenvolvimento no Ubuntu ou Windows

A documentação base para esse relatório pode ser encontrada [aqui](https://element-hq.github.io/synapse/latest/development/contributing_guide.html).

## Pré-requisitos

- Ubuntu ou Windows com WSL 2.0
- Git, Python 3, Python-venv e Poetry
- Cargo (Rust), que pode ser instalado seguindo [este link](https://rustup.rs/).

## 1. Instalando os pré-requisitos no Ubuntu 22.04 (WSL 2.0)

```bash
sudo apt update
sudo apt upgrade
sudo apt install python3 python3-dev python3-venv python3-pip libpq-dev libicu-dev python3-icu pkg-config
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env"
```

## 2. Clone do Repositório

```bash
git clone git@github.com:DVCOM-UFC/synapse.git  # Via SSH
git clone https://github.com/DVCOM-UFC/synapse.git  # Via HTTPS
```

## 3. Criar Virtualenv dentro da pasta raiz

```bash
cd synapse/
git checkout develop-dvcom
python3 -m venv .env
. .env/bin/activate
```

## 4. Instalar dependências do Synapse (com a .env ativada)

```bash
poetry install --extras all
```

Se não ocorrer nenhum erro de instalação, pule o passo 5.

## 5. Possíveis erros de instalação

### pyvenv.cfg

Vá até o arquivo `pyvenv.cfg` dentro da virtualenv e altere:

```ini
include-system-site-packages = true
```

### rpds-py

```bash
pip wheel --no-cache-dir --use-pep517 "rpds-py==0.8.10"
```

### pyicu

```bash
pip wheel --no-cache-dir --use-pep517 "pyicu==2.14"
```

Repita o passo 4 até completar a instalação sem erros.

## 6. Executar o Synapse

Se o passo 4 não retornou log de erro, o pacote `matrix-synapse` foi instalado corretamente.

Copie os arquivos de configuração para a raiz do projeto:

```bash
cp docs/sample_config.yaml homeserver.yaml
cp docs/sample_log_config.yaml log_config.yaml
```

- Defina um `server_name` e aplique nos arquivos copiados.
- Ajuste os caminhos dos arquivos corretamente.
- Para usar arquivos prontos configurados com PostgreSQL, baixe o seguinte [arquivo](https://drive.google.com/file/d/1BGpnB4JxmuR7BEELlEXfnLStM09WW2Tx/view?usp=sharing).

Rodar o Banco de Dados com Docker:

```bash
sudo docker compose up --build
```

Rodar o Synapse:

```bash
poetry run python -m synapse.app.homeserver -c homeserver.yaml
```

