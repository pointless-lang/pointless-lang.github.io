import { checkType } from "./pointless/src/values.js";
import { Env } from "./pointless/src/env.js";
import { repr, show } from "./pointless/src/repr.js";

export const shimConsole = {
  output: [],
  inputs: [],

  print(string, end = "\n") {
    this.output.push(string + end);
  },

  getOutput() {
    const result = this.output.join("");
    this.output = [];
    return result;
  },
};

const Console = {
  write(value) {
    checkType(value, "string");
    shimConsole.print(value, "");
    return value;
  },

  error(value) {
    shimConsole.print(show(value));
    return value;
  },

  print(value) {
    shimConsole.print(show(value));
    return value;
  },

  debug(value) {
    shimConsole.print(repr(value));
    return value;
  },

  prompt(message) {
    checkType(message, "string");
    const input = shimConsole.inputs.shift() ?? "";
    shimConsole.output.push(`${message}${input}\n`);
    return input;
  },
};

export const natives = {
  Async: await import("./pointless/std/Async.js"),
  Bool: await import("./pointless/std/Bool.js"),
  // Char: await import("./pointless/std/Char.js"),
  Console,
  Err: await import("./pointless/std/Err.js"),
  // Fs: await import("./pointless/std/Fs.js"),
  List: await import("./pointless/std/List.js"),
  Math: await import("./pointless/std/Math.js"),
  None: await import("./pointless/std/None.js"),
  Obj: await import("./pointless/std/Obj.js"),
  Panic: await import("./pointless/std/Panic.js"),
  Rand: await import("./pointless/std/Rand.js"),
  Ref: await import("./pointless/std/Ref.js"),
  Re: await import("./pointless/std/Re.js"),
  Set: await import("./pointless/std/Set.js"),
  Str: await import("./pointless/std/Str.js"),
  Table: await import("./pointless/std/Table.js"),
  Test: await import("./pointless/std/Test.js"),
};
