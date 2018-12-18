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
    toggle_checkbox.addEventListener('change', function(e){
      const checkbox_value = e.target.checked
      state.checks.forEach(function(check){
        // console.log(check)
        check.checked = checkbox_value
      })
    })

  }

  return {
    init, state
  }
})()

document.addEventListener('turbolinks:load', ToggleCheckbox.init)
