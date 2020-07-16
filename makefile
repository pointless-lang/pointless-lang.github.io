
SHELL:=/bin/bash

.PHONY: all
all: online highlight api

.PHONY: deps
deps:
	pub get

.PHONY: highlight
highlight: deps online
	dart2js highlight/dart/highlightGen.dart -o highlight/js/highlightGen.js

.PHONY: online
online: deps
	dart online/dart/savePreludeWeb.dart > online/dart/preludeList.dart
	dart2js online/dart/ptlsWeb.dart -o online/js/ptlsWeb.js

api/bin/makeDoc: deps api/makeDoc.dart
	dart2native api/makeDoc.dart -o api/bin/makeDoc

.PHONY: api
api: deps api/bin/makeDoc
	api/makeDocs.sh api/prelude/ pointless/prelude/exports.ptls pointless/prelude/*
