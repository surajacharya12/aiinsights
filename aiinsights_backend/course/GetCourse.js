import { db } from "../config/db.js";
import { coursesTable } from "../config/schema.js";
import { eq } from "drizzle-orm";

// GET /course/get?courseId=...
async function getCourseById(req, res) {
  const { courseId } = req.query;
  if (!courseId) {
    return res.status(400).json({ error: "Missing courseId" });
  }
  try {
    const courses = await db
      .select()
      .from(coursesTable)
      .where(eq(coursesTable.cid, courseId));
    if (!courses.length) {
      return res.status(404).json({ error: "Course not found" });
    }
    res.status(200).json(courses[0]);
  } catch (err) {
    res.status(500).json({ error: err.message || "Internal server error" });
  }
}

export { getCourseById };
