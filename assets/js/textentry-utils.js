let insertAtCursor = function(field, text) {
  let startPos = field.selectionStart;
  let endPos = field.selectionEnd;
  field.value = field.value.substring(0, startPos) + text +
    field.value.substring(endPos, field.value.length);
  field.selectionStart = startPos + text.length;
  field.selectionEnd = startPos + text.length;
};

let getSelected = function(field) {
  let startPos = field.selectionStart;
  let endPos = field.selectionEnd;
  return field.value.substring(startPos, endPos);
};

let wrapTextToggle = function(field, before, after) {
  let startPos = field.selectionStart;
  let endPos = field.selectionEnd;
  let beforePart = field.value.substring(0, startPos);
  let insidePart = field.value.substring(startPos, endPos);
  let afterPart = field.value.substring(endPos);
  if (beforePart.endsWith(before) && afterPart.startsWith(after)) {
    beforePart = beforePart.substring(0, beforePart.length - before.length);
    afterPart = afterPart.substring(after.length);
  } else {
    beforePart = beforePart + before;
    afterPart = after + afterPart;
  }
  field.value = beforePart + insidePart + afterPart;
  field.focus();
  field.selectionStart = beforePart.length;
  field.selectionEnd = beforePart.length + insidePart.length;
};

module.exports = {
  insertAtCursor: insertAtCursor,
  getSelected: getSelected,
  wrapTextToggle: wrapTextToggle,
};
