import { Controller, Get, Header, Res, StreamableFile } from '@nestjs/common';
import { ApiOkResponse, ApiProduces, ApiTags } from '@nestjs/swagger';
import type { Response } from 'express';
import { Public } from '../../shared/auth/public.decorator.js';
import { ApiErrorResponses } from '../../shared/http/decorators/api-error-responses.decorator.js';
import { CvService } from './cv.service.js';

@ApiTags('cv')
@Controller('cv')
export class CvController {
  constructor(private readonly cv: CvService) {}

  /** PDF do currículo, gerado agora a partir dos dados atuais. */
  @Public()
  @Get()
  @Header('Cache-Control', 'no-store')
  @ApiProduces('application/pdf')
  @ApiOkResponse({
    description: 'PDF',
    content: { 'application/pdf': { schema: { type: 'string', format: 'binary' } } },
  })
  @ApiErrorResponses()
  async downloadCv(@Res({ passthrough: true }) res: Response): Promise<StreamableFile> {
    const { filename, pdf } = await this.cv.render();
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
    return new StreamableFile(pdf, { type: 'application/pdf', length: pdf.length });
  }
}
