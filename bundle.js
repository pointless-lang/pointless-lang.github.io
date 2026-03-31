export { CodeJar } from "codejar";

import { tokenize } from "pointless/lang/tokenizer.js";
import { parse } from "pointless/lang/parser.js";
import { Panic } from "pointless/lang/panic.js";
import { Highlighter } from "pointless/utils/highlight.js";
import { repr } from "pointless/lang/repr.js";
import { Runtime } from "pointless/runtime/runtime.js";

const impl = {
  Async: await import("pointless/std/Async.js"),
  Bool: await import("pointless/std/Bool.js"),
  Char: await import("pointless/std/Char.js"),
  // Console: await import("pointless/std/Console.js"),
  Err: await import("pointless/std/Err.js"),
  // Fs: await import("pointless/std/Fs.js"),
  List: await import("pointless/std/List.js"),
  Math: await import("pointless/std/Math.js"),
  Obj: await import("pointless/std/Obj.js"),
  Panic: await import("pointless/std/Panic.js"),
  Rand: await import("pointless/std/Rand.js"),
  Ref: await import("pointless/std/Ref.js"),
  Re: await import("pointless/std/Re.js"),
  Set: await import("pointless/std/Set.js"),
  Str: await import("pointless/std/Str.js"),
  Table: await import("pointless/std/Table.js"),
  Test: await import("pointless/std/Test.js"),
};

export const ptls = {
  tokenize,
  parse,
  Panic,
  Highlighter,
  repr,
  Runtime,
  impl,
};
