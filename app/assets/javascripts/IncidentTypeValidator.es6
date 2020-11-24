document.addEventListener('turbolinks:load', () => {

  const IncidentTypeValidator = (() => {

    const state = {
      inputs: [],
      empty_fields: true
    }

    // DOMCache
    const form = document.querySelector('.incident_type_form')
    if (form) {
      const inputs = form.querySelectorAll('input[type="text"][name^="incident_type"]')
      state.inputs = Array.from(form.querySelectorAll('[data-required="true"]'))

      inputs.forEach(input => input.addEventListener('blur', inputBlur))
      inputs.forEach(input => input.addEventListener('keyup', inputChange))
      form.addEventListener('submit', fieldsValidation)
    }

    function init() {
    }

    function inputChange(e) {
      state.empty_fields = state.inputs.some(input => input.value.length < 1)

      if (e.target.value.length > 0) {
        e.target.parentNode.querySelector('span.step__error') && removeMessage(e.target)
      } else {
        renderMessage(e.target)
      }
    }

    function inputBlur(e) {
      if (e.target.value.length < 1) {
        renderMessage(e.target)
      }
    }

    function fieldsValidation(e) {
      e.preventDefault()

      if(state.empty_fields) {
        renderMessages()
        return
      }

      // form.submit()
    }

    function HTMLMessage(message) {
      const span = document.createElement('span')
      span.className = 'step__error'
      span.innerText = message
      return span
    }

    function removeMessage(field) {
      const remove_span = field.parentNode.querySelector('span.step__error')
      remove_span && field.parentNode.removeChild(remove_span) && field.classList.remove('error')
    }

    function renderMessage(field) {
      const message = HTMLMessage(field.dataset.error)
      removeMessage(field)

      field.classList.add('error')
      field.parentNode.appendChild(message)
    }

    function renderMessages() {
      const filtered_fields = state.inputs.filter(field => field.value.length < 1)

      filtered_fields.map(field => renderMessage(field))
    }

    return { init }
  })()

  const incident_type_form = document.querySelector('form.incident_type_form')
  if (incident_type_form) {
    IncidentTypeValidator.init()
  }
})
