document.addEventListener('DOMContentLoaded', () => {
    const startVoiceBtn = document.getElementById('start-voice-btn');
    const chatMessages = document.getElementById('chat-messages');
    const speechToTextField = document.getElementById('speech-to-text');

    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    const recognition = SpeechRecognition ? new SpeechRecognition() : null;

    if (!recognition) {
        alert('Your browser does not support the Web Speech API. Please try Chrome or Firefox.');
        return;
    }

    recognition.lang = 'en-US';
    recognition.interimResults = true;

    let isRecording = false;

    startVoiceBtn.addEventListener('click', () => {
        isRecording = !isRecording;
        if (isRecording) {
            startRecognition();
            startVoiceBtn.classList.add('recording');
        } else {
            stopRecognition();
            startVoiceBtn.classList.remove('recording');
        }
    });

    function startRecognition() {
        recognition.start();
        speechToTextField.textContent = 'Listening...';
    }

    function stopRecognition() {
        recognition.stop();
        speechToTextField.textContent = '';
    }

    recognition.onresult = (event) => {
        const transcript = Array.from(event.results)
            .map(result => result[0])
            .map(result => result.transcript)
            .join('');

        speechToTextField.textContent = transcript;

        if (event.results[0].isFinal) {
            addUserMessage(transcript);
            getBotResponse(transcript);
        }
    };

    async function getBotResponse(text) {
        try {
            const response = await fetch('http://127.0.0.1:8000/chatbot', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ text })
            });

            if (!response.ok) {
                throw new Error('API request failed');
            }

            const data = await response.json();
            const botMessage = data.response;

            addBotMessage(botMessage);
            speak(botMessage);

        } catch (error) {
            console.error('Error getting bot response:', error);
            addBotMessage('Sorry, something went wrong. Please try again.');
            speak('Sorry, something went wrong. Please try again.');
        }
    }

    recognition.onerror = (event) => {
        console.error('Speech recognition error:', event.error);
        speechToTextField.textContent = 'Error recognizing speech.';
        stopRecognition();
    };

    recognition.onend = () => {
        if (isRecording) {
            // If we are still supposed to be recording, restart recognition
            startRecognition();
        } else {
            stopRecognition();
        }
    };

    function addUserMessage(message) {
        const messageElement = document.createElement('div');
        messageElement.classList.add('chat-message', 'user-message');
        messageElement.textContent = message;
        chatMessages.appendChild(messageElement);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    function addBotMessage(message) {
        const messageElement = document.createElement('div');
        messageElement.classList.add('chat-message', 'bot-message');
        messageElement.textContent = message;
        chatMessages.appendChild(messageElement);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    function speak(text) {
        const utterance = new SpeechSynthesisUtterance(text);
        utterance.lang = 'en-US';
        speechSynthesis.speak(utterance);
    }
});
