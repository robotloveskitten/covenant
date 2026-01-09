// Import and register all your controllers
import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

// Import controllers
import HelloController from "./hello_controller"
import TiptapController from "./tiptap_controller"
import ViewToggleController from "./view_toggle_controller"
import KanbanController from "./kanban_controller"
import AutosaveController from "./autosave_controller"

// Register controllers
application.register("hello", HelloController)
application.register("tiptap", TiptapController)
application.register("view-toggle", ViewToggleController)
application.register("kanban", KanbanController)
application.register("autosave", AutosaveController)

export { application }
