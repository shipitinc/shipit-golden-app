BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "household_members" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "household_members" (
    "id" bigserial PRIMARY KEY,
    "householdId" bigint NOT NULL,
    "name" text NOT NULL,
    "email" text NOT NULL,
    "role" text NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "householdMembersHouseholdIndex" ON "household_members" USING btree ("householdId");

--
-- ACTION DROP TABLE
--
DROP TABLE "program_members" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "program_members" (
    "id" bigserial PRIMARY KEY,
    "programId" bigint NOT NULL,
    "householdId" bigint NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "programMembersProgramHouseholdIndex" ON "program_members" USING btree ("programId", "householdId");


--
-- MIGRATION VERSION FOR shipit_golden
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('shipit_golden', '20260912110426389-household-id-int', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260912110426389-household-id-int', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();


COMMIT;
