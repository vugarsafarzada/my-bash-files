#!/bin/bash

mkdir "nest-project"
# shellcheck disable=SC2164
cd "nest-project"

pnpm init

pnpm install reflect-metadata @nestjs/common @nestjs/core @nestjs/platform-express @prisma/client

pnpm install --save-dev typescript @types/node @nestjs/cli @nestjs/schematics prisma

mkdir src

## Create the TypeScript configuration file with good defaults
cat <<EOF > tsconfig.json
{
  "compilerOptions": {
    "module": "commonjs",
    "declaration": true,
    "removeComments": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "allowSyntheticDefaultImports": true,
    "target": "ES2023",
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./",
    "baseUrl": "./",
    "skipLibCheck": true,
    "incremental": true
  }
}
EOF

## Create the TypeScript config file
## that will be used when building the project with NestJS's CLI
cat <<EOF > tsconfig.build.json
{
  "extends": "./tsconfig.json",
  "exclude": ["node_modules", "test", "dist", "**/*spec.ts"]
}
EOF

## Create the NestJS CLI config file
## Do note that we don't want to generate spec files while using the 'generate' command
## since we are not using Jest in this tutorial
## Also, Jest isn't mandatory.
## You could use any other testing framework that works with TS decorators
cat <<EOF > nest-cli.json
{
  "\$schema": "https://json.schemastore.org/nest-cli",
  "collection": "@nestjs/schematics",
  "monorepo": false,
  "sourceRoot": "src",
  "entryFile": "main",
  "language": "ts",
  "generateOptions": {
    "spec": false
  },
  "compilerOptions": {
    "tsConfigPath": "./tsconfig.build.json",
    "webpack": false,
    "deleteOutDir": true,
    "assets": [],
    "watchAssets": false,
    "plugins": []
  }
}
EOF

## Create a minimal application root module
npx nest generate module app --flat

## Create a minimal application entrypoint under src/main.ts file
cat <<EOF > src/main.ts
import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';
import { AppModule } from './app.module';
import {ValidationPipe} from "@nestjs/common";

async function main() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(new ValidationPipe());
  await app.listen(process.env.PORT ?? 3000);
}
main();

EOF


## Prepare Prisma

npx prisma

npx prisma init


## Create a .env file
cat <<EOF > .env
# Environment variables declared in this file are automatically made available to Prisma.
# See the documentation for more detail: https://pris.ly/d/prisma-schema#accessing-environment-variables-from-the-schema

# Prisma supports the native connection string format for PostgreSQL, MySQL, SQLite, SQL Server, MongoDB and CockroachDB.
# See the documentation for all the connection string options: https://pris.ly/d/connection-strings

DATABASE_URL="dialect://username:password@host/database" # on development
EOF

## Create prisma schema file
cat <<EOF > prisma/schema.prisma
datasource db {
  provider = "mysql"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
}

EOF

## Create prisma service file
cat <<EOF > src/prisma.service.ts
import { Injectable, OnModuleInit } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit {
  async onModuleInit() {
    await this.\$connect();
  }
}

EOF


## Edit package.json file
cat <<EOF > package.json
{
  "name": "nest-project",
  "version": "1.0.0",
  "description": "Nest.js Project",
  "scripts": {
    "build": "nest build",
    "start:dev": "nest start --watch",
    "start:prod": "node .",
    "create:module": "nest g resource",
    "create:controller": "nest g controller",
    "create:provider": "nest g service",
    "db:pull": "npx prisma db pull",
    "db:deploy": "npx prisma migrate deploy",
    "db:migrate": "npx prisma migrate dev",
    "db:reset": "npx prisma migrate reset",
    "db:seed": "ts-node prisma/seed.ts",
    "db:studio": "npx prisma studio"
  },
  "keywords": [
    "nest"
  ],
  "author": "Vugar Safarzada",
  "license": "ISC",
  "dependencies": {
    "@nestjs/common": "^11.1.0",
    "@nestjs/core": "^11.1.0",
    "@nestjs/mapped-types": "*",
    "@nestjs/platform-express": "^11.1.0",
    "@prisma/client": "6.6.0",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.1",
    "express": "^5.1.0",
    "node-fetch": "^3.3.2",
    "reflect-metadata": "^0.2.2"
  },
  "devDependencies": {
    "@nestjs/cli": "^11.0.7",
    "@nestjs/schematics": "^11.0.5",
    "@types/node": "^22.15.2",
    "prisma": "^6.6.0",
    "typescript": "^5.8.3"
  },
  "pnpm": {
    "onlyBuiltDependencies": [
      "@nestjs/core"
    ]
  }
}

EOF

pnpm update

echo "Project created successfully!"
echo "1. Update 'DATABASE_URL' on '.env' and add your db schemas to prisma/schema.prisma"
echo "2. Reset Database 'pnpm run db:reset'"
echo "3. Migrate Database 'pnpm run db:migrate'"
echo "4. Run 'pnpm run start:dev'"
