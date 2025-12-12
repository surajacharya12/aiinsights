import { db } from "../config/db.js";
import { coursesTable } from "../config/schema.js";
import { GoogleGenAI, Modality } from "@google/genai";
import crypto from "crypto";

const PROMPT = `Generate a Learning Course based on the following details. The response should include Course Name, Description, Course Banner Image Prompt (create a modern, flat-style 2D digital illustration with UI/UX elements, icons, mockups, text blocks, sticky notes, charts, and a 3D look using a vibrant color palette), and JSON for:
{
  "course": {
    "name": "string",
    "description": "string",
    "category": "string",
    "level": "string",
    "duration": "string",
    "includeVideo": "boolean",
    "noOfChapters": "number",
    "bannerImagePrompt": "string",
    "chapters": [
      {
        "chapterName": "string",
        "duration": "string",
        "topics": ["string"]
      }
    ]
  }
}`;

async function GenerateImageWithGemini(prompt) {
  const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });
  const response = await ai.models.generateContent({
    model: "gemini-3-pro-image-preview",
    contents: prompt,
    config: {
      responseModalities: [Modality.IMAGE, Modality.TEXT],
      image: { width: 1024, height: 1024 },
    },
  });
  const imagePart = response.candidates?.[0]?.content?.parts.find(
    (part) => part.inlineData?.data
  );
  if (!imagePart) throw new Error("No image data received from Gemini.");
  return imagePart.inlineData.data;
}

async function addNewCourse(req, res) {
  try {
    let { courseId, ...formData } = req.body;
    const email = req.user?.email || formData.email;
    if (!email) {
      return res
        .status(401)
        .json({ error: "Unauthorized: user not logged in" });
    }
    if (!courseId) courseId = crypto.randomUUID();

    // 1. Generate course structure using Gemini
    const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });
    const response = await ai.models.generateContent({
      model: "gemini-2.0-flash",
      contents: [
        {
          role: "user",
          parts: [
            {
              text: `${PROMPT}\n${JSON.stringify(formData)}`,
            },
          ],
        },
      ],
    });
    const generatedText = response.candidates?.[0]?.content?.parts?.[0]?.text;
    if (!generatedText) {
      throw new Error("Failed to generate course layout");
    }

    // 2. Extract JSON from Gemini response
    const extractJSON = (text) => {
      const first = text.indexOf("{");
      const last = text.lastIndexOf("}");
      if (first === -1 || last === -1)
        throw new Error("Invalid JSON in AI output");
      return text.substring(first, last + 1);
    };
    const jsonString = extractJSON(generatedText);
    const parsedCourse = JSON.parse(jsonString);
    const course = parsedCourse.course;
    const noOfChapters = course.noOfChapters;
    const imagePrompt = course.bannerImagePrompt;

    // 3. Generate image using Gemini's multimodal capability
    const bannerImageBase64 = await GenerateImageWithGemini(imagePrompt);

    // 4. Save course to DB
    await db.insert(coursesTable).values({
      cid: courseId,
      userEmail: email,
      name: formData.name,
      description: formData.description,
      category: formData.category,
      level: formData.level,
      includeVideo: formData.includeVideo,
      noOfChapters,
      courseJson: jsonString,
      bannerImageURL: `data:image/png;base64,${bannerImageBase64}`, // inline base64 image
    });
    return res.status(200).json({ courseId });
  } catch (error) {
    console.error("API error:", error);
    return res
      .status(500)
      .json({ error: error.message || "Internal server error" });
  }
}

export { addNewCourse };
