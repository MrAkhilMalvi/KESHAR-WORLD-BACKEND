// redisClient.js
import { createClient } from 'redis';
import config from 'config';
import dotenv from "dotenv";
dotenv.config();

const redisClient = createClient({
  socket: {
    host: process.env.REDIS_HOST,//config.get('App.redis.host'),
    port: process.env.REDIS_PORT,//config.get('App.redis.port'),
  },
});

redisClient.on('connect', () => {
  console.log("port",process.env.REDIS_HOST)
  console.log('✅ Redis connected');
});

redisClient.on('error', (err) => {
  console.error('❌ Redis connection error:', err);
});

// Connect once, on first import
redisClient.connect().catch((err) => {
  console.error('❌ Failed to connect to Redis:', err);
});

export default redisClient;
