import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["entries", "abstract"]
  static values = { container: String }

  connect() {
    // Use requestAnimationFrame to ensure DOM is ready
    requestAnimationFrame(() => {
      this.buildTableOfContents()
      this.setupScrollTracking()
      this.setupHoverBehavior()
    })
  }

  disconnect() {
    if (this.scrollHandler) {
      window.removeEventListener("scroll", this.scrollHandler)
    }
  }

  buildTableOfContents() {
    console.log("Building ToC, looking for:", this.containerValue)
    const container = document.querySelector(this.containerValue)
    console.log("Container found:", container)

    if (!container) {
      console.log("Container not found!")
      return
    }

    // Find all headings in the content
    const headings = container.querySelectorAll("h1, h2, h3, h4, h5, h6")
    console.log("Headings found:", headings.length)

    if (headings.length === 0) {
      console.log("No headings found, hiding ToC")
      this.element.style.display = "none"
      return
    }

    this.element.style.display = "block"
    this.headings = Array.from(headings)

    // Build the entries list
    this.buildEntries()

    // Build the abstract bars
    this.buildAbstract()

    console.log("ToC built successfully")
  }

  buildEntries() {
    this.entriesTarget.innerHTML = ""

    this.headings.forEach((heading, index) => {
      // Ensure heading has an ID for anchor linking
      if (!heading.id) {
        heading.id = `heading-${index}`
      }

      const level = parseInt(heading.tagName.substring(1)) - 1 // h1 = level 0, h2 = level 1, etc.
      const text = heading.textContent.trim()

      const li = document.createElement("li")
      li.className = `toc-entry toc-entry-level-${level}`
      li.dataset.headingId = heading.id
      li.dataset.index = index

      const link = document.createElement("a")
      link.href = `#${heading.id}`
      link.textContent = text
      link.className = `block px-3 py-1.5 text-sm hover:bg-base-200 rounded transition-colors ${level > 0 ? `ml-${level * 4}` : ""}`

      link.addEventListener("click", (e) => {
        e.preventDefault()
        this.scrollToHeading(heading)
      })

      li.appendChild(link)
      this.entriesTarget.appendChild(li)
    })
  }

  buildAbstract() {
    this.abstractTarget.innerHTML = ""

    this.headings.forEach((heading, index) => {
      const level = parseInt(heading.tagName.substring(1)) - 1

      const li = document.createElement("li")
      li.className = `toc-abstract-entry toc-abstract-entry-level-${level}`
      li.dataset.index = index

      const bar = document.createElement("div")
      bar.className = "h-1 bg-base-300 rounded-full transition-colors"

      // Different widths based on level
      const widths = ["w-full", "w-3/4", "w-1/2"]
      bar.classList.add(widths[Math.min(level, widths.length - 1)])

      li.appendChild(bar)
      this.abstractTarget.appendChild(li)
    })
  }

  setupScrollTracking() {
    this.scrollHandler = this.throttle(() => {
      this.updateCurrentSection()
    }, 100)

    window.addEventListener("scroll", this.scrollHandler)
    this.updateCurrentSection()
  }

  updateCurrentSection() {
    if (!this.headings || this.headings.length === 0) return

    const scrollPosition = window.scrollY + 100 // Offset for better UX

    let currentIndex = 0
    for (let i = this.headings.length - 1; i >= 0; i--) {
      if (this.headings[i].offsetTop <= scrollPosition) {
        currentIndex = i
        break
      }
    }

    // Update entries
    this.entriesTarget.querySelectorAll(".toc-entry").forEach((entry, index) => {
      if (index === currentIndex) {
        entry.classList.add("toc-entry-current")
        entry.querySelector("a").classList.add("font-semibold", "text-primary")
      } else {
        entry.classList.remove("toc-entry-current")
        entry.querySelector("a").classList.remove("font-semibold", "text-primary")
      }
    })

    // Update abstract
    this.abstractTarget.querySelectorAll(".toc-abstract-entry").forEach((entry, index) => {
      const bar = entry.querySelector("div")
      if (index === currentIndex) {
        bar.classList.remove("bg-base-300")
        bar.classList.add("bg-primary")
      } else {
        bar.classList.remove("bg-primary")
        bar.classList.add("bg-base-300")
      }
    })
  }

  setupHoverBehavior() {
    let hoverTimeout

    this.element.addEventListener("mouseenter", () => {
      clearTimeout(hoverTimeout)
      this.expand()
    })

    this.element.addEventListener("mouseleave", () => {
      hoverTimeout = setTimeout(() => {
        this.collapse()
      }, 300)
    })
  }

  expand() {
    this.entriesTarget.classList.remove("hidden")
    this.abstractTarget.classList.add("hidden")
  }

  collapse() {
    this.entriesTarget.classList.add("hidden")
    this.abstractTarget.classList.remove("hidden")
  }

  scrollToHeading(heading) {
    const offset = 80 // Account for fixed headers
    const top = heading.offsetTop - offset

    window.scrollTo({
      top: top,
      behavior: "smooth"
    })
  }

  // Utility: throttle function
  throttle(func, delay) {
    let timeoutId
    let lastRan
    return function (...args) {
      if (!lastRan) {
        func.apply(this, args)
        lastRan = Date.now()
      } else {
        clearTimeout(timeoutId)
        timeoutId = setTimeout(() => {
          if (Date.now() - lastRan >= delay) {
            func.apply(this, args)
            lastRan = Date.now()
          }
        }, delay - (Date.now() - lastRan))
      }
    }
  }
}
