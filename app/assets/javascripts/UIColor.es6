document.addEventListener('turbolinks:load', function() {
  const UIColor = (() => {

    const state = {}

    // DomCache
    const uicolor_btn = $('.user_options__link--light-ui, .user_options__link--dark-ui')

    // EventBinding
    uicolor_btn.on('click', click)

    // Functions
    function init() {}

    function click(e) {
      e.preventDefault()
      const target = $(e.target)
      const target_text = target.attr('class').split('-')[2]

      let inverse_color = 'light'
      let inverse_icon = 'moon'

      if (target_text == 'light') {
        inverse_color = 'dark'
        inverse_icon = 'sun'
      }

      $('body').removeAttr('class').addClass(`${inverse_color}-ui`)
      target.removeAttr('class').addClass(`user_options__link--${inverse_color}-ui`)
      target.children('i').attr('class', `icon-${inverse_icon}`)
    }

    // API
    return {
        init, state
    }
  })()

  UIColor.init()
})
