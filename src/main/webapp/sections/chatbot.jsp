<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/chatbot.css">

<jsp:include page="/includes/header.jsp" />
<div class="px-2 main-container">
    <div class="row">
        <div class="col-lg-3 col-md-4 mb-4">
            <jsp:include page="/includes/sidebar.jsp" />
        </div>

        <div class="col-lg-9 col-md-8">
            <div class="card-modern chatbot-card">
                <div class="chatbot-header">
                    <div class="chatbot-title">
                        <div class="chatbot-title-text">AI Chat</div>
                        <div class="chatbot-subtitle">Text + Voice</div>
                    </div>
                    <div class="chatbot-actions">
                        <button type="button" class="chatbot-icon-btn" id="toggle-tts-btn" title="Toggle voice output">
                            <i class="fa fa-volume-up"></i>
                        </button>
                        <button type="button" class="chatbot-icon-btn" id="clear-chat-btn" title="Clear chat">
                            <i class="fa fa-trash"></i>
                        </button>
                    </div>
                </div>

                <div class="chat-container">
                    <div class="chat-messages" id="chat-messages">
                        <!-- Chat messages will be displayed here -->
                    </div>

                    <div class="chat-input-container">
                        <button type="button" id="start-voice-btn" class="chatbot-round-btn" title="Voice input">
                            <i class="fa fa-microphone"></i>
                        </button>
<div class="chatbot-input-wrap">
    <input id="chat-input" class="chatbot-input" type="text" placeholder="Type a message..." autocomplete="off" />
    <div id="speech-to-text" class="speech-to-text"></div>
</div>

<button type="button" id="send-btn" class="chatbot-send-btn" title="Send">
    <i class="fa fa-paper-plane"></i>
</button>
</div>
</div>
</div>
        </div>
    </div>
</div>

<script>
    window.CHATBOT_API_BASE = window.CHATBOT_API_BASE || 'http://127.0.0.1:8000';
</script>
<script src="${pageContext.request.contextPath}/js/chatbot.js"></script>
