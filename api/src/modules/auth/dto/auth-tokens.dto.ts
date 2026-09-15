import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import type { IssuedTokens } from '../auth.service.js';

export class AuthTokensDto {
  @ApiProperty()
  accessToken: string;

  /** Segundos até o access token expirar. */
  @ApiProperty({ type: 'integer', example: 900 })
  expiresIn: number;

  /** Presente só para MOBILE; no WEB o refresh viaja em cookie httpOnly. */
  @ApiPropertyOptional()
  refreshToken?: string;

  static from(tokens: IssuedTokens, includeRefresh: boolean): AuthTokensDto {
    const dto = new AuthTokensDto();
    dto.accessToken = tokens.accessToken;
    dto.expiresIn = tokens.expiresIn;
    if (includeRefresh) dto.refreshToken = tokens.refreshToken;
    return dto;
  }
}
