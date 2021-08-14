import { createApp } from 'vue'
import Chart from './chart'

document.addEventListener('turbolinks:load', () => {
  const selector = '#js-chart';
  const chart = document.querySelector(selector)
  if (chart) {
    const chartId = Number(chart.getAttribute('data-chart-id'))
    const currentUserId = Number(chart.getAttribute('data-current-user-id'))
    const app = createApp(Chart, { chartId: chartId, currentUserId: currentUserId })
    app.mount(selector)
  }
})
