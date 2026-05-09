import { Response } from "express";
import { AuthRequest } from "../../core/middleware/auth.middleware";
import { ProfileService } from "./profile.service";

const profileService = new ProfileService();

export const getMyProfile = async (req: AuthRequest, res: Response) => {
  try {
    const profile = await profileService.getProfile(req.userId!);
    res.json({ status: "success", data: profile });
  } catch (error: any) {
    res.status(404).json({ status: "error", message: error.message });
  }
};

export const updateMyProfile = async (req: AuthRequest, res: Response) => {
  try {
    const result = await profileService.updateProfile(req.userId!, req.body);
    res.json({ status: "success", message: "Profile updated", data: result });
  } catch (error: any) {
    res.status(400).json({ status: "error", message: error.message });
  }
};

export const changePassword = async (req: AuthRequest, res: Response) => {
  try {
    const { currentPassword, newPassword } = req.body;
    if (!currentPassword || !newPassword) {
      return res.status(400).json({ status: "error", message: "Both passwords are required" });
    }
    const result = await profileService.changePassword(req.userId!, currentPassword, newPassword);
    res.json({ status: "success", message: result.message });
  } catch (error: any) {
    res.status(400).json({ status: "error", message: error.message });
  }
};
