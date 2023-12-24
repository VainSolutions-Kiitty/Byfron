const socket = io();

socket.on('message', (message) => {
  displayMessage(message);
});

function postMessage() {
  var message = document.getElementById('messageInput').value;

  if (message.trim() !== '') {
    // Send the message to the server
    socket.emit('message', message);

    // Clear the input field
    document.getElementById('messageInput').value = '';
  } else {
    alert('Please enter a message before posting.');
  }
}

function displayMessage(message) {
  var messagesContainer = document.getElementById('messages');
  var messageElement = document.createElement('div');
  messageElement.className = 'message';
  messageElement.textContent = message;

  messagesContainer.appendChild(messageElement);
}
