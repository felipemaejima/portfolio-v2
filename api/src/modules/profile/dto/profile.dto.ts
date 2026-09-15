import { ApiProperty } from '@nestjs/swagger';
import { Availability, WorkMode } from '../../../shared/domain/enums.js';
import type { ProfileView } from '../profile.service.js';
import { LanguageDto, LocationDto } from './profile-parts.dto.js';

export class ProfileDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty()
  name: string;

  @ApiProperty()
  headline: string;

  @ApiProperty()
  summary: string;

  @ApiProperty()
  description: string;

  @ApiProperty({ type: LocationDto })
  location: LocationDto;

  @ApiProperty({ enum: Availability, enumName: 'Availability', isArray: true })
  availability: Availability[];

  @ApiProperty({ enum: WorkMode, enumName: 'WorkMode', isArray: true })
  workModes: WorkMode[];

  @ApiProperty({ type: [LanguageDto] })
  languages: LanguageDto[];

  /** URL pública permanente da foto, ou null. */
  @ApiProperty({ type: String, nullable: true })
  imageUrl: string | null;

  @ApiProperty({ format: 'date-time' })
  createdAt: string;

  @ApiProperty({ format: 'date-time' })
  updatedAt: string;

  static from(view: ProfileView): ProfileDto {
    const dto = new ProfileDto();
    dto.id = view.id;
    dto.name = view.name;
    dto.headline = view.headline;
    dto.summary = view.summary;
    dto.description = view.description;
    dto.location = { city: view.city, state: view.state, country: view.country };
    dto.availability = view.availability;
    dto.workModes = view.workModes;
    dto.languages = view.languages;
    dto.imageUrl = view.imageUrl;
    dto.createdAt = view.createdAt.toISOString();
    dto.updatedAt = view.updatedAt.toISOString();
    return dto;
  }
}
