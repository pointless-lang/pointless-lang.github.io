
SHELL:=/bin/bash

.PHONY: all
all: online highlight api

.PHONY: highlight
highlight: online
	dart2js highlight/dart/highlightGen.dart -o highlight/js/highlightGen.js

.PHONY: online
online:
	dart online/dart/savePreludeWeb.dart > online/dart/preludeList.dart
	dart2js online/dart/ptlsWeb.dart -o online/js/ptlsWeb.js

api/bin/makeDoc: api/makeDoc.dart
	dart2native api/makeDoc.dart -o api/bin/makeDoc

.PHONY: api
api: api/bin/makeDoc
	api/makeDocs.sh api/prelude/ pointless/prelude/exports.ptls pointless/prelude/*
