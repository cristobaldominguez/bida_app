const ToggleCheckbox = (function(){
  const state = {
    checks: null
  }

  function init(){
    state.checks = document.querySelectorAll('.active')
    domManipulation()
  }

  function domManipulation() {
    const toggle_checkbox = document.querySelector('.toggle_checkbox')

    if(!toggle_checkbox){return 0}

    toggle_checkbox.addEventListener('change', function(e){
      const checkbox_value = e.target.checked

      state.checks.forEach(function(check){
        check.checked = checkbox_value
      })

    })
  }

  return {
    init, state
  }
})()

document.addEventListener('turbolinks:load', ToggleCheckbox.init)
