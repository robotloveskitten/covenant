# Covenant Product Audit & Feature Roadmap

*Last updated: January 2026*

## Executive Summary

Covenant is a product management tool with opinionated structure (strategy → initiative → epic → task) that aims to combine the clarity of hierarchical planning with the flexibility of a Notion-like wiki. This document audits the current state of the application and outlines potential features to compete with Linear while staying true to our vision.

---

## Part 1: Current Application Audit

### Architecture Overview

| Aspect | Implementation |
|--------|----------------|
| **Framework** | Rails 8 + Hotwire/Turbo |
| **Frontend** | Stimulus controllers, TailwindCSS 4, DaisyUI |
| **Rich Text** | Tiptap editor with extensions |
| **Authentication** | Devise |
| **Multi-tenancy** | Organization-scoped with Memberships |
| **Components** | ViewComponent with Lookbook previews |

### Data Models (8 total)

```
User
  └── Membership (role: admin|member)
        └── Organization
              ├── Task (hierarchical)
              │     ├── TaskVersion
              │     ├── TaskDependency
              │     └── TaskTag
              ├── Tag
              └── Invitation
```

**Task Hierarchy (Single Model, Self-Referential)**
```
Strategy
  └── Initiative
        └── Epic
              └── Task (leaf node)
```

The `task_type` field enforces which children are allowed:
- Strategy → can only contain Initiatives
- Initiative → can only contain Epics
- Epic → can only contain Tasks
- Task → cannot have children

### Controllers & Routes

| Controller | Actions | Purpose |
|------------|---------|---------|
| TasksController | index, show, kanban, new, create, edit, update, destroy, reorder_children | Core task CRUD + views |
| OrganizationsController | show, update | Org settings (admin only) |
| InvitationsController | index, create, destroy, accept | User invitations |
| SettingsController | show, update | User profile settings |
| TagsController | search, create, update, destroy | JSON API for tags |
| UsersController | search | User search for assignee picker |
| VersionsController | index, show, restore | Task version history |

### Stimulus Controllers (7 total)

| Controller | Functionality |
|------------|---------------|
| tiptap_controller | Rich text editor, autosave (1s debounce), bubble menu, slash commands |
| kanban_controller | HTML5 drag-and-drop, status updates via API |
| view_toggle_controller | Document/Kanban switching, URL persistence |
| autosave_controller | Generic form field autosave |
| combobox_controller | Single-select dropdown with search (assignee) |
| tag_combobox_controller | Multi-select tags with inline editing |
| task_field_controller | Task metadata field handling |

### ViewComponents (3 total)

| Component | Purpose |
|-----------|---------|
| ExampleComponent | Template/demo component |
| TaskTagsComponent | Tag display with edit mode toggle |
| TagComboboxComponent | Tag search, select, and create UI |

### Features Already Built

**Core Task Management**
- [x] Create, read, update, delete tasks
- [x] Task hierarchy with type enforcement
- [x] Rich text content editing (Tiptap)
- [x] Dual view system (Document / Kanban)
- [x] Drag-and-drop reordering (Kanban cards, child list)
- [x] Autosave with debounce
- [x] Version history with restore capability

**Task Metadata**
- [x] Status (not_started, in_progress, completed, blocked)
- [x] Assignee (single user)
- [x] Due date
- [x] Tags with colors
- [x] Dependencies (task blocking)

**Organization & Users**
- [x] User registration and authentication
- [x] Organization creation
- [x] Multi-tenancy with data isolation
- [x] Role-based access (admin/member)
- [x] Email invitations with token expiry
- [x] User settings (name, email, password)

**UI/UX**
- [x] Breadcrumb navigation
- [x] Responsive layout
- [x] Type-colored indicators
- [x] Status badges
- [x] Lookbook component previews

---

## Part 2: Competitive Analysis (vs. Linear)

### What Linear Does Well

1. **Speed & Polish** - Feels instant, keyboard-first, beautiful design
2. **Developer Focus** - Deep GitHub/GitLab integration
3. **Cycles** - Built-in sprint planning with velocity tracking
4. **Command Palette** - ⌘K for everything
5. **Views** - List, board, timeline, custom saved views
6. **Automation** - Rules for automatic status changes, assignments
7. **Real-time** - Live collaboration, presence indicators

### Where Covenant Can Differentiate

1. **Strategic Hierarchy** - Linear is flat (Projects → Issues). Covenant has Strategy → Initiative → Epic → Task which maps to how executives think.

2. **Document-First** - Tasks in Covenant are rich documents, not just ticket stubs. Like Notion pages that also track work.

3. **Simplicity** - Linear has grown complex. Covenant can stay lean for teams that don't need all the features.

4. **Flexibility** - The rich text + hierarchy could serve as a wiki, documentation hub, AND task tracker.

---

## Part 3: Feature Roadmap

### Tier 1: High Impact, Low Complexity

*Quick wins that dramatically improve daily usability*

| Feature | Description | Rationale |
|---------|-------------|-----------|
| **Priority Field** | Urgent / High / Medium / Low / None | Standard PM metadata, simple migration + enum |
| **Estimate Field** | Story points (1, 2, 3, 5, 8, 13) or hours | Essential for sprint planning |
| **Comments** | Threaded comments on tasks | Already have sidebar placeholder; table stakes for collaboration |
| **Activity Feed** | Per-task log of changes | Leverage TaskVersion data, add to sidebar |
| **Command Palette (⌘K)** | Global search + quick actions | Linear's signature UX; huge productivity boost |
| **Keyboard Shortcuts** | j/k nav, 1-4 for status, e to edit | Power user productivity |
| **Quick Create** | Minimal modal from anywhere | ⌘K → "Create task" or inline add |

### Tier 2: High Impact, Medium Complexity

*Significant engineering but major value*

| Feature | Description | Rationale |
|---------|-------------|-----------|
| **Custom Views** | Save filter/sort combos as named views | Teams work differently; "My tasks", "Blocked items", etc. |
| **Full-Text Search** | Search titles + rich text content | Table stakes at scale; use Postgres full-text initially |
| **Cycles / Sprints** | Time-boxed work periods | Agile teams expect this; links to estimates |
| **GitHub Integration** | Link PRs to tasks, status updates | Developer workflow essential |
| **@Mentions** | Notify users in comments | Collaboration feature |
| **Team Workspaces** | Multiple teams per org with separate backlogs | Scales to larger organizations |
| **Bulk Actions** | Multi-select + batch status/assignee change | Triage efficiency |

### Tier 3: High Impact, High Complexity

*Major investments requiring significant resources*

| Feature | Description | Rationale |
|---------|-------------|-----------|
| **Timeline View** | Gantt-style visualization with dependencies | Strategic planning, executive visibility |
| **Automation Rules** | "If status = done, move to Archive" | Reduces manual work, Linear parity |
| **Real-time Collaboration** | Live cursors, presence, instant updates | Modern expectation; needs ActionCable |
| **Analytics Dashboard** | Burndown, velocity, cycle reports | Manager insights |
| **Custom Workflows** | Status flows per task type | Enterprise flexibility |
| **Public API + Webhooks** | REST/GraphQL API for integrations | Platform play, enables ecosystem |

### Tier 4: Medium Impact, Quick Wins

*Nice polish, relatively easy*

| Feature | Description |
|---------|-------------|
| Favorites / Starred | Quick access to important tasks |
| Recently Viewed | Return to recent work |
| Templates | Reusable task/epic/initiative structures |
| Due Date Reminders | Email/in-app notifications |
| Keyboard Navigation | Arrow keys in lists |
| Dark Mode | Theme toggle |
| Avatar Uploads | Profile pictures |

---

## Part 4: Strategic Questions

### Market Positioning

**1. Who is the ideal customer?**

Linear targets engineering teams explicitly. Covenant's hierarchy (strategy → initiative) suggests a different user:
- Product teams wanting strategic alignment?
- Startups wanting something simpler than Jira but more structured than Notion?
- Agencies managing client projects?
- Teams where executives need visibility into how work connects to strategy?

**2. What's the core value proposition?**

Options to test:
- "From strategy to shipping" - emphasize the hierarchy
- "Tasks that think bigger" - rich documents + work tracking
- "The simple alternative to complex PM tools" - anti-ClickUp/Jira

**3. Why not just use Notion?**

Notion is infinitely flexible but has no opinions. Covenant's value is the enforced hierarchy that keeps teams aligned. But is that constraint a feature or a bug?

### Product Strategy

**4. Hierarchy Rigidity**

The 4-level structure (Strategy → Initiative → Epic → Task) is opinionated. Consider:
- Some teams want 2 levels (Project → Task)
- Some want 6 levels (Portfolio → Program → Project → ...)
- Should we allow custom levels? Or is the opinion the product?

**5. Single-Player vs. Multiplayer**

Current app lacks:
- Comments
- @mentions
- Notifications
- Real-time updates

v1 could ship without collaboration and position as "personal planning tool" but that limits market. How collaborative should initial release be?

**6. Integration Strategy**

Linear wins developer mindshare with GitHub integration. Options:
- Go integration-first (GitHub, Slack, Figma)
- Go feature-first (build core product, add integrations later)
- Go open-first (API + webhooks so others build integrations)

### Go-to-Market

**7. Pricing Model**

Options:
- Freemium (free tier with limits, paid for teams)
- Per-seat ($10-20/user/month like Linear)
- Flat rate per org (simpler, better for small teams)
- Usage-based (tasks/storage)

**8. Acquisition Strategy**

- Product-led growth (free tier, viral features)
- Content marketing (SEO, thought leadership on strategic planning)
- Enterprise sales (if targeting larger orgs)
- Open source community (if going open core)

**9. Open Source?**

Benefits: Community, trust, contributions, adoption
Risks: Competition forking, harder to monetize
Models: Open core (core free, enterprise paid), hosted-only, dual license

### Technical Considerations

**10. Real-time Infrastructure**

Current: Request/response with Turbo
Future: ActionCable for WebSocket connections

When to invest? Real-time adds complexity but is expected in modern tools.

**11. Search Infrastructure**

Current: No search
Options:
- Postgres full-text (simple, good to 100k tasks)
- Meilisearch/Typesense (better UX, self-hosted)
- Algolia (SaaS, expensive at scale)

**12. Mobile Strategy**

Options:
- Responsive web (current)
- PWA (add offline, push notifications)
- Native apps (iOS/Android - significant investment)

Linear is web + native. Mobile important for on-the-go task management.

---

## Part 5: Recommended Next Steps

### Immediate (This Sprint)

1. **Add Priority Field**
   - Migration: Add `priority` enum to tasks
   - UI: Add dropdown in task metadata section
   - Simple, high-value, validates pipeline

2. **Add Estimate Field**
   - Migration: Add `estimate` integer to tasks
   - UI: Add story points selector
   - Enables future sprint planning

3. **Add Comments**
   - New model: `Comment` (task_id, user_id, content, timestamps)
   - UI: Populate "Comments" tab in sidebar
   - Table stakes for teams

### Short-term (Next Month)

4. **Command Palette (⌘K)**
   - Stimulus controller for modal
   - Search tasks by title
   - Quick actions (create, change status)
   - Biggest UX improvement possible

5. **Keyboard Shortcuts**
   - Global shortcuts: ⌘K (palette), c (create)
   - Task page: e (edit), 1-4 (status)
   - List navigation: j/k

### Medium-term (Quarter)

6. **GitHub Integration (Basic)**
   - OAuth connection
   - Link PRs to tasks via branch name or commit message
   - Show PR status on task
   - Validates developer workflow thesis

7. **Custom Views**
   - Save filter/sort combinations
   - "My tasks", "High priority", "Due this week"
   - Essential for team usage

### Validation

8. **User Interviews**
   - Test hierarchy model (is 4 levels right?)
   - Understand workflow (document view vs kanban)
   - Identify deal-breaker missing features

---

## Appendix: File Reference

### Key Model Files
- `app/models/task.rb` - Core task model with hierarchy
- `app/models/organization.rb` - Multi-tenancy
- `app/models/membership.rb` - User roles

### Key Controller Files
- `app/controllers/tasks_controller.rb` - Task CRUD
- `app/controllers/application_controller.rb` - Auth helpers

### Key Frontend Files
- `app/javascript/controllers/tiptap_controller.js` - Rich text editor
- `app/javascript/controllers/kanban_controller.js` - Drag-and-drop board
- `app/views/tasks/show.html.erb` - Main task view

### Database Schema
- `db/schema.rb` - Current database structure
