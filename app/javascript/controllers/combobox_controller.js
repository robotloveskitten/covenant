import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown", "list", "selected", "hiddenInput"]
  static values = {
    url: String,
    selected: { type: Object, default: {} },
    placeholder: { type: String, default: "Search..." }
  }

  connect() {
    this.isOpen = false
    this.results = []
    this.highlightedIndex = -1
    
    // Close dropdown when clicking outside
    this.clickOutsideHandler = (e) => {
      if (!this.element.contains(e.target)) {
        this.close()
      }
    }
    document.addEventListener("click", this.clickOutsideHandler)
  }

  disconnect() {
    document.removeEventListener("click", this.clickOutsideHandler)
  }

  toggle() {
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
    if (this.inputTarget.value.length >= 1 || this.results.length === 0) {
      this.search()
    }
  }

  close() {
    this.isOpen = false
    this.dropdownTarget.classList.add("hidden")
    this.highlightedIndex = -1
  }

  async search() {
    const query = this.inputTarget.value
    
    try {
      const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`, {
        headers: {
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
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
    if (this.results.length === 0) {
      this.listTarget.innerHTML = `
        <div class="px-3 py-2 text-sm text-base-content/50">No results found</div>
      `
      return
    }

    this.listTarget.innerHTML = this.results.map((item, index) => `
      <button type="button"
              class="w-full px-3 py-2 text-left text-sm hover:bg-base-200 flex items-center gap-2 ${index === this.highlightedIndex ? 'bg-base-200' : ''}"
              data-action="click->combobox#select"
              data-id="${item.id}"
              data-name="${this.escapeHtml(item.name)}">
        <div class="w-6 h-6 rounded-full bg-base-300 flex items-center justify-center text-xs font-medium">
          ${item.name.charAt(0).toUpperCase()}
        </div>
        <span>${this.escapeHtml(item.name)}</span>
      </button>
    `).join('')
  }

  select(event) {
    const button = event.currentTarget
    const id = button.dataset.id
    const name = button.dataset.name

    this.selectedValue = { id, name }
    this.hiddenInputTarget.value = id
    this.updateSelectedDisplay(name)
    this.close()
    this.inputTarget.value = ""
    
    // Dispatch change event for autosave
    this.hiddenInputTarget.dispatchEvent(new Event('change', { bubbles: true }))
  }

  clear(event) {
    event.stopPropagation()
    this.selectedValue = {}
    this.hiddenInputTarget.value = ""
    this.updateSelectedDisplay(null)
    
    // Dispatch change event for autosave
    this.hiddenInputTarget.dispatchEvent(new Event('change', { bubbles: true }))
  }

  updateSelectedDisplay(name) {
    if (name) {
      this.selectedTarget.innerHTML = `
        <div class="flex items-center gap-2">
          <div class="w-6 h-6 rounded-full bg-base-300 flex items-center justify-center text-xs font-medium">
            ${name.charAt(0).toUpperCase()}
          </div>
          <span class="text-sm">${this.escapeHtml(name)}</span>
          <button type="button" data-action="click->combobox#clear" class="ml-auto text-base-content/40 hover:text-base-content">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
          </button>
        </div>
      `
    } else {
      this.selectedTarget.innerHTML = `
        <span class="text-sm text-base-content/40">${this.placeholderValue}</span>
      `
    }
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
        if (this.highlightedIndex >= 0 && this.results[this.highlightedIndex]) {
          this.selectHighlighted()
        }
        break
      case "Escape":
        this.close()
        break
    }
  }

  highlightNext() {
    if (this.highlightedIndex < this.results.length - 1) {
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
    const item = this.results[this.highlightedIndex]
    if (item) {
      this.selectedValue = { id: item.id, name: item.name }
      this.hiddenInputTarget.value = item.id
      this.updateSelectedDisplay(item.name)
      this.close()
      this.inputTarget.value = ""
      this.hiddenInputTarget.dispatchEvent(new Event('change', { bubbles: true }))
    }
  }

  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }
}
