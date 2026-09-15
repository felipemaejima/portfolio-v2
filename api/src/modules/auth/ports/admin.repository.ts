import type { Admin } from '../../../generated/prisma/client.js';

export abstract class AdminRepository {
  abstract findByEmail(email: string): Promise<Admin | null>;
  abstract findById(id: string): Promise<Admin | null>;
}
