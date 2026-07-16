---
name: hugo-templates
description: Use when designing, debugging, or refactoring Hugo layouts, partials, lookup rules, render hooks, and asset pipelines at an expert level.
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [hugo, templates, go-templates, partials, render-hooks, assets, lookup-order]
    related_skills: [hugo, plan, requesting-code-review]
---

# Hugo templates, layouts, and rendering

## Overview

Use this skill when the task is specifically about Hugo's template system rather than Hugo installation or basic site setup.

This skill covers how Hugo chooses templates, how context and Go template syntax behave, how to structure layouts and partials, how to use render hooks and the resource pipeline, and how to debug template-level problems without guessing.

Prefer Hugo's official docs as source of truth for evolving behavior:

- `https://gohugo.io/templates/`
- `https://gohugo.io/templates/lookup-order/`
- `https://gohugo.io/templates/types/`
- `https://gohugo.io/functions/`
- `https://gohugo.io/render-hooks/`

Important details confirmed from the current docs and local Hugo v0.161.1:

- Hugo selects templates from most specific to least specific.
- Lookup is interleaved across the project and theme layout directories.
- `type` and `layout` in front matter can target a different template.
- `layouts/page.html` works for regular pages, while `single.html` is a fallback.
- `baseof.html` + `block`/`define` is the core composition pattern.
- Partials live under `layouts/_partials/`.
- `partial` can return rendered HTML or any data type if the partial uses `return`.
- `partialCached` caches output and accepts variant keys.
- Render hooks live under `layouts/_markup/`.
- Asset pipelines via `resources.Get`, `minify`, and `fingerprint` work naturally inside templates.
- `hugo --templateMetrics --templateMetricsHints` emits per-template timing data.

## When to Use

- Build or refactor Hugo layouts for pages, sections, home, taxonomy, and terms
- Diagnose why Hugo picked the wrong template
- Create reusable partials with explicit context passing
- Convert duplicated markup into `baseof.html`, `block`, `define`, and partials
- Work with `.Site`, `.Page`, `.Params`, page collections, `where`, `sort`, `group`, and `range`
- Implement render hooks for links, images, headings, code blocks, tables, or blockquotes
- Build CSS/JS/image asset pipelines with Hugo resources
- Debug scope issues involving `.` and `$`
- Tune or validate expensive partials with `partialCached`
- Create section-specific or type-specific template overrides

Do not use this skill for:

- Initial Hugo installation only
- Generic Markdown authoring with no template work
- Non-Hugo Go templates in unrelated tools
- JS framework hydration patterns unless they are embedded in a Hugo template workflow

## Mental model: how Hugo renders a page

For any request or build target, think in this order:

1. What page kind is this?
   - `home`
   - `page`
   - `section`
   - `taxonomy`
   - `term`

2. What makes it more specific?
   - content type
   - section
   - language
   - output format
   - front matter `type`
   - front matter `layout`

3. Which template file wins?
   - Hugo searches from most specific to least specific.
   - It interleaves project and theme layouts, choosing the most specific match found in either.

4. Does a base template apply?
   - `baseof.html` provides the shared shell.
   - the selected template fills named `block`s via `define`.

5. Does the selected template call partials, render hooks, or resources?
   - partials are ordinary subtemplates
   - render hooks affect Markdown-to-HTML rendering
   - resource pipelines generate processed assets

If you keep those five steps straight, most Hugo template bugs become obvious.

## Template file layout

The modern high-signal files to reach for first are:

```text
layouts/
  baseof.html
  home.html
  page.html
  section.html
  taxonomy.html
  term.html
  _partials/
  _markup/
```

Important fallback behavior from the docs:

- `page.html` is the specific template for regular content pages.
- `single.html` is a fallback for regular pages when `page.html` does not exist.
- List kinds fall back toward list-style templates such as `_default/list.html`.

Practical guidance:

- Prefer `home.html`, `page.html`, `section.html`, `taxonomy.html`, and `term.html` for clarity.
- Only fall back to `_default/single.html` and `_default/list.html` when you intentionally want generic shared behavior.
- Add section-specific or type-specific overrides only when there is a real divergence in presentation.

## Template lookup order in practice

Key current rules from the docs:

- Hugo uses the most specific matching template.
- Templates may live in the project's layout directory or a theme's layout directory.
- Hugo interleaves project and theme lookups.
- You cannot change the lookup order itself.
- You can steer selection with front matter such as `type` and `layout`.

Use these rules when debugging:

1. Determine the page kind.
2. Determine the page's content type and section.
3. Check whether front matter sets `layout` or `type`.
4. Inspect project `layouts/` before blaming the theme.
5. Remember that a more specific template beats a generic one even if both exist.

A reliable override strategy:

- Put broad defaults in `layouts/page.html` or `layouts/section.html`.
- Put targeted overrides in paths like `layouts/posts/page.html` when a specific section needs its own rendering.
- Use front matter `layout = 'landing'` only when the content author should explicitly opt into a special template.

## Auditing whether a theme param is actually used

When a user asks whether a Hugo theme parameter is used, do not stop at exact symbol matches.

Use this audit sequence:

1. Search for exact references first:
   - `.Site.Params.foo`
   - `site.Params.foo`
   - nested forms such as `.Site.Params.attributes.website`
2. If exact references are absent, search for generic iteration over parent maps:
   - `range .Site.Params.attributes`
   - `isset .Site.Params`
   - `index .Site.Params ...`
   - merges or dict construction from params
3. Trace any matching partial into its call sites.
   - A parameter may be consumed indirectly inside a partial and emitted into HTML attributes, JSON, or script data.
4. Distinguish between:
   - direct logical use
   - indirect generic use
   - unused declaration

Example pattern:

```go-html-template
{{ range $key, $value := .Site.Params.attributes }}
  {{ $attrs = (printf "data-%s=\"%s\" %s" $key $value $attrs) | safeHTMLAttr }}
{{ end }}
```

If a theme then includes that partial in `baseof.html`, every entry under `params.attributes` is effectively used even when no key such as `website` is referenced by name.

## Base templates and block composition

This is the primary composition pattern for maintainable Hugo sites.

Base template:

```html
<!doctype html>
<html>
  <head>
    <title>{{ .Title }}</title>
  </head>
  <body>
    <header>{{ partial "nav.html" . }}</header>
    <main>{{ block "main" . }}{{ end }}</main>
  </body>
</html>
```

Page or section template:

```html
{{ define "main" }}
  <h1>{{ .Title }}</h1>
  {{ .Content }}
{{ end }}
```

Best practices:

- Keep `baseof.html` structural: head, shell, header, footer, slots.
- Put page-specific logic inside `define` blocks, not in the base template.
- Do not overload `baseof.html` with section-specific branching when separate templates would be clearer.
- Use partials for shared fragments, not for every tiny one-liner.

## Context, dot, and variables

The single most common Hugo mistake is losing track of context.

Rules:

- `.` means the current context.
- At the top of a page template, `.` is typically a `Page`.
- Inside `range`, `with`, and some partials, `.` changes.
- `$` points to the root context originally passed into the current template.

Example:

```go-html-template
{{ range .Site.RegularPages }}
  <a href="{{ .RelPermalink }}">{{ .Title }}</a>
  <span>Current page title: {{ $.Title }}</span>
{{ end }}
```

Use this discipline:

- Capture important objects up front:

```go-html-template
{{ $page := . }}
{{ $pages := where site.RegularPages "Section" "posts" }}
```

- When passing multiple values to a partial, use `dict`.
- When the partial needs the original page, pass it explicitly rather than assuming the dot will still be correct.

Safe partial call pattern:

```go-html-template
{{ partial "card.html" (dict "page" . "class" "featured") }}
```

Then inside the partial:

```go-html-template
{{ $p := .page }}
<article class="{{ .class }}">
  <a href="{{ $p.RelPermalink }}">{{ $p.LinkTitle }}</a>
</article>
```

## Page kinds and the right collections

Use the collection that matches the page kind.

Common patterns:

### Home page

```go-html-template
{{ range site.RegularPages }}
  <a href="{{ .RelPermalink }}">{{ .LinkTitle }}</a>
{{ end }}
```

### Section page

```go-html-template
{{ range .Pages }}
  <a href="{{ .RelPermalink }}">{{ .LinkTitle }}</a>
{{ end }}
```

### Taxonomy page

```go-html-template
{{ range .Data.Terms.ByCount }}
  <a href="{{ .Page.RelPermalink }}">{{ .Page.LinkTitle }}</a> ({{ .Count }})
{{ end }}
```

### Term page

```go-html-template
{{ range .Pages }}
  <a href="{{ .RelPermalink }}">{{ .LinkTitle }}</a>
{{ end }}
```

Practical rule:

- Use `site.RegularPages` when you want a site-wide content collection.
- Use `.Pages` when you want children of the current list-like page.
- Use `.Data.Terms` only in taxonomy contexts.

## Filtering, sorting, and grouping pages

Reach for page collections before custom logic.

Common patterns:

```go-html-template
{{ $posts := where site.RegularPages "Section" "posts" }}
{{ $featured := where $posts "Params.featured" true }}
{{ $sorted := sort $posts "Date" "desc" }}
{{ range first 5 $sorted }}
  <a href="{{ .RelPermalink }}">{{ .Title }}</a>
{{ end }}
```

Guidelines:

- Filter first, then sort, then limit.
- Avoid repeating the same expensive pipeline in many templates.
- If reused often, compute once in a partial or assign to a variable.
- If the computation is expensive and invariant for many pages, consider `partialCached`.

## Partials: include, return values, and caching

### `partial`

Use `partial` for reusable template fragments.

Key doc behavior:

- `partial` optionally accepts context.
- If the partial contains `return`, it returns that value.
- Without `return`, it returns rendered HTML.

HTML partial:

```go-html-template
{{ partial "breadcrumbs.html" . }}
```

Data-returning partial:

```go-html-template
{{ $card := partial "card-data.html" . }}
<a href="{{ $card.link }}">{{ $card.title }}</a>
```

With partial implementation:

```go-html-template
{{ return (dict "title" .Title "link" .RelPermalink) }}
```

Use data-returning partials when you want shared derivation logic without coupling it to markup.

### `partialCached`

Use `partialCached` only when the output is genuinely reusable.

Important doc behavior:

- It caches the rendered result.
- It accepts one or more variant keys.
- Variant keys matter whenever output depends on page, language, theme mode, or another dimension.

Pattern:

```go-html-template
{{ partialCached "styles.html" . .Site.Language.Lang }}
```

Rules of thumb:

- If the partial output is globally identical, no variant key may be needed.
- If output depends on language, section, color mode, output format, or page params, include those as variants.
- Wrong variant keys create subtle cross-page bugs.
- Do not use `partialCached` as a reflex; prove there is a repeated expensive partial first.

## Render hooks

Render hooks override Markdown rendering and belong in `layouts/_markup/`.

Common files:

```text
layouts/_markup/render-link.html
layouts/_markup/render-image.html
layouts/_markup/render-heading.html
layouts/_markup/render-codeblock.html
```

Use render hooks when the source content is Markdown but the output HTML needs policy or structure changes.

Examples:

- add attributes to outbound links
- wrap images in `figure`
- add heading anchors
- customize code block chrome
- adjust table or blockquote markup

A minimal link render hook:

```html
<a href="{{ .Destination | safeURL }}" data-hook="link"{{ with .Title }} title="{{ . }}"{{ end }}>{{ .Text | safeHTML }}</a>
```

Important boundary:

- Render hooks affect Markdown rendering.
- They do not automatically change arbitrary HTML emitted by shortcodes, partials, or hard-coded layouts.

## Resource pipelines for CSS, JS, and generated assets

Hugo's resource pipeline is a template-level superpower.

Typical CSS pattern:

```go-html-template
{{ with resources.Get "css/main.css" }}
  {{ $css := . | minify | fingerprint }}
  <link rel="stylesheet" href="{{ $css.RelPermalink }}" integrity="{{ $css.Data.Integrity }}">
{{ end }}
```

Useful resource functions confirmed in the docs:

- `resources.Get`
- `resources.GetMatch`
- `resources.Match`
- `resources.FromString`
- `resources.ExecuteAsTemplate`
- `resources.Minify`
- `resources.Fingerprint`
- `resources.PostProcess`
- `resources.GetRemote`

Guidance:

- Use `assets/` for pipeline-managed resources.
- Use `static/` for files that should pass through unchanged.
- Fingerprint production assets that need cache-busting and integrity metadata.
- Use `resources.ExecuteAsTemplate` when an asset itself must be templated from site data.

## Choosing between templates, partials, shortcodes, and render hooks

Use the right abstraction:

- Template (`home.html`, `page.html`, etc.): choose the full page structure
- Partial: reusable site chrome or reusable derivation logic
- Shortcode: author-invoked component inside Markdown content
- Render hook: automatic transformation of Markdown-generated HTML

Good decision rule:

- If editors explicitly place it in content, use a shortcode.
- If every Markdown link or image should change, use a render hook.
- If it is shared layout chrome, use a partial.
- If it defines the page shell or page-kind rendering, use a template.

## Section-specific and custom layout strategies

Prefer stable defaults plus narrow overrides.

Examples:

- generic article pages in `layouts/page.html`
- blog section override in `layouts/posts/page.html`
- custom landing layout selected via front matter `layout = 'landing'`

Avoid these anti-patterns:

- one giant template with many section `if eq` branches
- front matter layouts for everything
- duplicating near-identical markup across many section templates

## Debugging workflow

When Hugo templates misbehave, do this in order.

### 1. Verify the render path

Run a build and read the warnings:

```bash
hugo
```

If you suspect dev-server behavior differences:

```bash
hugo server -D --disableFastRender
```

### 2. Inspect template timing

Use template metrics to find slow templates or partials:

```bash
hugo --templateMetrics --templateMetricsHints
```

This was verified locally and emits a table with cumulative duration, average duration, cache potential, cached count, and template name.

### 3. Check the selected template by reasoning from kind and specificity

Ask:

- Is this `home`, `page`, `section`, `taxonomy`, or `term`?
- Is there a more specific section or type template overshadowing the generic one?
- Is front matter setting `layout` or `type`?
- Is the theme providing a template I forgot about?

### 4. Check context loss

If values vanish inside a `range` or partial, suspect dot changes first.

Typical fix:

```go-html-template
{{ $root := . }}
{{ range .Pages }}
  {{ partial "card.html" (dict "root" $root "page" .) }}
{{ end }}
```

### 5. Reduce to the smallest reproducer

If lookup order is confusing, temporarily create the minimum files needed:

- `baseof.html`
- one target template
- one content file

Then add specificity one step at a time.

## Common Pitfalls

1. Confusing `.` with `$`.
   - Inside `range`, `.` often becomes the current element.
   - Use `$` for the root context or pass values explicitly.

2. Using a partial without passing the data it needs.
   - Partials do not magically inherit every variable you intended.
   - Pass a dict with named fields.

3. Caching the wrong thing with `partialCached`.
   - If output varies by language, page, or section, include variant keys.
   - Otherwise one page can leak cached HTML into another.

4. Debugging the wrong template file.
   - Hugo may be using a more specific template than the one you are editing.
   - Start with kind, type, section, layout, and theme overrides.

5. Using `static/` instead of `assets/` for pipeline-managed files.
   - `resources.Get` works with assets, not arbitrary static files.

6. Expecting render hooks to affect manually-written HTML.
   - Render hooks only intercept Markdown-rendered elements.

7. Overusing front matter layouts.
   - `layout` is powerful, but if every page needs it, the template hierarchy is probably wrong.

8. Duplicating markup instead of using `baseof.html` and partials.
   - Duplication makes template drift inevitable.

9. Mixing content concerns into layout selection.
   - Use front matter for content metadata.
   - Use templates and partials for presentation.

10. Ignoring build warnings for missing template kinds.
   - Warnings like missing `section`, `taxonomy`, or `term` templates explain broken pages immediately.

11. Treating “no exact grep hit” as proof that a param is unused.
   - Theme params are often consumed through generic map iteration or helper partials.
   - Audit both direct references and indirect use through partials before declaring a parameter dead.

## One-shot recipes

### Build a clean page/home/section skeleton

1. Create:

```text
layouts/baseof.html
layouts/home.html
layouts/page.html
layouts/section.html
```

2. Put shell markup in `baseof.html`.
3. Put page-kind-specific content inside `define "main"` blocks.
4. Build with `hugo` and inspect warnings.

### Add a reusable component with explicit inputs

1. Create `layouts/_partials/<name>.html`
2. Call it with `dict`
3. Keep presentation in the partial and data derivation in named variables
4. If it only computes data, use `return`

### Add custom Markdown link behavior

1. Create `layouts/_markup/render-link.html`
2. Use `.Destination`, `.Text`, and `.Title`
3. Build a page containing Markdown links
4. Inspect generated HTML, not just template source

### Add fingerprinted CSS

1. Put CSS under `assets/css/`
2. In a head partial, call `resources.Get | minify | fingerprint`
3. Include the resulting `RelPermalink` and integrity hash
4. Build and confirm hashed files appear in output

## Verified local patterns

These patterns were exercised successfully with local Hugo v0.161.1:

- `baseof.html` + `home.html`, `section.html`, and `page.html`
- section-specific override via `layouts/posts/page.html`
- `partial "..."` with `dict` input
- partial `return` to produce a dict rather than HTML
- `partialCached` with a language variant key
- Markdown link customization via `layouts/_markup/render-link.html`
- CSS processing with `resources.Get`, `minify`, and `fingerprint`
- timing output from `hugo --templateMetrics --templateMetricsHints`

See the linked reference file for compact copy-paste snippets.

## Verification Checklist

- [ ] Confirm the page kind before editing templates
- [ ] Check for `type` and `layout` overrides in front matter
- [ ] Prefer `home.html`, `page.html`, `section.html`, `taxonomy.html`, and `term.html` before generic fallbacks
- [ ] Keep shell markup in `baseof.html`
- [ ] Pass explicit context to partials, usually with `dict`
- [ ] Use `$` or named variables when context changes under `range`/`with`
- [ ] Use `partialCached` only with correct variant keys
- [ ] Put resource-pipeline inputs in `assets/`, not `static/`
- [ ] Put Markdown render hooks in `layouts/_markup/`
- [ ] Run `hugo` and read warnings before assuming the template is correct
- [ ] Use `hugo --templateMetrics --templateMetricsHints` when performance matters

## References

- Templates overview: https://gohugo.io/templates/
- Introduction to templating: https://gohugo.io/templates/introduction/
- Template lookup order: https://gohugo.io/templates/lookup-order/
- Template types: https://gohugo.io/templates/types/
- Partials: https://gohugo.io/functions/partials/
- partial: https://gohugo.io/functions/partials/include/
- partialCached: https://gohugo.io/functions/partials/includecached/
- Go-template range: https://gohugo.io/functions/go-template/range/
- Render hooks: https://gohugo.io/render-hooks/
- Resources functions: https://gohugo.io/functions/resources/
