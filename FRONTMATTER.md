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

Runtime validators in `layouts/partials/frontmatter/validators/` perform constraint checking:

| Type | Validator Location | Validates |
|------|-------------------|-----------|
| `string` | `validators/types/string.html` | Pattern, length constraints |
| `number` | `validators/types/number.html` | Min/max, integer constraints |
| `array` | `validators/types/array.html` | Item count constraints |
| `enum` | `validators/types/enum.html` | Valid options |

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
