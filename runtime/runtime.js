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
  None: await import("pointless/std/None.js"),
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

export function makeRuntime(shim, loader) {
  return new Runtime({ ...impl, ...shim }, loader);
}

export { CodeJar } from "codejar";
