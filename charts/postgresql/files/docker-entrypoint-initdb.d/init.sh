#!/#!/usr/bin/env bash

set -eu

psql -v ON_ERROR_STOP=1 --username "$POSTGRESQL_USERNAME" <<-EOSQL
  -- Create database.
  CREATE DATABASE db_app;

  -- Create two database users
  CREATE ROLE readwrite LOGIN ENCRYPTED PASSWORD 'password';
  CREATE ROLE readonly LOGIN ENCRYPTED PASSWORD 'password';

  -- Give readwrite the ability to perform migrations.
  GRANT CREATE ON SCHEMA public TO readwrite;
EOSQL
