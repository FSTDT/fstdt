const resize_debounce_ms = 250;

let fields = Array.prototype.slice.call(document.getElementsByClassName("js-textentry"));
let field;
let field_l = fields.length;

var toMarkdown = require("to-markdown");
var utils = require("./textentry-utils");

let doHandleChange = function(field) {
  let pre = field.fstdt__textentry__pre;
  let val = field.value;
  pre.innerHTML = "";
  pre.appendChild(document.createTextNode(field.value));
  pre.appendChild(document.createElement("br"));
  pre.appendChild(document.createElement("br"));
  let sty = window.getComputedStyle(pre);
  field.style.height = sty.height;
  field.style.width = sty.width;
};
let handleChange = function(e) {
  doHandleChange(e.target);
};
let windowHandleChange = function() {
  if (!window.fstdt__textentry__window__debounce) {
    window.fstdt__textentry__window__debounce = setTimeout(doWindowHandleChange, resize_debounce_ms);
  }
};
let doWindowHandleChange = function() {
  for (let i = 0; i !== field_l; ++i) {
    doHandleChange(fields[i]);
  }
  delete window.fstdt__textentry__window__debounce;
};
let handlePaste = function(e) {
  let field = e.target;
  let items = e.clipboardData.items;
  let items_l = items.length;
  let used_item;
  let used_goodness = 0;
  let text;
  for (let i = 0; i !== items_l; ++i) {
    let item = items[i];
    let goodness = -1;
    switch (item.type.split(';')[0].replace(' ', '')) {
      case "text/uri-list":
        goodness = 1;
        break;
      case "text/plain":
        goodness = 2;
        break;
      case "text/html":
      case "application/xhtml+xml":
        goodness = 3;
        break;
      case "text/markdown":
        goodness = 4;
        break;
      default:
        console.log("[paste] unsupported clipboard type: " + item.type);
    }
    if (goodness > used_goodness) {
      used_item = item;
      used_goodness = goodness;
    }
  }
  if (used_goodness !== 0) {
    e.preventDefault();
    if (used_item.type === "text/html") {
      console.log("[paste] convert HTML to Markdown");
      used_item.getAsString(text => {
        utils.insertAtCursor(field, toMarkdown(text))
        handleChange(e);
      });
    } else {
      console.log("[paste] plain text");
      used_item.getAsString(text => {
        utils.insertAtCursor(field, text)
        handleChange(e);
      });
    }
  } else {
    console.log("[paste] #13 support uploading images");
  }
};
for (let i = 0; i !== field_l; ++i) {
  field = fields[i];
  let wrapper = document.createElement("div");
  wrapper.className = "textentry";
  let pre = document.createElement("pre");
  pre.className = "textentry-box";
  field.className = "textentry-box";
  field.parentNode.insertBefore(wrapper, field);
  field.parentNode.removeChild(field);
  field.fstdt__textentry__pre = pre;
  field.addEventListener("keydown", handleChange);
  field.addEventListener("keyup", handleChange);
  field.addEventListener("change", handleChange);
  field.addEventListener("paste", handlePaste);
  field.addEventListener("cut", handleChange);
  wrapper.appendChild(field);
  wrapper.appendChild(pre);
  setTimeout(() => handleChange({target: field}), 0);
}
window.addEventListener("resize", windowHandleChange);
