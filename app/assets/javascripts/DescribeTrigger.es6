document.addEventListener('turbolinks:load', function() {
  const DescribeTrigger = (() => {
    const state = {}

    // CacheDom
    const selects = document.querySelectorAll('select')

    // Bind Events
    selects.forEach(function(select){
      select.addEventListener('change', onChange)
    })

    function init() {}

    function onChange(e){
      const sel = getSelectedText(e.target)
      const response = checkRegex(sel)
      const target = this.parentNode.parentNode.nextSibling.nextSibling

      if (response) {
        target.classList.add('show')
      } else {
        target.classList.remove('show')
      }
    }

    function checkRegex(text) {
      const regex = /\([\w]+\)/
      return regex.test(text)
    }

    function getSelectedText(elt) {
        if (elt.selectedIndex == -1){ return null }
        return elt.options[elt.selectedIndex].text;
    }

    return {
        init, state
    }

  })()

  DescribeTrigger.init()
})
