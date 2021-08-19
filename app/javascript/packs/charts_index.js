document.addEventListener('DOMContentLoaded', () => {
  function copy() {
    const tmp = document.createElement("div");
    const pre = document.createElement('pre');

    pre.style.webkitUserSelect = 'auto';
    pre.style.userSelect = 'auto';

    const input = this.previousElementSibling
    const url = input.getAttribute('value')
    this.innerHTML = 'Copied!'

    tmp.appendChild(pre).textContent = url
    document.body.appendChild(tmp);
    document.getSelection().selectAllChildren(tmp);

    const result = document.execCommand("copy");

    document.body.removeChild(tmp);

    return result;
  }

  const copyButtons = document.getElementsByClassName("vss-copy-button")
  Array.prototype.forEach.call(copyButtons, function(button) {
    button.addEventListener("click", copy)
  })
})
