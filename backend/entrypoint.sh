#!/bin/sh

echo "[STARTUP] Applying database migrations..."
node -e "
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

async function migrate() {
  const client = await pool.connect();
  try {
    // Ensure Prisma migrations tracking table exists
    await client.query(\`
      CREATE TABLE IF NOT EXISTS \"_prisma_migrations\" (
        id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::text,
        checksum VARCHAR(64) NOT NULL,
        finished_at TIMESTAMPTZ,
        migration_name VARCHAR(255) NOT NULL,
        logs TEXT,
        rolled_back_at TIMESTAMPTZ,
        started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
        applied_steps_count INTEGER NOT NULL DEFAULT 0
      )
    \`);

    const migrationsDir = path.join(process.cwd(), 'prisma', 'migrations');
    const entries = fs.readdirSync(migrationsDir)
      .filter(d => fs.statSync(path.join(migrationsDir, d)).isDirectory())
      .sort();

    const { rows: applied } = await client.query(
      'SELECT migration_name FROM \"_prisma_migrations\" WHERE finished_at IS NOT NULL'
    );
    const appliedSet = new Set(applied.map(r => r.migration_name));

    for (const dir of entries) {
      if (appliedSet.has(dir)) {
        console.log('[MIGRATION] Already applied:', dir);
        continue;
      }
      const sqlFile = path.join(migrationsDir, dir, 'migration.sql');
      if (!fs.existsSync(sqlFile)) continue;

      const sql = fs.readFileSync(sqlFile, 'utf8');
      const checksum = crypto.createHash('sha256').update(sql).digest('hex').slice(0, 64);
      const id = crypto.randomUUID();

      console.log('[MIGRATION] Applying:', dir);
      await client.query('BEGIN');
      try {
        await client.query(sql);
        await client.query(
          'INSERT INTO \"_prisma_migrations\" (id, checksum, migration_name, finished_at, applied_steps_count) VALUES (\$1, \$2, \$3, NOW(), 1)',
          [id, checksum, dir]
        );
        await client.query('COMMIT');
        console.log('[MIGRATION] Done:', dir);
      } catch (e) {
        await client.query('ROLLBACK');
        throw e;
      }
    }
    console.log('[MIGRATION] All migrations complete.');
  } finally {
    client.release();
    await pool.end();
  }
}

migrate().catch(e => { console.error('[MIGRATION ERROR]', e.message); process.exit(1); });
"

echo "[STARTUP] Checking if seed is needed..."
node -e "
const { PrismaPg } = require('@prisma/adapter-pg');
const { PrismaClient } = require('@prisma/client');
const { Pool } = require('pg');

async function main() {
  const pool = new Pool({ connectionString: process.env.DATABASE_URL });
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
    await pool.end();
  }
}
main().catch(e => { console.error(e); process.exit(1); });
"

echo "[STARTUP] Starting server..."
exec npm start
