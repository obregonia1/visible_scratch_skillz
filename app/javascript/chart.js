import { createApp } from 'vue'
import App from './chart.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-chart';
  if (document.querySelector(selector)) {
    createApp(App).mount(selector);
  }
})
