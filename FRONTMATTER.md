# Frontmatter Validation System

## Overview

Runtime validation of Hugo page frontmatter against a JSON schema. Invalid frontmatter generates build warnings with specific error messages.

**Key Features**:
- Schema-driven configuration
- Build-time validation (warnings only, doesn't block builds)
- Extensible validator architecture
- Custom error messages

---

## Validators

### Types

| Type | Location | Constraints |
|------|----------|-------------|
| `string` | `validators/types/string.html` | `pattern`, `min_length`, `max_length` |
| `number` | `validators/types/number.html` | `minimum`, `maximum`, `integer` |
| `array` | `validators/types/array.html` | `min_items`, `max_items` |
| `enum` | `validators/types/enum.html` | `items` (list) |

### Formats

| Format | Location | Extends |
|--------|----------|---------|
| `email` | `validators/formats/email.html` | `string` |
| `date` | `validators/formats/date.html` | `string` |
| `text` | `validators/formats/text.html` | `string` |
| `option` | `validators/formats/option.html` | `enum` |

Format validators delegate to their base type, inheriting all validation logic.

---

## Architecture

### Flow

```
single.html
  ↓
validate.html (orchestrator)
  ↓ Loads schema from data/presidium/frontmatter-schema.json
  ↓ Iterates fields
  ↓
validators/root.html
  ↓ Checks required/null
  ↓ Routes to type/format validator
  ↓
Type/Format Validator
  ↓ Validates constraints
  ↓ Stores result in .Scratch
  ↓
Root aggregates errors → Hugo warnf
```

### Root Validator Pattern

**Root Validator** handles lifecycle:
- Required field checking
- Null/empty value handling
- Routing to appropriate validator
- Error message formatting

**Type/Format Validators** handle business logic:
- Constraint validation only
- Assume value exists (root checked already)
- Store results in `.Scratch`

**Benefits**: DRY, extensible, maintainable (~30% less code per validator)

### .Scratch Pattern

Hugo converts partial returns to `template.HTML`, breaking dict access. Always use `.Scratch`:

```go-html-template
{{/* Caller */}}
{{- partial "validators/types/string.html" (dict 
    "value" $value "rules" $rules "fieldName" $fieldName "context" $ctx) -}}
{{- $result := $ctx.Scratch.Get "type_validation_result" -}}

{{/* Validator */}}
{{- $ctx := .context -}}
{{- $result := dict "valid" true "errors" slice -}}
{{- $ctx.Scratch.Set "type_validation_result" $result -}}
```

---

## Usage

### Quick Start

**1. Define schema** in `config/_default/frontmatter/params.yaml`:

```yaml
frontmatter:
  title:
    type: string
    required: true
    min_length: 5
    max_length: 100
    
  status:
    type: enum
    required: true
    items: [draft, published, archived]
    validation_message: "Status must be draft, published, or archived"
```

**2. Generate schema** (automatic in build):

```bash
hugo --config=config.yml,config-gen.yaml --destination data/presidium
```

**3. Validation runs automatically**. Invalid frontmatter shows warnings:

```
WARN  [Frontmatter Validation] post.md: title must be at least 5 characters
```

### Configuration

**Schema location** (configurable):
```yaml
params:
  data:
    namespace: "presidium"  # → data/presidium/frontmatter-schema.json
```

**Error messages**:
- Missing required field: `"fieldName is required"` (not customizable)
- Invalid value: Specific error OR custom `validation_message` from config

---

## Extending

### Add a Type Validator

**1. Create** `validators/types/<type>.html`:

```go-html-template
{{- $value := .value -}}
{{- $rules := .rules -}}
{{- $fieldName := .fieldName -}}
{{- $ctx := .context -}}
{{- $errors := slice -}}

{{/* Type check */}}
{{- $valueType := printf "%T" $value -}}
{{- if ne $valueType "bool" -}}
  {{- $errors = $errors | append (printf "%s must be true or false" $fieldName) -}}
{{- end -}}

{{/* Store result */}}
{{- $result := dict "valid" (eq (len $errors) 0) "errors" $errors -}}
{{- $ctx.Scratch.Set "type_validation_result" $result -}}
```

**2. Add to** `data/schemas/frontmatter/types.yaml`:

```yaml
boolean:
  # No constraints
```

**3. Use in config**:

```yaml
frontmatter:
  is_published:
    type: boolean
    required: true
```

### Add a Format Validator

**1. Create** `validators/formats/<format>.html`:

```go-html-template
{{- $value := .value -}}
{{- $rules := .rules -}}
{{- $fieldName := .fieldName -}}
{{- $ctx := .context -}}

{{/* Delegate to base type */}}
{{- partial "frontmatter/validators/types/string.html" (dict 
    "value" $value "rules" $rules "fieldName" $fieldName "context" $ctx) -}}

{{/* Pass through result */}}
{{- $result := $ctx.Scratch.Get "type_validation_result" -}}
{{- $ctx.Scratch.Set "type_validation_result" $result -}}
```

**2. Add to** `data/schemas/frontmatter/formats.yaml`:

```yaml
url:
  extends: string
  pattern: '^https?://[^\s/$.?#].[^\s]*$'
```

### Validator Checklist

- ✅ Accept: `value`, `rules`, `fieldName`, `context`
- ✅ Extract: `$ctx := .context`
- ✅ Store result: `$ctx.Scratch.Set "type_validation_result" $result`
- ✅ Never return directly
- ✅ Result: `dict "valid" (bool) "errors" (slice)`

---

## File Structure

```
layouts/partials/frontmatter/
├── load-schema.html              # Schema loader
├── validate.html                 # Orchestrator
└── validators/
    ├── root.html                 # Lifecycle handler
    ├── types/
    │   ├── string.html
    │   ├── number.html
    │   ├── array.html
    │   └── enum.html
    └── formats/
        ├── email.html
        ├── date.html
        ├── text.html
        └── option.html
```

**Total**: ~329 lines across 12 files

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Schema not found | Regenerate: `hugo --config=config.yml,config-gen.yaml --destination data/presidium` |
| Validation not running | Check build integration in `single.html` includes validation call |
| Wrong error messages | Verify field exists in frontmatter; check `validation_message` override |
