let debounce_ms = 500;
function handleChange(e) {
  let contents = e.target;
  let area = contents.fstdt__preview__area;
  let button = contents.fstdt__preview__button;
  if (button.getAttribute("aria-checked") == "true") {
    area.style.display = "block";
    if (contents.fstdt__preview__debounce === undefined) {
      contents.fstdt__preview__debounce = setTimeout(handleChangeDebounced, debounce_ms, contents);
    }
  } else {
    area.style.display = "none";
  }
}
function handleChangeDebounced(contents) {
  let area = contents.fstdt__preview__area;
  let button = contents.fstdt__preview__button;
  if (button.getAttribute("aria-checked") != "true") {
    delete contents.fstdt__preview__debounce;
    return;
  }
  let ajax = new XMLHttpRequest();
  let async = true;
  ajax.onreadystatechange = () => {
    if (button.getAttribute("aria-checked") != "true") {
      ajax.abort();
      delete contents.fstdt__preview__debounce;
    } else if (ajax.readyState === 4) {
      area.innerHTML = ajax.responseText;
      delete contents.fstdt__preview__debounce;
    }
  };
  ajax.open("POST", "/api/markdown-preview", async);
  ajax.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
  ajax.send(JSON.stringify({
    url: contents.fstdt__preview__url,
    contents: contents.value,
  }));
}
function handleButtonClick(e) {
  e.preventDefault();
  let button = e.target;
  let contents = button.fstdt__preview__contents;
  if (button.getAttribute("aria-checked") == "true") {
    button.setAttribute("aria-checked", "false");
  } else {
    button.setAttribute("aria-checked", "true");
  }
  handleChange({target: contents});
}
let templates = Array.prototype.slice.call(document.getElementsByClassName("js-preview"));
let template;
for (var i = 0; i !== templates.length; ++i) {
  template = templates[i];
  let contents = document.getElementById(template.getAttribute("data-preview-contents"));
  let preview = document.importNode(template.content, true);
  let button = preview.querySelector(".js-preview-button");
  let area = preview.querySelector(".js-preview-area");
  contents.fstdt__preview__area = area;
  contents.fstdt__preview__button = button;
  contents.fstdt__preview__url = template.getAttribute("data-preview-url");
  contents.addEventListener("keydown", handleChange);
  contents.addEventListener("keyup", handleChange);
  contents.addEventListener("change", handleChange);
  contents.addEventListener("paste", handleChange);
  contents.addEventListener("cut", handleChange);
  button.fstdt__preview__area = area;
  button.fstdt__preview__contents = contents;
  button.fstdt__preview__url = template.getAttribute("data-preview-url");
  button.addEventListener("click", handleButtonClick);
  handleChange({target: contents});
  template.parentNode.insertBefore(preview, template);
}
