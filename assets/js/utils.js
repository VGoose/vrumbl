function esc(str) {
  let div = document.createElement("div");
  div.appendChild(document.createTextNode(str));
  return div.innerHTML;
}

function formatTime(at) {
  let date = new Date(null);
  date.setSeconds(at / 1000);
  return date.toISOString().substr(14, 5);
}

export { esc, formatTime };
