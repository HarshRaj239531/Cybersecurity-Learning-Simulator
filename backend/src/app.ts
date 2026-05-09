import express from "express";
import cors from "cors";
import helmet from "helmet";
import cookieParser from "cookie-parser";
import rateLimit from "express-rate-limit";
import pino from "pino-http";
import swaggerUi from "swagger-ui-express";
import { swaggerSpec } from "./lib/swagger";
import authRoutes from "./modules/auth/auth.routes";

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

// Auth Routes
app.use("/auth", authRoutes);

export default app;
