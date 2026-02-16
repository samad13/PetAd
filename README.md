# PetAd Backend — NestJS + Stellar Trust Engine 🐾

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0+-blue.svg)](https://www.typescriptlang.org/)
[![NestJS](https://img.shields.io/badge/NestJS-10+-E0234E.svg)](https://nestjs.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-336791.svg)](https://www.postgresql.org/)
[![Stellar](https://img.shields.io/badge/Stellar-Blockchain-7D00FF.svg)](https://stellar.org/)

A production-grade backend API and blockchain trust layer for **PetAd** — a platform enabling secure pet adoption and temporary custody with verifiable on-chain guarantees powered by Stellar.

---

## 📋 Table of Contents

- [System Overview](#system-overview)
- [Core Features](#core-features)
- [Architecture Principles](#architecture-principles)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Environment Setup](#environment-setup)
  - [Database Setup](#database-setup)
  - [Stellar Setup](#stellar-setup)
  - [Running the Server](#running-the-server)
- [Project Structure](#project-structure)
- [Core Systems](#core-systems)
  - [Escrow Engine](#escrow-engine)
  - [Event Ledger](#event-ledger)
  - [Trust & Reputation](#trust--reputation)
- [Stellar Integration](#stellar-integration)
- [Background Jobs](#background-jobs)
- [Security Model](#security-model)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Deployment](#deployment)
- [Critical Systems Checklist](#critical-systems-checklist)
- [Scaling Strategy](#scaling-strategy)
- [Contributing](#contributing)
- [License](#license)

---

## 🌟 System Overview

PetAd is designed as **trust infrastructure**, not just a CRUD API. The backend serves as a domain-driven trust engine that orchestrates complex custody workflows with blockchain-backed guarantees.

### The Backend Acts As:

- 🏛️ **Domain Engine** for pet custody logic
- 💰 **Escrow Orchestrator** managing Stellar multisig accounts
- 📜 **Event Ledger** maintaining immutable custody history
- 🔗 **Blockchain Gateway** abstracting Stellar complexity

### System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Frontend (React)                         │
│            User Interface & Experience Layer                │
└───────────────────────┬─────────────────────────────────────┘
                        │ REST API
                        ▼
┌─────────────────────────────────────────────────────────────┐
│              NestJS Backend (Trust Engine)                  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Domain Layer (Adoption + Custody Workflows)         │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Escrow Engine (Multisig Orchestration)              │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Event Sourcing (Immutable Custody Timeline)         │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Stellar Integration (Blockchain Trust Layer)        │  │
│  └──────────────────────────────────────────────────────┘  │
└────┬──────────────────────┬──────────────────┬─────────────┘
     │                      │                  │
     ▼                      ▼                  ▼
┌──────────────┐    ┌──────────────┐   ┌─────────────────┐
│  PostgreSQL  │    │    Redis     │   │  Stellar        │
│  (Events +   │    │  (Queues +   │   │  Blockchain     │
│   State)     │    │   Cache)     │   │  (Trust Layer)  │
└──────────────┘    └──────────────┘   └─────────────────┘
```

---

## ✨ Core Features

### 🐕 Adoption System

- ✅ Legally-binding adoption agreements
- 💰 Escrow deposit management
- 📊 Ownership transfer tracking
- 🔒 Immutable adoption history on-chain

### ⏰ Temporary Custody System

- ⏱️ Time-bound pet custody agreements
- 🛡️ Escrow-backed guarantees
- 🤖 Automatic settlement at term end
- ⚖️ Built-in dispute resolution

### 📜 Event Ledger

- 📝 Append-only custody timeline
- 🗺️ Complete pet movement tracking
- 👤 Adopter trust history
- 🔗 Blockchain hash anchoring for verification

### 🏆 Trust & Reputation

- ✔️ Completed agreements tracking
- 🚨 Dispute records and resolution history
- 🎖️ Verifiable trust profiles for all participants
- 📈 Reputation scoring algorithm

---

## 🏗️ Architecture Principles

### 1. Event Sourcing

All custody and adoption actions generate **immutable events** that serve as the source of truth.

**Events are:**
- ✅ Stored in PostgreSQL
- 🔐 Cryptographically hashed
- ⛓️ Anchored on Stellar blockchain
- 🔄 Used to rebuild complete system state

**Example Event Flow:**

```typescript
PetRegistered → CustodyRequested → EscrowCreated → 
CustodyStarted → CustodyCompleted → EscrowReleased
```

### 2. Escrow Isolation

Escrow logic lives in a **dedicated, audited module** with strict guarantees:

- 🔐 2-of-3 multisig account orchestration
- ⏰ Time-bound automatic settlements
- 🛡️ Built-in dispute resolution paths
- 💯 Idempotent transaction handling

### 3. Privacy by Design

User privacy is paramount:

- 🚫 **Zero** personal data stored on-chain
- 🔒 User identities hashed in blockchain events
- 📄 Documents encrypted at rest with AES-256
- 🎭 Anonymous trust profiles with selective disclosure

### 4. Deterministic Workflows

All state transitions follow **strict finite state machines** with no ambiguity:

```typescript
AdoptionState = 
  PENDING → APPROVED → ESCROW_FUNDED → ACTIVE → COMPLETED

CustodyState = 
  REQUESTED → ESCROW_LOCKED → ACTIVE → ENDED → SETTLED
```

---

## 🛠️ Tech Stack

### Backend Framework

| Technology | Purpose | Version |
|------------|---------|---------|
| **NestJS** | Progressive Node.js framework | 10+ |
| **TypeScript** | Type-safe development | 5.0+ |
| **Prisma ORM** | Type-safe database client | Latest |
| **PostgreSQL** | Event store + application state | 15+ |
| **Redis** | Job queues + caching layer | 7+ |
| **BullMQ** | Background job processing | Latest |

### Blockchain Layer

| Technology | Purpose |
|------------|---------|
| **Stellar SDK** | Blockchain interaction library |
| **Horizon API** | Stellar network gateway |
| **Multisig Escrow** | 2-of-3 signature accounts |
| **Hash Anchoring** | Event verification on-chain |

---

## 📦 Prerequisites

Ensure you have the following installed:

- **Node.js** `>= 20.0.0`
- **PostgreSQL** `>= 15.0`
- **Redis** `>= 7.0`
- **Docker** (optional but recommended)
- **Stellar CLI** (optional, for debugging)

**Verify installations:**

```bash
node --version
psql --version
redis-server --version
docker --version
```

---

## 🚀 Getting Started

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/amina69/PetAd-Backend.git
cd petad-backend
```

2. **Install dependencies**

```bash
npm install
```

Or using pnpm:

```bash
pnpm install
```

---

### Environment Setup

Create a `.env` file in the project root:

```env
# Database Configuration
DATABASE_URL=postgresql://user:password@localhost:5432/petad

# Redis Configuration
REDIS_URL=redis://localhost:6379

# Stellar Blockchain
STELLAR_NETWORK=testnet                    # Options: testnet | public
STELLAR_SECRET_KEY=S...                    # Platform escrow signing key
STELLAR_PUBLIC_KEY=G...                    # Platform public address
STELLAR_HORIZON_URL=https://horizon-testnet.stellar.org

# Authentication
JWT_SECRET=your-256-bit-secret-min-32-characters
JWT_EXPIRATION=7d

# Encryption
ENCRYPTION_KEY=your-aes-256-encryption-key-32-chars  # For document encryption

# Application
PORT=3000
NODE_ENV=development

# File Upload
MAX_FILE_SIZE=10485760                     # 10MB
UPLOAD_DEST=./uploads

# Background Jobs
QUEUE_CONCURRENCY=5
JOB_ATTEMPTS=3

# Monitoring (Production)
SENTRY_DSN=
LOG_LEVEL=debug                            # debug | info | warn | error
```

> **⚠️ CRITICAL SECURITY WARNING:**
> - Never commit `.env` files to version control
> - Use a secrets manager (AWS Secrets Manager, HashiCorp Vault) in production
> - Rotate keys regularly
> - Use different keys for testnet and mainnet

---

### Database Setup

1. **Create PostgreSQL database**

```bash
createdb petad
```

2. **Run Prisma migrations**

```bash
npx prisma migrate dev --name init
```

3. **Generate Prisma Client**

```bash
npx prisma generate
```

4. **Seed initial data (optional)**

```bash
npm run seed
```

**Explore database with Prisma Studio:**

```bash
npx prisma studio
# Opens at http://localhost:5555
```

---

### Stellar Setup

#### Testnet Configuration

1. **Generate a keypair** using Stellar Laboratory:
   - Visit: https://laboratory.stellar.org/#account-creator?network=test

2. **Fund your account** with test XLM:
   - Visit: https://friendbot.stellar.org
   - Paste your public key (G...)
   - Click "Get test network lumens"

3. **Verify account** on Stellar Explorer:
   - Visit: https://stellar.expert/explorer/testnet/account/YOUR_PUBLIC_KEY

4. **Add keys to `.env`:**

```env
STELLAR_NETWORK=testnet
STELLAR_SECRET_KEY=S...  # Keep this absolutely secret!
STELLAR_PUBLIC_KEY=G...  # Your platform escrow account
```

#### Production (Mainnet) Setup

> **🔴 PRODUCTION CRITICAL:**
> For mainnet deployment, use **hardware wallets** or **HSM** (Hardware Security Module)

```env
STELLAR_NETWORK=public
STELLAR_HORIZON_URL=https://horizon.stellar.org
# DO NOT store mainnet secret keys in .env files
# Use AWS Secrets Manager, GCP Secret Manager, or HashiCorp Vault
```

---

### Running the Server

**Development mode** (hot reload enabled):

```bash
npm run start:dev
```

**Production mode:**

```bash
npm run build
npm run start:prod
```

**Debug mode** (with inspector):

```bash
npm run start:debug
```

**API available at:**

```
http://localhost:3000
```

**Health check:**

```bash
curl http://localhost:3000/health
# Expected: {"status":"ok","database":"connected","blockchain":"synced"}
```

---

## 📁 Project Structure

```
src/
├── auth/                     # Authentication & authorization
│   ├── auth.controller.ts
│   ├── auth.service.ts
│   ├── jwt.strategy.ts
│   └── guards/
│       ├── jwt-auth.guard.ts
│       └── roles.guard.ts
│
├── users/                    # User management & profiles
│   ├── users.controller.ts
│   ├── users.service.ts
│   └── entities/
│
├── pets/                     # Pet domain logic
│   ├── pets.controller.ts
│   ├── pets.service.ts
│   └── entities/
│       └── pet.entity.ts
│
├── adoption/                 # Adoption workflows
│   ├── adoption.controller.ts
│   ├── adoption.service.ts
│   ├── adoption.state-machine.ts
│   └── dto/
│
├── custody/                  # Temporary custody workflows
│   ├── custody.controller.ts
│   ├── custody.service.ts
│   ├── custody.state-machine.ts
│   └── entities/
│
├── escrow/                   # 🔥 Escrow engine (CRITICAL)
│   ├── escrow.service.ts
│   ├── escrow.repository.ts
│   ├── multisig.builder.ts
│   ├── settlement.service.ts
│   └── dispute.handler.ts
│
├── events/                   # 📜 Event sourcing system
│   ├── events.service.ts
│   ├── event.repository.ts
│   ├── event.validator.ts
│   └── event.types.ts
│
├── reputation/               # Trust & reputation scoring
│   ├── reputation.service.ts
│   ├── trust-score.calculator.ts
│   └── reputation.controller.ts
│
├── stellar/                  # 🔗 Blockchain integration
│   ├── stellar.service.ts
│   ├── stellar.module.ts
│   ├── transaction.builder.ts
│   ├── hash-anchor.service.ts
│   └── utils/
│       ├── keypair.manager.ts
│       └── horizon.client.ts
│
├── jobs/                     # Background workers (BullMQ)
│   ├── jobs.module.ts
│   ├── processors/
│   │   ├── escrow-settlement.processor.ts
│   │   ├── blockchain-confirmation.processor.ts
│   │   └── notification.processor.ts
│   └── queues/
│
├── documents/                # Encrypted document handling
│   ├── documents.service.ts
│   ├── encryption.service.ts
│   └── storage.service.ts
│
├── notifications/            # Email & push notifications
│   ├── notifications.service.ts
│   └── templates/
│
├── common/                   # Shared utilities
│   ├── decorators/
│   ├── filters/
│   ├── guards/
│   ├── interceptors/
│   ├── pipes/
│   └── utils/
│
├── config/                   # Configuration management
│   ├── configuration.ts
│   └── validation.schema.ts
│
├── prisma/                   # Database layer
│   ├── schema.prisma         # Database schema
│   ├── migrations/           # Version-controlled migrations
│   └── seed.ts               # Seed data
│
├── main.ts                   # Application entry point
└── app.module.ts             # Root module
```

### Key Directories Explained

- **`escrow/`** - The heart of the trust system; handles all multisig account operations
- **`events/`** - Append-only event log; single source of truth for system state
- **`stellar/`** - Abstraction layer for all blockchain interactions
- **`jobs/`** - Background workers for async operations (settlements, confirmations)

---

## 🔥 Core Systems

### Escrow Engine

The escrow engine is the **most critical component** of PetAd. It manages Stellar multisig accounts with deterministic state transitions.

#### Escrow Lifecycle

```
┌────────────────────────────────────────────────────────────┐
│                  Escrow State Machine                      │
└────────────────────────────────────────────────────────────┘

CREATED
   │
   ├─→ Multisig account created (2-of-3: Owner, Caretaker, Platform)
   │
   ▼
FUNDED
   │
   ├─→ Deposit received and verified
   │
   ▼
ACTIVE
   │
   ├─→ Custody/adoption period begins
   │   Time-lock fallback transaction scheduled
   │
   ▼
COMPLETED / DISPUTED
   │
   ├─→ Normal completion OR dispute raised
   │
   ▼
SETTLED
   │
   └─→ Funds released according to outcome
```

#### Multisig Account Structure

```typescript
// escrow/multisig.builder.ts
interface MultisigEscrow {
  accountId: string;              // Stellar account address
  signers: {
    owner: { publicKey: string; weight: 1 };
    caretaker: { publicKey: string; weight: 1 };
    platform: { publicKey: string; weight: 1 };
  };
  thresholds: {
    low: 0;
    medium: 2;  // 2-of-3 required for transactions
    high: 2;
  };
  timeLock?: {
    unlockDate: Date;
    fallbackRecipient: string;
  };
}
```

#### Example: Creating an Escrow

```typescript
// escrow/escrow.service.ts
async createEscrow(params: CreateEscrowDto): Promise<Escrow> {
  // 1. Generate new escrow account
  const escrowKeypair = this.stellarService.generateKeypair();
  
  // 2. Build multisig transaction
  const multisigTx = await this.multisigBuilder.create({
    escrowAccount: escrowKeypair.publicKey(),
    signers: [params.ownerPublicKey, params.caretakerPublicKey, PLATFORM_KEY],
    amount: params.depositAmount,
    timeLock: params.duration
  });
  
  // 3. Submit to Stellar
  const result = await this.stellarService.submitTransaction(multisigTx);
  
  // 4. Emit event
  await this.eventsService.emit({
    type: 'ESCROW_CREATED',
    payload: {
      escrowId: escrowKeypair.publicKey(),
      txHash: result.hash,
      timestamp: new Date()
    }
  });
  
  // 5. Store in database
  return this.escrowRepository.create({
    accountId: escrowKeypair.publicKey(),
    status: 'CREATED',
    transactionHash: result.hash
  });
}
```

#### Automatic Settlement

```typescript
// jobs/processors/escrow-settlement.processor.ts
@Processor('escrow-settlement')
export class EscrowSettlementProcessor {
  @Process('settle')
  async handleSettlement(job: Job<{ escrowId: string }>) {
    const escrow = await this.escrowService.findOne(job.data.escrowId);
    
    // Check if custody period ended
    if (escrow.endDate <= new Date() && escrow.status === 'ACTIVE') {
      // Build settlement transaction
      const settlementTx = await this.buildSettlement(escrow);
      
      // Submit to blockchain
      await this.stellarService.submitTransaction(settlementTx);
      
      // Update state
      await this.escrowService.updateStatus(escrow.id, 'SETTLED');
      
      // Emit event
      await this.eventsService.emit({
        type: 'ESCROW_SETTLED',
        payload: { escrowId: escrow.id, outcome: 'SUCCESS' }
      });
    }
  }
}
```

---

### Event Ledger

The event ledger provides an **immutable, append-only log** of all custody operations.

#### Event Structure

```typescript
// events/event.types.ts
interface CustodyEvent {
  id: string;
  type: EventType;
  aggregateId: string;      // Pet ID or Adoption ID
  payload: EventPayload;
  hash: string;             // SHA-256 hash of event
  blockchainTxHash?: string; // Stellar transaction hash
  timestamp: Date;
  userId: string;
}

enum EventType {
  PET_REGISTERED = 'PET_REGISTERED',
  CUSTODY_REQUESTED = 'CUSTODY_REQUESTED',
  ESCROW_CREATED = 'ESCROW_CREATED',
  CUSTODY_STARTED = 'CUSTODY_STARTED',
  CUSTODY_ENDED = 'CUSTODY_ENDED',
  ESCROW_SETTLED = 'ESCROW_SETTLED',
  DISPUTE_OPENED = 'DISPUTE_OPENED',
  DISPUTE_RESOLVED = 'DISPUTE_RESOLVED',
}
```

#### Event Flow

```
User Action
     │
     ▼
Domain Service (validate)
     │
     ▼
Event Service (create event)
     │
     ├─→ Hash event payload
     │
     ├─→ Store in PostgreSQL
     │
     └─→ Anchor hash on Stellar (async)
```
---

### Trust & Reputation

The reputation system provides **verifiable trust scores** based on completed agreements and dispute history.

#### Trust Score Calculation

```typescript
// reputation/trust-score.calculator.ts
interface TrustScore {
  overall: number;          // 0-100
  completedAgreements: number;
  disputeRate: number;
  averageRating: number;
  blockchainVerified: boolean;
}

async calculateTrustScore(userId: string): Promise<TrustScore> {
  const history = await this.getHistory(userId);
  
  const score = {
    overall: 0,
    completedAgreements: history.completed.length,
    disputeRate: history.disputes.length / history.total.length,
    averageRating: this.calculateAverage(history.ratings),
    blockchainVerified: await this.verifyOnChain(userId)
  };
  
  // Weighted calculation
  score.overall = (
    (score.completedAgreements * 0.4) +
    ((1 - score.disputeRate) * 100 * 0.3) +
    (score.averageRating * 20 * 0.2) +
    (score.blockchainVerified ? 10 : 0)
  );
  
  return score;
}
```

---

## 🔗 Stellar Integration

All blockchain interactions are abstracted behind service classes for maintainability and testability.

### Key Abstraction Layers

| Service | Responsibility |
|---------|----------------|
| `stellar.service.ts` | High-level blockchain operations |
| `transaction.builder.ts` | Construct Stellar transactions |
| `hash-anchor.service.ts` | Event hash anchoring |
| `horizon.client.ts` | Horizon API wrapper |
| `keypair.manager.ts` | Secure key storage and retrieval |

---

## ⚙️ Background Jobs

BullMQ handles all async operations with retry logic and failure handling.

### Job Queues

```typescript
// jobs/jobs.module.ts
BullModule.registerQueue(
  { name: 'escrow-settlement' },
  { name: 'blockchain-confirmation' },
  { name: 'notifications' },
  { name: 'document-processing' }
)
```

---

### Security Headers

```typescript
// main.ts
import helmet from 'helmet';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Security headers
  app.use(helmet());
  
  // CORS configuration
  app.enableCors({
    origin: process.env.FRONTEND_URL,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization']
  });
  
  // Rate limiting
  app.use(
    rateLimit({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 100 // limit each IP to 100 requests per windowMs
    })
  );
  
  await app.listen(3000);
}
```

---

## 🧪 Development Workflow

### Available Scripts

| Command | Description |
|---------|-------------|
| `npm run start` | Start application |
| `npm run start:dev` | Development with hot reload |
| `npm run start:debug` | Debug mode with inspector |
| `npm run start:prod` | Production mode |
| `npm run build` | Build for production |
| `npm run test` | Run unit tests |
| `npm run test:watch` | Watch mode for tests |
| `npm run test:cov` | Generate coverage report |
| `npm run test:e2e` | End-to-end tests |
| `npm run lint` | Lint with ESLint |
| `npm run format` | Format with Prettier |
| `npm run prisma:migrate` | Run database migrations |
| `npm run prisma:generate` | Generate Prisma Client |
| `npm run prisma:studio` | Open Prisma Studio |
| `npm run seed` | Seed database |

---

---

### Docker Configuration

**Dockerfile:**

```dockerfile
# Multi-stage build for production
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma/

RUN npm ci

COPY . .

RUN npx prisma generate
RUN npm run build

# Production image
FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma
COPY package*.json ./

EXPOSE 3000

CMD ["node", "dist/main"]
```

**Build and run:**

```bash
docker build -t petad-backend .
docker run -p 3000:3000 --env-file .env.production petad-backend
```

### Docker Compose (Development)

```yaml
version: '3.8'

services:
  backend:
    build: .
    ports:
      - "3000:3000"
    env_file: .env
    depends_on:
      - postgres
      - redis
    volumes:
      - ./src:/app/src
      - ./uploads:/app/uploads

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: petad
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redisdata:/data

  prisma-studio:
    image: timothyjmiller/prisma-studio:latest
    environment:
      DATABASE_URL: postgresql://user:password@postgres:5432/petad
    ports:
      - "5555:5555"
    depends_on:
      - postgres

volumes:
  pgdata:
  redisdata:
```

**Start full stack:**

```bash
docker-compose up -d
```

---

## ✅ Critical Systems Checklist

### Must Build Carefully

These systems require extra scrutiny:

- [ ] **Escrow State Machine** - No ambiguous transitions, all paths tested
- [ ] **Event Validation Engine** - Strict schema validation, no invalid events
- [ ] **Stellar Transaction Signer** - Secure key management, idempotent signing
- [ ] **Key Management Service** - Encrypted storage, rotation policies
- [ ] **Dispute Workflow Logic** - Fair resolution, auditable decisions

### Important Infrastructure

- [ ] **Backup Strategy** - Automated daily backups, tested restore procedures
- [ ] **Monitoring & Alerts** - Error tracking, performance metrics, uptime alerts
- [ ] **Rate Limiting** - Per-user and per-IP limits, DDoS protection
- [ ] **Error Tracking** - Sentry integration, error aggregation
- [ ] **Audit Logs** - Immutable logs, compliance-ready, searchable

### Recommended Monitoring Tools

| Tool | Purpose |
|------|---------|
| **Sentry** | Error monitoring and crash reporting |
| **OpenTelemetry** | Distributed tracing across services |
| **Prometheus + Grafana** | Metrics collection and visualization |
| **PagerDuty / Opsgenie** | On-call alerts and incident management |

---

## 📈 Scaling Strategy

### Phase 1: Modular Monolith

**Current architecture** (suitable for 0-10K users):

- Single NestJS application
- Redis for job queues
- PostgreSQL with read replicas
- Horizontal scaling via load balancer

### Phase 2: Service Extraction

**When to scale** (10K-100K users):

- Extract escrow engine to dedicated service
- Separate worker service for background jobs
- Event streaming with Kafka/RabbitMQ
- Horizontal scaling per service

**Architecture:**

```
Load Balancer
     │
     ├─→ API Service (multiple instances)
     ├─→ Worker Service (job processing)
     └─→ Escrow Service (critical path isolation)
     
Kafka Event Bus
     │
     ├─→ Event Store
     └─→ Analytics Pipeline
```

### Phase 3: Microservices (Optional)

**When to scale** (100K+ users):

- Adoption service
- Custody service
- Escrow service
- Event sourcing service
- Notification service

---

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Workflow

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/escrow-improvements`)
3. **Write tests** for new functionality
4. **Ensure all tests pass** (`npm run test && npm run test:e2e`)
5. **Lint your code** (`npm run lint`)
6. **Commit with conventional commits:**
   - `feat:` new feature
   - `fix:` bug fix
   - `docs:` documentation changes
   - `refactor:` code refactoring
   - `test:` test additions/changes
7. **Push to your fork** (`git push origin feature/escrow-improvements`)
8. **Open a Pull Request**

### Critical Module Review

Pull requests affecting these modules require **mandatory review** by 2+ maintainers:

- `escrow/`
- `stellar/`
- `events/`
- `auth/`

### Code Review Checklist

- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No security vulnerabilities introduced
- [ ] Environment variables documented
- [ ] Breaking changes clearly noted in PR description
- [ ] Escrow state machine integrity maintained

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Built with ❤️ to enable transparent, trustworthy pet adoption
- Powered by [Stellar](https://stellar.org) blockchain for verifiable trust
- Inspired by the mission to connect pets with loving homes through technology

---

## 🔗 Related Projects

- **Frontend:** [petad-frontend](https://github.com/amina69/PetAd-Frontend) - React web application

---

**Made with 🐾 by the PetAd Team**

*Building trust infrastructure for pet adoption, one escrow at a time.*
