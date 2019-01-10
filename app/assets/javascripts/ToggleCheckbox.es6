document.addEventListener('turbolinks:load', function() {
  const ToggleCheckbox = (() => {
    const state = {
        inputs: null,
        samplings: null,
        selections: []
    }

    // CacheDom
    const standards       = document.querySelectorAll('.standard')
    const toggle_checkbox = document.querySelector('.toggle_checkbox')

    // Bind Events
    if (toggle_checkbox) {
      toggle_checkbox.addEventListener('change', toggleAllCheckboxes)
    }

    standards.forEach(function(standard){
      standard.addEventListener('change', toggleOneCheckbox)
    })

    function init(){
      state.inputs      = document.querySelectorAll('.standard')
      state.samplings   = document.querySelectorAll('ul[class$="_samplings"]')
      state.selections  = [].slice.call(state.inputs).map(input => true)

      Observer.subscribe(render)
    }

    function toggleOneCheckbox(e){
      const css_class = e.target.dataset.target
      const nodesArray = [].slice.call(state.inputs)
      const index = nodesArray.map(input => input.dataset.target).indexOf(css_class);

      state.selections[index] = !state.selections[index]

      Observer.notifyAll()
    }

    function toggleAllCheckboxes(e) {
      const value = e.target.checked
      state.selections = state.selections.map(sel => value)

      state.inputs.forEach(function(check){
        check.checked = value
      })

      Observer.notifyAll()
    }

    function render() {
      const count = state.selections.filter(sel => sel).length

      if (count) {
        state.samplings.forEach(function(target){
          target.querySelector('li.no_standards').classList.add('hide')
        })

      } else {
        state.samplings.forEach(function(target){
          target.querySelector('li.no_standards').classList.remove('hide')
        })
      }

      state.inputs.forEach(function(select, index){
        const dataset = select.dataset.target

        state.samplings.forEach(function(sampling) {
          const li = sampling.querySelector(`li.${dataset}`)
          const input = li.querySelector('input')

          if (state.selections[index]) {
            li.classList.remove('hide')
            input.removeAttribute('disabled')
          } else {
            li.classList.add('hide')
            input.setAttribute('disabled', true)
          }

        })
      })

    }

    return {
        init, state
      }
  })()

  ToggleCheckbox.init()
})
