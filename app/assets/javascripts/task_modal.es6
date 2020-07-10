document.addEventListener('turbolinks:load', function() {
  const TaskModal = (() => {

    const state = {
        i18n: {},
        steps: 0,
        step: 0,
        svg: '',
        trail_position: 0,
        validations: [],
        current_validation: [],
        never_been_edited: true
    }

    Events.on('taskmodal/render/modal', renderModal)
    Events.on('taskmodal/render/data_modal', renderDataOnModal)
    Events.on('taskmodal/render/buttons', renderButtons)
    Events.on('taskmodal/render/validation', renderValidation)
    Events.on('taskmodal/render/frecuencyOptions', displayFrecuencyOptions)
    Events.on('taskmodal/state/step', onStepChange)
    Events.on('taskmodal/render/svg_class', onChangeSVGClass)
    Events.on('taskmodal/render/trail', moveTrail)
    Events.on('taskmodal/state/stepsHeight', calculateStepsHeight)
    Events.on('taskmodal/state/stepHeight', recalculateHeight)
    Events.on('taskmodal/render/stepsHeight', onDefineStepsHeight)
    Events.on('taskmodal/init/addListeners', addListeners)
    Events.on('taskmodal/render/cleanSelections', cleanSelections)
    Events.on('taskmodal/render/frecuencySelections', renderFrecuencySelections)
    Events.on('taskmodal/render/frequencyButtons', renderFrequencyButtons)
    Events.on('taskmodal/render/dataOnForm', renderDataOnForm)
    Events.on('taskmodal/render/modal_number_type', modalNumberType)
    Events.on('taskmodal/render/removeTaskIds', removeTaskIds)

    const week_days = $('.select_week__day-link, .select_week__day-link--selected')
    const month_days = $('.select_month__day-link, .select_month__day-link--selected')
    const month_months = $('.select_months__month-link, .select_months__month-link--selected')
    const select_frecuency = $('#frecuency_frecuency_id')
    const save_btn = $('.modal-footer__save-btn')
    const next_btn = $('.modal-footer__next-btn')
    const prev_btn = $('.modal-footer__prev-btn')
    const steps = $('[class^="step-"]')
    const modal = $('#plant_logbook')
    const input_targets = $('.modal-content [data-target]')
    const value_type = $('#input_type_input_type')
    const add_task = $('.add_task__plus')
    const table_logbook_edit = $('table.logbook')
    const hidden_number = $('.hidden_number')[0]
    const first_task_in_list = $('.logbook .table_main__table-row:first-child')
    const delete_button = $('.options_menu__link--modal-destroy')

    week_days.on('click', toggleWeekDay)
    month_days.on('click', toggleMonthDays)
    month_months.on('click', toggleMonthMonths)
    select_frecuency.on('change', frecuencySelect)
    next_btn.on('click', onNextButtonClick)
    prev_btn.on('click', onPrevButtonClick)
    save_btn.on('click', onSubmit)
    delete_button.on('confirm', deleteTask)
    add_task.on('click', addNewTask)
    value_type.on('change', valueTypeHandle)
    input_targets.on('change', inputsListeners)
    $('body').on('click', '.options_menu__link--modal-edit', getFormData)
    steps.each((index, el) => state.validations[index] = $(el).find('[data-required="true"]'))
    $('body').on('click', '.options_menu__link--modal-edit', editOnModal)

    function setup() {
      APITranslations()
    }

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

    function APITranslations() {
      const locale = $('html').attr('lang')

      $.ajax({
        url: `/${locale}/locales.json?i18n=[global.show,global.edit,global.destroy,global.confirm]`,
        type: 'GET',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}
      })
      .done(function(data) {
        state.i18n = data
      })
      .fail(function(error) {
        console.log(error);
      })
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
      if (value === '') { value = 'Daily' }

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

    function moveTrail() {
      const trail_movement = (state.steps_height
                                   .slice(0, state.step)
                                   .toArray()
                                   .reduce(function(total, num) { return total + num }, 0) * -1)

      $(':root').get(0).style.setProperty('--steps-trail-position', trail_movement + 'px')
    }

    function editOnModal(e) {
      e.preventDefault()
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
      Events.emit('app/options/unclick', null)
    }

    function getFormData(e) {
      if (e.currentTarget.className !== 'options_menu__link--modal-edit') { return 0 }

      e.preventDefault()
      const element = $(this).closest('.table_main__table-row')
      state.selected_task = element

      const _data = {
        name: element.find('.name').val(),
        cycles: element.find('.cycle').val(),
        season: element.find('.season').val(),
        comment: element.find('.comment').val(),
        frecuency: element.find('.frecuency').val(),
        data_type: element.find('.data_type').val(),
        input_type: element.find('.input_type').val(),

        responsible: element.find('.responsible').val()
      }

      state.data = {
        ..._data,
        cycles: _data.cycles ? JSON.parse(_data.cycles) : { days: [], months: [] }
      }

      state.data_comparison = JSON.stringify({...state.data})

      Events.emit('taskmodal/render/modal', null)
      Events.emit('taskmodal/render/modal_number_type', null)
    }

    function renderDataOnModal() {
      if (!state.data) { return 0 }

      const { name, season, comment, frecuency, cycles, responsible, input_type, data_type } = state.data
      $('#task_name').val(name)
      $('#task_comment').val(comment)
      $('#responsible_responsible_id').val(responsible)
      $('#data_type_data_type').val(data_type)
      $('#season_modal_season').val(season)
      select_frecuency.val(frecuency)
      value_type.val(input_type)

      Events.emit('taskmodal/render/frecuencyOptions', frecuency)
    }

    function valueTypeHandle(e) {
      const option_selected = $(this).val()
      option_selected === 'number' ? hidden_number.classList.remove('hide') : hidden_number.classList.add('hide')
    }

    function modalNumberType() {
      state.data.input_type === 'number' ? hidden_number.classList.remove('hide') : hidden_number.classList.add('hide')
      Events.emit('taskmodal/state/stepsHeight', null)
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

      const recently_edited = JSON.stringify({...state.data}) !== state.data_comparison
      if (state.never_been_edited && recently_edited) {
        Events.emit('taskmodal/render/removeTaskIds', null)
        state.never_been_edited = false
      }

      const { name, season, comment, frecuency, cycles, responsible, input_type, data_type } = state.data
      const cycles_json = JSON.stringify(cycles)

      element.find('.name').val(name)
      element.find('.season').val(season)
      element.find('.comment').val(comment)
      element.find('.cycle').val(cycles_json)
      element.find('.frecuency').val(frecuency ? frecuency : '')
      element.find('.responsible').val(responsible ? responsible : '')
      element.find('.span_name').text(name)
      element.find('.input_type').val(input_type ? input_type : '')
      element.find('.data_type').val(data_type && input_type === 'number' ? data_type : 'other')

      Events.emit('taskmodal/render/idChecker', null)
    }

    function removeTaskIds() {
      const logbook_table = document.querySelector('.logbook')
      const elems = logbook_table.querySelectorAll('.task_list_id, .task_id')
      elems.forEach((elem, i) => elem.remove())
    }

    function addNewTask(e) {
      e.preventDefault()
      const list = table_logbook_edit.find('tbody')
      const tasks_number = list.find('tr')

      const task_list_id = parseInt(first_task_in_list.find('.task_list_id').val())
      const plant_id = parseInt(first_task_in_list.find('.plant_id').val())

      state.tasks = {
        id: tasks_number.length,
        task_list_id: isNaN(task_list_id) ? '' : task_list_id,
        plant_id: isNaN(plant_id) ? '' : plant_id,
      }

      const html = Task.create(state.tasks)

      list.append(html)
      Events.emit('taskmodal/render/idChecker', null)
    }

    function deleteTask(e) {
      e.preventDefault()
      const _parent = $(e.target).closest('.table_main__table-row')
      _parent.remove()

      const recently_edited = JSON.stringify({...state.data}) !== state.data_comparison
      if (state.never_been_edited && recently_edited) {
        Events.emit('taskmodal/render/removeTaskIds', null)
        state.never_been_edited = true
      }
      Events.emit('taskmodal/render/idChecker', null)
    }

    return {
        setup, init, state
    }
  })()

  const Task = (() => {

    Events.on('taskmodal/render/idChecker', idChecker)

    function create({ id, task_list_id, plant_id, task_id, name, season, comment, responsible, input_type, data_type, frecuency, cycle }) {
      task_list_id = task_list_id ? ` value="${task_list_id}"` : ''
      plant_id = plant_id ? ` value="${plant_id}"` : ''
      task_id = task_id ? ` value="${task_id}"` : ''
      cycle = cycle ? ` value='${cycle}'` : ''

      const _tr = document.createElement('tr')
      _tr.classList.add('table_main__table-row')
      _tr.innerHTML = `
        <td class="table_main__table-data--left-text">
          <input name="plant[task_lists_attributes][0][tasks_attributes][0][active]" type="hidden" value="1">
          <input type="checkbox" checked="checked" name="plant[task_lists_attributes][0][tasks_attributes][0][active]">
        </td>
        <td class="table_main__table-data--left-text">
          <input class="task_list_id" type="hidden" name="plant[task_lists_attributes][0][id]" value="${ task_list_id }">
          <input class="plant_id" type="hidden" name="plant[task_lists_attributes][0][plant_id]" value="${ plant_id }">

          <input class="task_id" type="hidden" name="plant[task_lists_attributes][0][tasks_attributes][0][id]"${ task_id }>
          <input class="name" type="hidden" name="plant[task_lists_attributes][0][tasks_attributes][0][name]" value="${ name || '' }">
          <input class="season" type="hidden" name="plant[task_lists_attributes][0][tasks_attributes][0][season]" value="${ season || '' }">
          <input class="comment" type="hidden" name="plant[task_lists_attributes][0][tasks_attributes][0][comment]" value="${ comment || '' }">
          <input class="responsible" type="hidden" name="plant[task_lists_attributes][0][tasks_attributes][0][responsible]" value="${ responsible || '' }">
          <input class="input_type" type="hidden" name="plant[task_lists_attributes][0][tasks_attributes][0][input_type]" value="${ input_type || '' }">
          <input class="data_type" type="hidden" name="plant[task_lists_attributes][0][tasks_attributes][0][data_type]" value="${ data_type || '' }">
          <input class="frecuency" type="hidden" name="plant[task_lists_attributes][0][tasks_attributes][0][frecuency]" value="${ frecuency || '' }">
          <input class="cycle" type="hidden" name="plant[task_lists_attributes][0][tasks_attributes][0][cycle]"${ cycle }>

          <span class="span_name">${ name || '' }</span>
        </td>
        <td class="table_main__table-data--options">
          <a href="#" class="table_main__link--options"></a>
          <div class="options_menu">
            <ul class="options_menu__list">
              <li class="options_menu__item"><a class="options_menu__link--modal-show" href="#">${ TaskModal.state.i18n.show }</a></li>
              <li class="options_menu__item"><a class="options_menu__link--modal-edit" href="#">${ TaskModal.state.i18n.edit }</a></li>
              <li class="options_menu__item"><a class="options_menu__link--modal-destroy" data-confirm="${ TaskModal.state.i18n.confirm }" href="#">${ TaskModal.state.i18n.destroy }</a></li>
            </ul>
            <div class="unclick"></div>
          </div>
        </td>`

      return _tr
    }

    function idChecker() {
      const regex_id   = /[\d]+/g
      const regex_name = /\[[\d]+\]/g

      const list = document.querySelectorAll('.table_main__table.logbook .table_main__table-row')
      list.forEach((task, i) => {
        const inputs = task.querySelectorAll('input:not(.plant_id)')
        inputs.forEach((input, _) => {
          input.name = input.name.replace(regex_name, (match, ind) => ind === 49 ? `[${i}]` : match)
        });
      });
    }

    function create_from_array(tasks) {
      const html_tasks = tasks.map(task => create(task))
      console.log(html_tasks)
      return html_tasks
    }

    return { create, create_from_array }
  })()

  const DefaultTasks = (() => {

    let state = {}

    Events.on('state/default_tasks/render', renderTasks)

    // DomCache
    const table_logbook_edit = $('table.logbook')
    const tasks_default = $('.add_task__default')

    tasks_default.on('click', init)

    function init(e) {
      e.preventDefault()

      APITasks()
    }

    function setState(data) {
      state = {...state, tasks: data}
      Events.emit('state/default_tasks/render', null)
    }

    function APITasks() {
      const locale = $('html').attr('lang')
      const country = $('#plant_country_id').children('option:selected').text()
      const tasks_locale = get_locale_from(country)

      $.ajax({
        url: `/${locale}/tasks/defaults/${tasks_locale}`,
        type: 'GET',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}
      })
      .done(function(data) {
        setState(data)
      })
      .fail(function(error) {
        console.log(error);
      })
    }

    function get_locale_from(country) {
      switch(country) {
        case 'United States':
        case 'Australia':
        case 'New Zealand':
          return 'en'
          break;
        case 'Chile':
        case 'Peru':
          return 'es'
          break;
        default:
          return 'en'
      }
    }

    function renderTasks() {
      const list = table_logbook_edit.find('tbody')
      const html = Task.create_from_array(state.tasks)
      list.append(html)
      Events.emit('taskmodal/render/idChecker', null)
    }

    return { init }
  })()

  TaskModal.setup()

  // Event triggered before modal will be show
  $('#plant_logbook').on('shown.bs.modal', function (e) {
    TaskModal.init()
  })

  // Event triggered before modal will be hidden
  $('#plant_logbook').on('hide.bs.modal', function (e) {
    $(".modal-backdrop").fadeOut('fast').remove()
  })
})
