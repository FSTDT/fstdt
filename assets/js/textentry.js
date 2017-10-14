let handleChange = function(e) {
  let field = e.target;
  let pre = field.fstdt__pre;
  let val = field.value;
  pre.innerHTML = "";
  pre.appendChild(document.createTextNode(field.value));
  pre.appendChild(document.createElement("br"));
  pre.appendChild(document.createElement("br"));
  let sty = window.getComputedStyle(pre);
  field.style.height = sty.height;
  field.style.width = sty.width;
};
let fields = document.getElementsByClassName("js-textentry");
let field;
for (field of fields) {
  let wrapper = document.createElement("div");
  wrapper.className = "textentry";
  let pre = document.createElement("pre");
  pre.className = "textentry-box";
  field.className = "textentry-box";
  field.parentNode.insertBefore(wrapper, field);
  field.parentNode.removeChild(field);
  field.fstdt__pre = pre;
  field.addEventListener("keydown", handleChange);
  field.addEventListener("keyup", handleChange);
  field.addEventListener("change", handleChange);
  field.addEventListener("paste", handleChange);
  field.addEventListener("cut", handleChange);
  wrapper.appendChild(field);
  wrapper.appendChild(pre);
  handleChange({target: field});
}
