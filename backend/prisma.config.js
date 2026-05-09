const { defineConfig } = require('prisma/config');
const { PrismaPg } = require('@prisma/adapter-pg');
const { Pool } = require('pg');

module.exports = defineConfig({
  migrate: {
    adapter: (env) => {
      const pool = new Pool({ connectionString: env.DATABASE_URL });
      return new PrismaPg(pool);
    },
  },
});
