# Covenant

A Rails 8 application with a modern frontend stack.

## Tech Stack

- **Ruby on Rails 8** - Web framework
- **Tailwind CSS 4** - Utility-first CSS framework
- **DaisyUI** - Tailwind component library
- **ViewComponent** - Server-rendered components
- **Stimulus** - JavaScript framework for enhancing HTML
- **Hotwire/Turbo** - SPA-like navigation without JavaScript complexity

## Getting Started

### Prerequisites

- Ruby 3.4+
- Node.js (for DaisyUI/Tailwind plugins)
- SQLite3

### Setup

```bash
# Install dependencies
bundle install
npm install

# Setup database
bin/rails db:setup

# Start the development server
bin/dev
```

The app will be available at `http://localhost:3000`.

## Development

### Running the server

```bash
bin/dev
```

This starts both the Rails server and Tailwind CSS watcher.

### ViewComponents

Components are located in `app/components/`. Generate a new component:

```bash
bin/rails generate component ExampleComponent title
```

### Stimulus Controllers

JavaScript controllers are in `app/javascript/controllers/`. Generate a new controller:

```bash
bin/rails generate stimulus example
```
