
import "dart:js";
import "package:pointless/pointless.dart";

import "preludeList.dart";

// ---------------------------------------------------------------------------

class WebSourceFile extends SourceFile {

  WebSourceFile(String chars): super("<web>", chars);

  // -------------------------------------------------------------------------

  static var prelude = WebPreludeFile();

  // -------------------------------------------------------------------------

  Env getEnv() {
    if (env == null) {
      env = Env(prelude.getEnv());
      eval(env, getNode());
    }

    return env;
  }
}

// ---------------------------------------------------------------------------

class WebPreludeFile extends PreludeFile {

  List<Token> getTokens() {
    if (tokens == null) {
      tokens = [];

      for (var filePair in preludeList) {
        var path = filePair[0];
        var chars = filePair[1];
        var tmp = SourceFile(path, chars);
        tokens.addAll(tmp.getTokens());
      }

      var lastEOF = tokens.last;
      tokens.removeWhere((tok) => tok.tokType == Tok.EOF);
      tokens.add(lastEOF);
    }

    return tokens;
  }
}

// ---------------------------------------------------------------------------

void runCommandWeb(PtlsValue command) {
  command.checkType([PtlsLabel, PtlsTuple]);

  if (command is PtlsTuple) {
    runTupleWeb(command.label.value, command.members);

  } else {
    runLabelWeb((command as PtlsLabel).value);
  }
}

// ---------------------------------------------------------------------------

void runLabelWeb(String label) {
  switch (label) {
    case "IOClearConsole": 
      context["clearConsole"].apply([]);
      break;

    default: invalidLabel(label);
  }
}

// ---------------------------------------------------------------------------

void runTupleWeb(String label, List<PtlsValue> args) {
  switch (label) {
    case "IOPrint": 
      checkArity(label, args, 1);
      PtlsString string = args[0].checkType([PtlsString]);
      context["printOut"].apply([string.value]);
      break;

    default: invalidLabel(label);
  }
}

// ---------------------------------------------------------------------------

void main() {
  var commands;

  context["runProgram"] = (String chars) {
    var source = WebSourceFile(chars);

    for (var token in source.getTokens()) {
      if (token.tokType == Tok.Import) {
        var error = PtlsError("Platform Error");
        error.message = "Imports not supported in web interface";
        error.locs.add(token.loc);
        throw error;
      }
    }

    var env = source.getEnv();
    commands = env.getOutput().iterator;
  };

  context["getOutput"] = () {
    if (commands.moveNext()) {
      runCommandWeb(commands.current);
      return true;

    } else {
      return false;
    }
  };

  PtlsLabel.debugHandler = (String str) => context["debugHandler"].apply([str]);
}
