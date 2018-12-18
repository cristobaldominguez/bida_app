const IsRange = (() => {

  //State
  const state = {
    checks: null
  }

  function init() {
    state.checks = document.querySelectorAll('.check')
    check_events()
  }

  function check_events() {
    state.checks.forEach(function(checkbox){
      checkbox.addEventListener('change', (event) => {

        const parent      = event.target.parentNode.parentNode
        const in_from     = parent.querySelector('.in_from')
        const in_to       = parent.querySelector('.in_to')
        const out_from    = parent.querySelector('.out_from')
        const out_to      = parent.querySelector('.out_to')
        const col_spans   = parent.querySelectorAll('.col_span')
        const cols_hidden  = parent.querySelectorAll('.hidden')

        if (event.target.checked) {

          console.log(col_spans)

          col_spans.forEach(function(col_span){
            col_span.removeAttribute('colspan')
          })

          cols_hidden.forEach(function(col_hidden){
            col_hidden.classList.remove('hide')
          })

          in_from.setAttribute('placeholder', 'From')
          in_to.setAttribute('placeholder', 'To')

          out_from.setAttribute('placeholder', 'From')
          out_to.setAttribute('placeholder', 'To')

        } else {

          col_spans.forEach(function(col_span){
            col_span.setAttribute('colspan', '2')
          })

          cols_hidden.forEach(function(col_hidden){
            col_hidden.classList.add('hide')
          })

          in_from.setAttribute('placeholder', 'Number')
          out_from.setAttribute('placeholder', 'Number')
        }
      })
    })
  }

  return {
    init, state
  }
})()

document.addEventListener('turbolinks:load', IsRange.init)
