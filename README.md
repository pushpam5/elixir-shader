# Shader Generator

A web API service built with Phoenix that generates fragment shaders using Claude API. This service allows you to create custom WebGL2 fragment shaders by describing them in natural language.

## Features

- REST API for generating fragment shaders from text descriptions
- Powered by Anthropic's Claude 3.7 Sonnet model
- WebGL2 compliant shader code generation

## Setup

### Prerequisites

- Elixir
- Mix
- An Anthropic API key

### Environment Variables

Set your Anthropic API key as an environment variable:

```
export ANTHROPIC_API_KEY=your_api_key_here
```

### Installation

1. Clone the repository

```
git clone git@github.com:pushpam5/elixir-shader.git
```

2. Install dependencies:

```
mix deps.get
```

3. Start the Phoenix server:

```
mix phx.server
```

The server will be available at [http://localhost:4000](http://localhost:4000).

## API Usage

### Generate a Shader

**Endpoint:** `POST /api/shader`

**Request Body:**
```json
{
  "prompt": "Create a wavy blue ocean shader with white foam"
}
```

**Success Response (200 OK):**
```json
{
  "shader": "precision mediump float;\n\nuniform vec2 uResolution;\nuniform float uTime;\n\nvoid main() {\n    // Your generated shader code\n}"
}
```

**Error Response (500 Internal Server Error):**
```json
{
  "error": "Failed to generate shader: [error message]"
}
```

## Project Structure

- `lib/shader/llm.ex` - The module that handles interactions with Claude AI
- `lib/shader_web/controllers/shader_controller.ex` - Controller for the shader generation endpoint
- `lib/shader_web/router.ex` - API route definitions

## Live Demo

You can try out the shader generator live at [https://react-calculator-shader.vercel.app/](https://react-calculator-shader.vercel.app/)

The live demo allows you to:
- Enter natural language prompts to generate shaders
- See the shader code generated by Claude API
- View the rendered shader output in real-time
- Experiment with different prompts and effects
