require('dotenv').config();
module.exports = {
  migrations: {
    seed: 'ts-node ./prisma/seed.ts',
  },
  datasource: {
    url: process.env.DATABASE_URL,
  },
};
