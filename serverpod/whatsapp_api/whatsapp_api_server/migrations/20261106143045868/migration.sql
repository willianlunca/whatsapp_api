BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "whatsapp_contact" (
    "id" bigserial PRIMARY KEY,
    "jid" text NOT NULL,
    "name" text,
    "phone" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "whatsapp_contact_jid_idx" ON "whatsapp_contact" USING btree ("jid");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "whatsapp_conversation" (
    "id" bigserial PRIMARY KEY,
    "contactId" bigint NOT NULL,
    "status" text NOT NULL,
    "lastMessageAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "whatsapp_conversation_contact_idx" ON "whatsapp_conversation" USING btree ("contactId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "whatsapp_message" (
    "id" bigserial PRIMARY KEY,
    "conversationId" bigint NOT NULL,
    "whatsappMessageId" text NOT NULL,
    "senderJid" text NOT NULL,
    "fromMe" boolean NOT NULL,
    "content" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "whatsapp_message_id_idx" ON "whatsapp_message" USING btree ("whatsappMessageId");
CREATE INDEX "whatsapp_message_conversation_idx" ON "whatsapp_message" USING btree ("conversationId");


--
-- MIGRATION VERSION FOR whatsapp_api
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('whatsapp_api', '20261106143045868', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261106143045868', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
