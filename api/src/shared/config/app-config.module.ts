import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { configSchemaWithProductionRules } from './config.schema.js';

/**
 * Variáveis vêm do ambiente do container (compose), nunca de arquivo .env
 * dentro da API. Validação falha rápido no boot.
 */
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      ignoreEnvFile: true,
      validationSchema: configSchemaWithProductionRules,
    }),
  ],
})
export class AppConfigModule {}
