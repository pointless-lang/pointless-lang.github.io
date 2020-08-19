
// ---------------------------------------------------------------------------

function convertValue(value) {
  if (value instanceof HTMLElement) {
    return value;
  }
  return document.createTextNode(value.toString());
}

// ---------------------------------------------------------------------------

function makeNode(tag, children) {
  let node = document.createElement(tag);
  children.map(convertValue).map(node.appendChild.bind(node));
  return node;
}

// ---------------------------------------------------------------------------

function H(tag, attrs = {}) {
  return (...children) => {
    let node = makeNode(tag, children)
    Object.keys(attrs).map(key => node.setAttribute(key, attrs[key]));
    return node;
  }
}

// ---------------------------------------------------------------------------

let $ = document.querySelectorAll.bind(document);

// ---------------------------------------------------------------------------

$(".highlight").forEach((elem) => {
  let a = H("code", {spellcheck: false})();

  let initText = elem.innerText;
  elem.innerHTML = "";
  elem.appendChild(a);

  if (elem.dataset.edit === undefined) {
    a.style.position = "static";
    a.style.userSelect = "auto";

    try {
      a.innerHTML = highlight(initText);

    } catch (err) {
      console.log(err.message);
      a.innerHTML = initText;
    }
    return;
  }

  let b = H("textarea", {spellcheck: false, autofocus: true})(initText);
  elem.appendChild(b);

  let storeid = elem.dataset.storeid;
  if (storeid !== undefined && localStorage.getItem(storeid) !== null) {
    b.value = localStorage.getItem(storeid);
  }

  // -------------------------------------------------------------------------

  function update() {
    let storeid = elem.dataset.storeid;
    if (storeid !== undefined) {
      localStorage.setItem(storeid, b.value);
    }

    try {
      a.innerHTML = highlight(b.value);

    } catch (err) {
      console.log(err.message);
      a.innerHTML = b.value;
    }
    alignScrolls();
  }

  // -------------------------------------------------------------------------

  b.addEventListener("input", update);
  b.addEventListener("paste", update);
  b.addEventListener("cut", update);
  update();

  b.addEventListener("scroll", alignScrolls);

  function alignScrolls() {
    b.scrollTop = Math.min(b.scrollTop, a.scrollHeight - a.offsetHeight)
    a.scrollTop = b.scrollTop;
    a.scrollLeft = b.scrollLeft;
  }
});
