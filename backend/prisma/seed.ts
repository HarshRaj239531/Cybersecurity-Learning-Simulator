import { PrismaClient } from "@prisma/client";
import { PrismaPg } from "@prisma/adapter-pg";
import pg from "pg";

const connectionString = process.env.DATABASE_URL;
const pool = new pg.Pool({ connectionString });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  // Clear existing data
  await prisma.achievement.deleteMany();
  await prisma.challengeProgress.deleteMany();
  await prisma.challenge.deleteMany();
  await prisma.progress.deleteMany();
  await prisma.lab.deleteMany();

  // Labs
  await prisma.lab.create({
    data: {
      id: "sql_injection",
      title: "SQL Injection: Level 1",
      difficulty: "BEGINNER",
      category: "Web",
      description: "Learn to extract database data using SQLi",
      xpReward: 250,
    },
  });
  await prisma.lab.create({
    data: {
      id: "xss",
      title: "XSS Attack Basics",
      difficulty: "BEGINNER",
      category: "Web",
      description: "Understand DOM manipulation attacks",
      xpReward: 250,
    },
  });
  await prisma.lab.create({
    data: {
      id: "jwt",
      title: "JWT Exploits",
      difficulty: "INTERMEDIATE",
      category: "Auth",
      description: "Bypass token validation mechanisms",
      xpReward: 400,
    },
  });

  // Challenges
  await prisma.challenge.create({
    data: {
      id: "base64_decode",
      title: "Base64 Decode",
      description: "Decode the hidden message to reveal the flag.",
      type: "crypto",
      flag: "FLAG{b4se64_1s_n0t_encrypti0n}",
      difficulty: "EASY",
      xpReward: 100,
    },
  });
  await prisma.challenge.create({
    data: {
      id: "hash_cracking",
      title: "Hash Cracking",
      description: "Crack the MD5 hash to find the password.",
      type: "crypto",
      flag: "FLAG{password123}",
      difficulty: "MEDIUM",
      xpReward: 250,
    },
  });

  // Achievements
  await prisma.achievement.create({
    data: {
      title: "First Blood",
      description: "Complete your first lab",
      icon: "water_drop",
    },
  });
  await prisma.achievement.create({
    data: {
      title: "Rookie Hacker",
      description: "Reach Level 5",
      icon: "star",
    },
  });

  console.log("Seeding finished.");
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
