
for path in "${@:3}"; do
  file="$(basename ${path} .ptls)"
  out="$1"

  [[ "${out}" != */ ]] && out="${out}/"

  outPath="$out${file}.html"

  echo "$outPath"
  api/bin/makeDoc "${path}" "$2" > "$outPath"
done

# ./makeDocs.sh prelude/ ../pointless/prelude/exports.ptls ../pointless/prelude/*
