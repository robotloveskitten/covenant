# Create a test user
user = User.find_or_create_by!(email: "demo@example.com") do |u|
  u.password = "password123"
  u.name = "Demo User"
end

puts "Created user: #{user.email}"

# Create some tags
tags = %w[urgent feature bug documentation research].map do |name|
  Tag.find_or_create_by!(name: name)
end

puts "Created #{tags.count} tags"

# Create a strategy
strategy = Task.find_or_create_by!(title: "Q1 Product Strategy") do |t|
  t.task_type = "strategy"
  t.status = "in_progress"
  t.default_view = "kanban"
  t.content = "<h2>Overview</h2><p>This is our product strategy for Q1. We're focusing on improving user experience and building core features.</p>"
  t.creator = user
end

# Create initiatives under strategy
initiatives = [
  { title: "Improve Onboarding Experience", status: "in_progress" },
  { title: "Build Core Features", status: "not_started" },
  { title: "Performance Optimization", status: "not_started" }
]

initiatives.each do |init|
  Task.find_or_create_by!(title: init[:title]) do |t|
    t.task_type = "initiative"
    t.status = init[:status]
    t.parent = strategy
    t.default_view = "kanban"
    t.creator = user
  end
end

puts "Created strategy with initiatives"

# Create epics under first initiative
initiative = Task.find_by(title: "Improve Onboarding Experience")
epics = [
  { title: "User Registration Flow", status: "completed" },
  { title: "Welcome Tutorial", status: "in_progress" },
  { title: "Email Onboarding Sequence", status: "not_started" }
]

epics.each do |epic|
  Task.find_or_create_by!(title: epic[:title]) do |t|
    t.task_type = "epic"
    t.status = epic[:status]
    t.parent = initiative
    t.default_view = "document"
    t.creator = user
  end
end

puts "Created epics under initiative"

# Create tasks under first epic
epic = Task.find_by(title: "User Registration Flow")
tasks = [
  { title: "Design registration form", status: "completed", due_date: Date.today - 5 },
  { title: "Implement email validation", status: "completed", due_date: Date.today - 3 },
  { title: "Add social login options", status: "in_progress", due_date: Date.today + 2 },
  { title: "Write unit tests", status: "not_started", due_date: Date.today + 5 }
]

tasks.each do |task|
  Task.find_or_create_by!(title: task[:title]) do |t|
    t.task_type = "task"
    t.status = task[:status]
    t.due_date = task[:due_date]
    t.parent = epic
    t.assignee = user
    t.creator = user
    t.content = "<p>Task details for #{task[:title]}.</p>"
  end
end

puts "Created tasks under epic"
puts "Seed data created successfully!"
