const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const { Kafka } = require('kafkajs');
const path = require('path');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

const KAFKA_BROKER = process.env.KAFKA_BROKER || 'localhost:9092';
const TOPIC = 'video-upload-topic';

app.use(express.static(path.join(__dirname)));

let videos = [];

// Broadcast to connected frontend clients
function broadcast(data) {
  wss.clients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(data));
    }
  });
}

wss.on('connection', ws => {
  ws.send(JSON.stringify({ type: 'INIT', data: videos }));
});

// Kafka Consumer
const kafka = new Kafka({ clientId: 'netflix-backend', brokers: [KAFKA_BROKER] });
const consumer = kafka.consumer({ groupId: 'netflix-stream-group' });

async function runKafkaConsumer() {
  await consumer.connect();
  await consumer.subscribe({ topic: TOPIC, fromBeginning: true });

  await consumer.run({
    eachMessage: async ({ message }) => {
      const videoData = JSON.parse(message.value.toString());
      videos.unshift(videoData);
      broadcast({ type: 'NEW_VIDEO', data: videoData });
      console.log('Processed Video Event:', videoData);
    },
  });
}

runKafkaConsumer().catch(console.error);

server.listen(3000, () => console.log('Netflix app running on port 3000'));