document.addEventListener('DOMContentLoaded', () => {
    const startVoiceBtn = document.getElementById('start-voice-btn');
    const chatMessages = document.getElementById('chat-messages');
    const speechToTextField = document.getElementById('speech-to-text');
    const chatInput = document.getElementById('chat-input');
    const sendBtn = document.getElementById('send-btn');
    const toggleTtsBtn = document.getElementById('toggle-tts-btn');
    const clearChatBtn = document.getElementById('clear-chat-btn');

    const API_BASE = (window.CHATBOT_API_BASE || 'http://127.0.0.1:8000').replace(/\/$/, '');

    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    const recognition = SpeechRecognition ? new SpeechRecognition() : null;

    let ttsEnabled = true;
    let history = [];

    if (!recognition) {
        alert('Your browser does not support the Web Speech API. Please try Chrome or Firefox.');
        if (startVoiceBtn) {
            startVoiceBtn.disabled = true;
        }
    }

    if (recognition) {
        recognition.lang = 'en-US';
        recognition.interimResults = true;
    }

    let isRecording = false;

    if (toggleTtsBtn) {
        toggleTtsBtn.addEventListener('click', () => {
            ttsEnabled = !ttsEnabled;
            const icon = toggleTtsBtn.querySelector('i');
            if (icon) {
                icon.className = ttsEnabled ? 'fa fa-volume-up' : 'fa fa-volume-mute';
            }
        });
    }

    if (clearChatBtn) {
        clearChatBtn.addEventListener('click', () => {
            chatMessages.innerHTML = '';
            history = [];
            speechToTextField.textContent = '';
            if (chatInput) {
                chatInput.value = '';
                chatInput.focus();
            }
        });
    }

    if (sendBtn && chatInput) {
        sendBtn.addEventListener('click', () => {
            const text = (chatInput.value || '').trim();
            if (!text) return;
            chatInput.value = '';
            sendUserMessage(text);
        });

        chatInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendBtn.click();
            }
        });
    }

    if (startVoiceBtn && recognition) {
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
    }

    function startRecognition() {
        if (!recognition) return;
        recognition.start();
        speechToTextField.textContent = 'Listening...';
    }

    function stopRecognition() {
        if (!recognition) return;
        recognition.stop();
        speechToTextField.textContent = '';
    }

    if (recognition) recognition.onresult = (event) => {
        const transcript = Array.from(event.results)
            .map(result => result[0])
            .map(result => result.transcript)
            .join('');

        speechToTextField.textContent = transcript;

        if (event.results[0].isFinal) {
            sendUserMessage(transcript);
        }
    };

    async function getBotResponse(text) {
        try {
            const response = await fetch(`${API_BASE}/chat`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    user_input: text,
                    history
                })
            });

            if (!response.ok) {
                throw new Error('API request failed');
            }

            const data = await response.json();
            const botMessage = data.response || data.message || '';

            addBotMessage(botMessage);
            if (ttsEnabled) {
                speak(botMessage);
            }

        } catch (error) {
            console.error('Error getting bot response:', error);
            addBotMessage('Sorry, something went wrong. Please try again.');
            if (ttsEnabled) {
                speak('Sorry, something went wrong. Please try again.');
            }
        }
    }

    if (recognition) recognition.onerror = (event) => {
        console.error('Speech recognition error:', event.error);
        speechToTextField.textContent = 'Error recognizing speech.';
        stopRecognition();
    };

    if (recognition) recognition.onend = () => {
        if (isRecording) {
            // If we are still supposed to be recording, restart recognition
            startRecognition();
        } else {
            stopRecognition();
        }
    };

    function sendUserMessage(message) {
        addUserMessage(message);
        history.push({ role: 'user', content: message });
        getBotResponse(message);
    }

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

        history.push({ role: 'assistant', content: message });
    }

    function speak(text) {
        if (!window.speechSynthesis) return;
        const utterance = new SpeechSynthesisUtterance(text);
        utterance.lang = 'en-US';
        speechSynthesis.speak(utterance);
    }
});
