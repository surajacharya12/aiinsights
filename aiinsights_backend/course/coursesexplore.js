import express from 'express';
import { db } from '../config/db.js';
import { coursesTable } from '../config/schema.js';
import { and, eq, ne, sql } from 'drizzle-orm';

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const courseId = (req.query.courseId || '').trim();
    const search = (req.query.search || '').toLowerCase();

    if (courseId === "0" || courseId === "") {
      let result = await db
        .select()
        .from(coursesTable)
        .where(
          and(
            ne(coursesTable.courseContent, "{}"),
            ne(coursesTable.courseContent, "[]"),
            ne(coursesTable.courseContent, ""),
            sql`${coursesTable.courseContent} IS NOT NULL`
          )
        );

      if (search) {
        result = result.filter(course =>
          (course.name?.toLowerCase() || "").includes(search)
        );
      }

      return res.json(result);
    }

    if (courseId) {
      const result = await db
        .select()
        .from(coursesTable)
        .where(eq(coursesTable.cid, courseId));

      if (result.length === 0) {
        return res.status(404).json({ error: "Course not found" });
      }

      return res.json(result[0]);
    }

    return res.json([]);
  } catch (error) {
    console.error("Error fetching courses:", error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
});

export default router;
