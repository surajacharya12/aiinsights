// ./course/GetCourse.js
import { db } from "../config/db.js";
import { coursesTable } from "../config/schema.js";
import { eq } from "drizzle-orm";

async function getCourseById(req, res) {
  try {
    const courseId = req.query.courseId;

    if (!courseId) {
      return res.status(400).json({ error: "Missing courseId in query params" });
    }

    const course = await db
      .select()
      .from(coursesTable)
      .where(eq(coursesTable.cid, courseId));

    if (course.length === 0) {
      return res.status(404).json({ error: "Course not found" });
    }

    return res.status(200).json(course[0]);
  } catch (error) {
    console.error("Fetch course error:", error);
    return res.status(500).json({ error: error.message || "Internal server error" });
  }
}

export { getCourseById };
