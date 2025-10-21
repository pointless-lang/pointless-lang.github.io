import { tokenize } from "./pointless/lang/tokenizer.js";
import { parse } from "./pointless/lang/parser.js";
import { Panic } from "./pointless/lang/panic.js";
import { highlight } from "./pointless/render/highlight.js";
import { show } from "./pointless/lang/repr.js";
import { CodeJar, makeRuntime } from "./runtime.js";

const hl = (editor) => {
  const tokens = tokenize("editor", editor.textContent);
  editor.innerHTML = highlight(tokens);
};

const jar = CodeJar(document.querySelector("#source"), hl);

// const textarea = document.querySelector("#source textarea");
// const highlighted = document.querySelector("#source pre code");
// const output = document.querySelector("#output");
// const run = document.querySelector("#run");

// textarea.oninput = async () => {
//   const tokens = tokenize("editor", textarea.value);
//   highlighted.innerHTML = highlight(tokens);

//   const statements = parse(tokens);
//   // await (await spawnStd()).eval(statements)
// };

// await textarea.oninput();

const Console = {
  clear() {
    output.innerText = "";
  },

  print(value) {
    output.innerText += show(value) + "\n";
  },

  write(string) {
    output.innerText += string;
  },
};

const shim = { Console };

run.onclick = async () => {
  try {
    const tokens = tokenize("editor", jar.toString());
    const statements = parse(tokens);
    const runtime = makeRuntime(shim, {});
    await runtime.spawnEnv().eval(statements);
  } catch (err) {
    console.log(err.toString());
  }
};

// textarea.onscroll = () => {

// }
