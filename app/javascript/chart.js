import { createApp } from 'vue'
import App from './chart'

document.addEventListener('turbolinks:load', () => {
  const selector = '#js-chart';
  const chart = document.querySelector(selector)
  if (chart) {
    const app = createApp(App)
    app.mount(selector)
  }
})
