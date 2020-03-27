document.addEventListener('turbolinks:load', function() {
  const UIActions = (() => {

    const state = {}

    // DomCache
    const body = $('body')
    const general_option_btn = $('.option-button__link')
    // const element_option_btn = $('.table_main__link--options')
    const toast_notification = $('.toast__close')
    const toast_notices = $('.toast--blue')

    // EventBinding
    general_option_btn.on('click', general_option_btn_click)
    $('body').on('click', '.table_main__link--options', element_option_btn_click)
    toast_notification.on('click', toast_notification_fadeout)
    body.on('click', '.unclick--general-options', unclick_general_options)
    body.on('click', '.unclick', unclick_specific_options)

    if (!is_empty(toast_notices)) {
      toast_notices.each(function(index) {
        $(toast_notices[index]).delay(5000).fadeOut('slow', function() {
          $(this).remove()
        })
      })
    }

    // Functions
    function init() {}

    function is_empty(obj) {
        for(var key in obj) {
            if(obj.hasOwnProperty(key))
                return false
        }
        return true
    }

    function onEmptyLink(e) {
      e.preventDefault()
    }

    function general_option_btn_click(e) {
      e.preventDefault()
      e.stopPropagation()

      const elem = $(this).siblings('.option-button__options')

      if (elem) {
        elem.attr('class', 'option-button__options--open')
      } else {
        $(this).find('.option-button__options--open').attr('class', 'option-button__options')
      }
    }

    function element_option_btn_click(e) {
      e.preventDefault()
      e.stopPropagation()

      const elem = $(this).siblings('.options_menu')
      const icon = $(this)

      if (icon.hasClass('table_main__link--options')) {
        icon.attr('class', 'table_main__link--options-open')
      }

      if (elem) {
        elem.attr('class', 'options_menu--show')
      } else {
        $(this).find('.options_menu--show').attr('class', 'options_menu')
      }
    }

    function unclick_general_options(event) {
      event.preventDefault()
      $(this).parent().attr('class', 'option-button__options')
    }

    function unclick_specific_options() {
      event.preventDefault()
      $(this).parent().attr('class', 'options_menu')
      $('.table_main__link--options-open').attr('class', 'table_main__link--options')
    }

    function toast_notification_fadeout(e) {
      e.preventDefault()
      const parent = $(this).parent()
      parent.fadeOut('slow', function() {
        $(this).remove()
      })
    }

    // API
    return {
        init, state
    }
  })()

  UIActions.init()
})
