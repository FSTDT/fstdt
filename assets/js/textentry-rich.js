let utils = require("./textentry-utils");

let handleClick = function(e) {
  e.preventDefault();
  let button = e.target;
  let field = button.fstdt__rich__contents;
  switch (button.fstdt__rich__action) {
    case "strong":
      utils.wrapTextToggle(field, "**", "**");
      break;
    case "em":
      utils.wrapTextToggle(field, "*", "*");
      break;
    case "blockquote":
      let startPos = field.selectionStart;
      let endPos = field.selectionEnd;
      let beforePart = field.value.substring(0, startPos);
      let beforePartNl = beforePart.lastIndexOf("\n");
      if (beforePartNl != -1) {
        beforePart = beforePart.substring(0, beforePartNl) + "\n> " + beforePart.substring(beforePartNl+1);
      }
      let insidePart = field.value.substring(startPos, endPos);
      let insidePartNl = insidePart.indexOf("\n");
      while (insidePartNl != -1) {
        insidePart = insidePart.substring(0, insidePartNl) + "\n> " + insidePart.substring(insidePartNl+1);
        insidePartNl = insidePart.indexOf("\n", insidePartNl + 1);
      }
      let afterPart = field.value.substring(endPos);
      field.value = beforePart + insidePart + afterPart;
      break;
    default:
      console.log("[rich] unknown action: " + button.fstdt__rich__action);
  }
}

let templates = Array.prototype.slice.call(document.getElementsByClassName("js-rich"));
let templates_l = templates.length;
let template;
for (let i = 0; i != templates_l; ++i) {
  template = templates[i];
  let contents = document.getElementById(template.getAttribute("data-rich-contents"));
  let rich = document.importNode(template.content, true);
  let buttons = rich.querySelectorAll("button");
  let buttons_l = buttons.length;
  let button;
  for (let j = 0; j != buttons_l; ++j) {
    button = buttons[j];
    button.fstdt__rich__contents = contents;
    button.fstdt__rich__action = button.getAttribute("data-rich-action");
    button.addEventListener("click", handleClick);
  }
  template.parentNode.insertBefore(rich, template);
}
