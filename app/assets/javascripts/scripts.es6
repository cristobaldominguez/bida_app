"use strict";

const SystemSize = (() => {

  //State
  const state = {
    sizes: [],
    current_module: 0
  }

  // CacheDom

  // Event Binding
  function eventBinding() {

    const plus = document.querySelector('.system_size__plus')
    plus.addEventListener('click', add_size)

    document.addEventListener('focusout', function (event) {

      if (event.target.matches('.size__input')) {
        get_sizes()
        echo_sizes()
      }

    }, false);

    document.addEventListener('click', function (event) {

      if (event.target.matches('span.delete')) {
        const sizes = document.querySelector('.system_size__elements')
        const elem = event.target.parentNode.parentNode
        sizes.removeChild(elem)
      }

    }, false);

  }

  // Functions
  function init() {
    eventBinding()
    get_sizes()
    console.log(state)
  }

  function get_sizes() {
    state.sizes = []
    const sizes = document.querySelectorAll('li.size')
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
    size.innerHTML += `<li class="size"><h3>Module #<span class="size__number">${++state.current_module}</span></h3><input type="text" class="size__input" name="size__quantity" placeholder="Size of the module" data-module="${state.current_module}"></li>`
  }

  return {
    init, state
  }
})()

document.addEventListener('turbolinks:load', SystemSize.init)
