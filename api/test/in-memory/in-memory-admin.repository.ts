import type { Admin } from '../../src/generated/prisma/client.js';
import { AdminRepository } from '../../src/modules/auth/ports/admin.repository.js';

export class InMemoryAdminRepository extends AdminRepository {
  constructor(readonly admins: Admin[] = []) {
    super();
  }

  async findByEmail(email: string): Promise<Admin | null> {
    return this.admins.find((a) => a.email === email) ?? null;
  }

  async findById(id: string): Promise<Admin | null> {
    return this.admins.find((a) => a.id === id) ?? null;
  }
}
