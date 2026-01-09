import { Controller } from "@hotwired/stimulus"
import { Editor } from "@tiptap/core"
import StarterKit from "@tiptap/starter-kit"
import Placeholder from "@tiptap/extension-placeholder"

export default class extends Controller {
  static targets = ["editor"]
  static values = {
    editable: { type: Boolean, default: false },
    taskId: Number
  }

  connect() {
    this.initEditor()
  }

  disconnect() {
    if (this.editor) {
      this.editor.destroy()
    }
  }

  initEditor() {
    const content = this.editorTarget.innerHTML.trim()

    // Clear the element before Tiptap initializes to prevent duplicate content
    this.editorTarget.innerHTML = ""

    this.editor = new Editor({
      element: this.editorTarget,
      extensions: [
        StarterKit.configure({
          heading: {
            levels: [1, 2, 3]
          }
        }),
        Placeholder.configure({
          placeholder: "Start writing..."
        })
      ],
      content: content === "<p class=\"text-base-content/40\">Click to add content...</p>" ? "" : content,
      editable: this.editableValue,
      editorProps: {
        attributes: {
          class: "prose prose-sm max-w-none focus:outline-none min-h-[200px]"
        }
      },
      onUpdate: ({ editor }) => {
        if (this.editableValue) {
          this.scheduleAutosave(editor.getHTML())
        }
      }
    })
  }

  scheduleAutosave(content) {
    if (this.autosaveTimeout) {
      clearTimeout(this.autosaveTimeout)
    }

    this.autosaveTimeout = setTimeout(() => {
      this.saveContent(content)
    }, 1000)
  }

  async saveContent(content) {
    if (!this.taskIdValue) return

    try {
      const response = await fetch(`/tasks/${this.taskIdValue}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Accept": "application/json"
        },
        body: JSON.stringify({
          task: { content: content }
        })
      })

      if (!response.ok) {
        console.error("Failed to save content")
      }
    } catch (error) {
      console.error("Error saving content:", error)
    }
  }
}
