{{- $nav := printf "%s" (partial "navigation/root" .) -}}
{{/* hugo --minify cannot reach this markup - to a JS minifier it is opaque text inside
     a template literal - and the browser must parse all of it before the sidebar can
     paint, so collapse inter-tag whitespace here instead. */}}
{{- $nav = replaceRE `>[ \t\r\n]+<` "><" $nav -}}
window.navigation = `{{ trim $nav " \t\r\n" | safeHTML }}`;
