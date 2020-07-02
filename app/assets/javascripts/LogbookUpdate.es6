document.addEventListener('turbolinks:load', function() {
  'use strict'

  const LogbookUpdate = (() => {
    const state = {}

    // DomCache
    const selects = document.querySelectorAll('.form__select')
    selects.forEach(function(select){
      select.addEventListener('change', onChangeInput)
    })

    const checkboxes = document.querySelectorAll('.form__checkbox')
    checkboxes.forEach(function(checkbox){
      checkbox.addEventListener('change', onChangeCheckbox)
    })

    const inputs = document.querySelectorAll('.form__input')
    inputs.forEach(function(input){
      input.addEventListener('blur', onChangeInput)
    })

    const radio_btns = document.querySelectorAll('.form__radio-button')
    radio_btns.forEach(function(btn){
      btn.addEventListener('change', onChangeInput)
    })


    function init() {}

    function onChangeInput(e) {
      apiCall({ id: e.target.dataset.id, value: e.target.value })
    }

    function onChangeCheckbox(e){
      apiCall({ id: e.target.dataset.id, value: e.target.checked ? 1 : '' })
    }

    function apiCall({ id, value }) {
      $.ajax({
        url: `/logs/${id}`,
        type: 'PATCH',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        dataType: 'json',
        data: { log: { value: value } }
      })
      .done(data => {
        $(`[data-id=${data}]`).closest('.table_main__table-row')
                              .first()
                              .children('.table_main__api-response')
                              .html('<div class="updated__green update-done"></div>')
      })
      .fail(function(error) {
        $(`[data-id=${data}]`).closest('.table_main__table-row')
                              .first()
                              .children('.table_main__api-response')
                              .append('<div class="updated__red update-error"></div>')
      })
    }

    return { init, state}

  })()

  LogbookUpdate.init()
})
