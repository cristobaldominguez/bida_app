document.addEventListener('turbolinks:load', function() {
  "use strict";

  const SystemSize = (() => {

    //State
    const state = {
      sizes: [],
      current_module: 1
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

    document.addEventListener('click', function(event) {

      if (event.target.matches('.system_size__delete')) {
        const sizes = document.querySelector('.system_size__elements')
        const elem = event.target.parentNode.parentNode
        sizes.removeChild(elem)
        state.current_module--
        reset_numbers()
        get_sizes()
        echo_sizes()
      }

    }, false);

    function eventBinding() {}

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

      const input_val = document.querySelector('#plant_plant_system_size_total')
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

      // div.delete
      const _delete_div = document.createElement('div')
      _delete_div.className = 'system_size__delete_div'
      const _delete_link = document.createElement('a')
      _delete_link.className = 'system_size__delete'
      const _delete_text = document.createTextNode('x')
      _delete_link.appendChild(_delete_text)
      _delete_div.appendChild(_delete_link)
      mainNode.appendChild(_delete_div)

      // div.field__value
      const _div_input = document.createElement('div')
      _div_input.className = 'field__value'

      // input.size__input
      const _input = document.createElement('input')
      _input.className = 'size__input'
      _input.classList.add('field__value-input')
      _input.setAttribute('type', 'text')
      _input.setAttribute('name', 'size__quantity')
      _input.setAttribute('placeholder', '0')
      _input.setAttribute('data-module', 'text')
      _input.dataset.module = `${state.current_module}`
      _div_input.appendChild(_input)

      // span.field__value-span
      const value_span = document.createElement('span')
      value_span.className = 'field__value-span'
      value_span.innerText = 'm²'
      _div_input.appendChild(value_span)

      // Append nodes
      mainNode.appendChild(_h3)
      mainNode.appendChild(_div_input)
      size.appendChild(mainNode)
    }

    function reset_numbers() {
      const sizes = document.querySelectorAll('.size__number')
      sizes.forEach(function(val, index) {
        const number = ++index
        val.innerText = number
      })
    }

    return {
      init, state
    }
  })()

  SystemSize.init()
})
