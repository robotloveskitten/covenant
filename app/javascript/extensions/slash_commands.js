import { Extension } from "@tiptap/core"
import Suggestion from "@tiptap/suggestion"

// Slash command items - what appears in the "/" menu
export const slashCommandItems = [
  // Block types
  {
    title: "Heading 1",
    description: "Large section heading",
    icon: "H1",
    category: "blocks",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).setNode("heading", { level: 1 }).run()
    }
  },
  {
    title: "Heading 2",
    description: "Medium section heading",
    icon: "H2",
    category: "blocks",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).setNode("heading", { level: 2 }).run()
    }
  },
  {
    title: "Heading 3",
    description: "Small section heading",
    icon: "H3",
    category: "blocks",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).setNode("heading", { level: 3 }).run()
    }
  },
  {
    title: "Bullet List",
    description: "Create a simple bullet list",
    icon: "•",
    category: "blocks",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).toggleBulletList().run()
    }
  },
  {
    title: "Numbered List",
    description: "Create a numbered list",
    icon: "1.",
    category: "blocks",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).toggleOrderedList().run()
    }
  },
  {
    title: "Task List",
    description: "Track tasks with checkboxes",
    icon: "☐",
    category: "blocks",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).toggleTaskList().run()
    }
  },
  {
    title: "Blockquote",
    description: "Add a quote block",
    icon: "❝",
    category: "blocks",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).toggleBlockquote().run()
    }
  },
  {
    title: "Code Block",
    description: "Add a code snippet",
    icon: "</>",
    category: "blocks",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).toggleCodeBlock().run()
    }
  },
  {
    title: "Divider",
    description: "Insert a horizontal line",
    icon: "—",
    category: "blocks",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).setHorizontalRule().run()
    }
  },
  {
    title: "Image",
    description: "Insert an image from URL",
    icon: "🖼",
    category: "blocks",
    command: ({ editor, range }) => {
      const url = window.prompt("Enter image URL:", "https://")
      if (url) {
        editor.chain().focus().deleteRange(range).setImage({ src: url }).run()
      }
    }
  },
  // Emoji - common reactions
  {
    title: "Thumbs Up",
    description: "Insert 👍",
    icon: "👍",
    category: "emoji",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).insertContent("👍").run()
    }
  },
  {
    title: "Thumbs Down",
    description: "Insert 👎",
    icon: "👎",
    category: "emoji",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).insertContent("👎").run()
    }
  },
  {
    title: "Clap",
    description: "Insert 👏",
    icon: "👏",
    category: "emoji",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).insertContent("👏").run()
    }
  },
  {
    title: "Fire",
    description: "Insert 🔥",
    icon: "🔥",
    category: "emoji",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).insertContent("🔥").run()
    }
  },
  {
    title: "Heart",
    description: "Insert ❤️",
    icon: "❤️",
    category: "emoji",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).insertContent("❤️").run()
    }
  },
  {
    title: "Star",
    description: "Insert ⭐",
    icon: "⭐",
    category: "emoji",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).insertContent("⭐").run()
    }
  },
  {
    title: "Rocket",
    description: "Insert 🚀",
    icon: "🚀",
    category: "emoji",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).insertContent("🚀").run()
    }
  },
  {
    title: "Check Mark",
    description: "Insert ✅",
    icon: "✅",
    category: "emoji",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).insertContent("✅").run()
    }
  },
  {
    title: "Warning",
    description: "Insert ⚠️",
    icon: "⚠️",
    category: "emoji",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).insertContent("⚠️").run()
    }
  },
  {
    title: "Light Bulb",
    description: "Insert 💡",
    icon: "💡",
    category: "emoji",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).insertContent("💡").run()
    }
  },
  {
    title: "Question",
    description: "Insert ❓",
    icon: "❓",
    category: "emoji",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).insertContent("❓").run()
    }
  },
  {
    title: "Party",
    description: "Insert 🎉",
    icon: "🎉",
    category: "emoji",
    command: ({ editor, range }) => {
      editor.chain().focus().deleteRange(range).insertContent("🎉").run()
    }
  }
]

// Create the SlashCommands extension
export const SlashCommands = Extension.create({
  name: "slashCommands",

  addOptions() {
    return {
      suggestion: {
        char: "/",
        command: ({ editor, range, props }) => {
          // props is the selected item from the menu
          props.command({ editor, range })
        }
      }
    }
  },

  addProseMirrorPlugins() {
    return [
      Suggestion({
        editor: this.editor,
        ...this.options.suggestion
      })
    ]
  }
})

// Suggestion renderer - creates the popup UI
export function createSlashCommandsRenderer() {
  let popup = null
  let selectedIndex = 0
  let items = []
  let currentProps = null

  return {
    onStart: (props) => {
      items = props.items
      currentProps = props
      selectedIndex = 0

      popup = document.createElement("div")
      popup.className = "slash-commands-menu"
      popup.innerHTML = renderItems(items, selectedIndex)

      // Position near the cursor
      const { view } = props.editor
      const { from } = props.range
      const coords = view.coordsAtPos(from)

      popup.style.position = "fixed"
      popup.style.left = `${coords.left}px`
      popup.style.top = `${coords.bottom + 8}px`
      popup.style.zIndex = "2147483647"
      popup.style.isolation = "isolate"

      document.body.appendChild(popup)

      // Add click handlers
      addClickHandlers(popup, items, props)
    },

    onUpdate: (props) => {
      items = props.items
      currentProps = props

      // Reset selection if items changed
      if (selectedIndex >= items.length) {
        selectedIndex = 0
      }

      if (popup) {
        popup.innerHTML = renderItems(items, selectedIndex)

        // Re-add click handlers
        addClickHandlers(popup, items, props)

        // Update position
        const { view } = props.editor
        const { from } = props.range
        const coords = view.coordsAtPos(from)
        popup.style.left = `${coords.left}px`
        popup.style.top = `${coords.bottom + 8}px`
      }
    },

    onKeyDown: (props) => {
      const { event } = props

      if (event.key === "ArrowDown") {
        event.preventDefault()
        selectedIndex = (selectedIndex + 1) % items.length
        if (popup) {
          popup.innerHTML = renderItems(items, selectedIndex)
          addClickHandlers(popup, items, currentProps)
        }
        return true
      }

      if (event.key === "ArrowUp") {
        event.preventDefault()
        selectedIndex = (selectedIndex - 1 + items.length) % items.length
        if (popup) {
          popup.innerHTML = renderItems(items, selectedIndex)
          addClickHandlers(popup, items, currentProps)
        }
        return true
      }

      if (event.key === "Enter") {
        event.preventDefault()
        const selectedItem = items[selectedIndex]
        if (selectedItem && currentProps) {
          // Call the command with full props object including editor and range
          currentProps.command({ 
            editor: currentProps.editor, 
            range: currentProps.range, 
            props: selectedItem 
          })
        }
        return true
      }

      if (event.key === "Escape") {
        if (popup) {
          popup.remove()
          popup = null
        }
        return true
      }

      return false
    },

    onExit: () => {
      if (popup) {
        popup.remove()
        popup = null
      }
      selectedIndex = 0
      currentProps = null
    }
  }
}

function addClickHandlers(popup, items, props) {
  popup.querySelectorAll(".slash-command-item").forEach((element, index) => {
    element.addEventListener("click", (e) => {
      e.preventDefault()
      e.stopPropagation()
      const selectedItem = items[index]
      if (selectedItem && props) {
        // Call the command with full props object including editor and range
        props.command({ 
          editor: props.editor, 
          range: props.range, 
          props: selectedItem 
        })
      }
    })
  })
}

function renderItems(items, selectedIndex) {
  if (items.length === 0) {
    return '<div class="slash-command-empty">No results</div>'
  }

  return items
    .map(
      (item, index) => `
      <button type="button" class="slash-command-item ${index === selectedIndex ? "is-selected" : ""}" data-index="${index}">
        <span class="slash-command-icon">${item.icon}</span>
        <div class="slash-command-content">
          <span class="slash-command-title">${item.title}</span>
          <span class="slash-command-description">${item.description}</span>
        </div>
      </button>
    `
    )
    .join("")
}

// Filter items based on query
export function filterSlashItems(query) {
  return slashCommandItems.filter((item) =>
    item.title.toLowerCase().includes(query.toLowerCase())
  )
}
