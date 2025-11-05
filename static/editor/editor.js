import { CodeJar, ptls } from "/bundle.js";

const editor = document.querySelector("#editor");
const run = document.querySelector("#run");
const stop = document.querySelector("#stop");
const output = document.querySelector("#output");

function highlight() {
  const tokens = ptls.tokenize("editor", jar.toString());
  editor.innerHTML = ptls.highlight(tokens);
}

editor.addEventListener("keydown", (event) => {
  if (event.ctrlKey && event.key === "Enter") {
    event.preventDefault();
    run.onclick();
  }
});

const jar = CodeJar(editor, highlight, {
  tab: "  ",
  moveToNewline: null,
  addClosing: false,
  autoclose: null,
});

setTimeout(() => editor.focus(), 50);

function saveSource() {
  localStorage.setItem("source", jar.toString());
}

function sourceUrl() {
  return new URLSearchParams(location.search).get("source");
}

async function loadUrl(url) {
  const response = await fetch(url);
  return await response.text();
}

const source = sourceUrl()
  ? await loadUrl(sourceUrl())
  : localStorage.getItem("source") ??
    await loadUrl("/examples/hailstone/hailstone.ptls");

jar.updateCode(source);

saveSource();

const Console = {
  clear() {
    output.innerText = "";
  },

  async print(value) {
    output.innerText += await ptls.repr(value, { rawStr: true }) + "\n";
  },

  write(string) {
    output.innerText += string;
  },
};

jar.onUpdate((code) => {
  if (sourceUrl() && code !== source) {
    window.history.pushState({}, "", window.location.pathname);
  } else {
    saveSource();
  }
});

window.onpopstate = () => {
  jar.updateCode(source);
};

const runtime = new ptls.Runtime({ ...ptls.impl, Console }, {});

run.onclick = async () => {
  try {
    runtime.halted = true;
    await new Promise((resolve) => setTimeout(resolve, 50));
    Console.clear();

    const tokens = ptls.tokenize("editor", jar.toString());
    const statements = ptls.parse(tokens);
    runtime.halted = false;

    await runtime.spawnEnv().eval(statements);
  } catch (err) {
    output.innerText += await err.repr();
    throw err;
  }
};

stop.onclick = () => {
  runtime.halted = true;
};
