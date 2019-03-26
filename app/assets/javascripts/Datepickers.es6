document.addEventListener('turbolinks:load', function() {
  'use strict'

  const DatePicker = (() => {
    const state = {}
    function init() {

      const datepickers = document.querySelectorAll('input.datepicker')

      if (datepickers.length > 0) {
        datepickers.forEach(function(datepicker){
          let picker = new Pikaday({
            field: datepicker,
            format: 'DD/MM/YYYY',
            toString(date, format) {
                const day = date.getDate();
                const month = date.getMonth() + 1;
                const year = date.getFullYear();
                return `${year}-${month}-${day}`;
            },
            parse(dateString, format) {
                // dateString is the result of `toString` method
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
