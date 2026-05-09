import express from "express";
import cors from "cors";
import helmet from "helmet";
import cookieParser from "cookie-parser";
import rateLimit from "express-rate-limit";
import pino from "pino-http";
import swaggerUi from "swagger-ui-express";
import { swaggerSpec } from "./lib/swagger";
import authRoutes from "./modules/auth/auth.routes";
import labRoutes from "./modules/labs/labs.routes";
import ctfRoutes from "./modules/ctf/ctf.routes";
import leaderboardRoutes from "./modules/leaderboard/leaderboard.routes";
import achievementRoutes from "./modules/achievements/achievements.routes";
import mentorRoutes from "./modules/mentor_ai/mentor_ai.routes";
import profileRoutes from "./modules/profile/profile.routes";

const app = express();

// Security Middleware
app.use(helmet());
app.use(
  cors({
    origin: process.env.CORS_ORIGIN || "*",
    credentials: true,
  }),
);

// Rate Limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
});
app.use(limiter);

// General Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(pino());

// Root Route
app.get("/", (req, res) => {
  res.json({ message: "CyberVerse API is online" });
});

// Swagger Documentation
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Module Routes
app.use("/auth", authRoutes);
app.use("/labs", labRoutes);
app.use("/ctf", ctfRoutes);
app.use("/leaderboard", leaderboardRoutes);
app.use("/achievements", achievementRoutes);
app.use("/mentor", mentorRoutes);
app.use("/profile", profileRoutes);

export default app;
