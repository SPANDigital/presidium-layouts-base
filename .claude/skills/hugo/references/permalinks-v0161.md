# Hugo permalink audit notes for v0.161.0+

Use this note when reviewing a Hugo site's URL configuration after the permalink matcher changes introduced in v0.161.0.

## What changed in v0.161.0

Hugo added an array form for `permalinks`.

Example:

```yaml
permalinks:
  - pattern: /:sectionslugs/
    target:
      kind: section
  - pattern: /:sectionslugs/:slug
    target:
      kind: page
```

Key behavior:

- each entry requires `pattern`
- `target` is optional
- `target` accepts a page matcher
- Hugo applies the first matching pattern

## What did NOT change in v0.161.0

The `:sectionslugs` token itself is older. Hugo docs mark `:sectionslugs` and `:sectionslug` as introduced in v0.149.0.

So when someone says "new permalink features from v0.161.0", usually they mean matcher-based array configuration, not the token.

## Safe review checklist

1. Inspect source config.
   - Is it old map form or new array form?
2. Inspect front matter.
   - `url:` overrides matching permalink config.
   - `slug:` affects only the final path segment.
3. Run `hugo config`.
   - Newer Hugo may normalize old map form into `[[permalinks]]` matcher entries in effective config output.
4. Build the site.
   - Verify real output paths, not just config theory.
5. Check aliases.
   - Legacy numbered URLs may still be emitted on purpose via `aliases:`.

## Practical interpretation rule

If source config is old-style but `hugo config` shows the expected matcher-based effective output and the built paths are correct, the permalink behavior is correct even though the source has not been migrated.

## Migration caution

Do not rewrite a site into explicit array form until the build pipeline, CI image, or deployment environment supports Hugo >= v0.161.0.

If local Hugo is newer than CI, local success is not enough.

## Good audit conclusion template

```text
The permalink behavior is correct.
The source config is still using the older map form.
Hugo <current version> normalizes it into matcher-based effective config.
Built output confirms the intended paths.
Do not migrate to explicit array form until CI/build pipeline supports Hugo >= v0.161.0.
Check front matter `url:` overrides before changing permalink config.
```
