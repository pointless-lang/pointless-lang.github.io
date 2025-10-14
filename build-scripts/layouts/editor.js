import { h } from "pointless/render/escape.js";

export function build(node) {
  const main = node.children.map(
    (child) =>
      h`
      <a href="/${child.path}/">
        <li>
          <strong>${child.label}</strong>
          ${child.subtitle}
        </li>
      </a>
    `,
  );

  return h`
    <hr />
    <ul class="page-links">$${main}</ul>
  `;
}
