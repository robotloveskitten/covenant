import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown", "list", "selectedContainer", "hiddenInputs"]
  static values = {
    url: String,
    createUrl: String,
    taskUrl: String,
    selected: { type: Array, default: [] },
    colors: { type: Array, default: [] },
    placeholder: { type: String, default: "Add tags..." }
  }

  connect() {
    this.isOpen = false
    this.results = []
    this.highlightedIndex = -1
    this.editingTag = null
    this.currentEditPopover = null

    this.clickOutsideHandler = (e) => {
      if (!this.element.contains(e.target)) {
        this.close()
        this.closeEditPopover()
      }
    }
    document.addEventListener("click", this.clickOutsideHandler)
  }

  disconnect() {
    document.removeEventListener("click", this.clickOutsideHandler)
  }

  toggle(event) {
    // Don't toggle if clicking on a tag badge (for edit)
    if (event.target.closest('[data-tag-id]')) return

    if (this.isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.isOpen = true
    this.dropdownTarget.classList.remove("hidden")
    this.inputTarget.focus()
    this.search()
  }

  close() {
    this.isOpen = false
    this.dropdownTarget.classList.add("hidden")
    this.highlightedIndex = -1
    this.inputTarget.value = ""
  }

  async search() {
    const query = this.inputTarget.value.trim()

    try {
      const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`, {
        headers: {
          "Accept": "application/json",
          "X-CSRF-Token": this.csrfToken
        }
      })

      if (response.ok) {
        this.results = await response.json()
        this.renderResults()
      }
    } catch (error) {
      console.error("Search error:", error)
    }
  }

  renderResults() {
    const query = this.inputTarget.value.trim()

    // Filter out already-selected tags
    const available = this.results.filter(t => !this.isSelected(t.id))

    let html = available.map((tag, index) => `
      <button type="button"
              class="w-full px-3 py-2 text-left text-sm hover:bg-base-200 flex items-center gap-2 ${index === this.highlightedIndex ? 'bg-base-200' : ''}"
              data-action="click->tag-combobox#selectTag"
              data-id="${tag.id}"
              data-name="${this.escapeHtml(tag.name)}"
              data-color="${tag.color}">
        <span class="w-3 h-3 rounded-full flex-shrink-0" style="background-color: ${tag.color}"></span>
        <span>${this.escapeHtml(tag.name)}</span>
      </button>
    `).join('')

    // Show "Create new" option if query doesn't exactly match existing tag
    if (query && !this.results.some(t => t.name.toLowerCase() === query.toLowerCase())) {
      const createIndex = available.length
      html += `
        <button type="button"
                class="w-full px-3 py-2 text-left text-sm hover:bg-base-200 flex items-center gap-2 text-primary ${createIndex === this.highlightedIndex ? 'bg-base-200' : ''}"
                data-action="click->tag-combobox#createTag"
                data-name="${this.escapeHtml(query)}">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd" />
          </svg>
          Create "${this.escapeHtml(query)}"
        </button>
      `
    }

    if (!html) {
      html = '<div class="px-3 py-2 text-sm text-base-content/50">Type to search or create tags...</div>'
    }

    this.listTarget.innerHTML = html
  }

  selectTag(event) {
    const { id, name, color } = event.currentTarget.dataset
    this.addTag({ id: parseInt(id), name, color })
  }

  addTag(tag) {
    if (this.isSelected(tag.id)) return
    this.selectedValue = [...this.selectedValue, tag]
    this.renderSelected()
    this.updateHiddenInputs()
    this.saveTagsToTask()
    this.inputTarget.value = ""
    this.search()
  }

  removeTag(event) {
    event.stopPropagation()
    const id = parseInt(event.currentTarget.dataset.id)
    this.selectedValue = this.selectedValue.filter(t => t.id !== id)
    this.renderSelected()
    this.updateHiddenInputs()
    this.saveTagsToTask()
  }

  isSelected(id) {
    return this.selectedValue.some(t => t.id === parseInt(id))
  }

  async createTag(event) {
    const name = event.currentTarget.dataset.name

    try {
      const response = await fetch(this.createUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken,
          "Accept": "application/json"
        },
        body: JSON.stringify({ tag: { name } })
      })

      if (response.ok) {
        const tag = await response.json()
        this.addTag(tag)
      } else {
        const error = await response.json()
        console.error("Create tag error:", error)
      }
    } catch (error) {
      console.error("Create tag error:", error)
    }
  }

  openEditPopover(event) {
    event.stopPropagation()
    const tagElement = event.currentTarget
    const tagId = parseInt(tagElement.dataset.tagId)
    const tag = this.selectedValue.find(t => t.id === tagId)

    if (!tag) return

    this.renderEditPopover(tag, tagElement)
  }

  renderEditPopover(tag, anchor) {
    // Remove any existing popover (but don't reset editingTag yet)
    if (this.currentEditPopover) {
      this.currentEditPopover.remove()
      this.currentEditPopover = null
    }

    // Set the editing tag
    this.editingTag = tag

    const rect = anchor.getBoundingClientRect()
    const containerRect = this.element.getBoundingClientRect()

    const popover = document.createElement('div')
    popover.className = 'absolute bg-base-100 border border-base-200 rounded-lg shadow-lg z-50 p-3 w-64'
    popover.style.left = `${rect.left - containerRect.left}px`
    popover.style.top = `${rect.bottom - containerRect.top + 4}px`
    popover.innerHTML = `
      <div class="space-y-3">
        <div>
          <label class="text-xs text-base-content/50 block mb-1">Name</label>
          <input type="text"
                 value="${this.escapeHtml(tag.name)}"
                 class="input input-sm input-bordered w-full"
                 data-edit-name>
        </div>
        <div>
          <label class="text-xs text-base-content/50 block mb-1">Color</label>
          <div class="flex gap-1 flex-wrap" data-color-buttons></div>
        </div>
        <div class="flex gap-2 pt-2 border-t border-base-200">
          <button type="button"
                  class="btn btn-sm btn-primary flex-1"
                  data-save-btn>
            Save
          </button>
          <button type="button"
                  class="btn btn-sm btn-ghost btn-error"
                  data-delete-btn>
            Delete
          </button>
        </div>
      </div>
    `

    this.element.appendChild(popover)
    this.currentEditPopover = popover

    // Store selected color for editing
    this.editingColor = tag.color

    // Add color buttons with click handlers
    const colorContainer = popover.querySelector('[data-color-buttons]')
    this.colorsValue.forEach(color => {
      const btn = document.createElement('button')
      btn.type = 'button'
      btn.className = `w-6 h-6 rounded-full border-2 ${color === tag.color ? 'border-base-content' : 'border-transparent'} hover:scale-110 transition-transform`
      btn.style.backgroundColor = color
      btn.dataset.color = color
      btn.addEventListener('click', (e) => {
        e.stopPropagation()
        this.handleColorSelect(color)
      })
      colorContainer.appendChild(btn)
    })

    // Add save button handler
    popover.querySelector('[data-save-btn]').addEventListener('click', (e) => {
      e.stopPropagation()
      this.saveTagEdit()
    })

    // Add delete button handler
    popover.querySelector('[data-delete-btn]').addEventListener('click', (e) => {
      e.stopPropagation()
      this.handleDeleteTag(tag.id)
    })

    // Focus the name input
    popover.querySelector('[data-edit-name]').focus()
  }

  closeEditPopover() {
    if (this.currentEditPopover) {
      this.currentEditPopover.remove()
      this.currentEditPopover = null
    }
    this.editingTag = null
    this.editingColor = null
  }

  handleColorSelect(color) {
    this.editingColor = color

    // Update visual selection
    if (this.currentEditPopover) {
      this.currentEditPopover.querySelectorAll('[data-color]').forEach(btn => {
        if (btn.dataset.color === color) {
          btn.classList.add('border-base-content')
          btn.classList.remove('border-transparent')
        } else {
          btn.classList.remove('border-base-content')
          btn.classList.add('border-transparent')
        }
      })
    }
  }

  async saveTagEdit() {
    if (!this.editingTag || !this.currentEditPopover) return

    const nameInput = this.currentEditPopover.querySelector('[data-edit-name]')
    const newName = nameInput.value.trim()
    const newColor = this.editingColor

    if (!newName) return

    try {
      const response = await fetch(`/tags/${this.editingTag.id}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken,
          "Accept": "application/json"
        },
        body: JSON.stringify({ tag: { name: newName, color: newColor } })
      })

      if (response.ok) {
        const updatedTag = await response.json()

        // Update in selected array
        this.selectedValue = this.selectedValue.map(t =>
          t.id === updatedTag.id ? updatedTag : t
        )

        this.renderSelected()
        this.closeEditPopover()
      } else {
        const error = await response.json()
        console.error("Update tag error:", error)
      }
    } catch (error) {
      console.error("Update tag error:", error)
    }
  }

  async handleDeleteTag(id) {
    try {
      const response = await fetch(`/tags/${id}`, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": this.csrfToken,
          "Accept": "application/json"
        }
      })

      if (response.ok) {
        this.selectedValue = this.selectedValue.filter(t => t.id !== id)
        this.renderSelected()
        this.updateHiddenInputs()
        this.saveTagsToTask()
        this.closeEditPopover()
      } else {
        const error = await response.json()
        alert(error.error || "Cannot delete tag")
      }
    } catch (error) {
      console.error("Delete tag error:", error)
    }
  }

  updateHiddenInputs() {
    // Clear existing hidden inputs except the empty one
    const inputs = this.hiddenInputsTarget.querySelectorAll('input[value]')
    inputs.forEach(input => {
      if (input.value) input.remove()
    })

    // Add new hidden inputs for each selected tag
    this.selectedValue.forEach(tag => {
      const input = document.createElement('input')
      input.type = 'hidden'
      input.name = 'task[tag_ids][]'
      input.value = tag.id
      this.hiddenInputsTarget.appendChild(input)
    })
  }

  async saveTagsToTask() {
    if (!this.taskUrlValue) return

    const formData = new FormData()
    // Add empty value first to ensure array is sent even when empty
    formData.append('task[tag_ids][]', '')
    // Add all selected tag IDs
    this.selectedValue.forEach(tag => {
      formData.append('task[tag_ids][]', tag.id)
    })

    try {
      const response = await fetch(this.taskUrlValue, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": this.csrfToken,
          "Accept": "application/json"
        },
        body: formData
      })

      if (response.ok) {
        console.log("Tags saved")
      } else {
        console.error("Failed to save tags")
      }
    } catch (error) {
      console.error("Error saving tags:", error)
    }
  }

  renderSelected() {
    if (this.selectedValue.length === 0) {
      this.selectedContainerTarget.innerHTML = ''
      return
    }

    this.selectedContainerTarget.innerHTML = this.selectedValue.map(tag => `
      <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-xs cursor-pointer hover:opacity-80"
            style="background-color: ${tag.color}20; color: ${tag.color}"
            data-action="click->tag-combobox#openEditPopover"
            data-tag-id="${tag.id}">
        ${this.escapeHtml(tag.name)}
        <button type="button"
                class="hover:opacity-60"
                data-action="click->tag-combobox#removeTag"
                data-id="${tag.id}">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </button>
      </span>
    `).join('')
  }

  onKeydown(event) {
    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.highlightNext()
        break
      case "ArrowUp":
        event.preventDefault()
        this.highlightPrevious()
        break
      case "Enter":
        event.preventDefault()
        this.selectHighlighted()
        break
      case "Escape":
        this.close()
        break
    }
  }

  highlightNext() {
    const available = this.results.filter(t => !this.isSelected(t.id))
    const query = this.inputTarget.value.trim()
    const hasCreate = query && !this.results.some(t => t.name.toLowerCase() === query.toLowerCase())
    const maxIndex = available.length + (hasCreate ? 1 : 0) - 1

    if (this.highlightedIndex < maxIndex) {
      this.highlightedIndex++
      this.renderResults()
    }
  }

  highlightPrevious() {
    if (this.highlightedIndex > 0) {
      this.highlightedIndex--
      this.renderResults()
    }
  }

  selectHighlighted() {
    const available = this.results.filter(t => !this.isSelected(t.id))
    const query = this.inputTarget.value.trim()
    const hasCreate = query && !this.results.some(t => t.name.toLowerCase() === query.toLowerCase())

    if (this.highlightedIndex >= 0 && this.highlightedIndex < available.length) {
      const tag = available[this.highlightedIndex]
      this.addTag(tag)
    } else if (hasCreate && this.highlightedIndex === available.length) {
      // Create new tag
      this.createTagFromInput()
    }
  }

  async createTagFromInput() {
    const name = this.inputTarget.value.trim()
    if (!name) return

    try {
      const response = await fetch(this.createUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken,
          "Accept": "application/json"
        },
        body: JSON.stringify({ tag: { name } })
      })

      if (response.ok) {
        const tag = await response.json()
        this.addTag(tag)
      }
    } catch (error) {
      console.error("Create tag error:", error)
    }
  }

  get csrfToken() {
    return document.querySelector('meta[name="csrf-token"]').content
  }

  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }
}
