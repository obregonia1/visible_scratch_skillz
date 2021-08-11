import { createApp } from 'vue'
import Chart from './chart'

document.addEventListener('turbolinks:load', () => {
  const selector = '#js-chart';
  const chart = document.querySelector(selector)
  if (chart) {
    const chartId = Number(chart.getAttribute('data-chart-id'))
    const app = createApp(Chart, {chartId: chartId})
    app.mount(selector)
  }
})
