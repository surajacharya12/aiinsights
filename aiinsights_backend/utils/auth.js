// utils/auth.js
import { db } from '../config/db.js';
import { usersTable } from '../config/schema.js';
import { eq } from 'drizzle-orm';

export async function getUserFromRequest(req) {
  const email = req.headers['x-user-email'];
  if (!email) return null;
  try {
    const users = await db.select().from(usersTable).where(eq(usersTable.email, email));
    return users[0] || null;
  } catch (e) {
    return null;
  }
}
