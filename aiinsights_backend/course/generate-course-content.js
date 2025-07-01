import express from "express";
import axios from "axios";
import { db } from "../config/db.js";
import { coursesTable } from "../config/schema.js";
import { eq } from "drizzle-orm";
import dotenv from "dotenv";
dotenv.config();

const router = express.Router();

const YOUTUBE_BASE_URL = "https://www.googleapis.com/youtube/v3/search";

// Fetch 4 YouTube videos for a topic
const GetYoutubeVideo = async (query) => {
  if (!query) return [];
  try {
    const params = {
      part: "snippet",
      q: query,
      key: process.env.YOUTUBE_API_KEY,
      type: "video",
      maxResults: 4,
    };
    const resp = await axios.get(YOUTUBE_BASE_URL, { params });

    return resp.data.items.map((item) => ({
      videoId: item.id?.videoId,
      title: item.snippet?.title,
    }));
  } catch (error) {
    console.error("YouTube API error:", error.message);
    return [];
  }
};

// Replace this with your AI model integration (e.g., Google Gemini or OpenAI)
async function generateAIContent(prompt, chapter) {
  // Dummy implementation — replace with real API call to AI
  throw new Error("AI content generation function not implemented");
}

// POST: Generate and save course content
router.post("/", async (req, res) => {
  const PROMPT = `You are an AI that generates strictly valid JSON educational content.

Given a chapter name and its topics, generate json-formatted content for each topic. Embed a JSON structure.

⚠️ RULES:
- Do NOT include triple backticks, markdown formatting, or explanations.
- Only output raw, valid JSON.
- Ensure it is valid and parseable JSON.
- Use this format:

{
  "chapterName": "Chapter Name",
  "topics": [
    {
      "topic": "Topic Name",
      "content": "json formatted content here"
    }
  ]
}

Now here is the chapter data:
`;

  try {
    const { courseJson, courseTitle, courseId } = req.body;

    if (!courseId || !courseJson || !courseTitle) {
      return res.status(400).json({ error: "Missing courseId, courseJson, or courseTitle" });
    }

    const promises = courseJson?.chapters?.map(async (chapter) => {
      try {
        const response = await generateAIContent(PROMPT, chapter);

        let rawText = response.trim();
        rawText = rawText.replace(/^```.*\n?/, "").replace(/```$/, "").trim();

        const jsonResp = JSON.parse(rawText);

        if (Array.isArray(jsonResp.topics)) {
          for (let topic of jsonResp.topics) {
            if (typeof topic.content === "string") {
              try {
                topic.content = JSON.parse(topic.content);
              } catch {
                // Leave it as string if not parseable
              }
            }
          }
        }

        const chapterName = jsonResp.chapterName || chapter.chapterName || chapter.title || "";
        const youtubeData = await GetYoutubeVideo(chapterName);

        return {
          ...jsonResp,
          youtubeVideos: youtubeData,
        };
      } catch (error) {
        console.error("❌ Error generating content for chapter:", chapter?.title, error);
        return {
          error: true,
          chapter: chapter?.title || chapter?.chapterName || "unknown",
          message: error.message || "Unknown error",
        };
      }
    });

    const CourseContent = await Promise.all(promises);

    const dbResp = await db
      .update(coursesTable)
      .set({ courseContent: CourseContent })
      .where(eq(coursesTable.cid, courseId));

    return res.json({
      courseName: courseTitle,
      CourseContent,
      dbResp,
    });
  } catch (e) {
    console.error("❌ Fatal error in POST /generate-course-content:", e);
    return res.status(500).json({ error: "Failed to process request", details: e.message });
  }
});

// GET: Fetch course content by courseId
router.get("/", async (req, res) => {
  try {
    const courseId = req.query.courseId;

    if (!courseId) {
      return res.status(400).json({ error: "Missing courseId" });
    }

    const courseData = await db
      .select()
      .from(coursesTable)
      .where(eq(coursesTable.cid, courseId))
      .limit(1);

    if (!courseData || courseData.length === 0) {
      return res.status(404).json({ error: "Course not found" });
    }

    const course = courseData[0];

    return res.json({
      courseName: course.courseName,
      CourseContent: course.courseContent,
    });
  } catch (error) {
    console.error("❌ Error in GET /generate-course-content:", error);
    return res.status(500).json({ error: "Failed to fetch course content", details: error.message });
  }
});

export default router;
