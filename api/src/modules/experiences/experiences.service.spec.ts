import { ValidationError } from '../../shared/http/errors/domain.errors.js';
import { assertPeriod } from './experiences.service.js';

describe('assertPeriod', () => {
  it('aceita fim ausente ou posterior/igual ao início', () => {
    expect(() => assertPeriod({ startDate: '2023-01', endDate: null })).not.toThrow();
    expect(() => assertPeriod({ startDate: '2023-01', endDate: '2023-01' })).not.toThrow();
    expect(() => assertPeriod({ startDate: '2023-01', endDate: '2024-12' })).not.toThrow();
  });
  it('rejeita fim anterior ao início em endDate', () => {
    expect(() => assertPeriod({ startDate: '2023-06', endDate: '2023-05' })).toThrow(
      ValidationError,
    );
  });
});
