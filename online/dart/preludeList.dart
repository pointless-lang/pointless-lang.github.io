var preludeList = [["pointless/prelude/exports.ptls", "\nexport {\n  assert,\n  toArray,\n  toNDArray,\n  lessEq,\n  lessThan,\n  greaterEq,\n  greaterThan,\n  notFunc,\n  notEq,\n  eq,\n  orFunc,\n  andFunc,\n  inFunc,\n  any,\n  all,\n  lowers,\n  uppers,\n  alphas,\n  digits,\n  alNums,\n  delKey,\n  toDict,\n  keys,\n  vals,\n  items,\n  getDefault,\n  format,\n  compose,\n  id,\n  const,\n  iterate,\n  print,\n  println,\n  printFrame,\n  printFrames,\n  printLines,\n  debug,\n  readLines,\n  randFloat,\n  randRange,\n  randChoice,\n  getIndex,\n  length,\n  hasPrefix,\n  getLabel,\n  hasLabel,\n  unwrap,\n  wrap,\n  wrapTuple,\n  wrapObject,\n  head,\n  tail,\n  at,\n  last,\n  slice,\n  concat,\n  concatMap,\n  intersperse,\n  repeat,\n  take,\n  drop,\n  takeWhile,\n  takeUntil,\n  dropWhile,\n  dropUntil,\n  find,\n  span,\n  groupBy,\n  map,\n  filter,\n  reduce,\n  reduceFirst,\n  scan,\n  reverse,\n  zip,\n  zipN,\n  eager,\n  isEmpty,\n  toList,\n  enumerate,\n  sum,\n  range,\n  toInt,\n  floor,\n  ceil,\n  toFloat,\n  round,\n  pi,\n  euler,\n  abs,\n  pow,\n  mul,\n  div,\n  mod,\n  add,\n  sub,\n  max,\n  min,\n  minimum,\n  maximum,\n  toSet,\n  addElem,\n  delElem,\n  union,\n  intersection,\n  difference,\n  symDifference,\n  repr,\n  show,\n  sort,\n  join,\n  concatStrings,\n  split,\n  toTuple,\n  getType,\n  hasType,\n  is,\n  shuffle,\n  product,\n  asin,\n  acos,\n  atan,\n  atan2,\n  sin,\n  cos,\n  tan,\n  ln,\n  logBase,\n  argmin,\n  argmax,\n  unwrapTuple,\n  unwrapObject,\n  zeroArray,\n  notIs,\n  count,\n  readFile,\n  readFileLines,\n  toLower,\n  toUpper,\n  apply,\n  composeAll,\n}\n"], ["pointless/prelude/array.ptls", "\n-------------------------------------------------------------------------------\n\nzeroArray(n) = PtlsArray.!getZeros(n)\n\n-------------------------------------------------------------------------------\n-- Convert a collection (a list, array, set, or tuple) to an array\n\ntoArray(collection) =\n  zeroArray(length(collection))\n  |> insert(0, toList(collection))\n\ninsert(index, list, array) =\n  if isEmpty(list) then array\n  else insert(index + 1, tail(list), newArray)\n  where newArray = array with \$[index] = head(list)\n\n-------------------------------------------------------------------------------\n-- Make an N-dimensional array from the values in a list\n\ntoNDArray(dims, elems) =\n  head(wrappedArray)\n\n  requires assert(\n    reduceFirst(mul, dimsList) == length(elems),\n    format(\n      \"invalid dinemsions {} for elems length {}\",\n      [dims, length(elems)]\n    )\n  )\n\n  where {\n    dimsList = toList(dims)\n    wrappedArray = toNDHelper(dimsList, elems, length(dims))\n  }\n\n-------------------------------------------------------------------------------\n\ntoNDHelper(dimsList, elems, depth) =\n  if depth == 0 then elems\n  else chunks(head(dimsList), subArrays)\n  where {\n    subArrays = toNDHelper(tail(dimsList), elems, depth - 1)\n  }\n\n-------------------------------------------------------------------------------\n\nchunks(n, list) =\n  if isEmpty(list) then []\n  else [toArray(take(n, list))] ++ tailChunks\n  where tailChunks = chunks(n, drop(n, list))\n"], ["pointless/prelude/boolean.ptls", "\n------------------------------------------------------------------------------\n-- lessEq(b, a) = a <= b\n\nlessEq(b, a) = a <= b\n\n------------------------------------------------------------------------------\n-- lessThan(b, a) = a < b\n\nlessThan(b, a) = a < b\n\n------------------------------------------------------------------------------\n-- greaterEq(b, a) = a >= b\n\ngreaterEq(b, a) = a >= b\n\n------------------------------------------------------------------------------\n-- greaterThan(b, a) = a > b\n\ngreaterThan(b, a) = a > b\n\n------------------------------------------------------------------------------\n-- notFunc(x) = not x\n\nnotFunc(x) = not x\n\n------------------------------------------------------------------------------\n-- notEq(a, b) = a != b\n\nnotEq(a, b) = a != b\n\n------------------------------------------------------------------------------\n-- eq(a, b) = a == b\n\neq(a, b) = a == b\n\n------------------------------------------------------------------------------\n-- orFunc(a, b) = a or b\n\norFunc(a, b) = a or b\n\n------------------------------------------------------------------------------\n-- andFunc(a, b) = a and b\n\nandFunc(a, b) = a and b\n\n------------------------------------------------------------------------------\n-- inFunc(b, a) = a in b\n\ninFunc(b, a) = a in b\n\n------------------------------------------------------------------------------\n-- Takes a list of boolean values, returns true if any list value is true\n\nany(values) =\n  values\n  |> toList\n  |> reduce(orFunc, false)\n\n------------------------------------------------------------------------------\n-- Takes a list of boolean values, returns true if all list values are true\n\nall(values) =\n  values\n  |> toList\n  |> reduce(andFunc, true)\n"], ["pointless/prelude/chars.ptls", "\n-------------------------------------------------------------------------------\n-- lowers = toSet(\"abcdefghijklmnopqrstuvwxyz\")\n\nlowers = toSet(\"abcdefghijklmnopqrstuvwxyz\")\n\n-------------------------------------------------------------------------------\n-- uppers = toSet(\"ABCDEFGHIJKLMNOPQRSTUVWXYZ\")\n\nuppers = toSet(\"ABCDEFGHIJKLMNOPQRSTUVWXYZ\")\n\n-------------------------------------------------------------------------------\n-- Set of uppercase and lowercase letters\n\nalphas = union(lowers, uppers)\n\n-------------------------------------------------------------------------------\n-- digits = toSet(\"0123456789\")\n\ndigits = toSet(\"0123456789\")\n\n-------------------------------------------------------------------------------\n-- Set of uppercase and lowercase letters and digits 0 through 9\n\nalNums = union(alphas, digits)\n"], ["pointless/prelude/dict.ptls", "\n-------------------------------------------------------------------------------\n-- Remove an entry from a dict\n\ndelKey(dict, key) = dict.!getDelKey(key)\n\n-------------------------------------------------------------------------------\n-- Convert an object to a dict of strings (field names) to values (field values)\n\ntoDict(object) = object.!getDict\n\n-------------------------------------------------------------------------------\n-- Get a list of the keys in a dict\n\nkeys(dict) = dict.!getKeys\n\n-------------------------------------------------------------------------------\n-- Get a list of the values in a dict\n\nvals(dict) = dict.!getVals\n\n-------------------------------------------------------------------------------\n-- Get (key, value) tuples for each entry in a dict\n\nitems(dict) = keys(dict) |> map(key => (key, dict[key])) \n\n-------------------------------------------------------------------------------\n-- Get value for a given key if present in dict, otherwise default\n\ngetDefault(dict, default, key) =\n  if key in dict then dict[key] else default\n"], ["pointless/prelude/err.ptls", "\n------------------------------------------------------------------------------\n-- Throw AssertionError(message) if condition is not true\n\nassert(condition, message) =\n  if condition then true\n  else throw AssertionError(message)\n"], ["pointless/prelude/format.ptls", "\n-------------------------------------------------------------------------------\n-- Use a format pattern to build a string with inserted values\n--\n-- example:\n--\n-- >> format(\"{} {}!\", [\"Hello\", \"world\"])\n-- \"Hello world!\"\n-- \n-- example:\n--\n-- >> pairs  = [(\"dolor\", 5), (\"sit\", 3), (\"amet\", 4)]\n-- >> output = pairs |> map(format(\"[{<5} {}]\")) |> printLines\n-- [dolor 5]\n-- [sit   3]\n-- [amet  4]\n\nformat(fmtString, values) =\n  formatList(toList(fmtString), toList(values))\n  \n-------------------------------------------------------------------------------\n\nformatList(fmt, values) = cond {\n  -- return remaining format chars without value substitutions\n  case isEmpty(values) join(\"\", fmt)\n\n  -- lead contains the rest of the format string if there's no new pattern\n  -- convert from char list back to string\n  case isEmpty(pat) join(\"\", lead)\n\n  else join(\"\", lead) + pattStr + formatList(rest, tail(values))\n    where pattStr = processPattern(pat, head(values))\n\n  } where (lead, pat, rest) = nextPat(fmt)\n\n-------------------------------------------------------------------------------\n\n-- Leading   trailing\n--         pattern rest\n-- ....... {.....} ....\n\nspanUntil(func, list) = (takeUntil(func, list), dropUntil(func, list))\n\nnextPat(fmt) = (leading, pattern, rest) where {\n  (leading, trailing) = span(notEq(\"{\"), fmt)\n  (pattern, rest) = spanUntil(eq(\"}\"), trailing)\n}\n\n-------------------------------------------------------------------------------\n\nprocessPattern(pat, value) = cond {\n  case at(1, pat) == \">\"\n    show(value) |> padLeft(getPadding(pat))\n\n  case at(1, pat) == \"<\"\n    show(value) |> padRight(getPadding(pat))\n\n  else show(value)\n}\n\n-------------------------------------------------------------------------------\n\ngetPadding(pat) =\n  pat\n  |> slice(2, -1)\n  |> join(\"\")\n  |> toInt\n"], ["pointless/prelude/function.ptls", "\n-------------------------------------------------------------------------------\n-- compose(a, b) = x => b(a(x))\n\ncompose(a, b) = x => b(a(x))\n\n-------------------------------------------------------------------------------\n-- id(a) = a\n\nid(a) = a\n\n-------------------------------------------------------------------------------\n-- const(a, b) = a\n--\n-- example: length(list) = list |> map(const(1)) |> sum\n\nconst(a, b) = a\n\n-------------------------------------------------------------------------------\n-- Get an infinte list [init, func(init), func(func(init)) ...]\n\niterate(func, init) = [init] ++ iterate(func, func(init))\n\n-------------------------------------------------------------------------------\n-- call a function with the values in a given list as arguments\n\napply(args, func) =\n  if isEmpty(args) then func\n  else apply(tail(args), func(head(args)))\n\n-------------------------------------------------------------------------------\n-- compose a list of functions\n-- example: composeAll([a, b, c]) = x => x |> a |> b |> c\n\ncomposeAll(funcs) =\n  reduceFirst(compose, funcs)\n"], ["pointless/prelude/io.ptls", "\n------------------------------------------------------------------------------\n-- Generate command sequence to print the string rep for value\n\nprint(value) = [IOPrint(show(value))]\n\n------------------------------------------------------------------------------\n-- Generate command sequence to print value with a newline\n\nprintln(value) = print(show(value) + \"\\n\")\n\n------------------------------------------------------------------------------\n-- Print each element in a sequence on a separate line\n\nprintLines(iter) = iter |> toList |> concatMap(println)\n\n------------------------------------------------------------------------------\n-- Generate command sequence to clear console and print value with newline\n\nprintFrame(value) = [IOClearConsole] ++ println(value)\n\n------------------------------------------------------------------------------\n-- Print each element in a sequence in a separate frame\n\nprintFrames = concatMap(printFrame)\n\n------------------------------------------------------------------------------\n-- An identity function which logs its argument\n-- Useful for debugging\n\ndebug(value) = IO.!getDebug(value)\n\n------------------------------------------------------------------------------\n-- Read lines of input lazily\n\nreadLines = IO.!getLines\n\n------------------------------------------------------------------------------\n-- Get the text from the file at a given path\n\nreadFile = IO.!getReadFile\n\n------------------------------------------------------------------------------\n-- Get the lines from the file at a given path\n\nreadFileLines = IO.!getReadFileLines\n"], ["pointless/prelude/iter.ptls", "\n-------------------------------------------------------------------------------\n-- getIndex(lhs, rhs) = lhs[rhs]\n\ngetIndex(lhs, rhs) = lhs[rhs]\n\n-------------------------------------------------------------------------------\n-- Get the number of elements in a list, set, dict, array, or tuple\n\nlength(iter) = cond {\n  case isEmpty(iter) 0\n  case is(PtlsList, iter) lengthList(iter)\n  else iter.!getLength\n}\n\nlengthList(list) =\n  list\n  |> map(const(1))\n  |> sum\n\n-------------------------------------------------------------------------------\n-- Get the cartesian product of a list of iterables\n\nproduct(iters) = map(toList, iters) |> productLists |> map(toTuple)\n\nproductLists(lists) =\n  if isEmpty(lists) then [[]]\n  else\n    for tailProd in tailProds\n    for elem in head(lists)\n    yield [elem] ++ tailProd\n    where tailProds = productLists(tail(lists))\n\n-------------------------------------------------------------------------------\n-- Returns the nth element in a tuple, array, or list\n-- (must have at least n elements)\n\nat(n, iter) = cond {\n  case is(PtlsList, iter) iter |> drop(n) |> head\n  case is(PtlsTuple, iter) iter |> toList |> drop(n) |> head\n  case is(PtlsArray, iter) iter[n]\n}\n"], ["pointless/prelude/label.ptls", "\n-------------------------------------------------------------------------------\n-- Get the label of a labelled tuple or object, or a label\n\n-- need hasType instead of is to avoid infinite recursion\n\ngetLabel(value) = cond {\n  case hasType(PtlsLabel, value) value\n  case hasType(PtlsTuple, value) value.!getLabel\n  case hasType(PtlsObject, value) value.!getLabel\n}\n\n-------------------------------------------------------------------------------\n-- Does a labelled tuple or object have the given labelled\n\nhasLabel(label, value) = getLabel(value) == label\n\n-------------------------------------------------------------------------------\n-- Get the single value in a single-value tuple\n\nunwrap(wrapped) = value where (value) = wrapped\n\n-------------------------------------------------------------------------------\n\nunwrapTuple(tuple) = wrapTuple(PtlsTuple, tuple)\n\n-------------------------------------------------------------------------------\n\nunwrapObject(object) = wrapObject(PtlsObject, object)\n\n-------------------------------------------------------------------------------\n-- Get a single-value tuple with the given label containing value\n-- Foo(123) is syntactic sugar for wrap(Foo, 123) \n\nwrap(label, value) = label.!getWrap(value)\n\n-------------------------------------------------------------------------------\n-- Given a tuple, return the tuple labelled with label\n-- Foo(1, 2, 3) is syntactic sugar for wrapTuple(Foo, (1, 2, 3)) \n\nwrapTuple(label, tuple) = label.!getWrapTuple(tuple)\n\n-------------------------------------------------------------------------------\n-- Given an object, return the object labelled with label\n-- Foo {value = 123} is syntactic sugar for wrapObject(Foo, {value = 123}) \n\nwrapObject(label, object) = label.!getWrapObject(object)\n"], ["pointless/prelude/list.ptls", "\n-------------------------------------------------------------------------------\n-- Get the first element in a list\n\nhead(list) = list.!getHead\n\n-------------------------------------------------------------------------------\n-- Get all elements in a list after the first\n\ntail(list) = list.!getTail\n\n------------------------------------------------------------------------------\n-- Get the last element in a non-empty list\n\nlast(list) =\n  if isEmpty(tail(list))\n  then head(list)\n  else last(tail(list))\n\n------------------------------------------------------------------------------\n-- Get a sublist of indices [start ... (end - 1)]\n\nslice(start, end, list) =\n  slicePos(start, posEnd, list)\n  where\n    posEnd = if end > 0 then end else length(list) + end\n\nslicePos(start, end, list) =\n  list\n  |> drop(start)\n  |> take(end - start)\n\n-------------------------------------------------------------------------------\n-- Lazily concatenate a list of lists into a single list\n\nconcat(lists) = \n  if isEmpty(lists) then []\n  else head(lists) ++ concat(tail(lists))\n\n-------------------------------------------------------------------------------\n-- Map a list-generating function over a list and concatenate output lists\n\nconcatMap(func, lists) = lists |> map(func) |> concat\n\n-------------------------------------------------------------------------------\n-- Make a new list with sep element interted between each pervious element\n\nintersperse(sep, list) =\n  if isEmpty(list) then []\n  else [head(list)] ++ prependToAll(sep, tail(list))\n\nprependToAll(sep, list) =\n  if isEmpty(list) then []\n  else [sep, head(list)] ++ prependToAll(sep, tail(list))\n\n-------------------------------------------------------------------------------\n-- Make an infinite list of a value, repeated\n\nrepeat(elem) = [elem] ++ repeat(elem)\n\n-------------------------------------------------------------------------------\n-- Get the first n elements in an list, or the whole list of length < n\n\ntake(n, list) = \n  if n < 1 then []\n  else if isEmpty(list) then []\n  else [head(list)] ++ take(n - 1, tail(list))\n\n-------------------------------------------------------------------------------\n-- Get the elems after the first n elems in an list or empty if length < n\n\ndrop(n, list) = \n  if n < 1 then list\n  else if isEmpty(list) then []\n  else drop(n - 1, tail(list))\n\n-------------------------------------------------------------------------------\n-- Take from a list the leading elements for which func returns true\n\ntakeWhile(func, list) =\n  if isEmpty(list) then []\n\n  else if func(head(list))\n    then [head(list)] ++ takeWhile(func, tail(list))\n\n  else []\n\n-------------------------------------------------------------------------------\n-- Take elements up to (including) the first for which func returns true\n\ntakeUntil(func, list) =\n  if isEmpty(list) then []\n\n  else if func(head(list))\n    then [head(list)]\n\n  else [head(list)] ++ takeUntil(func, tail(list))\n\n-------------------------------------------------------------------------------\n-- Drop the leading elements for which func returns true\n\ndropWhile(func, list) =\n  drop(length(takeWhile(func, list)), list)\n\n-------------------------------------------------------------------------------\n-- Drop elements up to (including) the first for which func returns true\n\ndropUntil(func, list) =\n  drop(length(takeUntil(func, list)), list)\n\n-------------------------------------------------------------------------------\n-- Find the first element for which func return true, or None if none exists \n\nfind(func, list) =\n  if isEmpty(list) then None\n\n  else if func(head(list))\n    then head(list)\n\n  else find(func, tail(list))\n\n-------------------------------------------------------------------------------\n-- span(...) = (takewhile(...), dropWhile(...)) \n\nspan(func, list) = (head, tail)\n  where {\n    head = takeWhile(func, list)\n    tail = dropWhile(func, list)\n  }\n\n-------------------------------------------------------------------------------\n-- Return the list of lists of consecutive values for which func(a, b) == true\n\ngroupBy(func, list) =\n  if isEmpty(list) then []\n  else [groupList] ++ groupBy(func, spanTail)\n  where {\n    groupList = [[head(list)]] ++ spanHead\n    (spanHead, spanTail) = tail(list) |> span(func(head(list)))\n  }\n\n-------------------------------------------------------------------------------\n-- Get the reverse of list\n\nreverse(list) = reverseAcc([], list)\n\nreverseAcc(acc, list) =\n  if isEmpty(list) then acc\n  else reverseAcc([head(list)] ++ acc, tail(list))\n\n-------------------------------------------------------------------------------\n-- From two lists, get a list of tuple pairs of elems from each list in order \n--\n-- For lists [a0, a1, a2, ...], [b0, b1, b2, ...], return the list\n-- [(a0, b0), (a1, b1), (a2, b2) ...], with length limited by the length\n-- of the shorter input list\n\n-- alternively\n-- zip(a, b) = zipN([a, b]) -- shorter, but a lot slower\n\nzip(a, b) = cond {\n  case isEmpty(a) []\n  case isEmpty(b) []\n  else [pair] ++ zip(tail(a), tail(b))\n  where pair = (head(a), head(b))\n}\n\n-------------------------------------------------------------------------------\n-- Like zip, but for an arbitrary number of input lists\n\nzipN(lists) =\n  if any(map(isEmpty, lists)) then []\n  else [toTuple(map(head, lists))] ++ zipN(map(tail, lists))\n\n-------------------------------------------------------------------------------\n-- Evaluate each value in a list\n-- Useful for catching errors early\n\neager(list) = list |> reverse |> reverse\n\n-------------------------------------------------------------------------------\n-- isEmpty(list) = list == Empty\n\nisEmpty(list) = list == Empty\n\n-------------------------------------------------------------------------------\n-- Convert iter (a list, array, set, or tuple) to a list\n\ntoList(iter) =\n  if isEmpty(iter) then []\n  else iter.!getList\n\n-------------------------------------------------------------------------------\n-- For a list [a, b, c, ...] return [(0, a), (1, b), (2, c), ...]\n\nenumerate(list) =\n  list |> zip(nats) where nats = iterate(add(1), 0)\n\n-------------------------------------------------------------------------------\n-- Return true if list starts with the given prefix of elements\n\nhasPrefix(prefix, list) =\n  if isEmpty(prefix) then true\n  else if isEmpty(list) then false\n  else matchHead and matchTail\n  where {\n    matchHead = head(list) == head(prefix)\n    matchTail = hasPrefix(tail(prefix), tail(list))\n  }\n\n-------------------------------------------------------------------------------\n-- Apply a function to each list element, make a list of the results\n\nmap(func, list) =\n  if isEmpty(list) then []\n  else [func(head(list))] ++ map(func, tail(list))\n\n-------------------------------------------------------------------------------\n-- Apply a test to each list element, make new list of passing elements\n\nfilter(func, list) =\n  if isEmpty(list) then []\n\n  else if func(head(list))\n    then [head(list)] ++ filter(func, tail(list))\n\n  else filter(func, tail(list))\n\n-------------------------------------------------------------------------------\n-- Get a single value given a list, starting value, and accumulator function\n--\n-- Starting with accumulator value acc, update acc <- func(acc, elem)\n-- for each element elem in the list\n--\n-- example: sum(list) = reduce(0, add, list)\n\nreduce(func, acc, list) = \n  if isEmpty(list) then acc \n  else reduce(func, func(acc, head(list)), tail(list))\n\n-------------------------------------------------------------------------------\n-- Reduce a non-empty list with first element set as accumulator\n\nreduceFirst(func, list) = reduce(func, head(list), tail(list))\n\n-------------------------------------------------------------------------------\n-- Reduce a list with a given function and accumulator, returning a list of\n-- the intermediate accumulator values, including the initial value\n\nscan(func, acc, list) = \n  if isEmpty(list) then [] \n  else [acc] ++ scan(func, func(acc, head(list)), tail(list))\n\n-------------------------------------------------------------------------------\n\ncount(elem, list) =\n  list\n  |> filter(eq(elem))\n  |> length\n"], ["pointless/prelude/numerical.ptls", "\n------------------------------------------------------------------------------\n-- Get the sum of a list of numbers\n\nsum(list) = reduce(add, 0, list)\n\n------------------------------------------------------------------------------\n-- Get a list of numbers:\n--   [a, a + 1, a + 2, ... b] if a < b\n--   [a, a - 1, a - 2, ... b] if a > b\n--   [a]                      if a == b\n\nrange(a, b) =\n  if a < b then minToMax else reverse(minToMax)\n  where minToMax = rangeUp(min(a, b), max(a, b))\n\nrangeUp(a, b) =\n  iterate(add(1), a)\n  |> takeWhile(lessEq(b))\n\n------------------------------------------------------------------------------\n-- Convert a number or a string to a float\n\ntoFloat(val) = val.!getFloat\n\n------------------------------------------------------------------------------\n-- Convert a number or a string to an integer (truncates floats)\n\ntoInt(val) = val.!getInt\n\n------------------------------------------------------------------------------\n-- Round number down\n\nfloor(n) =\n  if n > 0 then toInt(n)\n  else toInt(n - 1)\n\n------------------------------------------------------------------------------\n-- Round number up\n\nceil(n) = floor(n + 1)\n\n------------------------------------------------------------------------------\n-- Round a number to the nearest int value\n\nround(n) = sign * (base + correction) where {\n  sign = if n < 0 then -1 else 1\n  base = toInt(abs(n))\n  frac = abs(n) - base\n  correction = if frac < .5 then 0 else 1\n}\n\n------------------------------------------------------------------------------\n\nasin(n) = n.!getAsin\n\n------------------------------------------------------------------------------\n\nacos(n) = n.!getAcos\n\n------------------------------------------------------------------------------\n\natan(n) = n.!getAtan\n\n------------------------------------------------------------------------------\n-- https://en.wikipedia.org/wiki/Atan2#Definition_and_computation\n\natan2(y, x) = cond {\n  case x < 0  and y >= 0 atan(y / x) + pi \n  case x < 0  and y < 0  atan(y / x) - pi \n  case x == 0 and y > 0  pi / 2\n  case x == 0 and y < 0  -pi / 2\n  else                   atan(y / x)\n}\n\n------------------------------------------------------------------------------\n\nsin(n) = n.!getSin\n\n------------------------------------------------------------------------------\n\ncos(n) = n.!getCos\n\n------------------------------------------------------------------------------\n\ntan(n) = n.!getTan\n\n------------------------------------------------------------------------------\n\nln(n) = n.!getLn\n\n------------------------------------------------------------------------------\n\nlogBase(b, a) = ln(a) / ln(b)\n\n------------------------------------------------------------------------------\n-- pi, to as many digits as I could remember\n\npi = 3.14159265358979323846264338327950\n\n------------------------------------------------------------------------------\n-- e, to as many digits as I could remember\n\neuler = 2.71828\n\n------------------------------------------------------------------------------\n-- Get the absolute-value of a number \n\nabs(n) = if n < 0 then -n else n\n\n------------------------------------------------------------------------------\n-- pow(b, a) = a ** b\n\npow(b, a) = a ** b\n\n------------------------------------------------------------------------------\n-- mul(b, a) = a * b\n\nmul(b, a) = a * b\n\n------------------------------------------------------------------------------\n-- div(b, a) = a / b\n\ndiv(b, a) = a / b\n\n------------------------------------------------------------------------------\n-- mod(b, a) = a % b\n\nmod(b, a) = a % b\n\n------------------------------------------------------------------------------\n-- add(b, a) = b + a\n\nadd(b, a) = b + a\n\n------------------------------------------------------------------------------\n-- sub(b, a) = b - a\n\nsub(b, a) = b - a\n\n------------------------------------------------------------------------------\n-- Get the larger of two numbers\n\nmax(a, b) = if a > b then a else b\n\n------------------------------------------------------------------------------\n-- Get the smaller of two numbers\n\nmin(a, b) = if a < b then a else b\n\n------------------------------------------------------------------------------\n-- Get the smallest number in a non-empty collection\n\nminimum(values) =\n  values\n  |> toList\n  |> reduceFirst(min)\n\n------------------------------------------------------------------------------\n-- Get the largest number in a non-empty collection\n\nmaximum(values) =\n  values\n  |> toList\n  |> reduceFirst(max)\n\n------------------------------------------------------------------------------\n\nargmin(func, values) =\n  map(func, values)\n  |> zip(values)\n  |> reduceFirst((a, b) => if at(1, a) < at(1, b) then a else b)\n  |> at(0)\n\n------------------------------------------------------------------------------\n\nargmax(func, values) =\n  map(func, values)\n  |> zip(values)\n  |> reduceFirst((a, b) => if at(1, a) > at(1, b) then a else b)\n  |> at(0)\n"], ["pointless/prelude/random.ptls", "\n------------------------------------------------------------------------------\n-- Get random float in 0 <= result <= n\n\nrandFloat(n) = IO.!getRand * n\n\n------------------------------------------------------------------------------\n-- Get random entry from range(a, b)\n\nrandRange(a, b) = randRangeUp(min(a, b), max(a, b))\n\nrandRangeUp(a, b) = floor(a + randFloat(b - a + 1))\n\n------------------------------------------------------------------------------\n-- Get random elem from collection\n\nrandChoice(elems) =\n  elems\n  |> toList\n  |> at(randRange(0, length(elems) - 1))\n\n-------------------------------------------------------------------------------\n-- Shuffle an iterable of values\n-- https://www.rosettacode.org/wiki/Knuth_shuffle\n\nshuffle(iter) =\n  range(length(array) - 1, 1)\n  |> reverse\n  |> reduce(shuffleStep, array)\n  |> toList\n  where array = toArray(iter)\n\nshuffleStep(array, i) = array with {\n  \$[i] = array[j]\n  \$[j] = array[i]\n} where j = randRange(0, i)\n"], ["pointless/prelude/set.ptls", "\n-------------------------------------------------------------------------------\n-- Convert a collection (a list, array, set, or tuple) to a set\n\ntoSet(collection) = reduce(addElem, Empty.!getSet, toList(collection))\n\n-------------------------------------------------------------------------------\n-- Add an element to a set\n\naddElem(set, elem) = set.!getAddElem(elem)\n\n-------------------------------------------------------------------------------\n-- Remove an element from a set\n\ndelElem(set, elem) = set.!getDelElem(elem)\n\n-------------------------------------------------------------------------------\n-- Get the union of two sets\n\nunion(a, b) =\n  toSet(toList(a) ++ toList(b))\n\n-------------------------------------------------------------------------------\n-- Get the intersection of two sets\n\nintersection(a, b) = toSet(interElems)\n  where interElems =\n    for elem in a\n    when elem in b\n    yield elem\n\n-------------------------------------------------------------------------------\n-- Get the difference of two sets\n\ndifference(a, b) = toSet(diffElems)\n  where diffElems =\n    for elem in a\n    when not (elem in b)\n    yield elem\n\n-------------------------------------------------------------------------------\n-- Get the symmetric difference of two sets\n\nsymDifference(a, b) = difference(union(a, b), intersection(a, b))\n"], ["pointless/prelude/show.ptls", "\n-------------------------------------------------------------------------------\n-- Get the string rep of a value, keeping quotes if value is a string\n\nrepr(value) =\n  if is(PtlsString, value)\n  then \"\\\"\" + value + \"\\\"\"\n  else show(value) \n\n-------------------------------------------------------------------------------\n-- Get the string representation of a value\n\nshow(value) = cond {\n  case is(Empty, value)       \"[]\" -- special case for empty list\n  case is(PtlsNumber, value)  toString(value)\n  case is(PtlsString, value)  toString(value)\n  case is(PtlsBool, value)    toString(value)\n  case is(PtlsLabel, value)   toString(value)\n  case is(PtlsSet, value)     showSet(value)\n  case is(PtlsDict, value)    showDict(value)\n  case is(PtlsList, value)    showList(value)\n  case is(PtlsArray, value)   showArray(value)\n  case is(PtlsObject, value)  showObject(value)\n  case is(PtlsTuple, value)   showTuple(value)\n  case is(PtlsFunc, value)    \"PtlsFunc\"\n  case is(PtlsBuiltIn, value) \"PtlsBuiltIn\"\n}\n\n-------------------------------------------------------------------------------\n\nshowElems(start, end, sep, iter) =\n  start + elemStr + end\n  where elemStr = iter |> toList |> map(repr) |> join(sep)\n\n-------------------------------------------------------------------------------\n\nshowSet   = showElems(\"{\", \"}\", \", \")\nshowList  = showElems(\"[\", \"]\", \", \")\nshowArray = showElems(\"[\", \"]\", \" \")\n\n-------------------------------------------------------------------------------\n\ngetLabelStrTuple(value) =\n  if getLabel(value) == PtlsTuple then \"\" else show(getLabel(value))\n\nshowTuple(tuple) = \n  getLabelStrTuple(tuple) + showElems(\"(\", \")\", \", \", tuple)\n\n-------------------------------------------------------------------------------\n\nshowDict = showPairs(repr, format(\"{}: {}\"), \", \")\n\n-------------------------------------------------------------------------------\n\ngetLabelStrObject(value) =\n  if getLabel(value) == PtlsObject then \"\" else show(getLabel(value)) + \" \"\n\nshowObject(object) = getLabelStrObject(object) + showDefs(object)\n\nshowDefs(object) =\n  object\n  |> toDict\n  |> showPairs(show, format(\"{} = {}\"), \"; \")\n\n-------------------------------------------------------------------------------\n\nshowPairs(keyFunc, pairFmt, sep, dict) = \"{\" + pairStr + \"}\"\n  where pairStr =\n    dict\n    |> items\n    |> map(reprPair(keyFunc))\n    |> map(pairFmt)\n    |> join(sep)\n\n-------------------------------------------------------------------------------\n\nreprPair(keyFunc, pair) = (keyFunc(a), repr(b)) where (a, b) = pair\n"], ["pointless/prelude/sort.ptls", "\n-------------------------------------------------------------------------------\n-- Sort an iterable of numbers\n\nsort(iter) = sortList(toList(iter))\n\nsortList(list) = \n  if list == Empty then []\n  else sortList(left) ++ center ++ sortList(right)\n  where {\n    left   = filter(lessThan(pivot), list)\n    center = filter(eq(pivot), list)\n    right  = filter(greaterThan(pivot), list)\n    pivot  = randChoice(list)\n  }\n"], ["pointless/prelude/string.ptls", "\n-------------------------------------------------------------------------------\n-- Convert a value to a string (works for number, bool, string, and label)\n\ntoString(value) = value.!getString\n\n-------------------------------------------------------------------------------\n-- Map a iterabel to strings, and join with a seperator string\n\njoin(sep, iter) =\n  iter\n  |> toList\n  |> map(show)\n  |> intersperse(sep)\n  |> concatStrings\n\n-- this could be optimized\nconcatStrings(strings) = reduce(add, \"\", strings)\n\n-------------------------------------------------------------------------------\n-- Return the list of substrings of a string, split by a delimiter\n\nsplit(delimStr, string) =\n  if delimStr == \"\"\n    then toList(string)\n\n  else splitChars(\"\", delim, chars) where {\n    delim = toList(delimStr)\n    chars = toList(string)\n  }\n\n-------------------------------------------------------------------------------\n\nsplitChars(result, delim, chars) =\n  if isEmpty(chars)\n    then [result]\n\n  else if hasPrefix(delim, chars)\n    then [result] ++ splitChars(\"\", delim, drop(length(delim), chars))\n\n  else splitChars(result + head(chars), delim, tail(chars))\n\n-------------------------------------------------------------------------------\n-- Left-pad a string with spaces to make its length >= n\n\npadLeft(n, string) = getPad(n, string) + string\n\ngetPad(n, string) =\n  repeat(\" \")\n  |> take(n - length(string))\n  |> join(\"\")\n\n-------------------------------------------------------------------------------\n-- Right-pad a string with spaces to make its length >= n\n\npadRight(n, string) = string + getPad(n, string)\n\n-------------------------------------------------------------------------------\n-- Convert string to lower case\n\ntoLower(string) = string.!getLower\n\n-------------------------------------------------------------------------------\n-- Convert string to upper case\n\ntoUpper(string) = string.!getUpper\n"], ["pointless/prelude/tuple.ptls", "\n-------------------------------------------------------------------------------\n-- Convert an iterable to a tuple\n\n-- (can't go straight from list to tuple since interpreter can't easily eval list)\n\ntoTuple(iter) = toArray(iter).!getTuple\n"], ["pointless/prelude/types.ptls", "\n-------------------------------------------------------------------------------\n-- Get a label representing the type of a value\n\ngetType(value) = value.!getType\n\n-------------------------------------------------------------------------------\n-- Does value have the type given by label\n\nhasType(label, value) = getType(value) == label\n\n-------------------------------------------------------------------------------\n-- Does value have the type given by label or is value a labelled tuple\n-- or object with a label matching label\n\nis(label, value) =\n  (hasType(label, value) or isLabelled and hasLabel(label, value)\n    where isLabelled =\n      hasType(PtlsLabel, value) or\n      hasType(PtlsTuple, value) or\n      hasType(PtlsObject, value))\n  requires hasType(PtlsLabel, label)\n\n-------------------------------------------------------------------------------\n\nnotIs(label, value) = not is(label, value)\n\n-------------------------------------------------------------------------------\n-- experimental\n-------------------------------------------------------------------------------\n-- Not working yet - circular definition issues\n\ncheckTypes(types, value) =\n  types\n  |> map(type => is(type, value))\n  |> any\n  |> (result => if result then true else throw TypeError(message))\n  where {\n    message  = format(\"Expected {}, got {} ({})\", [expected, got, value])\n    expected = join(\" or \", types)\n    got      = getType(value)\n  } requires is(PtlsList, types) and all(map(is(PtlsLabel), types))\n\n-------------------------------------------------------------------------------\n-- (doesn't call head() through checkTypes(), avoid infinite recursion)\n\ncheckType(type, value) =\n  if is(type, value) then true else throw TypeError(message)\n  where {\n    message = format(\"Expected {}, got {} ({})\", [type, got, value])\n    got     = getType(value)\n  } requires is(PtlsLabel, type)\n"]];
