const { defineConfig } = require('prisma/config');
const { PrismaPg } = require('@prisma/adapter-pg');
const pg = require('pg');

module.exports = defineConfig({
  earlyAccess: true,
  datasource: {
    url: process.env.DATABASE_URL,
  },
  migrate: {
    adapter() {
      const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });
      return new PrismaPg(pool);
    },
  },
});
