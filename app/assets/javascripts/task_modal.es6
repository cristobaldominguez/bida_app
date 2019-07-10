document.addEventListener('turbolinks:load', function() {
  const TaskModal = (() => {

    const state = {
        steps: 0,
        step: 0,
        trail_position: 0,
        validations: [],
        current_validation: [],
        week_days: [],
        months: []
    }

    Events.on('taskmodal/render/buttons', renderButtons)
    Events.on('taskmodal/render/stepsHeight', onDefineStepsHeight)
    Events.on('taskmodal/render/validation', renderValidation)
    Events.on('taskmodal/state/step', onStepChange)
    Events.on('taskmodal/render/svg_class', onChangeSVGClass)
    Events.on('taskmodal/render/trail', movetrail)
    Events.on('taskmodal/state/stepHeight', recalculateHeight)
    Events.on('taskmodal/init/addListeners', addListeners)
    Events.on('taskmodal/render/cleanSelections', cleanSelections)

    const week_days = $('.select_week__day-link, .select_week__day-link--selected')
    const month_days = $('.select_month__day-link, .select_month__day-link--selected')
    const month_months = $('.select_months__month-link, .select_months__month-link--selected')
    const select_frecuency = $('#frecuency_frecuency_id')
    const save_btn = $('.modal-footer__save-btn')
    const next_btn = $('.modal-footer__next-btn')
    const prev_btn = $('.modal-footer__prev-btn')
    const edit_on_modal = $('.options_menu__link--modal-edit')
    const steps = $('[class^="step-"]')

    week_days.on('click', toggleWeekDay)
    month_days.on('click', toggleMonthDays)
    month_months.on('click', toggleMonthMonths)
    select_frecuency.on('change', selector_frecuency)
    next_btn.on('click', onNextButtonClick)
    prev_btn.on('click', onPrevButtonClick)
    save_btn.on('click', onSubmit)
    $('body').on('click', '.options_menu__link--modal-edit', editOnModal)
    steps.each((index, el) => state.validations[index] = $(el).find('[data-required="true"]'))

    function init() {
      state.steps_height = $('[class^="step-"]').map((i,e) => $(e).outerHeight())
      state.steps = $('.steps__trail > [class^="step-"]').length - 1
      state.prev_btn = prev_btn.text() || 'Previous'
      state.next_btn = next_btn.text() || 'Next'
      state.svg = $('svg[class^="svg_img__"]')
      state.svg_class = state.svg.attr('class').split('--')[0] + '--'

      setDefaultState()

      Events.emit('taskmodal/render/buttons', null)
      Events.emit('taskmodal/render/stepsHeight', 0)
      Events.emit('taskmodal/init/addListeners', null)
    }

    function toggleWeekDay(e) {
      e.preventDefault()
      const dataset = $(this).data('day')

      if ($(this).hasClass('select_week__day-link')) {
        // state.week_days.push(dataset)
        state.week_days = [...state.week_days, dataset].sort((a, b) => a - b)
        $(this).removeClass('select_week__day-link').addClass('select_week__day-link--selected')
      } else {
        state.week_days = state.week_days.filter(day => day !== dataset )
        $(this).removeClass('select_week__day-link--selected').addClass('select_week__day-link')
      }

      console.log(state.week_days)
    }

    function toggleMonthDays(e) {
      e.preventDefault()
      const _this = $(this)
      const dataset = {
        day: _this.data('day'),
        week: _this.data('week'),
        num: _this.data('num')
      }

      if ($(this).hasClass('select_month__day-link')) {
        state.week_days = [...state.week_days, dataset].sort((a, b) => a.num - b.num)
        $(this).removeClass('select_month__day-link').addClass('select_month__day-link--selected')
      } else {
        state.week_days = state.week_days.filter(day => day.num !== dataset.num)
        $(this).removeClass('select_month__day-link--selected').addClass('select_month__day-link')
      }
    }

    function toggleMonthMonths(e) {
      e.preventDefault()
      const month = $(this).data('month')

      if ($(this).hasClass('select_months__month-link')) {
        state.months = [...state.months, month].sort((a, b) => a - b)
        $(this).removeClass('select_months__month-link').addClass('select_months__month-link--selected')
      } else {
        state.months = state.months.filter(num => num !== month).sort((a, b) => a - b)
        $(this).removeClass('select_months__month-link--selected').addClass('select_months__month-link')
      }
    }

    function selector_frecuency(e) {
      e.preventDefault()

      // Reset all States
      state.week_days = []
      state.months = []

      const value = $(this).children(':selected').text().toLowerCase().split(' ').join('_')
      const elements = $('.step-2 > [class^="select_"]').not('#' + value)
      elements.each(function(i, elem) {
        $(elem).hide()
      })

      $('#' + value).show()
      Events.emit('taskmodal/render/cleanSelections', null)
      Events.emit('taskmodal/state/stepHeight', null)
    }

    function onNextButtonClick(e) {
      e.preventDefault()
      const _fieldsValidation = fieldsValidation()

      if (!_fieldsValidation) {
        return Events.emit('taskmodal/state/stepHeight', null)
      }

      Events.emit('taskmodal/state/step', '+1')
    }

    function onPrevButtonClick(e) {
      e.preventDefault()
      Events.emit('taskmodal/state/step', '-1')
      Events.emit('taskmodal/state/stepHeight', null)
    }

    function fieldsValidation() {
      state.validations[state.step].each((index, el) => handleElementWithNoValue(el))

      return state.current_validation.length === 0
    }

    function renderValidation(el, bool) {
      setDefaultState()

      $.each(state.current_validation, function(index, el) {
        const element = document.querySelector('#' + $(el).attr('id'))
        element.parentNode.style.setProperty('--input-border', 'var(--red)')
        $(element).after('<span class="step__error">'+ $(this).data('error') +'</span>')
      })

      Events.emit('taskmodal/render/stepsHeight', null)
    }

    function handleElementWithNoValue(el) {
      $(el).val() === '' ? stateIncludes(el) : filterState(el)
      Events.emit('taskmodal/render/validation', null)
      Events.emit('taskmodal/state/stepHeight', null)
    }

    function stateIncludes(el) {
      !state.current_validation.includes(el) ? state.current_validation.push(el) : null
    }

    function filterState(el) {
      state.current_validation = state.current_validation.filter(currentEl => currentEl !== el)
    }

    function setDefaultState() {
      $('.field').removeAttr('style')
      $('.step__error').remove()
    }

    function addListeners() {
      $.each(state.validations, function(index, field) {
        field.each(function(index, validation) {
          $(validation).on('keyup blur change', function(event) {
            handleElementWithNoValue(event.target)
          })
        })
      })
    }

    function onSubmit(e) {
      e.preventDefault()
    }

    function recalculateHeight() {
      state.steps_height[state.step] = $('.step-' + (state.step + 1)).outerHeight()
      Events.emit('taskmodal/render/stepsHeight', null)
    }

    function onStepChange(data) {
      state.step = (data === '+1') ? ++state.step : --state.step

      Events.emit('taskmodal/render/svg_class', state.step)
      Events.emit('taskmodal/render/stepsHeight', null)
      Events.emit('taskmodal/render/buttons', null)
      Events.emit('taskmodal/render/trail', null)
    }

    function onDefineStepsHeight() {
      $(':root').get(0).style.setProperty('--steps-mask-height', state.steps_height[state.step] + 'px')
    }

    function onChangeSVGClass() {
      state.svg.removeAttr('class').addClass( state.svg_class + (state.step + 1))
    }

    function movetrail() {
      const trail_movement = (state.steps_height.slice(0, state.step)
                                                .toArray()
                                                .reduce(function(total, num) { return total + num }, 0) * -1)

      $(':root').get(0).style.setProperty('--steps-trail-position', trail_movement + 'px')
    }

    function editOnModal(e) {
      e.preventDefault()
      const element = $(this).parent().parent().parent().parent().parent()

      state.data = {
        name: element.find('.name').text(),
        comment: element.find('.comment').val(),
        frecuency: parseInt(element.find('.frecuency').val()),
        cycle: parseInt(element.find('.cycle').val()),
        responsible: parseInt(element.find('.responsible').val())
      }

      $('#plant_logbook').modal('show')
      renderDataOnModal()
    }

    function cleanSelections() {
      const selections = $('[class$="--selected"]')

      if (!selections.length) { return 0 }

      selections.each((index, selection) => {
        const className = $(selection).attr('class')
        const classFixed = className.split('--')[0]
        $(selection).removeClass(className).addClass(classFixed)
      })
    }

    function renderDataOnModal() {
      const { name, comment, responsible } = state.data
      $('#task_name').val(name)
      $('#task_comment').val(comment)
      $('#responsible_responsible_id').val(responsible)
    }

    function renderButtons() {
      if (state.step == 0) {
        // First slide
        save_btn.hide()
        next_btn.show()
        prev_btn.attr('disabled', true)
      } else if (state.step == state.steps) {
        // Last slide
        next_btn.hide()
        save_btn.show()
        prev_btn.removeAttr('disabled')
      } else if (state.step < state.steps) {
        // Inner slides
        save_btn.hide()
        next_btn.show()
        prev_btn.removeAttr('disabled')
      }
    }

    return {
        init, state
    }
  })()

  // Event triggered before modal will be show
  $('#plant_logbook').on('shown.bs.modal', function (e) {
    TaskModal.init()
  })

  // Event triggered before modal will be hidden
  $('#plant_logbook').on('hide.bs.modal', function (e) {

  })
})
