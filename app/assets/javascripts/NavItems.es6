document.addEventListener('turbolinks:load', function() {
  const NavItems = (() => {

	const state = {}

	// DomCache
	const menuItems = $('[class^="mobile_nav__link"][href="#"], [class^="mobile_nav__sublink"][href="#"]')
	const mainHamburger = $('.main_nav__hamburger')
  const user = $('.user_options__link--users')
  const unclick = $('.unclick')

	// Event Binding
	menuItems.on('click', function(e) {
		if ($(this).attr('href') == '#') {
			e.preventDefault()

			const target = $(this).siblings('ul')
			if (target.hasClass('mobile_nav__submenu-list')) {
				target.removeClass('mobile_nav__submenu-list').addClass('mobile_nav__submenu-list--open')
			} else {
				target.removeClass('mobile_nav__submenu-list--open').addClass('mobile_nav__submenu-list')
			}
		}
	})

	mainHamburger.on('click', function(event) {
		event.preventDefault()
		const close = 'mobile_nav'
		const open = 'mobile_nav--open'

		const div_open = $(`.${open}`)
		const div_close = $(`.${close}`)

		if (div_open) {
			div_open.removeClass(open).addClass(close)
		}

		if (div_close) {
			div_close.removeClass(close).addClass(open)
		}
	})

  user.on('click', function(e) {
    e.preventDefault();
    const target = $(this).siblings('div')
    $(this).attr('class', 'user_options__link--open');

    if (target.hasClass('options_menu')) {
      target.removeAttr('class').addClass('options_menu--show')
    } else {
      target.removeAttr('class').addClass('options_menu')
    }
  })

  $('body').on('click touchstart', '.unclick--user', function(event) {
    event.preventDefault();
    $('.main_header .options_menu--show').removeAttr('class').addClass('options_menu')
    $('.user_options__link--open').attr('class', 'user_options__link--users')
  });

	function init() {}

	return { init, state }
  })()

  // NavItems.init()
})
