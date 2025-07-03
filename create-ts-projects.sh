#!/bin/bash

# Init npm
npm init -y
mkdir -p src/models src/types
touch ./src/index.ts

# Add basic content to index.ts
echo 'console.log("Hello, TypeScript!");' > ./src/index.ts

# Init tsc
npx tsc --init

# Edit package.json
cat <<EOF > package.json
{
  "name": "ts-project",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "npx tsc && node ./dist/index.js"
  },
  "keywords": [],
  "author": "Vugar Safarzada",
  "license": "ISC",
  "description": "Default TypeScript Project",
  "devDependencies": {
    "typescript": "^5.5.4"
  }
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

# Create README.md
cat <<EOF > README.md
# TypeScript Project
**Created by:** _[Vugar Safarzada](https://github.com/vugarsafarzada)_ <br/>
**Date:** _$(date '+%d.%m.%Y')_
EOF

# Install dependencies and run project
npm install typescript --save-dev
npm run start
