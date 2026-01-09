# Covenant

A Notion-like project management tool with a clean, minimalistic interface.

## Features

- **Hierarchical Task Structure**: Strategy → Initiative → Epic → Task
- **Dual Views**: Document view for content, Kanban view for organization
- **WYSIWYG Editor**: Tiptap-powered rich text editing with autosave
- **Version Control**: Track changes and restore previous versions
- **Drag & Drop Kanban**: Visual task management with status columns
- **Tags & Dependencies**: Organize and link related tasks

## Tech Stack

- **Ruby on Rails 8** - Web framework
- **Tailwind CSS 4** - Utility-first CSS
- **DaisyUI** - Component library
- **Tiptap** - Rich text editor
- **Stimulus** - JavaScript controllers
- **Hotwire/Turbo** - SPA-like navigation

## Getting Started

### Prerequisites

- Ruby 3.4+
- Node.js 18+
- SQLite3

### Setup

```bash
# Install Ruby dependencies
bundle install

# Install JavaScript dependencies
yarn install

# Setup database
bin/rails db:setup

# Seed sample data (optional)
bin/rails db:seed
```

### Development

Start the development server with all watchers:

```bash
bin/dev
```

This starts:
- Rails server on `http://localhost:3000`
- Tailwind CSS watcher
- esbuild JavaScript bundler

### Demo Account

After running seeds, you can log in with:
- Email: `demo@example.com`
- Password: `password123`

## Project Structure

```
app/
├── controllers/
│   ├── tasks_controller.rb    # Main task CRUD
│   └── versions_controller.rb # Version history
├── javascript/controllers/
│   ├── tiptap_controller.js   # Rich text editor
│   ├── kanban_controller.js   # Drag & drop
│   └── view_toggle_controller.js
├── models/
│   ├── task.rb                # Unified task model
│   ├── tag.rb                 # Task tags
│   ├── task_version.rb        # Version snapshots
│   └── task_dependency.rb     # Task dependencies
└── views/tasks/
    ├── index.html.erb         # Root task list
    ├── show.html.erb          # Task document view
    ├── _kanban_board.html.erb # Kanban view partial
    └── _form.html.erb         # Task form
```

## Task Types

| Type | Purpose | Contains |
|------|---------|----------|
| Strategy | High-level goals | Initiatives |
| Initiative | Major projects | Epics |
| Epic | Feature groups | Tasks |
| Task | Individual work items | - |

## License

MIT
