import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  static values = {
    url: String,
    delay: { type: Number, default: 1000 }
  }

  connect() {
    this.timeout = null
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  save() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    this.timeout = setTimeout(() => {
      this.performSave()
    }, this.delayValue)
  }

  async performSave() {
    if (!this.urlValue) return

    const formData = new FormData()
    this.inputTargets.forEach(input => {
      formData.append(input.name, input.value)
    })

    try {
      const response = await fetch(this.urlValue, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          "Accept": "application/json"
        },
        body: formData
      })

      if (!response.ok) {
        console.error("Autosave failed")
      }
    } catch (error) {
      console.error("Autosave error:", error)
    }
  }
}
