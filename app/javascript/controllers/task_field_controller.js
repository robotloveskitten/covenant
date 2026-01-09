import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String
  }

  connect() {
    // Listen for change events on inputs within this controller
    this.element.addEventListener("change", this.handleChange.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("change", this.handleChange.bind(this))
  }

  async handleChange(event) {
    const input = event.target
    if (!input.name) return

    const formData = new FormData()
    formData.append(input.name, input.value || "")

    try {
      const response = await fetch(this.urlValue, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Accept": "application/json"
        },
        body: formData
      })

      if (response.ok) {
        // Show brief success indicator
        this.showSaved()
      } else {
        console.error("Failed to save field")
        this.showError()
      }
    } catch (error) {
      console.error("Error saving field:", error)
      this.showError()
    }
  }

  showSaved() {
    // Could add a toast notification here
    console.log("Field saved")
  }

  showError() {
    // Could add error handling here
    console.error("Failed to save field")
  }
}
