document.addEventListener('turbolinks:load', function() {

  const UnitNumber = (() => {

    // DomCache
    const plus = document.querySelector('.unit_number__plus')
    plus && plus.addEventListener('click', (e) => {
      e.preventDefault()
      e.stopPropagation()
      const target = e.target.closest('.unit_number__wrapper')
      const input = document.createElement('input')
      input.type = 'text'
      input.name = 'plant[unit_number][]'
      input.classList.add('unit_number__input')

      target.append(input)
    })

  })()
})
