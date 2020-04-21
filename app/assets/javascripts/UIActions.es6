document.addEventListener('turbolinks:load', function() {
  const UIActions = (() => {

    const state = {}

    // DomCache
    const body = $('body')
    const general_option_btn = $('.option-button__link')
    const nav_plants_btn = $('.main_nav__link-dropdown')
    const toast_notification = $('.toast__close')
    const toast_notices = $('.toast--blue')
    const unclick_desktop_menu = $('.unclick--desktop_menu')
    const desktop_nav_link = $('.desktop_nav__link')

    // EventBinding
    general_option_btn.on('click', general_option_btn_click)
    $('body').on('click', '.table_main__link--options', element_option_btn_click)
    nav_plants_btn.on('click', nav_plants_btn_click)
    toast_notification.on('click', toast_notification_fadeout)
    body.on('click', '.unclick--general-options', unclick_general_options)
    body.on('click', '.unclick', unclick_specific_options)
    body.on('click', '.unclick--plants', unclick_plants_options)
    desktop_nav_link.on('click', desktop_nav_link_click)
    unclick_desktop_menu.on('click', unclick_desktop_menu_click)

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

    function nav_plants_btn_click(e) {
      e.preventDefault()
      e.stopPropagation()

      const elem = $(this).siblings('.options_menu')
      const icon = $(this)

      icon.toggleClass('main_nav__link--options-open')

      // if (icon.hasClass('main_nav__link')) {
      //   icon.attr('class', 'table_main__link--options-open')
      // }

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

    function unclick_plants_options(event) {
      event.preventDefault()
      $(this).parent().attr('class', 'options_menu')
      $('.main_nav__link--options-open').toggleClass('main_nav__link--options-open')
    }

    function toast_notification_fadeout(e) {
      e.preventDefault()
      const parent = $(this).parent()
      parent.fadeOut('slow', function() {
        $(this).remove()
      })
    }

    function unclick_desktop_menu_click(e) {
      e.preventDefault()
      removeSubmenus()
    }

    function desktop_nav_link_click(e) {
      const next_elem = $(this).next()

      if (next_elem.hasClass('desktop_nav__submenu')) {
        e.preventDefault()

        removeSubmenus()
        $(this).toggleClass('desktop_nav__link--options-open')
        next_elem.toggleClass('desktop_nav__submenu--open')
      }
    }

    function removeSubmenus() {
      $('.desktop_nav__link').removeClass('desktop_nav__link--options-open')
      $('.desktop_nav__submenu').removeClass('desktop_nav__submenu--open')
    }


    // API
    return {
        init, state
    }
  })()

  UIActions.init()
})
