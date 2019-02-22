document.addEventListener('turbolinks:load', function() {
  "use strict";

  const SystemSize = (() => {

    //State
    const state = {
      sizes: [],
      current_module: 0
    }

    // CacheDom
    const plus = document.querySelector('.system_size__plus')

    // Event Binding
    plus ? plus.addEventListener('click', add_size) : null
    document.addEventListener('focusout', function (event) {

      if (event.target.matches('.size__input')) {
        get_sizes()
        echo_sizes()
      }

    }, false);

    document.addEventListener('click', function (event) {

      if (event.target.matches('span.size__delete')) {
        const sizes = document.querySelector('.system_size__elements')
        const elem = event.target.parentNode.parentNode
        sizes.removeChild(elem)
        state.current_module--
        reset_numbers()
        get_sizes()
        echo_sizes()
      }

    }, false);

    function eventBinding() {
    }

    // Functions
    function init() {
      const li = document.querySelector('li.system_size__size')
      if (!li) { return }
      eventBinding()
      get_sizes()
    }

    function get_sizes() {
      state.sizes = []
      const sizes = document.querySelectorAll('li.system_size__size')
      sizes.forEach((size) => {
        const size_input = size.querySelector('.size__input')
        const value = parseInt(size_input.value)
        if (value >= 0 ) {
          state.sizes.push(value)
        }
      })
      state.current_module = state.sizes.length || 1
    }

    function echo_sizes() {
      const hidden_input = document.querySelector('#plant_system_size')
      hidden_input.value = state.sizes.join(' ')

      const input_val = document.querySelector('#plant_system_size_total')
      input_val.value = state.sizes.reduce((acc, num) => acc + num)
    }

    function add_size(e) {
      e.preventDefault()
      const size = document.querySelector('.system_size__elements')

      // Li
      const mainNode = document.createElement('li')
      mainNode.className = 'system_size__size'

      // h3
      const _h3 = document.createElement('h3')
      const _h3_text = document.createTextNode('Module #')
      _h3.appendChild(_h3_text)

      // span.size__number
      const _size__number = document.createElement('span')
      _size__number.className = 'size__number'
      const _size__number_text = document.createTextNode(`${++state.current_module}`)
      _size__number.appendChild(_size__number_text)
      _h3.appendChild(_size__number)

      // span.delete
      const _delete = document.createElement('span')
      _delete.className = 'size__delete'
      const _delete_text = document.createTextNode('Delete')
      _delete.appendChild(_delete_text)
      _h3.appendChild(_delete)

      // input.size__input
      const _input = document.createElement('input')
      _input.className = 'size__input'
      _input.setAttribute('type', 'text')
      _input.setAttribute('name', 'size__quantity')
      _input.setAttribute('placeholder', '0')
      _input.setAttribute('data-module', 'text')
      _input.dataset.module = `${state.current_module}`

      // Append nodes
      mainNode.appendChild(_h3)
      mainNode.appendChild(_input)
      size.appendChild(mainNode)
    }

    function reset_numbers() {
      const sizes = document.querySelectorAll('.system_size__size')
      sizes.forEach(function(val, index) {
        const number = ++index
        val.firstElementChild.firstElementChild.innerText = number
      })
    }

    return {
      init, state
    }
  })()

  SystemSize.init()
})
