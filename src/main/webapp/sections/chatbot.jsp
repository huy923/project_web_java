<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/chatbot.css">

<div class="page-container">
    <div class="chat-container">
        <div class="chat-messages" id="chat-messages">
            <!-- Chat messages will be displayed here -->
        </div>
        <div class="chat-input-container">
            <button id="start-voice-btn">
                <i class="fa fa-microphone"></i>
            </button>
            <p id="speech-to-text" class="speech-to-text"></p>
        </div>
    </div>
</div>

<script src="../js/chatbot.js"></script>
