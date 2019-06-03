document.addEventListener('turbolinks:load', function() {
  const UIColor = (() => {

    // const state = {}

    // DomCache
    const uicolor_btn = $('.user_options__link--light-ui, .user_options__link--dark-ui')

    // EventBinding
    uicolor_btn.on('click', click)

    // Functions
    // function init() {}

    function click(e) {
      e.preventDefault()
      APICall()
    }

    function APICall() {
      $.ajax({
        url: '/users/uicolor',
        type: 'POST',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}
      })
      .done(function(data) {
        console.log(data)
        onChange(data)
      })
      .fail(function(error) {
        console.log(error);
      })
    }

    function onChange({color, icon}) {
      $('body').removeAttr('class').addClass(`${color}-ui`)
      $('li.user_options__item--ui a').removeAttr('class').addClass(`user_options__link--${color}-ui`)
      $('li.user_options__item--ui a i').attr('class', `icon-${icon}`)
    }

    // API
    return {
      // init, state
    }
  })()

  // UIColor.init()
})
