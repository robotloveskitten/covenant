import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["documentView", "kanbanView", "documentBtn", "kanbanBtn"]

  connect() {
    // Default to document view
    this.showDocument()
  }

  showDocument() {
    this.documentViewTarget.classList.remove("hidden")
    this.kanbanViewTarget.classList.add("hidden")
    this.documentBtnTarget.classList.add("btn-active")
    this.kanbanBtnTarget.classList.remove("btn-active")
  }

  showKanban() {
    this.documentViewTarget.classList.add("hidden")
    this.kanbanViewTarget.classList.remove("hidden")
    this.documentBtnTarget.classList.remove("btn-active")
    this.kanbanBtnTarget.classList.add("btn-active")
  }
}
