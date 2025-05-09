#!/bin/bash

# Init npm
npm init -y
mkdir src
mkdir src/models
mkdir src/types
touch ./src/index.ts

# Init tsc
tsc -init

# Edit package.json
cat <<EOF > package.json
{
  "name": "ts-project",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "tsc; node ./dist/index.js"
  },
  "keywords": [],
  "author": "Vugar Safarzada",
  "license": "ISC",
  "description": "Default TypeScript Project"
}

EOF

# Edit tsconfig.json
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
    "rootDir": "./src",
    "baseUrl": "./",
    "skipLibCheck": true,
    "incremental": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
EOF

# Run project
npm run start;