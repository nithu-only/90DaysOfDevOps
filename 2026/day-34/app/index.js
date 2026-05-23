const express = require("express");
const mysql = require("mysql2/promise");
const redis = require("redis");

const app = express();
const port = 3000;

async function startApp() {
  const db = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
  });

  const redisClient = redis.createClient({
    url: `redis://${process.env.REDIS_HOST}:6379`
  });

  await redisClient.connect();

  app.get("/", async (req, res) => {
    const [rows] = await db.execute("SELECT NOW() as now");
    await redisClient.set("message", "Hello from Redis!");
    const redisMessage = await redisClient.get("message");

    res.send(`
      <h1>Docker Compose Advanced (MySQL)</h1>
      <p>Database Time: ${rows[0].now}</p>
      <p>Redis Message: ${redisMessage}</p>
    `);
  });

  app.listen(port, () => {
    console.log(`App running on port ${port}`);
  });
}

startApp();