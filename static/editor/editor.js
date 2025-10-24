import { CodeJar, ptls } from "/bundle.js";

function highlight() {
  const tokens = ptls.tokenize("editor", jar.toString());
  editor.innerHTML = ptls.highlight(tokens);
}

const jar = CodeJar(document.querySelector("#editor"), highlight);

function saveSource() {
  localStorage.setItem("source", jar.toString());
}

jar.updateCode(
  new URLSearchParams(location.search).get("source") ??
    localStorage.getItem("source") ?? "",
);

saveSource();

const Console = {
  clear() {
    output.innerText = "";
  },

  print(value) {
    output.innerText += ptls.show(value) + "\n";
  },

  write(string) {
    output.innerText += string;
  },
};

jar.onUpdate(saveSource);

run.onclick = async () => {
  try {
    Console.clear();
    const tokens = ptls.tokenize("editor", jar.toString());
    const statements = ptls.parse(tokens);
    const runtime = new ptls.Runtime({ ...ptls.impl, Console }, {});
    await runtime.spawnEnv().eval(statements);
  } catch (err) {
    output.innerText = err.toString();
    throw err;
  }
};
