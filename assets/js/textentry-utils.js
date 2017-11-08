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
}

module.exports = {
  insertAtCursor: insertAtCursor,
  getSelected: getSelected
};
