import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "input", "minSalary", "maxSalary", "minSalaryLabel", "maxSalaryLabel"]

  connect() {
    this.timeout = null
  }

  debounce() {
    clearTimeout(this.timeout)

    const cursorPos = this.inputTarget.selectionStart

    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
      this.inputTarget.focus()
      this.inputTarget.setSelectionRange(cursorPos, cursorPos)
    }, 300)
  }

  updateSliderLabels() {
    this.minSalaryLabelTarget.textContent = this.minSalaryTarget.value
    this.maxSalaryLabelTarget.textContent = this.maxSalaryTarget.value
    this.debounce()
  }

  resetFilters() {
    this.inputTarget.value = ""
    this.minSalaryTarget.value = 0
    this.maxSalaryTarget.value = 0
    this.updateSliderLabels()
  }
}
