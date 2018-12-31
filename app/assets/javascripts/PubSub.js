const Events = (() => {
  const topics = {}
  const hOP = topics.hasOwnProperty

  return {
    on: (topic, listener) => {
      if(!hOP.call(topics, topic)) topics[topic] = []
      const index = topics[topic].push(listener) -1

      return {
        remove: () => {
          delete topics[topic][index]
        },
      }
    },
    emit: (topic, info) => {
      if(!hOP.call(topics, topic)) return
      topics[topic].forEach(item => {
        item(info != undefined ? info : {})
      })
    }
  }
})()

const Observer = (() => {
  const observers = []

  return {
    subscribe: observer => observers.push(observer),
    notifyAll: () => observers.map(x => x())
  }
})()
