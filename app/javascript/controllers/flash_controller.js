import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    this.showMessages()
  }

  showMessages() {
    this.messageTargets.forEach((msg) => {
      setTimeout(() => {
        msg.classList.add("opacity-100")
      }, 50)

      setTimeout(() => {
        this.closeMessage(msg)
      }, 4000)
    })
  }

  close(event) {
    let msg = event.currentTarget.closest(".flash-message")
    this.closeMessage(msg)
  }

  closeMessage(msg) {
    if (!msg) return
    msg.classList.remove("opacity-100")
    msg.classList.add("opacity-0")
    setTimeout(() => msg.remove(), 500)
  }
}
