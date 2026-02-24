// app/javascript/controllers/flash_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { duration: Number }

  connect() {
    const duration = this.hasDurationValue ? this.durationValue : 4000
    this.autoHide(duration)
  }

  autoHide(duration) {
    // fade out after duration
    setTimeout(() => {
      this.element.classList.add("animate-fade-out")
    }, duration)

    // remove element after fade animation
    setTimeout(() => {
      this.element.remove()
    }, duration + 1000)
  }

  close() {
    this.element.remove()
  }
}
