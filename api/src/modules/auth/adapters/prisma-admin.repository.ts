import { Injectable } from '@nestjs/common';
import type { Admin } from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../shared/prisma/prisma.service.js';
import { AdminRepository } from '../ports/admin.repository.js';

@Injectable()
export class PrismaAdminRepository extends AdminRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  findByEmail(email: string): Promise<Admin | null> {
    return this.prisma.admin.findUnique({ where: { email } });
  }

  findById(id: string): Promise<Admin | null> {
    return this.prisma.admin.findUnique({ where: { id } });
  }
}
