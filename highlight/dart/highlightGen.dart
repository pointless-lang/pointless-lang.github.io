
import "dart:js";
import "package:pointless/pointless.dart";

import "../../api/makeDoc.dart";
import "../../online/dart/preludeList.dart";

// ---------------------------------------------------------------------------

var exportsText = preludeList[0][1];
var preludeNames = getExports(exportsText);

String highlight(String chars) {
  var source = SourceFile("<web>", chars);

  var annotations = [];
  var color;

  for (var token in source.getTokens()) {
    if (keywords.containsKey(token.value)) {
      color = "#c594c5";

    } else if (opSyms.containsKey(token.value)) {
      color = "#F97B58";

    } else if (preludeNames.contains(token.value)) {
      color = "#6699cc";

    } else if (token.tokType == Tok.Label) {
      color = "#7986CB";

    } else if (token.tokType == Tok.Neg) {
      color = "#F97B58";

    } else if (token.tokType == Tok.Number) {
      color = "#F9AE58";

    } else if (token.tokType == Tok.String) {
      color = "#99C794";

    } else if (token.tokType == Tok.Comment) {
      color = "#A6ACB9";

    } else {
      color = "#D8DEE9";
    }

    var escaped = escapeHTML(token.value);
    var annotation = "<span style='color: $color;'>$escaped</span>";
    annotations.add(annotation);
  }

  return annotations.join("");
}

// ---------------------------------------------------------------------------
// https://stackoverflow.com/a/6234804

String escapeHTML(String text) {
  return text
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll("\"", "&quot;")
    .replaceAll("'", "&#039;");
 }

// ---------------------------------------------------------------------------

void main() {
  context["highlight"] = highlight;
}
