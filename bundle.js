export { CodeJar } from "codejar";

import { tokenize } from "./node_modules/pointless/lang/tokenizer.js";
import { parse } from "./node_modules/pointless/lang/parser.js";
import { Panic } from "./node_modules/pointless/lang/panic.js";
import { highlight } from "./node_modules/pointless/render/highlight.js";
import { repr } from "./node_modules/pointless/lang/repr.js";
import { Runtime } from "./node_modules/pointless/runtime/runtime.js";

const impl = {
  Async: await import("./node_modules/pointless/std/Async.js"),
  Bool: await import("./node_modules/pointless/std/Bool.js"),
  Char: await import("./node_modules/pointless/std/Char.js"),
  // Console: await import("./node_modules/pointless/std/Console.js"),
  Err: await import("./node_modules/pointless/std/Err.js"),
  // Fs: await import("./node_modules/pointless/std/Fs.js"),
  List: await import("./node_modules/pointless/std/List.js"),
  Math: await import("./node_modules/pointless/std/Math.js"),
  Obj: await import("./node_modules/pointless/std/Obj.js"),
  Panic: await import("./node_modules/pointless/std/Panic.js"),
  Rand: await import("./node_modules/pointless/std/Rand.js"),
  Ref: await import("./node_modules/pointless/std/Ref.js"),
  Re: await import("./node_modules/pointless/std/Re.js"),
  Set: await import("./node_modules/pointless/std/Set.js"),
  Str: await import("./node_modules/pointless/std/Str.js"),
  Table: await import("./node_modules/pointless/std/Table.js"),
  Test: await import("./node_modules/pointless/std/Test.js"),
};

export const ptls = { tokenize, parse, Panic, highlight, repr, Runtime, impl };
