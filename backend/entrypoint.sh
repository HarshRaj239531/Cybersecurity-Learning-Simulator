#!/bin/sh
set -e

echo "[STARTUP] Running Prisma migrations..."
npx prisma migrate deploy

echo "[STARTUP] Checking if seed is needed..."
node -e "
const { PrismaPg } = require('@prisma/adapter-pg');
const { PrismaClient } = require('@prisma/client');
const pg = require('pg');

async function main() {
  const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });
  const adapter = new PrismaPg(pool);
  const prisma = new PrismaClient({ adapter });
  try {
    const count = await prisma.lab.count();
    if (count === 0) {
      console.log('[SEED] Empty DB — running seed...');
      const { execSync } = require('child_process');
      execSync('node ./prisma/seed.js', { stdio: 'inherit' });
    } else {
      console.log('[SEED] DB has ' + count + ' labs — skipping seed.');
    }
  } finally {
    await prisma.\$disconnect();
    pool.end();
  }
}
main().catch(e => { console.error(e); process.exit(1); });
"

echo "[STARTUP] Starting server..."
exec npm start
