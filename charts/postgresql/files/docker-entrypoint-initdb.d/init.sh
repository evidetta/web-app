#!/#!/usr/bin/env bash

set -eu

psql -v ON_ERROR_STOP=1 --username "$POSTGRESQL_USERNAME"  <<-EOSQL
  -- Create database.
  CREATE DATABASE app_db;

  -- Create two database users
  CREATE ROLE readwrite LOGIN ENCRYPTED PASSWORD 'password';
  CREATE ROLE readonly LOGIN ENCRYPTED PASSWORD 'password';

  -- Give readwrite the ability to perform migrations.
  GRANT CREATE ON SCHEMA public TO readwrite;

  ---Grant default privileges
ALTER DEFAULT PRIVILEGES
    FOR ROLE postgres
    IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE ON TABLES TO readwrite;

ALTER DEFAULT PRIVILEGES
    FOR ROLE postgres
    IN SCHEMA public
    GRANT SELECT ON TABLES TO readonly;

ALTER DEFAULT PRIVILEGES
    FOR ROLE postgres
    IN SCHEMA public
    GRANT USAGE, SELECT ON SEQUENCES TO readwrite;

ALTER DEFAULT PRIVILEGES
    FOR ROLE postgres
    IN SCHEMA public
    GRANT SELECT ON SEQUENCES TO readonly;
EOSQL
