# Partials catalog — `presidium-layouts-base`

> Auto-generated reference of every Hugo partial and `define` block in this theme. Think of it as the "class definitions" for the templates: name, inferred signature (the `dict` keys passed at call sites), whether it returns a value, and who calls it. **Check here before writing a new partial** to avoid duplicating existing functionality.

- **66** partials defined · **20** `define` blocks · **1** partials used but inherited from a base theme

Regenerate with `python3 gen_catalog.py`.

## Index

- **archive/** — [`archive/table`](#archivetable)
- **article/** — [`article/author`](#articleauthor), [`article/authorisvalid`](#articleauthorisvalid), [`article/content`](#articlecontent), [`article/footer`](#articlefooter), [`article/frontmatter`](#articlefrontmatter), [`article/header`](#articleheader), [`article/item`](#articleitem), [`article/nested`](#articlenested), [`article/roles`](#articleroles), [`article/root`](#articleroot), [`article/status`](#articlestatus), [`article/title`](#articletitle)
- **common/** — [`common/archive`](#commonarchive), [`common/copylink`](#commoncopylink), [`common/dummy`](#commondummy), [`common/filepath`](#commonfilepath), [`common/formatmessage`](#commonformatmessage), [`common/hugo-version-check`](#commonhugo-version-check), [`common/is-imported`](#commonis-imported), [`common/pages`](#commonpages), [`common/slug`](#commonslug), [`common/sortorder`](#commonsortorder), [`common/uuid`](#commonuuid)
- **compendium/** — [`compendium/item`](#compendiumitem), [`compendium/root`](#compendiumroot)
- **frontmatter/** — [`frontmatter/detect-config-sources`](#frontmatterdetect-config-sources), [`frontmatter/load-schema`](#frontmatterload-schema), [`frontmatter/normalize-empty-arrays`](#frontmatternormalize-empty-arrays), [`frontmatter/processField`](#frontmatterprocessField), [`frontmatter/schema-generator`](#frontmatterschema-generator), [`frontmatter/validate`](#frontmattervalidate), [`frontmatter/validators/root`](#frontmattervalidatorsroot), [`frontmatter/validators/types/array`](#frontmattervalidatorstypesarray), [`frontmatter/validators/types/boolean`](#frontmattervalidatorstypesboolean), [`frontmatter/validators/types/number`](#frontmattervalidatorstypesnumber), [`frontmatter/validators/types/object`](#frontmattervalidatorstypesobject), [`frontmatter/validators/types/string`](#frontmattervalidatorstypesstring), [`frontmatter/validators/types/taxonomy_term_lookup`](#frontmattervalidatorstypestaxonomy_term_lookup)
- **json/** — [`json/item`](#jsonitem), [`json/root`](#jsonroot)
- **navigation/** — [`navigation/footer`](#navigationfooter), [`navigation/menu-title`](#navigationmenu-title), [`navigation/nav-item`](#navigationnav-item), [`navigation/nav-item-external`](#navigationnav-item-external), [`navigation/root`](#navigationroot)
- **page/** — [`page/analytics`](#pageanalytics), [`page/attributes`](#pageattributes), [`page/embed/breadcrumbs`](#pageembedbreadcrumbs), [`page/footer`](#pagefooter), [`page/globalfooter`](#pageglobalfooter), [`page/header`](#pageheader), [`page/info`](#pageinfo), [`page/list`](#pagelist), [`page/modal`](#pagemodal), [`page/parentheader`](#pageparentheader), [`page/script`](#pagescript), [`page/single`](#pagesingle)
- **pdf/** — [`pdf/article`](#pdfarticle), [`pdf/common/parent-slug`](#pdfcommonparent-slug)
- **searchmap/** — [`searchmap/item`](#searchmapitem), [`searchmap/root`](#searchmaproot)
- **title-bar/** — [`title-bar/brand`](#title-barbrand), [`title-bar/root`](#title-barroot)
- **type/** — [`type/typeclass`](#typetypeclass)
- **url/** — [`url/permalink`](#urlpermalink)

## Partials

### archive/

<a id="archivetable"></a>
#### `archive/table`
`{{ partial "archive/table" . }}` · `layouts/partials/archive/table.html`  
**Params (dict):** `NavPage`, `Pages`  
**Called by:** `layouts/partials/common/archive.html:10`  

### article/

<a id="articleauthor"></a>
#### `article/author`
`{{ partial "article/author" . }}` · `layouts/partials/article/author.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/article/frontmatter.html:25`, `layouts/partials/article/card.html:10`, `layouts/partials/article/frontmatter.html:27`, `layouts/partials/home/hero.html:10`  

<a id="articleauthorisvalid"></a>
#### `article/authorisvalid` — _returns a value_
`{{ partial "article/authorisvalid" . }}` · `layouts/partials/article/authorisvalid.html`  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

<a id="articlecontent"></a>
#### `article/content`
`{{ partial "article/content" . }}` · `layouts/partials/article/content.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/article/item.html:60`  

<a id="articlefooter"></a>
#### `article/footer`
`{{ partial "article/footer" . }}` · `layouts/partials/article/footer.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/article/item.html:61`  

<a id="articlefrontmatter"></a>
#### `article/frontmatter`
`{{ partial "article/frontmatter" . }}` · `layouts/partials/article/frontmatter.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/article/item.html:59`, `layouts/partials/page/list.html:30`  

<a id="articleheader"></a>
#### `article/header`
`{{ partial "article/header" . }}` · `layouts/partials/article/header.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/article/item.html:57`  

<a id="articleitem"></a>
#### `article/item`
`{{ partial "article/item" . }}` · `layouts/partials/article/item.html`  
Atomic article renderer - handles individual article display without recursion.  
**Params (dict):** `page`, `single`  
**Called by:** `layouts/partials/article/nested.html:33`  

<a id="articlenested"></a>
#### `article/nested`
`{{ partial "article/nested" . }}` · `layouts/partials/article/nested.html`  
performance nested article renderer using Hugo's template functions.  
**Params (dict):** `page`, `single`  
**Called by:** `layouts/partials/article/root.html:15`  

<a id="articleroles"></a>
#### `article/roles`
`{{ partial "article/roles" . }}` · `layouts/partials/article/roles.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/article/frontmatter.html:27`  

<a id="articleroot"></a>
#### `article/root`
`{{ partial "article/root" . }}` · `layouts/partials/article/root.html`  
Entry point for recursive article rendering system.  
**Params (dict):** `page`, `single`  
**Called by:** `layouts/_default/single.embed.html:33`, `layouts/partials/page/list.html:57`, `layouts/partials/page/list.html:71`, `layouts/partials/page/single.html:32`, `layouts/_default/single.html:18`  

<a id="articlestatus"></a>
#### `article/status`
`{{ partial "article/status" . }}` · `layouts/partials/article/status.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/article/frontmatter.html:26`  

<a id="articletitle"></a>
#### `article/title`
`{{ partial "article/title" . }}` · `layouts/partials/article/title.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/article/item.html:58`  

### common/

<a id="commonarchive"></a>
#### `common/archive`
`{{ partial "common/archive" . }}` · `layouts/partials/common/archive.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/single.html:16`  

<a id="commoncopylink"></a>
#### `common/copylink`
`{{ partial "common/copylink" . }}` · `layouts/partials/common/copylink.html`  
**Params (dict):** `Page`, `copyTitle`, `permalink`, `slug`  
**Called by:** `layouts/partials/article/title.html:33`, `layouts/partials/page/header.html:13`, `layouts/partials/page/parentheader.html:10`, `layouts/partials/article/frontmatter.html:19`, `layouts/partials/article/frontmatter.html:25`  

<a id="commondummy"></a>
#### `common/dummy`
`{{ partial "common/dummy" . }}` · `layouts/partials/common/dummy.html`  
a dummy template to force block overrides with no content  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/list.embed.html:2`, `layouts/_default/list.embed.html:6`, `layouts/_default/list.embed.html:10`, `layouts/_default/single.embed.html:2`, `layouts/_default/single.embed.html:6`, `layouts/_default/single.embed.html:10`, `layouts/partials/page/header.html:3`, `layouts/partials/page/header.html:2`  

<a id="commonfilepath"></a>
#### `common/filepath` — _returns a value_
`{{ partial "common/filepath" . }}` · `layouts/partials/common/filepath.html`  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

<a id="commonformatmessage"></a>
#### `common/formatmessage`
`{{ partial "common/formatmessage" . }}` · `layouts/partials/common/formatmessage.html`  
This partial formats the error/warning message based on the strict parameter  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

<a id="commonhugo-version-check"></a>
#### `common/hugo-version-check`
`{{ partial "common/hugo-version-check" . }}` · `layouts/partials/common/hugo-version-check.html`  
Hugo version compatibility check  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/baseof.html:8`  

<a id="commonis-imported"></a>
#### `common/is-imported` — _returns a value_
`{{ partial "common/is-imported" . }}` · `layouts/partials/common/is-imported.html`  
Checks if the current page/content is from an imported content module.  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/article/item.html:28`, `layouts/partials/navigation/nav-item.html:40`, `layouts/partials/page/list.html:14`, `layouts/partials/page/single.html:13`  

<a id="commonpages"></a>
#### `common/pages` — _returns a value_
`{{ partial "common/pages" . }}` · `layouts/partials/common/pages.html`  
Returns the pages after filtering out the archived articles  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/article/item.html:41`, `layouts/partials/navigation/nav-item.html:69`, `layouts/partials/page/list.html:37`, `layouts/partials/navigation/nav-item.html:66`  

<a id="commonslug"></a>
#### `common/slug` — _returns a value_
`{{ partial "common/slug" . }}` · `layouts/partials/common/slug.html`  
canonical slug for a page. Priority: front-matter slug -> title -> file name.  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/article/item.html:18`, `layouts/partials/article/title.html:1`, `layouts/partials/navigation/nav-item.html:9`, `layouts/partials/page/header.html:7`, `layouts/partials/page/list.html:11`, `layouts/partials/page/parentheader.html:4`, `layouts/partials/page/single.html:11`, `layouts/partials/pdf/article.html:5` _(+6 more)_  

<a id="commonsortorder"></a>
#### `common/sortorder` — _returns a value_
`{{ partial "common/sortorder" . }}` · `layouts/partials/common/sortorder.html`  
Default sort order is ascending when empty  
**Params (dict):** `SortByFilePath`  
**Called by:** `layouts/partials/article/nested.html:42`, `layouts/partials/navigation/nav-item.html:73`, `layouts/partials/page/list.html:43`  

<a id="commonuuid"></a>
#### `common/uuid` — _returns a value_
`{{ partial "common/uuid" . }}` · `layouts/partials/common/uuid.html`  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

### compendium/

<a id="compendiumitem"></a>
#### `compendium/item` — _returns a value_
`{{ partial "compendium/item" . }}` · `layouts/partials/compendium/item.html`  
**Params (dict):** `Category`, `Level`, `Page`, `Section`  
**Called by:** `layouts/partials/compendium/item.html:38`, `layouts/partials/compendium/root.html:7`  

<a id="compendiumroot"></a>
#### `compendium/root` — _returns a value_
`{{ partial "compendium/root" . }}` · `layouts/partials/compendium/root.html`  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

### frontmatter/

<a id="frontmatterdetect-config-sources"></a>
#### `frontmatter/detect-config-sources` — _returns a value_
`{{ partial "frontmatter/detect-config-sources" . }}` · `layouts/partials/frontmatter/detect-config-sources.html`  
**Params (dict):** `fieldName`, `mergedFieldConfig`, `sources`  
**Called by:** `layouts/partials/frontmatter/detect-config-sources.html:27`, `layouts/partials/frontmatter/schema-generator.html:403`  

<a id="frontmatterload-schema"></a>
#### `frontmatter/load-schema`
`{{ partial "frontmatter/load-schema" . }}` · `layouts/partials/frontmatter/load-schema.html`  
Schema Loader - reads complete schema from data directory  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/frontmatter/load-schema.html:3`, `layouts/partials/frontmatter/validate.html:6`  

<a id="frontmatternormalize-empty-arrays"></a>
#### `frontmatter/normalize-empty-arrays` — _returns a value_
`{{ partial "frontmatter/normalize-empty-arrays" . }}` · `layouts/partials/frontmatter/normalize-empty-arrays.html`  
Recursively normalize empty arrays to null to avoid Hugo YAML marshaller bug (issue #14596)  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/frontmatter/normalize-empty-arrays.html:20`  

<a id="frontmatterprocessField"></a>
#### `frontmatter/processField` — _returns a value_
`{{ partial "frontmatter/processField" . }}` · `layouts/partials/frontmatter/processField.html`  
=============================================================================  
**Params (dict):** `dataTypes`, `fieldConfig`, `fieldKey`  
**Called by:** `layouts/partials/frontmatter/processField.html:62`, `layouts/partials/frontmatter/processField.html:85`, `layouts/partials/frontmatter/schema-generator.html:397`  

<a id="frontmatterschema-generator"></a>
#### `frontmatter/schema-generator` — _returns a value_
`{{ partial "frontmatter/schema-generator" . }}` · `layouts/partials/frontmatter/schema-generator.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/frontmatter/schema-generator.html:14`  

<a id="frontmattervalidate"></a>
#### `frontmatter/validate`
`{{ partial "frontmatter/validate" . }}` · `layouts/partials/frontmatter/validate.html`  
Validation Orchestrator - coordinates validation of all frontmatter fields  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/list.html:46`, `layouts/_default/single.html:44`, `layouts/partials/frontmatter/validate.html:2`  

<a id="frontmattervalidatorsroot"></a>
#### `frontmatter/validators/root`
`{{ partial "frontmatter/validators/root" . }}` · `layouts/partials/frontmatter/validators/root.html`  
Root Validator - common validation lifecycle for all types  
**Params (dict):** `context`, `fieldName`, `pageParams`, `rules`, `value`  
**Called by:** `layouts/partials/frontmatter/validate.html:21`, `layouts/partials/frontmatter/validators/types/array.html:21`, `layouts/partials/frontmatter/validators/types/object.html:28`  

<a id="frontmattervalidatorstypesarray"></a>
#### `frontmatter/validators/types/array`
`{{ partial "frontmatter/validators/types/array" . }}` · `layouts/partials/frontmatter/validators/types/array.html`  
Array Validator - validates array type only  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

<a id="frontmattervalidatorstypesboolean"></a>
#### `frontmatter/validators/types/boolean`
`{{ partial "frontmatter/validators/types/boolean" . }}` · `layouts/partials/frontmatter/validators/types/boolean.html`  
Boolean Validator - validates boolean type  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

<a id="frontmattervalidatorstypesnumber"></a>
#### `frontmatter/validators/types/number`
`{{ partial "frontmatter/validators/types/number" . }}` · `layouts/partials/frontmatter/validators/types/number.html`  
Number Type Validator - validates number type only  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

<a id="frontmattervalidatorstypesobject"></a>
#### `frontmatter/validators/types/object`
`{{ partial "frontmatter/validators/types/object" . }}` · `layouts/partials/frontmatter/validators/types/object.html`  
Object Validator - validates object type  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

<a id="frontmattervalidatorstypesstring"></a>
#### `frontmatter/validators/types/string`
`{{ partial "frontmatter/validators/types/string" . }}` · `layouts/partials/frontmatter/validators/types/string.html`  
String Validator - validates string type and pattern  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

<a id="frontmattervalidatorstypestaxonomy_term_lookup"></a>
#### `frontmatter/validators/types/taxonomy_term_lookup`
`{{ partial "frontmatter/validators/types/taxonomy_term_lookup" . }}` · `layouts/partials/frontmatter/validators/types/taxonomy_term_lookup.html`  
Taxonomy Term Lookup Validator - validates taxonomy term values  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

### json/

<a id="jsonitem"></a>
#### `json/item` — _returns a value_
`{{ partial "json/item" . }}` · `layouts/partials/json/item.html`  
**Params (dict):** `CurrentPage`, `Level`, `NavPage`, `Roles`  
**Called by:** `layouts/partials/json/item.html:17`, `layouts/partials/json/root.html:11`  

<a id="jsonroot"></a>
#### `json/root` — _returns a value_
`{{ partial "json/root" . }}` · `layouts/partials/json/root.html`  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

### navigation/

<a id="navigationfooter"></a>
#### `navigation/footer`
`{{ partial "navigation/footer" . }}` · `layouts/partials/navigation/footer.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/navigation/root.html:31`  

<a id="navigationmenu-title"></a>
#### `navigation/menu-title`
`{{ partial "navigation/menu-title" . }}` · `layouts/partials/navigation/menu-title.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/navigation/nav-item.html:60`, `layouts/partials/navigation/nav-item.html:57`  

<a id="navigationnav-item"></a>
#### `navigation/nav-item`
`{{ partial "navigation/nav-item" . }}` · `layouts/partials/navigation/nav-item.html`  
**Params (dict):** `Collapsed`, `CurrentPage`, `Expanded`, `Index`, `Level`, `MenuName`, `NavPage`, `RootUrl`, `Show`, `UseSectionViewUrlFormat`  
**Called by:** `layouts/partials/navigation/nav-item.html:76`, `layouts/partials/navigation/nav-item.html:80`, `layouts/partials/navigation/root.html:24`, `layouts/partials/navigation/nav-item.html:69`, `layouts/partials/navigation/nav-item.html:76`, `layouts/partials/navigation/root.html:42`  

<a id="navigationnav-item-external"></a>
#### `navigation/nav-item-external`
`{{ partial "navigation/nav-item-external" . }}` · `layouts/partials/navigation/nav-item-external.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/navigation/root.html:20`, `layouts/partials/navigation/root.html:31`  

<a id="navigationroot"></a>
#### `navigation/root`
`{{ partial "navigation/root" . }}` · `layouts/partials/navigation/root.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/baseof.html:93`  

### page/

<a id="pageanalytics"></a>
#### `page/analytics`
`{{ partial "page/analytics" . }}` · `layouts/partials/page/analytics.html`  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

<a id="pageattributes"></a>
#### `page/attributes` — _returns a value_
`{{ partial "page/attributes" . }}` · `layouts/partials/page/attributes.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/baseof.html:63`  

<a id="pageembedbreadcrumbs"></a>
#### `page/embed/breadcrumbs`
`{{ partial "page/embed/breadcrumbs" . }}` · `layouts/partials/page/embed/breadcrumbs.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/list.embed.html:14`, `layouts/_default/single.embed.html:14`  

<a id="pagefooter"></a>
#### `page/footer`
`{{ partial "page/footer" . }}` · `layouts/partials/page/footer.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/baseof.html:111`, `layouts/_default/list.html:66`, `layouts/_default/single.html:67`, `layouts/_default/single.html:23`, `layouts/archive/list.html:11`  

<a id="pageglobalfooter"></a>
#### `page/globalfooter`
`{{ partial "page/globalfooter" . }}` · `layouts/partials/page/globalfooter.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/baseof.html:118`  

<a id="pageheader"></a>
#### `page/header`
`{{ partial "page/header" . }}` · `layouts/partials/page/header.html`  
This file is for the PAGE header, which sits outside the section  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/list.embed.html:19`, `layouts/_default/list.html:38`, `layouts/_default/single.embed.html:19`, `layouts/_default/single.html:11`, `layouts/archive/list.html:3`  

<a id="pageinfo"></a>
#### `page/info`
`{{ partial "page/info" . }}` · `layouts/partials/page/info.html`  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

<a id="pagelist"></a>
#### `page/list`
`{{ partial "page/list" . }}` · `layouts/partials/page/list.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/list.embed.html:31`, `layouts/_default/list.html:60`  

<a id="pagemodal"></a>
#### `page/modal` — _used via `partialCached`_
`{{ partial "page/modal" . }}` · `layouts/partials/page/modal.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/baseof.html:130`  

<a id="pageparentheader"></a>
#### `page/parentheader`
`{{ partial "page/parentheader" . }}` · `layouts/partials/page/parentheader.html`  
This file is for the PAGE header, which sits outside the section  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/single.html:37`  

<a id="pagescript"></a>
#### `page/script` — _used via `partialCached`_
`{{ partial "page/script" . }}` · `layouts/partials/page/script.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/baseof.html:131`  

<a id="pagesingle"></a>
#### `page/single`
`{{ partial "page/single" . }}` · `layouts/partials/page/single.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/single.html:59`  

### pdf/

<a id="pdfarticle"></a>
#### `pdf/article`
`{{ partial "pdf/article" . }}` · `layouts/partials/pdf/article.html`  
**Params (dict):** `context`, `depth`  
**Called by:** `layouts/index.pdf.html:24`, `layouts/partials/pdf/article.html:25`, `layouts/partials/pdf/article.html:29`  

<a id="pdfcommonparent-slug"></a>
#### `pdf/common/parent-slug` — _returns a value_
`{{ partial "pdf/common/parent-slug" . }}` · `layouts/partials/pdf/common/parent-slug.html`  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

### searchmap/

<a id="searchmapitem"></a>
#### `searchmap/item` — _returns a value_
`{{ partial "searchmap/item" . }}` · `layouts/partials/searchmap/item.html`  
**Params (dict):** `Category`, `Level`, `Page`, `Section`  
**Called by:** `layouts/partials/searchmap/item.html:47`, `layouts/partials/searchmap/root.html:4`  

<a id="searchmaproot"></a>
#### `searchmap/root` — _returns a value_
`{{ partial "searchmap/root" . }}` · `layouts/partials/searchmap/root.html`  
**Params:** plain context (`.`)  
**Called by:** _no internal call sites found (entry point or external)_  

### title-bar/

<a id="title-barbrand"></a>
#### `title-bar/brand`
`{{ partial "title-bar/brand" . }}` · `layouts/partials/title-bar/brand.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/partials/title-bar/root.html:3`  

<a id="title-barroot"></a>
#### `title-bar/root`
`{{ partial "title-bar/root" . }}` · `layouts/partials/title-bar/root.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/baseof.html:82`  

### type/

<a id="typetypeclass"></a>
#### `type/typeclass`
`{{ partial "type/typeclass" . }}` · `layouts/partials/type/typeclass.html`  
**Params:** plain context (`.`)  
**Called by:** `layouts/_default/baseof.html:85`  

### url/

<a id="urlpermalink"></a>
#### `url/permalink` — _returns a value_
`{{ partial "url/permalink" . }}` · `layouts/partials/url/permalink.html`  
**Params (dict):** `page`, `single`, `slug`, `warn`  
**Called by:** `layouts/partials/article/item.html:23`, `layouts/partials/compendium/item.html:14`, `layouts/partials/json/item.html:7`, `layouts/partials/navigation/nav-item.html:26`, `layouts/partials/searchmap/item.html:22`, `layouts/shortcodes/tooltip.html:23`, `layouts/partials/navigation/nav-item.html:27`  

## `define` blocks (named template regions)

| Block | Defined in |
|---|---|
| `breadcrumbs` | `layouts/_default/list.embed.html` |
| `breadcrumbs` | `layouts/_default/single.embed.html` |
| `content` | `layouts/_default/list.embed.html` |
| `content` | `layouts/_default/list.html` |
| `content` | `layouts/index.html` |
| `footer` | `layouts/_default/list.html` |
| `footer` | `layouts/_default/single.html` |
| `header` | `layouts/_default/list.embed.html` |
| `header` | `layouts/_default/list.html` |
| `header` | `layouts/_default/single.embed.html` |
| `header` | `layouts/_default/single.html` |
| `left-sidebar` | `layouts/_default/list.embed.html` |
| `left-sidebar` | `layouts/_default/single.embed.html` |
| `renderArticleTree` | `layouts/partials/article/nested.html` |
| `scripts` | `layouts/_default/list.embed.html` |
| `scripts` | `layouts/_default/single.embed.html` |
| `section` | `layouts/_default/single.embed.html` |
| `section` | `layouts/_default/single.html` |
| `toolbar` | `layouts/_default/list.embed.html` |
| `toolbar` | `layouts/_default/single.embed.html` |

## Used but inherited (defined in a base theme, not here)

These partial names are called in this theme but have no definition in this repo — they resolve to the base theme (e.g. `presidium-layouts-base`). Look there for their definitions.

- `analytics`
