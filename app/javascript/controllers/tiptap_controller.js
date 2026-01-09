import { Controller } from "@hotwired/stimulus"
import { Editor } from "@tiptap/core"
import StarterKit from "@tiptap/starter-kit"
import Placeholder from "@tiptap/extension-placeholder"
import Underline from "@tiptap/extension-underline"
import Link from "@tiptap/extension-link"
import Image from "@tiptap/extension-image"
import TextAlign from "@tiptap/extension-text-align"
import TaskList from "@tiptap/extension-task-list"
import TaskItem from "@tiptap/extension-task-item"
import { Color } from "@tiptap/extension-color"
import Highlight from "@tiptap/extension-highlight"
import { TextStyle } from "@tiptap/extension-text-style"

export default class extends Controller {
  static targets = [
    "editor",
    "toolbar",
    "headingLabel",
    "boldBtn",
    "italicBtn",
    "underlineBtn",
    "strikeBtn",
    "bulletListBtn",
    "orderedListBtn",
    "taskListBtn",
    "blockquoteBtn",
    "codeBlockBtn",
    "alignLeftBtn",
    "alignCenterBtn",
    "alignRightBtn",
    "alignJustifyBtn",
    "linkBtn"
  ]

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
        }),
        Underline,
        Link.configure({
          openOnClick: false,
          HTMLAttributes: {
            class: "text-primary underline"
          }
        }),
        Image.configure({
          HTMLAttributes: {
            class: "rounded-lg max-w-full"
          }
        }),
        TextAlign.configure({
          types: ["heading", "paragraph"]
        }),
        TaskList,
        TaskItem.configure({
          nested: true
        }),
        TextStyle,
        Color,
        Highlight.configure({
          multicolor: true
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
      },
      onSelectionUpdate: () => {
        this.updateToolbarState()
      },
      onTransaction: () => {
        this.updateToolbarState()
      }
    })

    // Initial toolbar state
    this.updateToolbarState()
  }

  // Toolbar state management
  updateToolbarState() {
    if (!this.editor || !this.editableValue) return

    const activeClass = "btn-active"

    // Text formatting
    this.updateButtonState("boldBtn", this.editor.isActive("bold"), activeClass)
    this.updateButtonState("italicBtn", this.editor.isActive("italic"), activeClass)
    this.updateButtonState("underlineBtn", this.editor.isActive("underline"), activeClass)
    this.updateButtonState("strikeBtn", this.editor.isActive("strike"), activeClass)

    // Lists
    this.updateButtonState("bulletListBtn", this.editor.isActive("bulletList"), activeClass)
    this.updateButtonState("orderedListBtn", this.editor.isActive("orderedList"), activeClass)
    this.updateButtonState("taskListBtn", this.editor.isActive("taskList"), activeClass)

    // Block elements
    this.updateButtonState("blockquoteBtn", this.editor.isActive("blockquote"), activeClass)
    this.updateButtonState("codeBlockBtn", this.editor.isActive("codeBlock"), activeClass)

    // Text alignment
    this.updateButtonState("alignLeftBtn", this.editor.isActive({ textAlign: "left" }), activeClass)
    this.updateButtonState("alignCenterBtn", this.editor.isActive({ textAlign: "center" }), activeClass)
    this.updateButtonState("alignRightBtn", this.editor.isActive({ textAlign: "right" }), activeClass)
    this.updateButtonState("alignJustifyBtn", this.editor.isActive({ textAlign: "justify" }), activeClass)

    // Link
    this.updateButtonState("linkBtn", this.editor.isActive("link"), activeClass)

    // Heading label
    if (this.hasHeadingLabelTarget) {
      if (this.editor.isActive("heading", { level: 1 })) {
        this.headingLabelTarget.textContent = "Heading 1"
      } else if (this.editor.isActive("heading", { level: 2 })) {
        this.headingLabelTarget.textContent = "Heading 2"
      } else if (this.editor.isActive("heading", { level: 3 })) {
        this.headingLabelTarget.textContent = "Heading 3"
      } else {
        this.headingLabelTarget.textContent = "Paragraph"
      }
    }
  }

  updateButtonState(targetName, isActive, activeClass) {
    const hasTarget = `has${targetName.charAt(0).toUpperCase() + targetName.slice(1)}Target`
    if (this[hasTarget]) {
      const target = this[`${targetName}Target`]
      if (isActive) {
        target.classList.add(activeClass)
      } else {
        target.classList.remove(activeClass)
      }
    }
  }

  // Text formatting actions
  toggleBold() {
    this.editor.chain().focus().toggleBold().run()
  }

  toggleItalic() {
    this.editor.chain().focus().toggleItalic().run()
  }

  toggleUnderline() {
    this.editor.chain().focus().toggleUnderline().run()
  }

  toggleStrike() {
    this.editor.chain().focus().toggleStrike().run()
  }

  // Heading actions
  setParagraph() {
    this.editor.chain().focus().setParagraph().run()
  }

  toggleHeading(event) {
    const level = parseInt(event.currentTarget.dataset.level, 10)
    this.editor.chain().focus().toggleHeading({ level }).run()
  }

  // List actions
  toggleBulletList() {
    this.editor.chain().focus().toggleBulletList().run()
  }

  toggleOrderedList() {
    this.editor.chain().focus().toggleOrderedList().run()
  }

  toggleTaskList() {
    this.editor.chain().focus().toggleTaskList().run()
  }

  // Block element actions
  toggleBlockquote() {
    this.editor.chain().focus().toggleBlockquote().run()
  }

  toggleCodeBlock() {
    this.editor.chain().focus().toggleCodeBlock().run()
  }

  // Text alignment actions
  setTextAlign(event) {
    const align = event.currentTarget.dataset.align
    this.editor.chain().focus().setTextAlign(align).run()
  }

  // Link actions
  setLink() {
    const previousUrl = this.editor.getAttributes("link").href
    const url = window.prompt("Enter URL:", previousUrl || "https://")

    if (url === null) {
      return // User cancelled
    }

    if (url === "") {
      this.editor.chain().focus().extendMarkRange("link").unsetLink().run()
      return
    }

    this.editor.chain().focus().extendMarkRange("link").setLink({ href: url }).run()
  }

  unsetLink() {
    this.editor.chain().focus().unsetLink().run()
  }

  // Image actions
  addImage() {
    const url = window.prompt("Enter image URL:", "https://")

    if (url) {
      this.editor.chain().focus().setImage({ src: url }).run()
    }
  }

  // Color actions
  setColor(event) {
    const color = event.currentTarget.dataset.color
    this.editor.chain().focus().setColor(color).run()
  }

  unsetColor() {
    this.editor.chain().focus().unsetColor().run()
  }

  toggleHighlight(event) {
    const color = event.currentTarget.dataset.color
    if (color) {
      this.editor.chain().focus().toggleHighlight({ color }).run()
    } else {
      this.editor.chain().focus().toggleHighlight().run()
    }
  }

  unsetHighlight() {
    this.editor.chain().focus().unsetHighlight().run()
  }

  // History actions
  undo() {
    this.editor.chain().focus().undo().run()
  }

  redo() {
    this.editor.chain().focus().redo().run()
  }

  // Autosave functionality
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
