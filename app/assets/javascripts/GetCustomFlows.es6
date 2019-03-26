document.addEventListener('turbolinks:load', function() {
  const GetCustomFlows = (() => {
    const state = {
        prev_days: 0,
        days_of_month: 0
    }

    const config = {
      api: {
        base: '/plants/1/flow_reports/custom.json',
        headers : { method: 'GET', mode: 'cors' },
        url: function(year, month) { return `${this.base}?date=${year}-${month}&items=1` }
      }
    }

    // CacheDom
    const dates  = document.querySelectorAll('[id^="flow_report_date"]')
    const _flows = document.querySelector('ul.flows')
    const flows__flow = _flows ? _flows.querySelectorAll('li.flows__flow') : null

    // Bind Events
    if (dates) {
      dates.forEach(function(date){
        date.addEventListener('change', get_api_data)
      })
    }

    function init(){
      Events.on('core/state', core_state)
      Events.on('core/algorithm', core_algorithm)
      Events.on('state/html', regenerate_html)
      Events.on('state/render', render)
      Events.on('init/html', init_html)
      Events.emit('init/html', null)
    }

    function get_api_data(e) {
      const [_, month, year] = dates

      fetch(config.api.url(year.value, month.value), config.api.headers)
      .then(function(response) {
        if (response.status !== 200) {
          return console.log('Looks like there was a problem. Status Code: ' + response.status)
        }
        return response.json()
      })
      .then(data => Events.emit('core/algorithm', data))
      .catch(error => console.log('Huston, we have a problem:' + error.message))
    }

    const core_algorithm = (data) => {
      const { month, year, days_of_month } = data
      Events.emit('state/html', { year, month, days_of_month })
    }

    const core_state = (data) => {
      this.state = {...state, ...data}
      Events.emit('state/render', null)
    }

    function init_html() {
      if (!_flows) { return }
      state.html = flows__flow
      state.prev_days = state.html.length
      state.days_of_month = state.html.length
    }

    function regenerate_html({ year, month, days_of_month }) {
      let html = []

      for (let i = 0; i < days_of_month; i++) {
        const current_value = state.html[i].querySelector('input[type="number"]').value || '0.0'
        const current_id = state.html[i].querySelector('input[type="hidden"][id^="flow_report_flows_attributes"]').nextSibling.nextSibling.value
        const day = i < 9 ? `0${i + 1}` : i + 1
        let li = document.createElement('li')
        li.className = 'flows__flow'
        li.innerHTML = `<strong>${ day }:</strong>
                        <span class="bmd-form-group is-filled">
                          <input autocomplete="off" step="0.0001" type="number" value="${ current_value }" name="flow_report[flows_attributes][${ i }][value]" id="flow_report_flows_attributes_${ i }_value">
                        </span>
                        <input type="hidden" value="${ year }-${ month }-${ day }" name="flow_report[flows_attributes][${ i }][date]" id="flow_report_flows_attributes_${ i }_date">
                        <input type="hidden" value="${ current_id }" name="flow_report[flows_attributes][${ i }][id]" id="flow_report_flows_attributes_${ i }_id">`

        html.push(li)
      }

      Events.emit('core/state', { html })
    }

    const render = () => {
      _flows.innerHTML = ''
      this.state.html.forEach(function(node) {
        _flows.appendChild(node)
      })
    }

    return {
        init, state
      }
  })()

  GetCustomFlows.init()
})
