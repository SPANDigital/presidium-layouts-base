# Frontmatter Validation System

## Overview

Runtime validation of Hugo page frontmatter against a JSON schema. Invalid frontmatter generates build warnings with specific error messages.

**Key Features**:
- Schema-driven configuration
- Build-time validation (warnings only, doesn't block builds)
- Extensible validator architecture
- Custom error messages

---

## Schema Type System

The frontmatter system uses a flat type model with 8 types: 5 base types and 3 presets.

### Base Types

| Type | Mandatory Attributes | Optional Attributes |
|------|---------------------|---------------------|
| `string` | `type`, `error_message`, `placeholder_message` | `required` (false), `options` ([]), `pattern` (""), `display_rows` (1) |
| `number` | `type`, `error_message`, `placeholder_message` | `required` (false), `options` ([]) |
| `boolean` | `type`, `error_message`, `placeholder_message` | `required` (false) |
| `array` | `type`, `error_message`, `placeholder_message`, `field` | `required` (false) |
| `object` | `type`, `error_message`, `placeholder_message`, `fields` | `required` (false) |

### Preset Types (String-based)

| Type | Pattern | Attributes |
|------|---------|------------|
| `date` | `^\d{4}-\d{2}-\d{2}$` | All `string` attributes + preconfigured `pattern` |
| `datetime` | `^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(Z\|[+-]\d{2}:\d{2})$` | All `string` attributes + preconfigured `pattern` |
| `email` | `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$` | All `string` attributes + preconfigured `pattern` |

**Note**: Presets are self-contained type definitions with all string attributes explicitly defined.

### Validators

Runtime validators in `layouts/partials/frontmatter/validators/` perform type checking and constraint validation:

| Type | Validator Location | Validates |
|------|-------------------|-----------|
| `string` | `validators/types/string.html` | Type check + pattern matching |
| `number` | `validators/types/number.html` | Type check (int/float detection) |
| `boolean` | `validators/types/boolean.html` | Type check (bool validation) |
| `array` | `validators/types/array.html` | Type check (array validation) |
| `object` | `validators/types/object.html` | Type check (map/dict validation) |

**Common Field Validation**: The root validator (`validators/root.html`) handles common attributes for all types:
- `required`: Missing field validation
- `options`: Value-in-list validation
- `error_message`: Custom error message override

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

### Two-Tier Validation Architecture

The validation system uses a two-tier architecture separating common field validation from type-specific validation:

**Tier 1: Common Field Validation** (`validators/root.html`)
- Validates attributes common to all types:
  - `required`: Checks if field exists when mandatory
  - `options`: Validates value is in allowed list (applies to string, number types)
  - `error_message`: Overrides default error with custom message
- Handles lifecycle: null/empty value handling, routing to type validators
- Runs BEFORE type-specific validation

**Tier 2: Type-Specific Validation** (`validators/types/*.html`)
- Validates type-exclusive constraints:
  - `string`: Type check + pattern matching (regex validation)
  - `number`: Type check (int/float detection)
  - `boolean`: Type check (bool validation)
  - `array`: Type check (array validation)
  - `object`: Type check (map/dict validation)
- Assumes value exists (root validator already checked)
- Stores results in `.Scratch` for root validator retrieval

**Preset Types**: Types like `email`, `date`, `datetime` are string-based presets with preconfigured patterns. They route to `validators/types/string.html` which handles pattern validation.

**Benefits**: DRY architecture, extensible, maintainable (~40% less code per validator)

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
    pattern: "^.{5,}$"  # Minimum 5 characters via regex
    error_message: "Title must be at least 5 characters"
    placeholder_message: "Enter article title"

  email:
    type: email  # Preset type with built-in pattern
    required: true
    error_message: "Valid email required"
    placeholder_message: "user@example.com"

  status:
    type: string
    required: true
    options: [draft, published, archived]  # Value-in-list validation
    error_message: "Status must be draft, published, or archived"
    placeholder_message: "Select status"

  priority:
    type: number
    required: false
    options: [1, 2, 3, 4, 5]
    error_message: "Priority must be 1-5"
    placeholder_message: "Enter priority level"
```

**2. Generate schema** (automatic in build):

```bash
hugo --config=config.yml,config-gen.yaml --destination data/presidium
```

**3. Validation runs automatically**. Invalid frontmatter shows warnings:

```
WARN  [Frontmatter Validation] post.md: Title must be at least 5 characters
WARN  [Frontmatter Validation] post.md: Status must be draft, published, or archived
WARN  [Frontmatter Validation] post.md: Valid email required
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

## Schema Generation

The schema generator ([schema-generator.html](layouts/partials/frontmatter/schema-generator.html)) produces complete, self-contained schemas from Hugo configuration and type definitions.

### Two-Level Merge Architecture

Schema generation happens in two phases:

**Level 1: Hugo Config Merge (Automatic)**
```
base theme params  →  client theme params  →  module imports
         ↓                    ↓                      ↓
              Hugo Deep Merge (automatic)
                        ↓
                  Merged Config
```

Hugo automatically deep-merges `.Site.Params.frontmatter` from all sources (base theme, client theme, module imports). Nested maps are merged, not replaced.

**Level 2: Type Defaults Application (Schema Generator)**
```
For each field in merged config:
  1. Look up type definition from types.yaml
  2. Apply optional attribute defaults
  3. Override with explicit config values
  4. Recursively process nested structures (array.field, object.fields)
  5. Return complete field schema
```

### Mandatory vs Optional Attributes

**Mandatory attributes** (must be provided in config):
- Type declarations: `type`, `error_message`, `placeholder_message`
- Nested structures: `field` (for arrays), `fields` (for objects)
- Build fails with `errorf` if missing

**Optional attributes** (use defaults from type definition):
- `required` (default: `false`)
- `options` (default: `[]`)
- `pattern` (default: `""`)
- `display_rows` (default: `1`, string types only)

### Recursive Processing

**Critical**: Generated schemas are **complete and self-contained** with all nested structures fully resolved.

**Rationale**: External consumers (UI generators, validators) lack awareness of type definitions. They require complete schemas with ALL defaults applied at every nesting level.

**Example**:

```yaml
# User Config (Partial - Only Mandatory Attributes)
tags:
  type: array
  error_message: "Tags must be a list"
  placeholder_message: "Add tags"
  field:
    type: string
    error_message: "Tag must be text"
    placeholder_message: "Enter tag"

# Generated Schema (Complete with Recursive Defaults)
tags:
  type: array
  error_message: "Tags must be a list"
  placeholder_message: "Add tags"
  required: false              # Applied from array type
  field:
    type: string
    error_message: "Tag must be text"
    placeholder_message: "Enter tag"
    required: false            # Applied recursively from string type
    options: []                # Applied recursively
    pattern: ""                # Applied recursively
    display_rows: 1            # Applied recursively
```

### Schema Files

| File | Purpose |
|------|---------|
| `data/schemas/frontmatter/types.yaml` | Type definitions (5 base + 3 presets) |
| `layouts/partials/frontmatter/schema-generator.html` | Main generator (calls processField) |
| `layouts/partials/frontmatter/processField.html` | Recursive field processor |

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

### Add a Preset Type

Presets are self-contained type definitions (typically string-based) with preconfigured patterns.

**1. Add to** `data/schemas/frontmatter/types.yaml`:

```yaml
# Preset types include ALL attributes from their base type
phone:
  type: string                          # Mandatory
  error_message: string                 # Mandatory
  placeholder_message: string           # Mandatory
  required: false                       # Optional (default)
  options: []                           # Optional (default)
  pattern: '^\+?[1-9]\d{1,14}$'        # Preconfigured pattern
  display_rows: 1                       # Optional (default)
```

**2. Create validator** `validators/types/phone.html` (delegates to string validator):

```go-html-template
{{- $value := .value -}}
{{- $rules := .rules -}}
{{- $fieldName := .fieldName -}}
{{- $ctx := .context -}}

{{/* Delegate to string validator */}}
{{- partial "frontmatter/validators/types/string.html" (dict
    "value" $value "rules" $rules "fieldName" $fieldName "context" $ctx) -}}
```

**3. Use in config**:

```yaml
frontmatter:
  contact_number:
    type: phone
    error_message: "Invalid phone number"
    placeholder_message: "Enter phone number"
```

Schema generator will recursively apply all defaults (required, options, display_rows) and merge the preconfigured pattern.

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
