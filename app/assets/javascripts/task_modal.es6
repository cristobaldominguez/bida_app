document.addEventListener('turbolinks:load', function() {
  const TaskModal = (() => {

    const state = {
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

        responsible: parseInt(element.find('.responsible').val())
      }

      state.data = {
        ..._data,
        cycles: _data.cycles ? JSON.parse(_data.cycles) : { days: [], months: [] },
        responsible: isNaN(_data.responsible) ? '' : _data.responsible
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
      const option_selected = $(this).find('option:selected').text()
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
        removeTaskIds()
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
    }

    function deleteTask(e) {
      e.preventDefault()
      const _parent = $(e.target).closest('.table_main__table-row')
      _parent.remove()
    }

    return {
        init, state
    }
  })()

  const Task = (() => {

    function tr(_class) {
      const _tr = document.createElement('tr')
      const cl_array = _class.split(' ')
      cl_array.forEach((cl, i) => _tr.classList.add(cl) )

      return _tr
    }

    function td(_class) {
      const _td = document.createElement('td')
      const cl_array = _class.split(' ')
      cl_array.forEach((cl, i) => _td.classList.add(cl) )

      return _td
    }

    function input({ name, type, value, checked, id, _class }) {
      const _input = document.createElement('input')

      if (id) { _input.id = id }
      if (type) { _input.type = type }
      if (name) { _input.name = name }
      if (value) { _input.value = value }
      if (_class) { _class.split(' ').forEach((cl, i) => _input.classList.add(cl) ) }
      if (typeof checked !== 'undefined') { _input.checked = checked }

      return _input
    }

    function span(_class) {
      const _span = document.createElement('span')
      const cl_array = _class.split(' ')
      cl_array.forEach((cl, i) => _span.classList.add(cl) )

      return _span
    }

    function link({ href, _class, text, confirm }) {
      const _link = document.createElement('a')
      _link.href = href
      const cl_array = _class.split(' ')
      cl_array.forEach((cl, i) => _link.classList.add(cl) )

      if (text) { _link.innerText = text }
      if (confirm) { _link.dataset.confirm = confirm }

      return _link
    }

    function div(_class) {
      const _div = document.createElement('div')
      const cl_array = _class.split(' ')
      cl_array.forEach((cl, i) => _div.classList.add(cl) )

      return _div
    }

    function ul(_class) {
      const _ul = document.createElement('ul')
      const cl_array = _class.split(' ')
      cl_array.forEach((cl, i) => _ul.classList.add(cl) )

      return _ul
    }

    function li(_class) {
      const _li = document.createElement('li')
      const cl_array = _class.split(' ')
      cl_array.forEach((cl, i) => _li.classList.add(cl) )

      return _li
    }

    function create({ id, task_list_id, plant_id }) {

      const _tr = tr('table_main__table-row')
      const td_01 = td('table_main__table-data--left-text')
      td_01.innerHTML = `<input name="plant[task_lists_attributes][0][tasks_attributes][${ id }][active]" type="hidden" value="0">
      <input type="checkbox" value="1" checked="checked" name="plant[task_lists_attributes][0][tasks_attributes][${ id }][active]" id="plant_task_lists_attributes_0_tasks_attributes_${ id }_active">`

      const td_02 = td('table_main__table-data--left-text')
      td_02.innerHTML = `<input type="hidden" value="${ task_list_id }" name="plant[task_lists_attributes][0][id]" id="plant_task_lists_attributes_0_id">
      <input type="hidden" value="${ plant_id }" name="plant[task_lists_attributes][0][plant_id]" id="plant_task_lists_attributes_0_plant_id">`


      const input_02_03 = input({ type: 'hidden', name: `plant[task_lists_attributes][0][tasks_attributes][${ id }][id]`, id: `plant_task_lists_attributes_0_tasks_attributes_${ id }_id` })
      const input_02_04 = input({ type: 'hidden', name: `plant[task_lists_attributes][0][tasks_attributes][${ id }][task_list_id]`, id: `plant_task_lists_attributes_0_tasks_attributes_${ id }_task_list_id`, value: task_list_id.toString() })

      const input_02_05 = input({ type: 'hidden', _class: 'name', name: `plant[task_lists_attributes][0][tasks_attributes][${ id }][name]`, id: `plant_task_lists_attributes_0_tasks_attributes_${ id }_name` })
      const input_02_06 = input({ type: 'hidden', _class: 'season', name: `plant[task_lists_attributes][0][tasks_attributes][${ id }][season]`, id: `plant_task_lists_attributes_0_tasks_attributes_${ id }_season`})
      const input_02_07 = input({ type: 'hidden', _class: 'comment', name: `plant[task_lists_attributes][0][tasks_attributes][${ id }][comment]`, id: `plant_task_lists_attributes_0_tasks_attributes_${ id }_comment`})
      const input_02_08 = input({ type: 'hidden', _class: 'responsible', name: `plant[task_lists_attributes][0][tasks_attributes][${ id }][responsible]`, id: `plant_task_lists_attributes_0_tasks_attributes_${ id }_responsible`})
      const input_02_09 = input({ type: 'hidden', _class: 'input_type', name: `plant[task_lists_attributes][0][tasks_attributes][${ id }][input_type]`, id: `plant_task_lists_attributes_0_tasks_attributes_${ id }_input_type`})
      const input_02_10 = input({ type: 'hidden', _class: 'data_type', name: `plant[task_lists_attributes][0][tasks_attributes][${ id }][data_type]`, id: `plant_task_lists_attributes_0_tasks_attributes_${ id }_data_type`})
      const input_02_11 = input({ type: 'hidden', _class: 'frecuency', name: `plant[task_lists_attributes][0][tasks_attributes][${ id }][frecuency]`, id: `plant_task_lists_attributes_0_tasks_attributes_${ id }_frecuency`})
      const input_02_12 = input({ type: 'hidden', _class: 'cycle', name: `plant[task_lists_attributes][0][tasks_attributes][${ id }][cycle]`, id: `plant_task_lists_attributes_0_tasks_attributes_${ id }_cycle`})
      const span_name = span('span_name')

      const td_03 = td('table_main__table-data--options')
      const link_options = link({ href: '#', _class: 'table_main__link--options' })

      const div_options = div('options_menu')
      const ul_options = ul('options_menu__list')
      const li_options_01 = li('options_menu__item')
      const link_options_01 = link({ href: '#', _class: 'options_menu__link--modal-show', text: 'show' })
      const li_options_02 = li('options_menu__item')
      const link_options_02 = link({ href: '#', _class: 'options_menu__link--modal-edit', text: 'edit' })
      const li_options_03 = li('options_menu__item')
      const link_options_03 = link({ href: '#', _class: 'options_menu__link--modal-destroy', text: 'destroy', confirm: 'Are you sure?' })
      const unclick = div('unclick')


      td_02.appendChild(input_02_03)
      td_02.appendChild(input_02_04)

      td_02.appendChild(input_02_05)
      td_02.appendChild(input_02_06)
      td_02.appendChild(input_02_07)
      td_02.appendChild(input_02_08)
      td_02.appendChild(input_02_09)
      td_02.appendChild(input_02_10)
      td_02.appendChild(input_02_11)
      td_02.appendChild(input_02_12)
      td_02.appendChild(span_name)

      td_03.appendChild(link_options)
      td_03.appendChild(div_options)

      li_options_01.appendChild(link_options_01)
      ul_options.appendChild(li_options_01)
      li_options_02.appendChild(link_options_02)
      ul_options.appendChild(li_options_02)
      li_options_03.appendChild(link_options_03)
      ul_options.appendChild(li_options_03)
      div_options.appendChild(ul_options)
      div_options.appendChild(unclick)


      _tr.appendChild(td_01)
      _tr.appendChild(td_02)
      _tr.appendChild(td_03)

      return _tr
    }

    return {
      create
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
