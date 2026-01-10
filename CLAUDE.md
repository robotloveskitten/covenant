# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

```bash
# Start development server (Rails + Tailwind + esbuild watchers)
bin/dev

# Run all RSpec tests
bundle exec rspec

# Run a single test file
bundle exec rspec spec/models/task_spec.rb

# Run a specific test by line number
bundle exec rspec spec/models/task_spec.rb:10

# Build JavaScript assets
yarn build

# Lint Ruby code
bin/rubocop

# Lint and auto-fix
bin/rubocop -a

# Database setup
bin/rails db:setup
bin/rails db:seed  # Creates demo user: demo@example.com / password123
```

## Architecture

### Multi-Tenancy
Users belong to Organizations through Memberships with roles (`admin`, `member`). Tasks and Tags are scoped to Organizations.

### Task Hierarchy
The application uses a single `Task` model with self-referential associations to create a strict hierarchy:
- **Strategy** → contains Initiatives
- **Initiative** → contains Epics
- **Epic** → contains Tasks
- **Task** → leaf nodes (no children)

The `task_type` field enforces which child types are allowed via `Task#allowed_child_types`.

### Dual View System
Each task can be viewed in two modes:
- **Document view** (`show.html.erb`) - Notion-like rich text editing with Tiptap
- **Kanban view** (`kanban.html.erb`) - Drag-and-drop board for child task status

The `default_view` field stores user preference per task.

### ViewComponents
UI components live in `app/components/` using ViewComponent. Lookbook provides previews at `/lookbook` in development (previews in `spec/components/previews/`).

### Stimulus Controllers
- `tiptap_controller.js` - Wraps Tiptap editor, handles autosave (1s debounce) via PATCH to `/tasks/:id`
- `kanban_controller.js` - Native HTML5 drag-and-drop, updates task status via API
- `view_toggle_controller.js` - Switches between document/kanban views
- `autosave_controller.js` - Form field autosave

### Version Control
`TaskVersion` captures snapshots automatically when `title` or `content` changes. Versions can be restored via `VersionsController#restore`.

### Key Patterns
- Authentication via Devise (`current_user`, `authenticate_user!`)
- Turbo/Hotwire for SPA-like navigation without full page reloads
- JSON API responses in `TasksController#update` for JS autosave
- DaisyUI component classes on Tailwind CSS 4
- RSpec with FactoryBot for testing

## Development Guidelines

This is an MVP. Prefer simple, clean, lean solutions over elaborate abstractions.

- **Tests**: New code should include basic happy-path RSpec tests
- **ViewComponents**: Use ViewComponents for UI elements where possible. Each component should have:
  - A Lookbook preview in `spec/components/previews/`
  - Basic RSpec tests in `spec/components/`
