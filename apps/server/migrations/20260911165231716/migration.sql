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
    "householdId" text NOT NULL,
    "name" text NOT NULL,
    "email" text NOT NULL,
    "role" text NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "householdMembersHouseholdIndex" ON "household_members" USING btree ("householdId");

--
-- ACTION ALTER TABLE
--
CREATE UNIQUE INDEX "householdsOwnerUniqueIndex" ON "households" USING btree ("ownerId");
--
-- ACTION DROP TABLE
--
DROP TABLE "programs" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "programs" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone NOT NULL,
    "status" text NOT NULL
);


--
-- MIGRATION VERSION FOR shipit_golden
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('shipit_golden', '20260911165231716', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260911165231716', "timestamp" = now();

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
