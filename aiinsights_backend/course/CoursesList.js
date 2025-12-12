import express from 'express';
import { coursesTable } from '../config/schema.js';
import { db } from '../config/db.js'; // or directly import db if you're exporting it from main
import { eq, desc } from 'drizzle-orm';
import { authenticateToken } from '../auth.js'; // import the auth middleware

const router = express.Router();

// ✅ Protected route - fetch courses of the logged-in user
router.get('/', authenticateToken, async (req, res) => {
  try {
    const userEmail = req.user?.email;

    if (!userEmail) {
      return res.status(401).json({ message: 'Unauthorized: User not logged in' });
    }

    const result = await db
      .select()
      .from(coursesTable)
      .where(eq(coursesTable.userEmail, userEmail))
      .orderBy(desc(coursesTable.id));

    return res.status(200).json(result);
  } catch (error) {
    console.error('❌ Error fetching user courses:', error);
    return res.status(500).json({ message: 'Server error', details: error.message });
  }
});

export default router;
