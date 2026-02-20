-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('USER', 'ADMIN', 'SHELTER');

-- CreateEnum
CREATE TYPE "PetSpecies" AS ENUM ('DOG', 'CAT', 'BIRD', 'RABBIT', 'OTHER');

-- CreateEnum
CREATE TYPE "PetStatus" AS ENUM ('AVAILABLE', 'PENDING', 'ADOPTED', 'IN_CUSTODY');

-- CreateEnum
CREATE TYPE "AdoptionStatus" AS ENUM ('PENDING', 'APPROVED', 'ESCROW_FUNDED', 'COMPLETED', 'REJECTED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "CustodyStatus" AS ENUM ('ACTIVE', 'COMPLETED', 'CANCELLED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "EscrowStatus" AS ENUM ('CREATED', 'FUNDED', 'RELEASED', 'REFUNDED', 'DISPUTED');

-- CreateEnum
CREATE TYPE "EventType" AS ENUM ('USER_REGISTERED', 'PET_LISTED', 'ADOPTION_REQUESTED', 'ADOPTION_APPROVED', 'ADOPTION_REJECTED', 'ADOPTION_COMPLETED', 'ESCROW_CREATED', 'ESCROW_FUNDED', 'ESCROW_RELEASED', 'ESCROW_REFUNDED', 'CUSTODY_STARTED', 'CUSTODY_COMPLETED');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "role" "UserRole" NOT NULL DEFAULT 'USER',
    "stellar_public_key" TEXT,
    "avatar_url" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pets" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "species" "PetSpecies" NOT NULL,
    "breed" TEXT,
    "age" INTEGER,
    "description" TEXT,
    "image_url" TEXT,
    "status" "PetStatus" NOT NULL DEFAULT 'AVAILABLE',
    "owner_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "pets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "adoption_requests" (
    "id" TEXT NOT NULL,
    "status" "AdoptionStatus" NOT NULL DEFAULT 'PENDING',
    "notes" TEXT,
    "pet_id" TEXT NOT NULL,
    "adopter_id" TEXT NOT NULL,
    "owner_id" TEXT NOT NULL,
    "escrow_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "adoption_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "custody_agreements" (
    "id" TEXT NOT NULL,
    "status" "CustodyStatus" NOT NULL DEFAULT 'ACTIVE',
    "deposit_amount" DECIMAL(12,2) NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3) NOT NULL,
    "terms" TEXT,
    "pet_id" TEXT NOT NULL,
    "owner_id" TEXT NOT NULL,
    "keeper_id" TEXT NOT NULL,
    "escrow_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "custody_agreements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "escrow_accounts" (
    "id" TEXT NOT NULL,
    "stellar_account_id" TEXT NOT NULL,
    "transaction_hash" TEXT,
    "amount" DECIMAL(12,2) NOT NULL,
    "status" "EscrowStatus" NOT NULL DEFAULT 'CREATED',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "escrow_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_logs" (
    "id" TEXT NOT NULL,
    "type" "EventType" NOT NULL,
    "aggregate_id" TEXT NOT NULL,
    "payload" JSONB NOT NULL DEFAULT '{}',
    "metadata" JSONB NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "event_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_stellar_public_key_key" ON "users"("stellar_public_key");

-- CreateIndex
CREATE INDEX "pets_status_idx" ON "pets"("status");

-- CreateIndex
CREATE INDEX "pets_species_idx" ON "pets"("species");

-- CreateIndex
CREATE INDEX "pets_owner_id_idx" ON "pets"("owner_id");

-- CreateIndex
CREATE UNIQUE INDEX "adoption_requests_escrow_id_key" ON "adoption_requests"("escrow_id");

-- CreateIndex
CREATE INDEX "adoption_requests_status_idx" ON "adoption_requests"("status");

-- CreateIndex
CREATE INDEX "adoption_requests_adopter_id_idx" ON "adoption_requests"("adopter_id");

-- CreateIndex
CREATE INDEX "adoption_requests_owner_id_idx" ON "adoption_requests"("owner_id");

-- CreateIndex
CREATE UNIQUE INDEX "custody_agreements_escrow_id_key" ON "custody_agreements"("escrow_id");

-- CreateIndex
CREATE INDEX "custody_agreements_status_idx" ON "custody_agreements"("status");

-- CreateIndex
CREATE INDEX "custody_agreements_owner_id_idx" ON "custody_agreements"("owner_id");

-- CreateIndex
CREATE INDEX "custody_agreements_keeper_id_idx" ON "custody_agreements"("keeper_id");

-- CreateIndex
CREATE UNIQUE INDEX "escrow_accounts_stellar_account_id_key" ON "escrow_accounts"("stellar_account_id");

-- CreateIndex
CREATE INDEX "escrow_accounts_status_idx" ON "escrow_accounts"("status");

-- CreateIndex
CREATE INDEX "event_logs_type_idx" ON "event_logs"("type");

-- CreateIndex
CREATE INDEX "event_logs_aggregate_id_idx" ON "event_logs"("aggregate_id");

-- CreateIndex
CREATE INDEX "event_logs_created_at_idx" ON "event_logs"("created_at");

-- AddForeignKey
ALTER TABLE "pets" ADD CONSTRAINT "pets_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "adoption_requests" ADD CONSTRAINT "adoption_requests_pet_id_fkey" FOREIGN KEY ("pet_id") REFERENCES "pets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "adoption_requests" ADD CONSTRAINT "adoption_requests_adopter_id_fkey" FOREIGN KEY ("adopter_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "adoption_requests" ADD CONSTRAINT "adoption_requests_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "adoption_requests" ADD CONSTRAINT "adoption_requests_escrow_id_fkey" FOREIGN KEY ("escrow_id") REFERENCES "escrow_accounts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "custody_agreements" ADD CONSTRAINT "custody_agreements_pet_id_fkey" FOREIGN KEY ("pet_id") REFERENCES "pets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "custody_agreements" ADD CONSTRAINT "custody_agreements_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "custody_agreements" ADD CONSTRAINT "custody_agreements_keeper_id_fkey" FOREIGN KEY ("keeper_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "custody_agreements" ADD CONSTRAINT "custody_agreements_escrow_id_fkey" FOREIGN KEY ("escrow_id") REFERENCES "escrow_accounts"("id") ON DELETE SET NULL ON UPDATE CASCADE;
