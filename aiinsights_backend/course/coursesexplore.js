import express from "express";
import { db } from "../config/db.js";
import { coursesTable } from "../config/schema.js";
import { desc, eq, and, ne, sql } from "drizzle-orm";

const router = express.Router();

router.get("/", async (req, res) => {
  try {
    const courseId = req.query.courseId;
    const search = req.query.search?.toLowerCase();

    // Get user email from header (if needed)
    const userEmail = req.headers['x-user-email'];

    // Case 1: Get all generated courses (courseId === "0")
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

      console.log("Courses fetched before filtering by search:", result.length);

      if (search) {
        result = result.filter((course) =>
          (course.name?.toLowerCase() || "").includes(search)
        );
      }

      console.log("Courses fetched after filtering by search:", result.length);
      return res.json(result);
    }

    // Case 2: Get specific course by ID
    if (courseId) {
      const result = await db
        .select()
        .from(coursesTable)
        .where(eq(coursesTable.cid, courseId));

      console.log("Fetched course by ID:", result.length);
      return res.json(result[0] || {});
    }

    // Case 3: Get courses for the current user
    if (!userEmail) {
      return res.status(401).json({ message: "Unauthorized: missing user email" });
    }

    const result = await db
      .select()
      .from(coursesTable)
      .where(eq(coursesTable.userEmail, userEmail))
      .orderBy(desc(coursesTable.id));

    console.log("Fetched user courses:", result.length);
    return res.json(result);
  } catch (error) {
    console.error("❌ Error fetching courses:", error);
    return res.status(500).json({ message: "Server error", details: error.message });
  }
});

export default router;
