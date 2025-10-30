import { CodeJar, ptls } from "/bundle.js";

const editor = document.querySelector("#editor");
const run = document.querySelector("#run");
const stop = document.querySelector("#stop");
const output = document.querySelector("#output");

function highlight() {
  const tokens = ptls.tokenize("editor", jar.toString());
  editor.innerHTML = ptls.highlight(tokens);
}

const jar = CodeJar(editor, highlight);

function saveSource() {
  localStorage.setItem("source", jar.toString());
}

const sourceUrl = new URLSearchParams(location.search).get("source");
let source;

if (sourceUrl) {
  const response = await fetch(sourceUrl);
  source = await response.text();
} else {
  source = localStorage.getItem("source") ?? "";
}

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

jar.onUpdate(saveSource);

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
    output.innerText += err.toString();
    throw err;
  }
};

stop.onclick = () => {
  runtime.halted = true;
};
