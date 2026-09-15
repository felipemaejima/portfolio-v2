-- CreateEnum
CREATE TYPE "Availability" AS ENUM ('CLT', 'PJ', 'FREELANCE', 'CONTRACT');

-- CreateEnum
CREATE TYPE "WorkMode" AS ENUM ('REMOTE', 'HYBRID', 'ON_SITE');

-- CreateEnum
CREATE TYPE "LanguageLevel" AS ENUM ('BASIC', 'INTERMEDIATE', 'ADVANCED', 'FLUENT', 'NATIVE');

-- CreateTable
CREATE TABLE "profiles" (
    "id" UUID NOT NULL,
    "key" TEXT NOT NULL DEFAULT 'default',
    "name" TEXT NOT NULL DEFAULT '',
    "headline" TEXT NOT NULL DEFAULT '',
    "summary" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "city" TEXT NOT NULL DEFAULT '',
    "state" TEXT NOT NULL DEFAULT '',
    "country" TEXT NOT NULL DEFAULT '',
    "availability" "Availability"[] DEFAULT ARRAY[]::"Availability"[],
    "work_modes" "WorkMode"[] DEFAULT ARRAY[]::"WorkMode"[],
    "languages" JSONB NOT NULL DEFAULT '[]',
    "image_key" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "profiles_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "profiles_key_key" ON "profiles"("key");
