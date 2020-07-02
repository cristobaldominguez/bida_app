document.addEventListener('turbolinks:load', function() {
  'use strict'

  const options = typeof pikaday_locale !== 'undefined' ? pikaday_locale : {}

  const DatePicker = (() => {
    const state = {}
    function init() {

      const datepickers = document.querySelectorAll('input.datepicker')

      if (datepickers.length > 0) {
        datepickers.forEach(function(datepicker){
          let picker = new Pikaday({
            ...options,
            field: datepicker,
            format: 'DD/MM/YYYY',
            toString(date, format) {
                const day = date.getDate();
                const month = date.getMonth() + 1;
                const year = date.getFullYear();
                return `${year}-${month}-${day}`;
            },
            parse(dateString, format) {
                const parts = dateString.split('/');
                const day = parseInt(parts[0], 10);
                const month = parseInt(parts[1], 10) - 1;
                const year = parseInt(parts[2], 10);
                return new Date(year, month, day);
            }
          });
        })
      }
    }
    return { init, state}
  })()

  DatePicker.init()
})
