import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["documentView", "kanbanView", "documentBtn", "kanbanBtn"]

  connect() {
    // Read view state from URL, default to document
    const params = new URLSearchParams(window.location.search)
    const view = params.get("view")
    
    if (view === "kanban") {
      this.showKanban({ updateUrl: false })
    } else {
      this.showDocument({ updateUrl: false })
    }
  }

  showDocument({ updateUrl = true } = {}) {
    this.documentViewTarget.classList.remove("hidden")
    this.kanbanViewTarget.classList.add("hidden")
    this.documentBtnTarget.classList.add("btn-active")
    this.kanbanBtnTarget.classList.remove("btn-active")
    
    if (updateUrl) {
      this.updateUrl("document")
    }
  }

  showKanban({ updateUrl = true } = {}) {
    this.documentViewTarget.classList.add("hidden")
    this.kanbanViewTarget.classList.remove("hidden")
    this.documentBtnTarget.classList.remove("btn-active")
    this.kanbanBtnTarget.classList.add("btn-active")
    
    if (updateUrl) {
      this.updateUrl("kanban")
    }
  }

  updateUrl(view) {
    const url = new URL(window.location)
    
    if (view === "document") {
      // Remove the view param for document (it's the default)
      url.searchParams.delete("view")
    } else {
      url.searchParams.set("view", view)
    }
    
    // Use replaceState to update URL without adding to history
    window.history.replaceState({}, "", url)
  }
}
