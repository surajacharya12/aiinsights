// utils/auth.js
import { db } from '../config/db.js';
import { usersTable } from '../config/schema.js';
import { eq } from 'drizzle-orm';

export async function getUserFromRequest(req) {
  const email = req.headers['x-user-email'];

  if (!email || typeof email !== 'string') {
    console.warn("No valid 'x-user-email' header found in request");
    return null;
  }

  try {
    const users = await db
      .select()
      .from(usersTable)
      .where(eq(usersTable.email, email));

    if (users.length === 0) {
      console.warn(`No user found with email: ${email}`);
      return null;
    }

    return users[0];
  } catch (error) {
    console.error("Error fetching user from DB:", error);
    return null;
  }
}
