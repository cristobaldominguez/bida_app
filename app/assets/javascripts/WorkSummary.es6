document.addEventListener('turbolinks:load', function() {
  "use strict";

  const WorkSummary = (() => {

    const state = {
      id: 0,
      work_summary: ''
    }

    // DomCache
    const body = $('body')
    const erase = '.work_summary__delete'

    // EventBinding
    body.on('click', erase, onClick)

    // Functions

    function onClick(e) {
      e.preventDefault()
      state.work_summary = $(this).parent().parent()
      state.id = state.work_summary.data('id')

      if (state.id) {
        APICall()
      } else {
        state.work_summary.remove()
      }
    }

    function init() {}

    function APICall() {

      $.ajax({
        url: `/work_summaries/${state.id}`,
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        type: 'DELETE'
      })
      .done(function(success) {
        state.work_summary.remove()
      })
      .fail(function(error) {
        console.log(error)
      })

    }

    // API
    return {
        init, state
    }
  })()

  WorkSummary.init()
})
