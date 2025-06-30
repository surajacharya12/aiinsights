import fetch from 'node-fetch';

const API_URL = 'http://localhost:3000/course/add';

const testCourse = {
  courseId: 'test-course-001',
  name: 'AI for Beginners',
  description: 'A beginner friendly course on AI concepts.',
  category: 'Technology',
  level: 'Beginner',
  duration: '4 weeks',
  includeVideo: true,
  email: 'testuser@example.com', // for testing auth logic
};

async function testAddCourse() {
  try {
    const response = await fetch(API_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(testCourse),
    });
    const data = await response.json();
    console.log('Status:', response.status);
    console.log('Response:', data);
  } catch (err) {
    console.error('Error:', err);
  }
}

testAddCourse();
