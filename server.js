const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const fs = require('fs');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

app.use(express.static('public'));

io.on('connection', (socket) => {
  console.log('A user connected');

  // Load existing messages from file
  const existingMessages = loadMessagesFromFile();
  existingMessages.forEach((message) => {
    socket.emit('message', message);
  });

  socket.on('message', (message) => {
    // Save the message to the file
    saveMessageToFile(message);

    // Broadcast the message to all connected clients
    io.emit('message', message);
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

function loadMessagesFromFile() {
  try {
    const data = fs.readFileSync('messages.json', 'utf-8');
    return JSON.parse(data);
  } catch (error) {
    console.error('Error reading messages file:', error.message);
    return [];
  }
}

function saveMessageToFile(message) {
  try {
    const existingMessages = loadMessagesFromFile();
    existingMessages.push(message);
    fs.writeFileSync('messages.json', JSON.stringify(existingMessages, null, 2), 'utf-8');
    console.log('Message saved to file:', message);
  } catch (error) {
    console.error('Error saving message to file:', error.message);
  }
}
