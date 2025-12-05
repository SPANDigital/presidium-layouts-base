# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the `presidium-layouts-base` repository - a Hugo theme module that provides the layout portion of the Presidium documentation system. It's designed as a Hugo theme component that works with the Presidium styling system to create documentation websites.

## Advanced Configuration

### Three-Tier Theme Inheritance Model

This repository serves as the foundational `base` tier in Presidium's theme inheritance system. The system supports up to three tiers of Hugo theme inheritance through module imports:

**Tier 1: Base (Required)**
- Repository: `presidium-layouts-base` (this repository)
- Purpose: Root theme providing core layout functionality
- Role: Foundation that all other tiers inherit from

**Tier 2: Organization (Optional)**
- Repository pattern: `{organization}-layouts-base` (e.g., `bigcorp-layouts-base`)
- Purpose: Customer-specific theme customizations
- Inheritance: Imports `base` tier as a Hugo module
- Configuration: Inherits all base configurations, adds organization-specific customizations

**Tier 3: Module (Required)**
- Repository type: Individual Hugo documentation sites (e.g., [span-handbook-docs](https://github.com/SPANDigital/span-handbook-docs))
- Purpose: Project-specific documentation content and configuration
- Inheritance options:
  - Direct: Inherits from `base` tier only
  - Indirect: Inherits from `organization` tier (which inherits from `base`)
- Configuration: Applies site-specific overrides on top of inherited configurations

## Architecture

### Hugo Theme Structure
- **layouts/**: Contains Hugo layout templates organized by type:
  - `_default/`: Base templates (baseof.html, list.html, single.html) with PDF and embed variants
  - `partials/`: Reusable template components organized by functionality:
    - `article/`: Article rendering (header, content, footer, validation)
    - `navigation/`: Site navigation components
    - `page/`: Page-level components (analytics, footer, scripts)
    - `common/`: Utility partials (pages, permalink, sorting)
  - `shortcodes/`: Custom Hugo shortcodes (callout, diagram, iframe, etc.)

### Output Formats
The theme defines several custom output formats in `config.yml`:
- **Navigation**: JavaScript format for site navigation
- **Compendium**: JSON format for content indexing  
- **Embed**: HTML format for standalone embeddable content
- **PDF**: HTML format optimized for PDF generation

### Key Templates
- `layouts/_default/baseof.html`: Base template with head, styling, and enterprise integration
- `layouts/partials/article/root.html`: Core article rendering logic with role-based access
- `layouts/shortcodes/callout.html`: Styled callout boxes for documentation

## Development Workflow

### Local Development Setup
1. Clone this theme repository
2. Clone the [presidium-test-validation](https://github.com/SPANDigital/presidium-test-validation) repo for testing
3. Add local path replacement to the test repo's `go.mod`:
   ```
   replace github.com/spandigital/presidium-layouts-base => /{your-local-path}/presidium-layouts-base
   ```
4. Run commands in the test repository:
   ```bash
   make refresh  # Refresh Hugo modules
   make serve    # Start development server on localhost:1313
   ```

### Hugo Module System
This is a Hugo module that should be imported alongside `presidium-styling-base`:
```yaml
# config.yml
module:
  imports:
  - path: github.com/spandigital/presidium-styling-base
  - path: github.com/spandigital/presidium-layouts-base
```

### Template Development Patterns
- **Partial Organization**: Templates are organized by functionality in `partials/` subdirectories
- **Role-based Content**: Articles support `roles` parameter for access control
- **Unique IDs**: Uses Hugo's `.File.UniqueID` for DOM element identification
- **Conditional Content**: Heavy use of Hugo conditionals for enterprise features and content variants

### Branch Strategy
- Uses trunk-based development (TBD)
- Branch directly off `main`
- Use conventional commit prefixes: `feat/`, `fix/`, `chore/`, `refactor/`
- Semantic releases are automated from commit messages

### Testing
Test changes using the `presidium-test-validation` repository which contains comprehensive examples of all supported features.

## Key Features
- Multi-format output (HTML, PDF, embed, navigation JSON)
- Enterprise integration capabilities
- Role-based content access
- Responsive design support
- Custom shortcodes for rich documentation
- Breadcrumb navigation
- Search map generation
- Lazy loading support

## Related Repositories
- **[presidium-js](https://github.com/SPANDigital/presidium-js)**: Source for the minified `static/presidium.js` file that handles client-side functionality including scrollspy navigation
- **[span-handbook-docs](https://github.com/SPANDigital/span-handbook-docs)**: A sample Hugo docs site repo that import this theme repo in its modules in config.yml.
