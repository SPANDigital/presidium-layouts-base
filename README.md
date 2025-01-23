# presidium-layouts-base
This repo makes up the `layouts` portion of the Presidium System Level Theme, and contains the officially support theme features.
For more info on Hugo Themes see the official Hugo documentation [here](https://gohugo.io/hugo-modules/theme-components/) 

# Getting Started

### Method 1 - Just using the Presidium Themes in your Hugo site (Default)
Update the `config.yml`:
```
module:
  imports:
  - path: github.com/SPANDigital/presidium-styling-base
  - path: github.com/spandigital/presidium-layouts-base
```

### Method 2 - Working on contributing to this repo in local development.
1. Clone the theme
1. Clone the [presidium-test-validation](https://github.com/SPANDigital/presidium-test-validation) repo. We use the `presidium-test-validation` repo as the styling and functionality test bed, where we throw all the officially supported features in with the kitchen sink, so that we can validate every theme change has no unintended effects.
1. Open the `go.mod` file in your `presidium-test-validation` clone.
1. Add the following to the bottom of your `go.mod` file, and update the path after the arrow to the correct path where you cloned the theme layout:
```
replace github.pie.apple.com/ase-docs/presidium-layouts-base => /{path-on-your-machine}/presidium-layouts-base
```

4. Run a refresh and then build the docset with Hugo:
```
make refresh
```
If you don't have the Makefile in your docset, then you can copy it from [here](https://github.com/SPANDigital/presidium/blob/develop/templates/default/Makefile)
Then run
```
make serve
```
Your served site should be available on `localhost:1313`.

---

## Conventional Commits

At SPAN we use [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) to make our commit messages more useful.

## Semantic Releases

This repository uses [Semantic Release](https://semantic-release.gitbook.io/semantic-release/) tool to automate version management and package publishing.

Upon merging into to the main or develop branch, Semantic Release tool will:
- Calculate the new release version based on the commits
- Create a git commit and a git tag for the release
- Create a Release with release notes from the commit messages
- Create and publish the container images

---

## Branching

Please see this [Presidium Git Strategy Miro board](https://miro.com/app/board/uXjVPK0XxiU=/).

In summary:
- `main` ⇾ production
  - Only hotfixes or `develop` get merged into `main`
- `develop`
  - Feature branches and bug fixes are branched from and merged into `develop`
- `feat/<TITLE>`
  - If there is a feature in development it will be on a feature branch

---

# Advanced Configuration

## Custom Output Formats

### Snippets

The `Snippet` output format is a alternative HTML output format to the standard output  (`index.html`) for _pages_ and _sections_. It's intended for generating standalone articles that can be used in third-party/isolated contexts (such as in an `iframe`).

Features of a snippet:
 - Generates content from the `content/` directory.
 - Uses the same stylesheets as the standard output.
 - Excludes inter-host navigation contexts that are in the standard output, such as the toolbar and left sidebar.
 - Includes breadcrumbs to ancestor snippets for limited navigation within the docset.

**Usage**  

Snippet outputs must be configured per docset repository in `config.yml`.

```yaml
# <my-docset>/config.yml
...
outputs:
  page:
    - html      # -> index.html
    - snippet   # -> snippet.html
  section:
    - html      # -> index.html
    - snippet   # -> snippet.html
```
