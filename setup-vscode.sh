#!/usr/bin/env bash
#
# setup-vscode.sh — one-shot VSCode setup for presidium-layouts-base.
#
# Installs the recommended extensions, writes this repo's .vscode/ config
# (Hugo template highlighting, sensible search excludes, a task to regenerate
# PARTIALS.md), and refreshes the partials catalog. Safe to re-run; existing
# .vscode files are backed up to *.bak.
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSC="$REPO_DIR/.vscode"
mkdir -p "$VSC"

info() { printf '\033[1;34m▶\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!\033[0m %s\n' "$*"; }

write_file() { # $1 = destination path; content on stdin
  local path="$1"
  if [ -f "$path" ]; then cp "$path" "$path.bak"; warn "backed up $(basename "$path") -> $(basename "$path").bak"; fi
  cat > "$path"
  ok "wrote ${path#$REPO_DIR/}"
}

# Extensions matched to this repo: Hugo/Go-template highlighting + the linters
# whose configs (.stylelintrc, .prettierrc) already live here.
EXTS=(
  budparr.language-hugo-vscode
  akmittal.hugofy
  stylelint.vscode-stylelint
  esbenp.prettier-vscode
)

info "Configuring $(basename "$REPO_DIR") for VSCode"

write_file "$VSC/extensions.json" <<'JSON'
{
  "recommendations": [
    "budparr.language-hugo-vscode",
    "akmittal.hugofy",
    "stylelint.vscode-stylelint",
    "esbenp.prettier-vscode"
  ]
}
JSON

write_file "$VSC/settings.json" <<'JSON'
{
  // Treat Hugo layout HTML as Go HTML templates.
  "files.associations": { "**/layouts/**/*.html": "gohtml" },
  // Keep Cmd/Ctrl+P and search focused on source, not build output.
  "search.exclude": {
    "**/public": true,
    "**/resources/_gen": true,
    "**/.git": true
  }
}
JSON

write_file "$VSC/tasks.json" <<'JSON'
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Presidium: Regenerate PARTIALS.md",
      "type": "shell",
      "command": "python3",
      "args": ["${workspaceFolder}/../gen_catalog.py"],
      "detail": "Rescan layouts/ and rewrite the partials catalog (the 'class definitions' for this theme).",
      "problemMatcher": []
    }
  ]
}
JSON

# --- install extensions --------------------------------------------------------
if command -v code >/dev/null 2>&1; then
  for e in "${EXTS[@]}"; do
    info "installing extension: $e"
    code --install-extension "$e" --force >/dev/null 2>&1 && ok "$e" || warn "could not install $e"
  done
else
  warn "'code' CLI not found. In VSCode: Cmd+Shift+P -> \"Shell Command: Install 'code' command in PATH\", then re-run this script."
fi

# --- refresh the catalog (optional) -------------------------------------------
GEN="$REPO_DIR/../gen_catalog.py"
if command -v python3 >/dev/null 2>&1 && [ -f "$GEN" ]; then
  info "regenerating PARTIALS.md"
  python3 "$GEN" >/dev/null 2>&1 && ok "PARTIALS.md refreshed" || warn "generator failed (run 'python3 $GEN' to see why)"
else
  warn "skipped catalog refresh (needs python3 and ../gen_catalog.py alongside the repos)"
fi

cat <<'TIP'

Done. Next:
  • Open the multi-root workspace: code ../presidium.code-workspace  (all three repos together)
  • Reload VSCode so the new extensions/associations apply.
  • Go-to-definition for a partial = Cmd/Ctrl+P then type its name (e.g. navigation/root) — partial names ARE file paths.
  • Browse the "class definitions": open PARTIALS.md.
  • Regenerate anytime: Cmd+Shift+P -> "Run Task" -> "Presidium: Regenerate PARTIALS.md".
TIP
