import express from 'express';
import { coursesTable } from '../config/schema.js';
import { db } from '../config/db.js';
import { desc, eq, and, ne, sql } from 'drizzle-orm';

const router = express.Router();
router.get("/", async (req, res) => {
  try {
    const courseId = req.query.courseId;
    const search = req.query.search?.toLowerCase();

    console.log("Received courseId:", courseId);
    console.log("Received search:", search);

    if (courseId === "0") {
      let result = await db
        .select()
        .from(coursesTable)
        .where(
          and(
            sql`${coursesTable.courseContent} IS NOT NULL`,
            ne(coursesTable.courseContent, ""),
          )
        );

      console.log("Initial courses fetched:", result.length);

      if (search) {
        result = result.filter((course) =>
          (course.name?.toLowerCase() || "").includes(search)
        );
        console.log("Courses after search filter:", result.length);
      }

      return res.json(result);
    }

    if (courseId) {
      const result = await db
        .select()
        .from(coursesTable)
        .where(eq(coursesTable.cid, courseId));

      console.log("Single course fetched:", result.length);
      return res.json(result[0] || {});
    }

    return res.json([]);

  } catch (error) {
    console.error("❌ Error fetching courses:", error);
    return res.status(500).json({ message: "Server error", details: error.message });
  }
});


export default router;
