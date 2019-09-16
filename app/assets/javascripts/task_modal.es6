document.addEventListener('turbolinks:load', function() {
  const TaskModal = (() => {

    const state = {
        steps: 0,
        step: 0,
        svg: '',
        trail_position: 0,
        validations: [],
        current_validation: []
    }

    Events.on('taskmodal/render/modal', renderModal)
    Events.on('taskmodal/render/data_modal', renderDataOnModal)
    Events.on('taskmodal/render/buttons', renderButtons)
    Events.on('taskmodal/render/validation', renderValidation)
    Events.on('taskmodal/render/frecuencyOptions', displayFrecuencyOptions)
    Events.on('taskmodal/state/step', onStepChange)
    Events.on('taskmodal/render/svg_class', onChangeSVGClass)
    Events.on('taskmodal/render/trail', movetrail)
    Events.on('taskmodal/state/stepsHeight', calculateStepsHeight)
    Events.on('taskmodal/state/stepHeight', recalculateHeight)
    Events.on('taskmodal/render/stepsHeight', onDefineStepsHeight)
    Events.on('taskmodal/init/addListeners', addListeners)
    Events.on('taskmodal/render/cleanSelections', cleanSelections)
    Events.on('taskmodal/render/frecuencySelections', renderFrecuencySelections)
    Events.on('taskmodal/render/frequencyButtons', renderFrequencyButtons)
    Events.on('taskmodal/render/dataOnForm', renderDataOnForm)

    const week_days = $('.select_week__day-link, .select_week__day-link--selected')
    const month_days = $('.select_month__day-link, .select_month__day-link--selected')
    const month_months = $('.select_months__month-link, .select_months__month-link--selected')
    const select_frecuency = $('#frecuency_frecuency_id')
    const save_btn = $('.modal-footer__save-btn')
    const next_btn = $('.modal-footer__next-btn')
    const prev_btn = $('.modal-footer__prev-btn')
    const edit_on_modal = $('.options_menu__link--modal-edit')
    const steps = $('[class^="step-"]')
    const modal = $('#plant_logbook')
    const input_targets = $('.modal-content [data-target]')

    week_days.on('click', toggleWeekDay)
    month_days.on('click', toggleMonthDays)
    month_months.on('click', toggleMonthMonths)
    select_frecuency.on('change', frecuencySelect)
    next_btn.on('click', onNextButtonClick)
    prev_btn.on('click', onPrevButtonClick)
    save_btn.on('click', onSubmit)
    input_targets.on('change', inputsListeners)
    $('body').on('click', '.options_menu__link--modal-edit', editOnModal)
    steps.each((index, el) => state.validations[index] = $(el).find('[data-required="true"]'))

    function init() {
      Events.emit('taskmodal/state/stepsHeight', null)
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

    function calculateStepsHeight() {
      state.steps_height = $('[class^="step-"]').map((i,e) => $(e).outerHeight())
    }

    function toggleWeekDay(e) {
      e.preventDefault()
      toggleButtonClass('select_week__day-link', $(this))
    }

    function toggleMonthDays(e) {
      e.preventDefault()
      toggleButtonClass('select_month__day-link', $(this))
    }

    function toggleMonthMonths(e) {
      e.preventDefault()
      const month = {month: $(this).data('month')}
      const current_cycles = state.data.cycles

      if ($(this).hasClass('select_months__month-link')) {
        current_cycles.months = [...current_cycles.months, month].sort((a, b) => a - b)
        $(this).removeClass('select_months__month-link').addClass('select_months__month-link--selected')
      } else {
        current_cycles.months = current_cycles.months.filter(num => num.month !== month.month).sort((a, b) => a - b)
        $(this).removeClass('select_months__month-link--selected').addClass('select_months__month-link')
      }
    }

    function toggleButtonClass(_class, _this) {
      const current_cycles = state.data.cycles
      const dataset = {
        day: _this.data('day'),
        week: _this.data('week') || 1,
        num: _this.data('num')
      }

      if (_this.hasClass(_class)) {
        current_cycles.days = [...current_cycles.days, dataset].sort((a, b) => a.num - b.num)
        _this.removeClass(_class).addClass(`${_class}--selected`)
      } else {
        current_cycles.days = current_cycles.days.filter(day => day.num !== dataset.num)
        _this.removeClass(`${_class}--selected`).addClass(_class)
      }

      const cycles_json = JSON.stringify(state.data.cycles)
    }

    function frecuencySelect(e) {
      e.preventDefault()

      // Reset all Cycles States
      state.data.cycles = {
        days: [],
        months: []
      }

      Events.emit('taskmodal/render/frecuencyOptions', $(this).val())
    }

    function displayFrecuencyOptions(value) {
      const elements = $('.step-2 > [class^="select_"]').not('#' + value)
      elements.each(function(i, elem) {
        $(elem).hide()
      })

      $('#' + value).show()

      Events.emit('taskmodal/state/stepsHeight', null)
      Events.emit('taskmodal/render/cleanSelections', null)
      Events.emit('taskmodal/render/frecuencySelections', null)
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

    function inputsListeners(e) {
      e.preventDefault()
      state.data[$(this).data('target')] = $(this).val()
    }

    function onSubmit(e) {
      e.preventDefault()
      Events.emit('taskmodal/render/dataOnForm', null)
      modal.modal('hide')
      setDefaultState()
    }

    function recalculateHeight() {
      state.steps_height[state.step] = $('.step-' + (state.step + 1)).outerHeight()
      Events.emit('taskmodal/render/stepsHeight', null)
    }

    function onStepChange(data) {
      // if (!state.data) { return 0 }

      if (typeof data === 'string' || data instanceof String) {
        state.step = (data === '+1') ? ++state.step : --state.step
      } else if (typeof data === 'number' || data instanceof Number) {
        state.step = data
      }

      Events.emit('taskmodal/render/svg_class', null)
      Events.emit('taskmodal/render/stepsHeight', null)
      Events.emit('taskmodal/render/buttons', null)
      Events.emit('taskmodal/render/trail', null)
    }

    function onDefineStepsHeight() {
      $(':root').get(0).style.setProperty('--steps-mask-height', state.steps_height[state.step] + 'px')
    }

    function onChangeSVGClass() {
      if (state.svg === '') { return 0 }

      state.svg.removeAttr('class').addClass( state.svg_class + (state.step + 1))
    }

    function movetrail() {
      const trail_movement = (state.steps_height.slice(0, state.step)
                                                .toArray()
                                                .reduce(function(total, num) { return total + num }, 0) * -1)

      $(':root').get(0).style.setProperty('--steps-trail-position', trail_movement + 'px')
    }

    function editOnModal(e) {
      if (e.currentTarget.className !== 'options_menu__link--modal-edit') { return 0 }

      e.preventDefault()
      const element = $(this).closest('.table_main__table-row')
      const cycles = element.find('.cycle').val()
      state.selected_task = element

      state.data = {
        comment: element.find('.comment').val(),
        cycles: cycles ? JSON.parse(cycles) : { days: [], months: [] },
        frecuency: element.find('.frecuency').val(),
        name: element.find('.name').val(),
        responsible: parseInt(element.find('.responsible').val()),
        season: element.find('.season').val()
      }

      Events.emit('taskmodal/render/modal', null)
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

    function renderModal() {
      modal.modal('show')
      Events.emit('taskmodal/state/step', 0)
      Events.emit('taskmodal/render/data_modal', null)
    }

    function renderDataOnModal() {
      if (!state.data) { return 0 }

      const { name,comment, responsible, season, frecuency } = state.data
      $('#task_name').val(state.data.name)
      $('#task_comment').val(state.data.comment)
      $('#responsible_responsible_id').val(state.data.responsible)
      $('#season_modal_season').val(state.data.season)
      $('#frecuency_frecuency_id').val(state.data.frecuency)

      Events.emit('taskmodal/render/frecuencyOptions', state.data.frecuency)
    }

    function renderFrecuencySelections(data) {
      if (!state.data) { return 0 }

      Events.emit('taskmodal/render/frequencyButtons', state.data.cycles.days)
      Events.emit('taskmodal/render/frequencyButtons', state.data.cycles.months)
    }

    function renderFrequencyButtons(data) {
      if (jQuery.isEmptyObject(data)) { return 0 }

      data.forEach(el => {
        const _freq = el.month === undefined ? { num: el.num, type: 'num' } : { num: el.month, type: 'month' }

        const freq = $(`#${state.data.frecuency} [data-${_freq.type}=${_freq.num}]`)
        const freq_class = freq.attr('class')

        freq.removeClass(freq_class).addClass(`${freq_class}--selected`)
      })
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

    function renderDataOnForm() {
      const element = $(state.selected_task)
      const { name, season, comment, frecuency, cycles, responsible } = state.data
      const cycles_json = JSON.stringify(cycles)

      element.find('.name').val(name)
      element.find('.season').val(season)
      element.find('.comment').val(comment)
      element.find('.cycle').val(cycles_json)
      element.find('.frecuency').val(frecuency)
      element.find('.responsible').val(responsible)
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
    $(".modal-backdrop").fadeOut('fast').remove()
  })
})
