/**
 * `pnpm openapi:emit` → grava api/openapi.json a partir do código compilado.
 * Não conecta no banco: cria a app sem init()/listen().
 */
import { writeFile } from 'node:fs/promises';
import path from 'node:path';
import { NestFactory } from '@nestjs/core';
import { AppModule } from '../app.module.js';
import { configureApp } from '../app.setup.js';
import { buildOpenApiDocument } from './document.js';

const app = configureApp(await NestFactory.create(AppModule, { logger: false }));
const document = buildOpenApiDocument(app);
const target = path.resolve(import.meta.dirname, '../../openapi.json');

await writeFile(target, `${JSON.stringify(document, null, 2)}\n`);
console.log(`openapi.json → ${target} (${Object.keys(document.paths).length} paths)`);
process.exit(0);
