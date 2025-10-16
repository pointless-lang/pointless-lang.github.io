import { renderMarkdown } from "pointless/render/render-markdown.js";
import { h } from "pointless/render/escape.js";
import { getType } from "pointless/src/values.js";
import { loadMeta } from "pointless/src/std.js";

const meta = loadMeta();

function showTags(name, value) {
  if (meta.globals[name] === value || meta.variants[name]) {
    return h`<span class="tag" title="Global"></span>`;
  }

  if (getType(value) !== "function") {
    return h`<span class="tag" title="Constant"></span>`;
  }

  return "";
}

function getDocStr(func) {
  const comment = func.handler
    .toString()
    .match(/^.*\n((?:[ \t]*\/\/.*\n?)*)/)
    .at(1)
    .trim();

  return comment
    .split("\n")
    .map((line) => line.replace(/\s*\/\/ ?/, ""))
    .join("\n");
}

async function showDocs(modName, name, value, consts) {
  if (modName === "Overloads") {
    const items = meta.variants[name].map((child) => {
      const other = child.name.split(".")[0];
      return h`<li><a href="../${other}/#${name}">${child}</a></li>`;
    });

    return h`
      <p>Overload of:</p>
      <ul class="overloads">
        $${items}
      </ul>
    `;
  }

  if (getType(value) === "function") {
    const overloader = meta.variants[name] &&
      h`
        <p class="overloads">
          (Accessible as a global through <a href="../Overloads/#${name}">Overloads.${name}</a>)
        </p>
      `;

    return h`$${await renderMarkdown(
      modName,
      getDocStr(value),
    )} $${overloader}`;
  }

  return await renderMarkdown(
    modName,
    `${consts?.[name] ?? ""}\n\`\`\`ptls --hide\n${modName}.${name}\n\`\`\``,
  );
}

export async function build(node) {
  const modName = node.path.split("/").at(-1);
  const defs = [];

  for (const [name, value] of Object.entries(meta.modules[modName])) {
    const label = getType(value) === "function" ? value : `${modName}.${name}`;
    const docs = await showDocs(modName, name, value, node.consts);

    defs.push(h`
      <hr />

      <h2 class="def-name" id="${name}">
        <code><a href="#${name}">${label}</a></code>
        $${showTags(name, value)}
      </h2>

      <div class="def-info">$${docs}</div>
    `);
  }

  const contents = Object.keys(meta.modules[modName]).map(
    (name) => h`<li><a href="#${name}">${name}</a></li>`,
  );

  return h`
    <ol class="contents std">$${contents}</ol>
    $${defs}
  `;
}
