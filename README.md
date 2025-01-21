# presidium-layouts-base
Base Hugo layouts for Presidium

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
