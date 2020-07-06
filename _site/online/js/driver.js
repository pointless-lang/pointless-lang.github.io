
// $ defined in highlight.js

// ---------------------------------------------------------------------------

let output = $("#output")[0];
let source = $("#source")[0];
let program = source.children[1];

// ---------------------------------------------------------------------------

function clearConsole() {
  output.innerText = "";
}

// ---------------------------------------------------------------------------

function printOut(value) {
  output.innerText += value;
  output.scrollTop = output.scrollHeight;
}

// ---------------------------------------------------------------------------

function handleOutput() {
  try {
    if (getOutput()) {
      requestAnimationFrame(handleOutput);
    }

  } catch (err) {
    console.log(err);
    printOut(err.message);
  }
}

// ---------------------------------------------------------------------------

function run() {
  try {
    clearConsole();
    runProgram(program.value);
    requestAnimationFrame(handleOutput);

  } catch (err) {
    console.log(err);
    printOut(err.message);
  }
}

function debugHandler(value) {
  printOut(value + "\n");
}

// ---------------------------------------------------------------------------

let runButton = $("#runButton")[0];
runButton.addEventListener("click", run); 
