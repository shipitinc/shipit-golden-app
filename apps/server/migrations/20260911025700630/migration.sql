BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "program_members" (
    "id" bigserial PRIMARY KEY,
    "programId" bigint NOT NULL,
    "householdId" text NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "programMembersProgramHouseholdIndex" ON "program_members" USING btree ("programId", "householdId");


--
-- MIGRATION VERSION FOR shipit_golden
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('shipit_golden', '20260911025700630', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260911025700630', "timestamp" = now();

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
