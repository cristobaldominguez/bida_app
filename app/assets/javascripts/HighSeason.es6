document.addEventListener('turbolinks:load', function() {
  const HighSeason = (() => {

    const state = {}
    const _switch = $('.highseason__input')

    _switch.on('change', handleToggleWitch)

    function init() {
      state.plant_id = getPlantId()
    }

    const getPlantId = () => window.location.pathname.split('/').filter(Boolean)[1]

    function handleToggleWitch(event) {
      event.preventDefault()
      apiCall(event.target.checked)
    }

    function apiCall(check) {
      $.ajax({
        url: `/plants/${state.plant_id}/highseason`,
        type: 'POST',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        dataType: 'json',
        data: { state: check }
      })
      .done(function(data) {
        render(data)
      })
      .fail(function(error) {
        console.log(error)
      })
    }

    function render({ className }) {
      if (className) {
        $('.highseason').addClass('active')
        $('.main_header').addClass('main_header--high-season')
      } else {
        $('.highseason').removeClass('active')
        $('.main_header').removeClass('main_header--high-season')
      }
    }

    return {
        init, state
    }
  })()

  HighSeason.init()
})
