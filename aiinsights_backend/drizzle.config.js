import 'dotenv/config';
import { defineConfig } from 'drizzle-kit';

export default defineConfig({
  schema: './config/schema.js',
  out: './drizzle',          // folder to save migrations
   dialect: 'postgresql',
  dbCredentials: {
    url: process.env.DATABASE_URL,
  },
});