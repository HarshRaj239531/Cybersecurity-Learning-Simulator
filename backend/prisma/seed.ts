import { prisma } from "../src/lib/prisma";

async function main() {
  await prisma.lab.createMany({
    data: [
      {
        title: "SQL Injection: Level 1",
        difficulty: "BEGINNER",
        category: "Web",
        description: "Learn to extract database data using SQLi",
        xpReward: 250,
      },
      {
        title: "XSS Attack Basics",
        difficulty: "BEGINNER",
        category: "Web",
        description: "Understand DOM manipulation attacks",
        xpReward: 250,
      },
      {
        title: "JWT Exploits",
        difficulty: "INTERMEDIATE",
        category: "Auth",
        description: "Bypass token validation mechanisms",
        xpReward: 400,
      },
    ],
  });

  await prisma.challenge.createMany({
    data: [
      {
        title: "Base64 Decode",
        flag: "FLAG{b4se64_1s_n0t_encrypti0n}",
        difficulty: "EASY",
        xpReward: 100,
      },
      {
        title: "Hash Cracking",
        flag: "FLAG{password123}",
        difficulty: "MEDIUM",
        xpReward: 250,
      },
    ],
  });

  await prisma.achievement.createMany({
    data: [
      {
        title: "First Blood",
        description: "Complete your first lab",
        icon: "water_drop",
      },
      {
        title: "Rookie Hacker",
        description: "Reach Level 5",
        icon: "star",
      },
    ],
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
