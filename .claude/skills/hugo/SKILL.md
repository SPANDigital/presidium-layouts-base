---
name: hugo
description: Use when creating, developing, building, or troubleshooting websites with the Hugo static site generator.
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [hugo, static-site-generator, ssg, markdown, themes, templates, deployment]
    related_skills: [plan, requesting-code-review]
---

# Hugo static site generator

## Overview

Use this skill when the user wants to create, run, edit, build, or debug a site built with Hugo.

Hugo is a static site generator with a CLI-centered workflow: create a project, add content under `content/`, render with templates and/or a theme, preview with `hugo server`, then build the deployable output with `hugo`.

Prefer Hugo's own CLI and documentation over framework-specific folklore. The canonical docs are at `https://gohugo.io/`.

Important current details confirmed from the docs and local CLI:

- The quick start docs use `hugo new project <path>`.
- `hugo new project` has aliases `project` and `site`, so `hugo new site <path>` also works.
- `hugo new content <path>` creates new content, usually with `draft = true` in front matter.
- `hugo server` is the development server and `hugo` / `hugo build` generates the static site.
- On newer Hugo versions, `languageCode` is deprecated; prefer `locale` in config.
- On this host, `hugo version` returned `hugo v0.161.1+extended+withdeploy`, so the extended edition is a good default recommendation.

## When to Use

- Create a new Hugo site or prototype
- Add posts, pages, sections, menus, and front matter
- Start a local dev server with drafts enabled
- Install or wire up a Hugo theme
- Build a production-ready static site into `public/` or another output directory
- Troubleshoot missing layouts, drafts not appearing, broken base URLs, or module/theme issues
- Inspect Hugo CLI capabilities such as `hugo mod`, `hugo list`, `hugo env`, and `hugo config`

Do not use this skill for:

- Next.js, Astro, Gatsby, Jekyll, or other non-Hugo site generators
- CMS-specific editing workflows that do not involve the Hugo CLI
- Generic Go module troubleshooting unrelated to a Hugo project

## Installation and verification

Prefer the extended edition unless the user explicitly says they only need the standard edition.

Documented installation commands from gohugo.io:

### macOS

```bash
brew install hugo
```

```bash
sudo port install hugo
```

### Windows

```powershell
choco install hugo-extended
```

```powershell
scoop install hugo-extended
```

```powershell
winget install Hugo.Hugo.Extended
```

### Linux

```bash
brew install hugo
```

```bash
sudo snap install hugo
```

Notes:

- The Linux snap is strictly confined; according to the docs, sites should live in the user's home directory or on removable media.
- Hugo quick start requires Hugo v0.158.0 or later and Git.

Always verify with:

```bash
hugo version
```

Useful environment check:

```bash
hugo env
```

## Core CLI map

These are the commands to reach for first:

```text
hugo                    Build the site
hugo build              Explicit build command
hugo server             Start the embedded dev server
hugo new project PATH   Create a new project
hugo new site PATH      Alias for new project
hugo new content PATH   Create a new content file
hugo list drafts        List draft content
hugo config             Show effective project config
hugo mod ...            Manage Hugo modules
hugo version            Show version
hugo env                Show version and environment info
```

## Standard workflow

### 1. Create a project

Use one of these:

```bash
hugo new project mysite
```

```bash
hugo new site mysite
```

If you want YAML or JSON config instead of TOML:

```bash
hugo new project mysite --format yaml
```

Then enter the project:

```bash
cd mysite
```

### 2. Set minimal config

Prefer `locale` over the deprecated `languageCode` key.

Minimal `hugo.toml`:

```toml
baseURL = 'https://example.org/'
locale = 'en-us'
title = 'My Hugo Site'
```

If a theme is being used, add its config according to the theme docs. For a classic themes-directory setup this may look like:

```toml
theme = 'ananke'
```

### 3. Create content

Create a post or page:

```bash
hugo new content posts/my-first-post.md
```

```bash
hugo new content about.md
```

Typical generated front matter looks like this:

```toml
+++
title = 'My First Post'
date = 2026-06-10T12:00:00Z
draft = true
+++
```

Important behavior:

- New content is often created as draft content.
- `hugo` will not publish drafts by default.
- For local preview, use `hugo server -D`.
- For production builds, flip `draft = false` or remove the draft flag if appropriate.

### 4. Preview locally

Most common dev command:

```bash
hugo server -D
```

Useful variations:

```bash
hugo server --bind 0.0.0.0 --port 1313 -D
```

```bash
hugo server --disableFastRender -D
```

Useful server facts confirmed from local CLI help:

- Default bind address is `127.0.0.1`
- Default port is `1313`
- File watching is enabled by default
- `-D` includes draft content
- `--openBrowser` opens the site after startup
- `--tlsAuto` can generate locally trusted certificates

### 5. Build for deployment

Default build:

```bash
hugo
```

Explicit build command:

```bash
hugo build
```

Choose an output directory:

```bash
hugo --destination public
```

Common production-ish build:

```bash
hugo --minify --gc
```

Draft and scheduling control:

```bash
hugo -D
hugo -F
hugo -E
```

These flags include draft, future, or expired content respectively. Use them intentionally; they are usually not what you want for production.

## Themes: two common approaches

### Approach A: classic themes directory

The official quick start uses a Git submodule. Example:

```bash
git init
git submodule add https://github.com/gohugo-ananke/ananke themes/ananke
```

Then set the theme in `hugo.toml`:

```toml
theme = 'ananke'
```

This is a good default when the theme's docs show a `themes/<name>` workflow.

### Approach B: Hugo Modules

When a theme uses Hugo Modules, initialize the project module first:

```bash
hugo mod init example.com/mysite
```

Then follow the theme's module import instructions.

Useful maintenance commands:

```bash
hugo mod tidy
hugo mod get
hugo mod verify
```

Use module mode when the theme or component docs explicitly refer to `module.imports`, `go.mod`, or Hugo Modules.

## Minimal no-theme site recipe

Use this when the user wants the smallest reproducible Hugo setup without pulling a third-party theme.

1. Create the project:

```bash
hugo new project demo
cd demo
```

2. Create a minimal config:

```toml
baseURL = 'https://example.org/'
locale = 'en-us'
title = 'Demo Site'
```

3. Add minimal templates:

`layouts/_default/baseof.html`

```html
<!doctype html>
<html><body>{{ block "main" . }}{{ end }}</body></html>
```

`layouts/index.html`

```html
{{ define "main" }}
<h1>{{ .Site.Title }}</h1>
{{ range .Site.RegularPages }}
  <a href="{{ .RelPermalink }}">{{ .Title }}</a>
{{ end }}
{{ end }}
```

`layouts/_default/single.html`

```html
{{ define "main" }}
<article>
  <h1>{{ .Title }}</h1>
  {{ .Content }}
</article>
{{ end }}
```

4. Add content:

```bash
hugo new content posts/hello.md
```

Then edit the file so `draft = false` and add body content.

5. Preview or build:

```bash
hugo server -D
```

```bash
hugo --destination public
```

This exact pattern was validated locally with Hugo v0.161.1: project creation, content creation, module initialization, and a build to a custom destination all succeeded.

## Permalinks and Hugo v0.161.0+

When working on URL structure, distinguish between the permalink tokens and the permalink configuration form.

Important rules:

- `:sectionslugs` and `:sectionslug` are permalink tokens introduced before v0.161.0 (the docs mark them as new in v0.149.0).
- The notable permalink feature added in v0.161.0 is the array form, where each entry uses a `pattern` and an optional `target` page matcher.
- In array form, Hugo applies the first matching pattern.
- Hugo still supports the older map form for section-based configuration.
- The `url` front matter field overrides any matching permalink pattern.

Array-form example:

```yaml
permalinks:
  - pattern: /:sectionslugs
    target:
      kind: section
  - pattern: /:sectionslugs/:slug
    target:
      kind: page
```

Audit workflow for permalink-heavy themes or sites:

1. Read the source config and determine whether it uses map form or array form.
2. Check for page-level `url:` overrides in front matter before blaming the permalink config.
3. Run `hugo config` to inspect Hugo's effective configuration.
4. If local Hugo is newer, note that `hugo config` may normalize older map-form rules into matcher-based `[[permalinks]]` output.
5. Verify with a real build and inspect generated output paths under `public/` or a temporary `--destination`.

Compatibility pitfall:

- Do not migrate a site to explicit v0.161.0 array-form permalinks just because your local Hugo understands it.
- First verify the build pipeline, CI image, or deployment environment supports Hugo >= v0.161.0.
- If the pipeline is pinned below v0.161.0, keep the older source form until the pipeline is upgraded, even if a newer local Hugo normalizes it correctly.
- In Hugo module/theme setups, all merged configs that define `permalinks` need to use the same data shape. If the site config uses array form but an imported module or theme config still uses map form, Hugo can fail during config merge with a panic like `interface conversion: interface {} is []interface {}, not hmaps.Params`.
- When migrating permalinks in a module-based site, audit both the project config and every imported module/theme config that defines `permalinks`, including local `replace` overrides in `go.mod`.
- After converting to array form, run both `hugo config` and a real `hugo` build. A successful edit to the site config alone is not enough proof if a module config still uses the old shape.

See also `references/permalinks-v0161.md` for a compact audit note.

## Recommended troubleshooting workflow

When a Hugo site is broken, inspect in this order:

1. Verify the toolchain:

```bash
hugo version
hugo env
```

2. Inspect config:

```bash
hugo config
```

3. Preview with drafts and full warnings visible:

```bash
hugo server -D
```

4. Do a clean-ish production build:

```bash
hugo --gc --minify
```

5. Inspect content state:

```bash
hugo list drafts
hugo list future
hugo list expired
```

6. If modules are involved:

```bash
hugo mod tidy
hugo mod verify
```

## Common Pitfalls

1. Using `languageCode` in new configs.
   - On newer Hugo versions this is deprecated.
   - Prefer `locale = 'en-us'`.

2. Expecting draft content to appear in a normal build.
   - `hugo` excludes drafts by default.
   - Use `hugo server -D` while writing, then set `draft = false` before release.

3. Seeing `found no layout file` warnings.
   - This means Hugo cannot find a template for a content kind such as `section`, `taxonomy`, `home`, or `single`.
   - Fix by adding matching templates under `layouts/` or by installing/configuring a theme that provides them.

4. Pulling in a theme without following that theme's installation style.
   - Some themes expect the `themes/` directory.
   - Others expect Hugo Modules and imports in config.
   - Read the theme's docs before guessing.

5. Broken absolute links after deploy.
   - Usually `baseURL` is wrong for the final host.
   - Set `baseURL` to the production URL before build, or use environment-specific config.

6. Creating content from the wrong directory.
   - `hugo new content ...` should be run from the project root unless you are explicitly using `--source`.

7. Linux snap confusion.
   - The snap package is confined.
   - Keep the site in the home directory or use the snap permissions documented by Hugo.

8. Assuming `hugo server` is the same as a production deployment.
   - It is a development server with live reload.
   - Always do a real `hugo` build before claiming the site is deploy-ready.

## Output patterns for Hermes

When helping a user with Hugo, prefer concise, command-first answers in this shape:

```text
Goal: <what we are doing>
Project root: <path>
Commands:
1. <command>
2. <command>
Files to edit:
- <path>
Verification:
- <what to check>
```

If you actually built or tested something, include:

- the Hugo version used
- the project path
- the command that succeeded
- the output directory or served URL
- any warnings that still remain

## Verification Checklist

- [ ] `hugo version` runs successfully
- [ ] The project was created with `hugo new project` or `hugo new site`
- [ ] Config includes a correct `baseURL` and uses `locale` instead of deprecated `languageCode`
- [ ] New content exists under `content/`
- [ ] Draft behavior is understood: `hugo server -D` for preview, `draft = false` for production
- [ ] Templates or a theme exist so the site can render without missing-layout surprises
- [ ] `hugo` or `hugo build` completed successfully
- [ ] The output directory (`public/` by default, or custom `--destination`) contains generated files
- [ ] Any module-based theme setup was followed with `hugo mod tidy` / `hugo mod verify` as needed

## References

- Hugo home: https://gohugo.io/
- Getting started: https://gohugo.io/getting-started/
- Quick start: https://gohugo.io/getting-started/quick-start/
- Installation: https://gohugo.io/installation/
- CLI commands: https://gohugo.io/commands/
