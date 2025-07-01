import { db } from "./config/db.js";
import { coursesTable } from "./config/schema.js";
import { nanoid } from "nanoid";

async function insertTestCourse() {
  const testCourse = {
    cid: nanoid(),
    name: "Test Course",
    description: "A test course for debugging.",
    noOfChapters: 3,
    includeVideo: false,
    level: "Beginner",
    category: "Testing",
    courseJson: { chapters: ["Intro", "Middle", "End"] },
    userEmail: "test@example.com",
    bannerImageURL: "https://placehold.co/600x400",
    courseContent: JSON.stringify({ chapters: ["Intro", "Middle", "End"] })
  };
  try {
    const result = await db.insert(coursesTable).values(testCourse).returning();
    console.log("Inserted test course:", result[0]);
  } catch (e) {
    console.error("Error inserting test course:", e);
  }
  process.exit();
}

insertTestCourse();
