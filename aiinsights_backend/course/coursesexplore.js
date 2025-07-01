import express from "express";
import { db } from "../config/db.js";
import { coursesTable } from "../config/schema.js";
import { desc, eq, and, ne, sql } from "drizzle-orm";
import { getUserFromRequest } from "../utils/auth.js"; 

const router = express.Router();

// GET: Fetch courses
router.get("/", async (req, res) => {
  try {
    const courseId = req.query.courseId;
    const search = req.query.search?.toLowerCase();
    const user = await getUserFromRequest(req); 
    // Case 1: Get all generated courses (courseId == 0)
    if (courseId === "0") {
      let result = await db
        .select()
        .from(coursesTable)
        .where(
          and(
            sql`${coursesTable.courseContent} IS NOT NULL`,
            ne(coursesTable.courseContent, "")
          )
        );

      result = result.filter((course) => {
        const cc = course.courseContent;
        if (!cc || typeof cc !== 'string') return false;
        const trimmed = cc.trim();
        if (trimmed === '' || trimmed === '{}' || trimmed === '[]') return false;
        try {
          const parsed = JSON.parse(trimmed);
          if (Array.isArray(parsed) && parsed.length === 0) return false;
          if (typeof parsed === 'object' && Object.keys(parsed).length === 0) return false;
        } catch {
        }
        return true;
      });

      if (search) {
        result = result.filter((course) =>
          (course.name?.toLowerCase() || "").includes(search)
        );
      }

      console.log("Fetched generated courses (filtered):", result);
      return res.json(result);
    }

    // Case 2: Get specific course by ID
    if (courseId) {
      const result = await db
        .select()
        .from(coursesTable)
        .where(eq(coursesTable.cid, courseId));

      console.log("Fetched course by ID:", result);
      return res.json(result[0] || {});
    }

    // Case 3: Get courses by current user
    if (!user?.email) {
      return res.status(401).json({ message: "Unauthorized: Missing or invalid x-user-email header" });
    }

    const result = await db
      .select()
      .from(coursesTable)
      .where(eq(coursesTable.userEmail, user.email))
      .orderBy(desc(coursesTable.id));

    console.log("Fetched user courses:", result);
    return res.json(result);
  } catch (error) {
    console.error("❌ Error fetching courses:", error);
    return res.status(500).json({ message: "Server error", details: error.message });
  }
});

export default router;
