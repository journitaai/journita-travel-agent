import React, { useState, useRef, useEffect } from 'react';
import { ChatMessage, apiService } from '../services/api';
import ChatBubble from './ChatBubble';
import './ChatInterface.css';

const ChatInterface: React.FC = () => {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [inputMessage, setInputMessage] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [connectionStatus, setConnectionStatus] = useState<'checking' | 'connected' | 'error'>('checking');
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    checkConnection();
  }, []);

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const checkConnection = async () => {
    try {
      const result = await apiService.testConnection();
      setConnectionStatus(result.status === 'connected' ? 'connected' : 'error');
    } catch (error) {
      setConnectionStatus('error');
    }
  };

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  const handleSendMessage = async () => {
    if (!inputMessage.trim() || isLoading) return;

    const userMessage: ChatMessage = {
      role: 'user',
      content: inputMessage,
      timestamp: new Date(),
    };

    setMessages(prev => [...prev, userMessage]);
    setInputMessage('');
    setIsLoading(true);

    try {
      const assistantMessage: ChatMessage = {
        role: 'assistant',
        content: '',
        timestamp: new Date(),
      };

      setMessages(prev => [...prev, assistantMessage]);

      let fullResponse = '';
      for await (const chunk of apiService.streamChat(inputMessage)) {
        fullResponse += chunk;
        setMessages(prev => {
          const newMessages = [...prev];
          newMessages[newMessages.length - 1] = {
            ...assistantMessage,
            content: fullResponse,
          };
          return newMessages;
        });
      }
    } catch (error) {
      console.error('Error sending message:', error);
      const errorMessage: ChatMessage = {
        role: 'assistant',
        content: `Sorry, I encountered an error: ${error}`,
        timestamp: new Date(),
      };
      setMessages(prev => [...prev.slice(0, -1), errorMessage]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  const getConnectionStatusDisplay = () => {
    switch (connectionStatus) {
      case 'checking':
        return { text: 'Checking connection...', color: '#ffa500' };
      case 'connected':
        return { text: 'Connected to backend', color: '#4caf50' };
      case 'error':
        return { text: 'Backend connection failed', color: '#f44336' };
    }
  };

  const status = getConnectionStatusDisplay();

  return (
    <div className="chat-interface">
      <div className="chat-header">
        <h1>🌍 Journita Travel Agent</h1>
        <div className="connection-status" style={{ color: status.color }}>
          {status.text}
        </div>
      </div>

      <div className="chat-messages">
        {messages.length === 0 && (
          <div className="welcome-message">
            <h2>Welcome to Journita Travel Agent! ✈️</h2>
            <p>I'm your AI-powered travel assistant. I can help you:</p>
            <ul>
              <li>🔍 Find flights to your destination</li>
              <li>🏨 Search for hotels and accommodations</li>
              <li>📋 Plan your itinerary</li>
              <li>💡 Provide travel tips and recommendations</li>
            </ul>
            <p>Try asking me something like:</p>
            <div className="example-prompts">
              <button onClick={() => setInputMessage("Find flights from New York to Paris for next week")}>
                Find flights from New York to Paris for next week
              </button>
              <button onClick={() => setInputMessage("I need a hotel in Tokyo for 3 nights")}>
                I need a hotel in Tokyo for 3 nights
              </button>
              <button onClick={() => setInputMessage("Plan a 5-day itinerary for Rome")}>
                Plan a 5-day itinerary for Rome
              </button>
            </div>
          </div>
        )}

        {messages.map((message, index) => (
          <ChatBubble key={index} message={message} />
        ))}

        {isLoading && (
          <div className="typing-indicator">
            <div className="typing-dots">
              <span></span>
              <span></span>
              <span></span>
            </div>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      <div className="chat-input">
        <div className="input-container">
          <textarea
            value={inputMessage}
            onChange={(e) => setInputMessage(e.target.value)}
            onKeyPress={handleKeyPress}
            placeholder="Ask me about your travel plans..."
            disabled={isLoading || connectionStatus === 'error'}
            rows={1}
          />
          <button
            onClick={handleSendMessage}
            disabled={isLoading || !inputMessage.trim() || connectionStatus === 'error'}
            className="send-button"
          >
            {isLoading ? '⏳' : '🚀'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default ChatInterface;
