-- PostgreSQL container initialization. The official image creates POSTGRES_DB
-- before executing this file, so do not issue CREATE DATABASE here.
\connect taskflow;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

SELECT 'TaskFlow PostgreSQL initialization completed' AS status;
