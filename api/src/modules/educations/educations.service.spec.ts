import { ValidationError } from '../../shared/http/errors/domain.errors.js';
import { assertYears } from './educations.service.js';

describe('assertYears', () => {
  it('aceita em andamento e ano único', () => {
    expect(() => assertYears({ startYear: 2023, endYear: null })).not.toThrow();
    expect(() => assertYears({ startYear: 2023, endYear: 2023 })).not.toThrow();
  });
  it('rejeita fim anterior ao início', () => {
    expect(() => assertYears({ startYear: 2023, endYear: 2020 })).toThrow(ValidationError);
  });
});
