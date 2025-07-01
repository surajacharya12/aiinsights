import express from "express";
import { db } from "../config/db.js";
import { coursesTable, enrollmentsTable } from "../config/schema.js";
import { eq, and, desc } from "drizzle-orm";
import { getUserFromRequest } from "../utils/auth.js"; 


const router = express.Router();

// POST: Enroll in a course
router.post("/enroll", async (req, res) => {
  try {
    const { courseId } = req.body;
    const user = await getUserFromRequest(req); // Implement this logic based on your auth system

    if (!user?.email) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const userEmail = user.email;

    const enrolledCourses = await db
      .select()
      .from(enrollmentsTable)
      .where(
        and(
          eq(enrollmentsTable.userEmail, userEmail),
          eq(enrollmentsTable.courseId, courseId)
        )
      );

    if (enrolledCourses.length === 0) {
      const result = await db
        .insert(enrollmentsTable)
        .values({
          userEmail,
          courseId,
        })
        .returning();

      return res.json(result);
    }

    return res.json({ message: "Already enrolled in this course" });
  } catch (error) {
    console.error("❌ Enrollment Error:", error);
    return res.status(500).json({ message: "Server Error", details: error.message });
  }
});

// GET: Get all enrolled courses for the current user
router.get("/enrollments", async (req, res) => {
  try {
    const user = await getUserFromRequest(req);

    if (!user?.email) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const userEmail = user.email;
    const courseId = req.query.courseId;

    let result;

    if (courseId) {
      result = await db
        .select()
        .from(coursesTable)
        .innerJoin(enrollmentsTable, eq(coursesTable.cid, enrollmentsTable.courseId))
        .where(
          and(
            eq(enrollmentsTable.userEmail, userEmail),
            eq(enrollmentsTable.courseId, courseId)
          )
        )
        .orderBy(desc(enrollmentsTable.id));
    } else {
      result = await db
        .select()
        .from(coursesTable)
        .innerJoin(enrollmentsTable, eq(coursesTable.cid, enrollmentsTable.courseId))
        .where(eq(enrollmentsTable.userEmail, userEmail))
        .orderBy(desc(enrollmentsTable.id));
    }

    return res.json(result);
  } catch (error) {
    console.error("❌ Fetch Enrollments Error:", error);
    return res.status(500).json({ message: "Server Error", details: error.message });
  }
});

export default router;
