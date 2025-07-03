import 'dotenv/config';
import express from 'express';
import helmet from 'helmet';
import bodyParser from 'body-parser';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { body, validationResult } from 'express-validator';
import { fileURLToPath } from 'url';
import bcrypt from 'bcrypt';

import { neon } from '@neondatabase/serverless';
import { drizzle } from 'drizzle-orm/neon-http';
import { sql, eq } from 'drizzle-orm';
import { usersTable } from './config/schema.js';
import { addNewCourse } from './course/AddNewCourse.js';
import { getCourseById } from './course/GetCourse.js';
import generateCourseContentRouter from './course/generate-course-content.js';
import coursesExploreRouter from './course/coursesexplore.js';
import coursesListRouter from './course/CoursesList.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
app.use(bodyParser.json());
app.use(helmet());
app.use(
  helmet.contentSecurityPolicy({
    useDefaults: true,
    directives: {
      "script-src": ["'self'", "'unsafe-inline'"],
    },
  })
);

// Connect to Neon Postgres
const pg = neon(process.env.DATABASE_URL);
const db = drizzle(pg);

// Serve uploaded images
const uploadDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir);
app.use('/uploads', express.static(uploadDir));

// Multer setup for photo upload
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, uploadDir),
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const uniqueName = `user-${Date.now()}${ext}`;
    cb(null, uniqueName);
  },
});
const upload = multer({ storage });

// Normalize photo path helper
function normalizePhotoPath(photo) {
  if (!photo) return photo;
  return photo.startsWith('/') ? photo : '/' + photo;
}

// Root
app.get('/', (req, res) => {
  res.send('API is running!');
});

// -------------------- USER ROUTES ----------------------

// Register
app.post(
  '/register',
  [
    body('name').isString().notEmpty(),
    body('email').isEmail(),
    body('password').isLength({ min: 6 }),
    body('photo').optional().isURL(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

    const { name, email, password, photo } = req.body;

    try {
      // Hash password before saving
      const hashedPassword = await bcrypt.hash(password, 10);

      const insertedUser = await db
        .insert(usersTable)
        .values({ name, email, password: hashedPassword, photo })
        .returning();

      res.status(201).json({ message: 'User registered successfully', user: insertedUser[0] });
    } catch (error) {
      console.error('Registration error:', error);
      if (error.code === '23505') {
        return res.status(409).json({ error: 'Email already exists' });
      }
      res.status(500).json({ error: 'Internal server error' });
    }
  }
);

// Login
app.post(
  '/login',
  [body('email').isEmail(), body('password').isLength({ min: 6 })],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

    const { email, password } = req.body;

    try {
      const users = await db
        .select()
        .from(usersTable)
        .where(sql`${usersTable.email} = ${email}`);

      if (users.length === 0) return res.status(404).json({ error: 'User not found' });

      const user = users[0];
      const match = await bcrypt.compare(password, user.password);
      if (!match) {
        return res.status(401).json({ error: 'Invalid credentials' });
      }

      res.status(200).json({ message: 'Login successful', user });
    } catch (error) {
      console.error('Login error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
);

// Photo upload
app.post('/user/photo-upload', upload.single('photo'), async (req, res) => {
  const userId = parseInt(req.body.id, 10);

  if (!req.file || !userId) {
    return res.status(400).json({ error: 'Missing user ID or file' });
  }

  try {
    let photoPath = `/uploads/${req.file.filename}`;
    photoPath = normalizePhotoPath(photoPath);

    const result = await db
      .update(usersTable)
      .set({ photo: photoPath })
      .where(eq(usersTable.id, userId))
      .returning();

    if (result.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json({ message: 'Photo uploaded and updated successfully', user: result[0] });
  } catch (error) {
    console.error('Upload error:', error);
    res.status(500).json({ error: 'Server error during upload' });
  }
});

// Get user by id
app.get('/user/:id', async (req, res) => {
  const userId = parseInt(req.params.id, 10);
  if (!userId) return res.status(400).json({ error: 'Invalid user ID' });

  try {
    const users = await db
      .select()
      .from(usersTable)
      .where(eq(usersTable.id, userId));

    if (users.length === 0) return res.status(404).json({ error: 'User not found' });

    res.status(200).json(users[0]);
  } catch (error) {
    console.error('Fetch user error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update user
app.put('/user/:id', async (req, res) => {
  const userId = parseInt(req.params.id, 10);
  if (!userId) return res.status(400).json({ error: 'Invalid user ID' });

  const { name, email, photo } = req.body;
  const updateFields = {};
  if (name) updateFields.name = name;
  if (email) updateFields.email = email;
  if (photo) updateFields.photo = photo;

  if (Object.keys(updateFields).length === 0) {
    return res.status(400).json({ error: 'No fields to update' });
  }

  try {
    const result = await db
      .update(usersTable)
      .set(updateFields)
      .where(eq(usersTable.id, userId))
      .returning();

    if (result.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json(result[0]);
  } catch (error) {
    console.error('Update user error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete user
app.delete('/user/:id', async (req, res) => {
  const userId = parseInt(req.params.id, 10);
  if (!userId) return res.status(400).json({ error: 'Invalid user ID' });

  try {
    const result = await db
      .delete(usersTable)
      .where(eq(usersTable.id, userId))
      .returning();

    if (result.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json({ message: 'Account deleted successfully' });
  } catch (error) {
    console.error('Delete user error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// -------------------- COURSE ROUTES ----------------------

// Mount imported routers (make sure these are valid router instances)
app.post('/course/add', addNewCourse);
app.get('/course/get', getCourseById);
app.post('/course/generate-course-content', generateCourseContentRouter);
app.use('/course/explore', coursesExploreRouter);
app.use('/courses', coursesListRouter); // fix: use router, not get()

// Start server
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
