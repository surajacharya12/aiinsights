// chatpdf.js
import express from "express";
import multer from "multer";
import fs from "fs";
import pdfParse from "pdf-parse";
import path from "path";
import { fileURLToPath } from "url";

const router = express.Router();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const uploadDir = path.join(__dirname, "uploads");
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir);

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, uploadDir),
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}-${file.originalname}`);
  },
});
const upload = multer({ storage });

const pdfContents = {}; // This can be moved to a DB or external cache if needed

router.post("/upload", upload.single("pdf"), async (req, res) => {
  if (!req.file) return res.status(400).json({ error: "No file uploaded" });

  try {
    const fileBuffer = fs.readFileSync(req.file.path);
    const data = await pdfParse(fileBuffer);

    const sessionId = Date.now().toString();
    pdfContents[sessionId] = data.text;

    res.json({
      message: "PDF uploaded and parsed successfully",
      sessionId,
      preview: data.text.slice(0, 500) + "...",
    });
  } catch (err) {
    console.error("Error parsing PDF:", err);
    res.status(500).json({ error: "Failed to parse PDF" });
  }
});

export default router;
