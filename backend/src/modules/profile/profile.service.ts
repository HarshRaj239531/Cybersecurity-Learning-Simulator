import { ProfileRepository } from "./profile.repository";
import { hashPassword, comparePassword } from "../../core/utils/password";

const profileRepository = new ProfileRepository();

export class ProfileService {
  async getProfile(userId: string) {
    const user = await profileRepository.getUserProfile(userId);
    if (!user) throw new Error("User not found");
    return user;
  }

  async updateProfile(userId: string, data: any) {
    const { password, email, ...updateData } = data;
    return profileRepository.updateProfile(userId, updateData);
  }

  async changePassword(userId: string, currentPassword: string, newPassword: string) {
    const { prisma } = await import("../../lib/prisma");
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new Error("User not found");

    const isMatch = await comparePassword(currentPassword, user.password);
    if (!isMatch) throw new Error("Current password is incorrect");

    const hashed = await hashPassword(newPassword);
    await prisma.user.update({ where: { id: userId }, data: { password: hashed } });
    return { message: "Password updated successfully" };
  }
}
