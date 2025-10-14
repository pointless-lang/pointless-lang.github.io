import { headerId, renderMarkdown } from "pointless/render/render-markdown.js";
import { h, serialize } from "pointless/render/escape.js";
import { cp, mkdir, readdir, readFile, rm, writeFile } from "node:fs/promises";
import matter from "gray-matter";
import { format } from "prettier";

async function getTree(path, parent = null) {
  const childMap = new Map();

  const node = {
    path,
    content: null,
    parent,
    depth: parent ? parent.depth + 1 : 0,
    files: [],
  };

  const files = await readdir(`pages/${path}`, { withFileTypes: true });

  for (const file of files) {
    if (file.name === "index.md") {
      const source = await readFile(`pages/${path}/index.md`, "utf8");
      const { data, content } = matter(source);

      node.content = content;

      // title
      // subtitle
      // consts
      // links
      // layout
      Object.assign(node, data);

      node.label = data.title?.split(": ").at(-1);
    } else if (file.isDirectory()) {
      const subPath = path ? `${path}/${file.name}` : file.name;
      childMap.set(file.name, await getTree(subPath, node));
    } else {
      node.files.push(file.name);
    }
  }

  node.children = node.links
    ? node.links.map((name) => childMap.get(name))
    : [...childMap.values()];

  for (const [index, child] of node.children.entries()) {
    child.prev = node.children[index - 1];
    child.next = node.children[index + 1];
  }

  return node;
}

const layouts = {
  collection: (await import("./layouts/collection.js")).build,
  module: (await import("./layouts/module.js")).build,
  editor: (await import("./layouts/editor.js")).build,
};

let template;

async function buildIndex(node) {
  const generated = await layouts[node.layout]?.(node) ?? "";

  const contents = node.content
    .matchAll(/^##(.*)/gm)
    .map(([, title]) => h`<li><a href="#${headerId(title)}">${title}</a></li>`);

  const withTOC = node.content.replace(
    "[[_TOC_]]",
    h`<ol class="contents">$${contents}</ol>`,
  );

  const intro = await renderMarkdown(
    `pages/${node.path}/index.md`,
    withTOC,
  );

  const main = h`
    $${intro}
    $${generated}
  `;

  const header = node.depth >= 2
    ? h`<a href=".." id="parent">${node.parent.title}:</a> <a href=".">${node.title}</a>`
    : h`<a href=".">${node.title}</a>`;

  let sequencer;

  if (node.depth >= 2) {
    const prev = node.prev &&
      h`
        <a href="/${node.prev.path}">
          <div>Previous</div>
          ${node.prev.label}
        </a>
      `;

    const next = node.next &&
      h`
        <a class="next" href="/${node.next.path}">
          <div>Next</div>
          ${node.next.label}
        </a>
      `;

    sequencer = h`
      <div id="sequencer">
        <hr />
        <div>$${prev} $${next}</div>
      </div>
    `;
  }

  const values = {
    title: node.title,
    header,
    subtitle: node.subtitle,
    main,
    sequencer,
  };

  template ??= await readFile(import.meta.dirname + "/template.html", "utf8");

  const html = template.replaceAll(/\${1,2}{(\w+)}/g, (match, name) => {
    return serialize(values[name], match.startsWith("$$"));
  });

  const result = await format(html, { parser: "html" });
  await writeFile(`docs/${node.path}/index.html`, result);
}

async function buildPage(node) {
  await mkdir(`docs/${node.path}`, { recursive: true });
  await buildIndex(node);

  for (const child of node.children.values()) {
    await buildPage(child);
  }

  for (const file of node.files) {
    await cp(
      `pages/${node.path}/${file}`,
      `docs/${node.path}/${file}`,
    );
  }
}

await rm("docs", { recursive: true, force: true });
await mkdir("docs", { recursive: true });
const tree = await getTree("");
await buildPage(tree);
await cp("static", "docs", { recursive: true });
