# Comparative Analysis of Database Migration Tools

Executive Summary

This repository contains the technical infrastructure and test data for a Bachelor thesis comparing open-source database migration tools for migrating MySQL databases to PostgreSQL and MongoDB. The environment includes Docker containers for MySQL 8.0, PostgreSQL 15, and MongoDB 7.0, three representative test databases (Blog, E-commerce, ERP), and configuration examples for migration tooling such as `pgloader` and `mongify`.

Key Accomplishments
- Docker environment configured with MySQL, PostgreSQL, and MongoDB containers.
- Three test databases created (Blog: simple, E-commerce: moderate, ERP: complex) with representative schemas and sample data.
- Migration tools identified and sample configuration files included (`pgloader_blog.conf`).
- Thesis structure and evaluation criteria documented.

Repository Structure
- `docker-compose.yml`: container orchestration for databases.
- `mysql_init/01_blog_db.sql`: Blog system schema and sample data.
- `mysql_init/02_ecommerce_db.sql`: E-commerce schema and sample data.
- `mysql_init/03_erp_db.sql`: ERP schema and sample data.
- `pgloader_blog.conf`: sample pgLoader configuration.

How to run
1. Ensure Docker Desktop is running.
2. From the repository root, start containers:

```powershell
docker compose up -d
```

3. MySQL will run initialization scripts in `mysql_init/` and create the three test databases.

Research Notes
- Databases are intentionally small but include features needed to exercise migration tools: views, stored procedures, triggers, generated columns, composite keys, CHECK and UNIQUE constraints, FULLTEXT indexes, and various data types.
- Use the SQL files in `mysql_init/` as the source data for migration runs and test cases.

If you want, I can also produce `pg_dump` snapshots, `pgloader` run scripts, or example migration runs to PostgreSQL and MongoDB.

Running migrations and verification

- Run pgLoader (MySQL -> PostgreSQL) for the `blog_db` using the included config:

```powershell
.\scripts\run-pgloader.ps1
```

- Run mongify (MySQL -> MongoDB) for the `blog_db` using the included translation and database config:

```powershell
.\scripts\run-mongify.ps1
```

- Verify MySQL contents and sample row counts:

```powershell
.\scripts\verify-mysql.ps1
```

Notes
- The scripts use `host.docker.internal` to let containers access host services; Docker Desktop on Windows provides this hostname.
- `run-pgloader.ps1` uses the `dimitri/pgloader` image and the `pgloader_blog.conf` file already present in the repo.
- `run-mongify.ps1` runs a temporary Ruby container, installs the `mongify` gem, and processes `mongify/translation.rb` using `mongify/database.yml`.

