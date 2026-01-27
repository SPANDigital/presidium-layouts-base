# Frontmatter Schema Coordination Guide

## For Module Content Developers

This guide helps you understand when and how to regenerate the frontmatter validation schema.

---

## Quick Decision Guide

```
┌─────────────────────────────────────────────┐
│ Did you change frontmatter configuration?  │
│ (base theme or module config)              │
└─────────────────────────────────────────────┘
           │
           ├─ YES → Regenerate schema (see Step-by-Step below)
           │
           └─ NO  → Continue with normal build
                    │
                    ├─ Schema exists in data/presidium/? → ✅ Ready to build
                    │
                    └─ Schema missing? → Regenerate once, then build
```

---

## When to Regenerate Schema

Regenerate the schema whenever you **change frontmatter configuration**:

### Scenario 1: You Added a New Field

**Example**: Adding an `author` field to your module config

```yaml
# config.yml (module)
params:
  frontmatter:
    author:  # ← NEW FIELD
      type: string
      required: true
```

**Action**: ✅ Regenerate schema

---

### Scenario 2: You Modified Field Rules

**Example**: Making an existing field required or changing its validation

```yaml
# Before
status:
  type: string
  required: false

# After
status:
  type: string
  required: true  # ← CHANGED
  options:        # ← ADDED
    - draft
    - published
```

**Action**: ✅ Regenerate schema

---

### Scenario 3: You Updated Base Theme

**Example**: Pulling latest changes from `presidium-layouts-base`

```bash
git pull upstream main
# Base theme's config/_default/frontmatter/params.yaml may have changed
```

**Action**: ✅ Regenerate schema

---

### Scenario 4: First-Time Setup

**Example**: New module or fresh clone without schema file

```bash
ls data/presidium/frontmatter-schema.yaml
# → No such file or directory
```

**Action**: ✅ Regenerate schema

---

## When NOT to Regenerate

Skip schema regeneration in these scenarios:

### Scenario 1: Content Changes Only

**Example**: Writing or editing markdown content

```markdown
---
title: "My New Article"  ← Just adding content
author: "Jane Developer"
---

Content here...
```

**Action**: ❌ No regeneration needed → Build normally

---

### Scenario 2: Schema Already Exists

**Example**: Schema present and config unchanged

```bash
ls data/presidium/frontmatter-schema.yaml
# → File exists

git status config/
# → No changes to config
```

**Action**: ❌ No regeneration needed → Build normally

---

### Scenario 3: Non-Frontmatter Config Changes

**Example**: Changing site title, menu structure, or other Hugo params

```yaml
# config.yml
title: "My Updated Site Title"  # ← Not frontmatter config
menu:
  main:
    - name: "About"
```

**Action**: ❌ No regeneration needed → Build normally

---

## Step-by-Step Workflow

### Stage 1: Generate Schema

**When**: After any frontmatter configuration change

```bash
# 1. Generate schema to public/
hugo --gc --config config.yml,dependencies.config.yml

# 2. Copy schema to data directory
mkdir -p data/presidium
cp public/frontmatter-schema.yaml data/presidium/frontmatter-schema.yaml

# 3. Clean public directory
rm -rf public
```

**What happens**:
- Hugo reads base theme config: `config/_default/frontmatter/params.yaml`
- Hugo reads module config: `config.yml` → `params.frontmatter`
- Hugo merges both configs
- Schema generator outputs: `public/frontmatter-schema.yaml`

---

### Stage 2: Build with Validation

**When**: Every normal build

```bash
hugo --gc
```

**What happens**:
- Hugo loads schema from: `data/presidium/frontmatter-schema.yaml`
- Validates all content frontmatter against schema
- Build fails with errors for invalid frontmatter
- Build succeeds for valid content

---

## Common Scenarios Walkthrough

### Scenario: Adding a New Required Field

**Goal**: Add a `category` field that all docs must have

**Step 1** - Update module config:

```yaml
# config.yml
params:
  frontmatter:
    category:
      type: string
      required: true
      error_message: "Category is required for all documentation"
      placeholder_message: "e.g., guides, reference, tutorials"
      options:
        - guides
        - reference
        - tutorials
```

**Step 2** - Regenerate schema:

```bash
hugo --gc --config config.yml,dependencies.config.yml
mkdir -p data/presidium
cp public/frontmatter-schema.yaml data/presidium/frontmatter-schema.yaml
rm -rf public
```

**Step 3** - Test with build:

```bash
hugo --gc
```

**Expected**: Build errors for content missing `category` field

**Step 4** - Update content:

```markdown
---
title: "Getting Started"
category: guides  # ← Add to all content
---
```

**Step 5** - Build again:

```bash
hugo --gc
```

**Expected**: Build succeeds ✅

---

### Scenario: Just Writing Content

**Goal**: Add new article to existing module

**Step 1** - Check schema exists:

```bash
ls data/presidium/frontmatter-schema.yaml
# ✅ File exists
```

**Step 2** - Create content:

```markdown
---
title: "My New Article"
category: guides
author: "jane@example.com"
---

Content here...
```

**Step 3** - Build:

```bash
hugo --gc
```

**No schema regeneration needed** ✅

---

## Troubleshooting

### Problem: Build Fails with "Schema not found"

```
Error: Schema file not found at data/presidium/frontmatter-schema.yaml
```

**Solution**: Generate schema (Stage 1):

```bash
hugo --gc --config config.yml,dependencies.config.yml
mkdir -p data/presidium
cp public/frontmatter-schema.yaml data/presidium/frontmatter-schema.yaml
rm -rf public
```

---

### Problem: Validation Errors After Config Change

```
Error: Frontmatter validation failed for field 'category': required field is missing
```

**Cause**: Config changed but content not updated

**Solution**: Update content to match new schema requirements

---

### Problem: Config Changes Not Reflected

**Example**: Changed `required: true` but validation still passes without field

**Cause**: Schema not regenerated

**Solution**: Regenerate schema (Stage 1) then rebuild (Stage 2)

---

### Problem: Module Override Not Working

**Example**: Module config not overriding base theme config

**Check 1** - Config structure:

```yaml
# ✅ Correct
params:
  frontmatter:
    title:
      required: true

# ❌ Wrong
frontmatter:  # Missing "params" wrapper
  title:
    required: true
```

**Check 2** - Regenerate schema after fixing structure

---

## Configuration Merge Behavior

### How Base + Module Configs Merge

**Base theme** ([config/_default/frontmatter/params.yaml](config/_default/frontmatter/params.yaml)):
```yaml
frontmatter:
  title:
    type: string
    required: true
    error_message: "Title required"
```

**Module** (`config.yml` → `params.frontmatter`):
```yaml
params:
  frontmatter:
    title:
      required: false  # ← Override
    author:            # ← Add new field
      type: string
```

**Result** (merged):
```yaml
frontmatter:
  title:
    type: string
    required: false    # Module override wins
    error_message: "Title required"
  author:
    type: string       # Module addition included
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Generate schema | `hugo --gc --config config.yml,dependencies.config.yml` |
| Copy schema | `cp public/frontmatter-schema.yaml data/presidium/` |
| Normal build | `hugo --gc` |
| Check schema exists | `ls data/presidium/frontmatter-schema.yaml` |
| View schema | `cat data/presidium/frontmatter-schema.yaml` |

---

## See Also

- [FRONTMATTER.md](FRONTMATTER.md) - Technical reference for validation system
- [config/_default/frontmatter/params.yaml](config/_default/frontmatter/params.yaml) - Base theme configuration
