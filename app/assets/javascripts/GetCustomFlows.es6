document.addEventListener('turbolinks:load', function() {
  const GetCustomFlows = (() => {
    const state = {
        prev_days: 0,
        days_of_month: 0
    }

    // CacheDom
    const dates  = document.querySelectorAll('[id^="flow_report_date"]')
    const flows = document.querySelector('ul.flows')

    // Bind Events
    if (dates) {
      dates.forEach(function(date){
        date.addEventListener('change', get_api_data)
      })
    }

    function init(){
      Events.on('state/render', render)
    }

    function get_api_data(e) {
      const [_, month, year] = dates

      const api_params = {
        url: `/plants/1/flow_reports/custom.json?date=${year.value}-${month.value}`,
        headers : { method: 'GET', mode: 'cors' }
      }

      fetch(api_params.url, api_params.headers)
      .then(function(response) {
        if (response.status !== 200) {
          console.log('Looks like there was a problem. Status Code: ' + response.status);
          return;
        }
        return response.json()
      })
      .then(function(data){
        const prev_days = GetCustomFlows.state.days_of_month
        GetCustomFlows.state = {prev_days, ...data}
        Events.emit('state/render', null)
      })
      .catch(function(error) {
        console.log('Huston, we have a problem:' + error.message);
      })
    }

    function render() {
      flows.innerHTML = ''

      for (let i = 0; i < GetCustomFlows.state.days_of_month; i++) {
        const day = i < 9 ? `0${i + 1}` : i + 1;
        let li = document.createElement('li')
        li.className = 'flow'
        li.innerHTML = `<strong>${ day }:</strong>
                  <span class="bmd-form-group is-filled">
                    <input autocomplete="off" step="0.0001" type="number" value="0.0" name="flow_report[flows_attributes][${i}][value]" id="flow_report_flows_attributes_${i}_value">
                  </span>
                  <input type="hidden" value="${GetCustomFlows.state.year}-${GetCustomFlows.state.month}-${ day }" name="flow_report[flows_attributes][${i}][date]" id="flow_report_flows_attributes_${i}_date">`
        flows.appendChild(li)
      }

    }

    return {
        init, state
      }
  })()

  GetCustomFlows.init()
})
