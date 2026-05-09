import { prisma } from "../../lib/prisma";

export class AuthRepository {
  findByUsername(username: any) {
    throw new Error("Method not implemented.");
  }
  async createUser(data: any) {
    return prisma.user.create({
      data: {
        username: data.username,
        email: data.email,
        password: data.password,
      },
    });
  }

  async findByEmail(email: string) {
    return prisma.user.findUnique({ where: { email } });
  }

  async findByUsername(username: string) {
    return prisma.user.findUnique({ where: { username } });
  }

  async findById(id: string) {
    return prisma.user.findUnique({ where: { id } });
  }
}
