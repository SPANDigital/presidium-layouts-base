# Hugo template quick reference

## Minimal base + page kind files

`layouts/baseof.html`

```html
<!doctype html>
<html>
  <head>
    <title>{{ .Title }}</title>
    {{ partialCached "styles.html" . .Site.Language.Lang }}
  </head>
  <body>
    <header>{{ partial "nav.html" . }}</header>
    <main>{{ block "main" . }}{{ end }}</main>
  </body>
</html>
```

`layouts/home.html`

```html
{{ define "main" }}
  <h1>{{ .Site.Title }}</h1>
  {{ range site.RegularPages }}
    <a href="{{ .RelPermalink }}">{{ .LinkTitle }}</a>
  {{ end }}
{{ end }}
```

`layouts/page.html`

```html
{{ define "main" }}
  <article>
    <h1>{{ .Title }}</h1>
    {{ .Content }}
  </article>
{{ end }}
```

`layouts/section.html`

```html
{{ define "main" }}
  <h1>{{ .Title }}</h1>
  {{ range .Pages }}
    <a href="{{ .RelPermalink }}">{{ .LinkTitle }}</a>
  {{ end }}
{{ end }}
```

## Pass explicit context to partials

Caller:

```go-html-template
{{ partial "card.html" (dict "page" . "variant" "featured") }}
```

Partial:

```go-html-template
{{ $p := .page }}
<article class="card card--{{ .variant }}">
  <a href="{{ $p.RelPermalink }}">{{ $p.LinkTitle }}</a>
</article>
```

## Return data from a partial

Caller:

```go-html-template
{{ $meta := partial "page-meta.html" . }}
<link rel="canonical" href="{{ $meta.canonical }}">
```

Partial:

```go-html-template
{{ return (dict
  "canonical" .Permalink
  "section" .Section
  "kind" .Kind
) }}
```

## Context safety inside range

```go-html-template
{{ $root := . }}
{{ range .Site.RegularPages }}
  <article>
    <a href="{{ .RelPermalink }}">{{ .Title }}</a>
    <span>Rendered from: {{ $root.Title }}</span>
  </article>
{{ end }}
```

## Common page collection patterns

Latest posts in a section:

```go-html-template
{{ $posts := where site.RegularPages "Section" "posts" }}
{{ range first 5 (sort $posts "Date" "desc") }}
  <a href="{{ .RelPermalink }}">{{ .Title }}</a>
{{ end }}
```

Featured content:

```go-html-template
{{ $featured := where site.RegularPages "Params.featured" true }}
{{ range $featured }}
  <a href="{{ .RelPermalink }}">{{ .Title }}</a>
{{ end }}
```

## Render hook for links

`layouts/_markup/render-link.html`

```html
<a href="{{ .Destination | safeURL }}" data-hook="link"{{ with .Title }} title="{{ . }}"{{ end }}>{{ .Text | safeHTML }}</a>
```

## Fingerprinted CSS asset

`layouts/_partials/styles.html`

```go-html-template
{{ with resources.Get "css/main.css" }}
  {{ $css := . | minify | fingerprint }}
  <link rel="stylesheet" href="{{ $css.RelPermalink }}" integrity="{{ $css.Data.Integrity }}">
{{ end }}
```

## Section-specific override

Use a more specific file when one section diverges:

```text
layouts/page.html
layouts/posts/page.html
```

The `posts/page.html` template can override the generic page template for content in the `posts` section.

## Template debugging commands

```bash
hugo
hugo server -D --disableFastRender
hugo --templateMetrics --templateMetricsHints
hugo config
```
