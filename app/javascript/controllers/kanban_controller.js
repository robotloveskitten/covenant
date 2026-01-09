import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["column", "list", "card"]
  static values = {
    taskId: Number
  }

  connect() {
    this.initDragAndDrop()
  }

  initDragAndDrop() {
    this.cardTargets.forEach(card => {
      card.setAttribute("draggable", "true")
      card.addEventListener("dragstart", this.handleDragStart.bind(this))
      card.addEventListener("dragend", this.handleDragEnd.bind(this))
    })

    this.listTargets.forEach(list => {
      list.addEventListener("dragover", this.handleDragOver.bind(this))
      list.addEventListener("drop", this.handleDrop.bind(this))
      list.addEventListener("dragenter", this.handleDragEnter.bind(this))
      list.addEventListener("dragleave", this.handleDragLeave.bind(this))
    })
  }

  handleDragStart(event) {
    event.dataTransfer.setData("text/plain", event.target.dataset.id)
    event.target.classList.add("opacity-50")
    this.draggedCard = event.target
  }

  handleDragEnd(event) {
    event.target.classList.remove("opacity-50")
    this.listTargets.forEach(list => {
      list.classList.remove("bg-base-200/50")
    })
  }

  handleDragOver(event) {
    event.preventDefault()
  }

  handleDragEnter(event) {
    event.target.closest("[data-kanban-target='list']")?.classList.add("bg-base-200/50")
  }

  handleDragLeave(event) {
    const list = event.target.closest("[data-kanban-target='list']")
    if (list && !list.contains(event.relatedTarget)) {
      list.classList.remove("bg-base-200/50")
    }
  }

  async handleDrop(event) {
    event.preventDefault()
    const cardId = event.dataTransfer.getData("text/plain")
    const list = event.target.closest("[data-kanban-target='list']")
    const newStatus = list?.dataset.status

    if (this.draggedCard && list && newStatus) {
      list.appendChild(this.draggedCard)
      list.classList.remove("bg-base-200/50")

      // Update task status via API
      try {
        const response = await fetch(`/tasks/${cardId}`, {
          method: "PATCH",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
            "Accept": "application/json"
          },
          body: JSON.stringify({
            task: { status: newStatus }
          })
        })

        if (!response.ok) {
          console.error("Failed to update task status")
        }
      } catch (error) {
        console.error("Error updating task:", error)
      }
    }
  }
}
