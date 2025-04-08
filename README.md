# Synapse Homeserver Setup (Development)

This project deploys a Matrix Synapse homeserver with PostgreSQL using Docker and a custom installation script.  
**Note:** This setup is intended for testing/development and includes insecure settings (e.g., unverified registration).

## Prerequisites
- Docker and Docker Compose installed
- Git
- Ubuntu/Debian-based system (tested on Ubuntu 22.04)
- Ports `8008` (HTTP) and `3375` (PostgreSQL) available

---

## Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/DVCOM-UFC/synapse.git
cd synapse
```

### 2. Start PostgreSQL Container
```bash
docker compose up -d --build
```

### 3. Review Configuration (Optional)
- Update `server_name` in `homeserver.yaml` to your domain.
- Change database credentials in both `homeserver.yaml` and `docker compose.yaml` for production.

### 4. Run Installation Script
```bash
chmod +x install_synapse.sh
./install_synapse.sh
```

---

## Key Configuration Details
- **Server URL**: `http://localhost:8008/` (update in `homeserver.yaml`)
- **PostgreSQL Credentials**:
  - Database: `synapse`
  - User: `synapse`
  - Password: `SynapeSecretPassword`
- **Registration**: Open registration enabled (disable via `enable_registration: false` in `homeserver.yaml` for production).

---

## Security Notes
⚠️ **This setup is not production-ready!**  
- TLS is disabled (`tls: false` in `homeserver.yaml`). Use a reverse proxy (e.g., Nginx) for HTTPS.
- `enable_registration_without_verification` allows unrestricted signups. Disable this in production.
- Replace default secrets (`macaroon_secret_key`, `registration_shared_secret`, etc.).

---

## Troubleshooting
- **Port Conflicts**: Ensure ports `8008` and `3375` are free.
- **Database Errors**: Verify PostgreSQL is running with `docker ps`.
- **Installation Failures**:
  - Ensure Rust and Python dependencies are installed.
  - Run `source ~/.cargo/env` if Rust isn't recognized.
- **Synapse Logs**: Check logs in `data/test.dv.techsmart.space.log.config`.

---

## Backup & Data Persistence
- PostgreSQL data is stored in Docker volume `synapse_db_data`.
- Backup `/var/lib/docker/volumes/synapse_db_data` periodically.
- Synapse media files are stored in `data/media_store`.

---

## Accessing the Server
1. Use a Matrix client (e.g., [Element](https://element.io)).
2. Connect to `http://localhost:8008`.
3. Create an account (open registration enabled).

---

## License
MIT License. See [LICENSE](LICENSE) (add if applicable).
