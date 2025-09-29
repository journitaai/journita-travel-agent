# Journita Travel Agent - React Frontend

A React TypeScript frontend for the Journita Travel Agent that consumes the FastAPI backend.

## Setup

1. Install Node.js (version 16 or higher)
2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm start
   ```

The frontend will run on http://localhost:3000 and will automatically proxy API requests to the backend at http://localhost:8000.

## Features

- Real-time chat interface with streaming responses
- Connection status monitoring
- Responsive design
- TypeScript support
- Modern React hooks and components

## Environment Variables

Create a `.env` file with:
```
REACT_APP_API_URL=http://localhost:8000
```

## Project Structure

```
src/
├── components/          # React components
│   ├── ChatBubble.tsx   # Individual chat message component
│   ├── ChatInterface.tsx # Main chat interface
│   └── *.css           # Component styles
├── services/           # API services
│   └── api.ts          # API client for backend communication
├── App.tsx             # Main app component
└── index.tsx           # React entry point
```

## Available Scripts

- `npm start` - Start development server
- `npm build` - Build for production
- `npm test` - Run tests

## Backend Integration

This frontend is designed to work with the FastAPI backend. Make sure the backend is running on port 8000 before starting the frontend.
