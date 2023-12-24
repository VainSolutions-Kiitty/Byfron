function postMessage() {
    var message = document.getElementById("messageInput").value;

    if (message.trim() !== "") {
        var messagesContainer = document.getElementById("messages");
        var messageElement = document.createElement("div");
        messageElement.className = "message";
        messageElement.textContent = message;

        messagesContainer.appendChild(messageElement);

        // You can perform further actions like sending the message to a server or storing it locally.
        console.log("Posted message:", message);

        // Clear the input field
        document.getElementById("messageInput").value = "";
    } else {
        alert("Please enter a message before posting.");
    }
}
