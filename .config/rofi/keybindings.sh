#!/usr/bin/env bash
set -euo pipefail

KEYBINDINGS_FILE="${1:-$HOME/.config/hypr/keybindings.lua}"

if [[ ! -f "$KEYBINDINGS_FILE" ]]; then
    echo "Error: no se encontró el archivo de keybindings: $KEYBINDINGS_FILE" >&2
    exit 1
fi

parse_bindings() {
    awk '
    function trim(s) { gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", s); return s }
    function unquote(s) { if (s ~ /^".*"$/) return substr(s, 2, length(s) - 2); return s }
    function expand(expr,   v, out) {
        expr = trim(expr)
        for (v in loop_vars) {
            gsub("\\<" v "\\>", loop_vars[v], expr)
        }
        gsub(/mainMod/, mainMod, expr)
        gsub(/secondMod/, secondMod, expr)
        gsub(/bothMod/, bothMod, expr)
        gsub(/[ \t]*\.{2}[ \t]*/, " ", expr)
        out = ""
        while (match(expr, /("[^"]*"|[^ \t]+)/, a)) {
            v = a[1]
            expr = substr(expr, RSTART + RLENGTH)
            if (v ~ /^".*"$/) {
                v = substr(v, 2, length(v) - 2)
            }
            out = out v
        }
        gsub(/^[ \t]+|[ \t]+$/, "", out)
        return out
    }
    function print_binding(s,   expr, desc, parts, n, i, mod, key) {
        if (s ~ /^[ \t]*--/) return
        if (match(s, /hl\.bind[ \t]*\(\s*([^,]+)\s*,/, a)) {
            expr = expand(a[1])
            if (match(s, /description[ \t]*=[ \t]*"([^"]*)"/, a)) {
                desc = a[1]
                n = split(expr, parts, /[ \t]*\+[ \t]*/)
                if (n > 1) {
                    key = parts[n]
                    mod = parts[1]
                    for (i = 2; i < n; i++) {
                        mod = mod " + " parts[i]
                    }
                } else {
                    mod = ""
                    key = expr
                }
                print mod "|" key "|" desc
            }
        }
    }
    function process_loop() {
        for (i = loop_start; i <= loop_end; i++) {
            delete loop_vars
            loop_vars[loop_var] = i
            for (j = 1; j <= loop_line_count; j++) {
                line = loop_lines[j]
                if (match(line, /local[ \t]+([[:alnum:]_]+)[ \t]*=[ \t]*([[:alnum:]_]+)[ \t]*%[ \t]*([0-9]+)/, a)) {
                    if (a[1] == "key") {
                        val = i % a[3]
                        if (val == 0) val = 0
                        loop_vars[a[1]] = val
                    } else {
                        loop_vars[a[1]] = i % a[3]
                    }
                }
            }
            for (j = 1; j <= loop_line_count; j++) {
                if (loop_lines[j] ~ /hl\.bind/) {
                    print_binding(loop_lines[j])
                }
            }
        }
    }
    BEGIN {
        mainMod = "SUPER"
        secondMod = "ALT"
        bothMod = "SUPER + ALT"
        in_bind = 0
        in_loop = 0
        loop_line_count = 0
        paren = 0
    }
    {
        if ($0 ~ /^[ \t]*--/) next
        if ($0 ~ /^[ \t]*$/) next
        if (!in_loop && match($0, /^[ \t]*local[ \t]+mainMod[ \t]*=[ \t]*"([^"]*)"/, a)) { mainMod = a[1]; next }
        if (!in_loop && match($0, /^[ \t]*local[ \t]+secondMod[ \t]*=[ \t]*"([^"]*)"/, a)) { secondMod = a[1]; next }
        if (!in_loop && match($0, /^[ \t]*local[ \t]+bothMod[ \t]*=[ \t]*(.*)$/, a)) {
            bothMod = expand(a[1]); next
        }
        if (!in_loop && match($0, /^[ \t]*for[ \t]+([[:alnum:]_]+)[ \t]*=[ \t]*([0-9]+)[ \t]*,[ \t]*([0-9]+)[ \t]*do/, a)) {
            in_loop = 1
            loop_var = a[1]
            loop_start = a[2]
            loop_end = a[3]
            loop_line_count = 0
            next
        }
        if (in_loop) {
            if ($0 ~ /^[ \t]*end[ \t]*$/) {
                process_loop()
                in_loop = 0
                next
            }
            loop_lines[++loop_line_count] = $0
            next
        }
        if (in_bind == 0) {
            if ($0 ~ /hl\.bind[ \t]*\(/) {
                bind_text = $0
                paren = gsub(/\(/, "", $0) - gsub(/\)/, "", $0)
                in_bind = 1
                if (paren <= 0) { print_binding(bind_text); in_bind = 0 }
            }
        } else {
            bind_text = bind_text "\n" $0
            paren += gsub(/\(/, "", $0) - gsub(/\)/, "", $0)
            if (paren <= 0) { print_binding(bind_text); in_bind = 0 }
        }
    }
    END {
        if (in_bind) print_binding(bind_text)
        if (in_loop) process_loop()
    }
    ' "$KEYBINDINGS_FILE"
}

menu_items=()
max_left=0
while IFS='|' read -r mod key desc; do
    if [[ -z "$key" ]]; then
        continue
    fi

    if [[ -n "$mod" ]]; then
        left="$mod + $key"
    else
        left="$key"
    fi

    if (( ${#left} > max_left )); then
        max_left=${#left}
    fi

    menu_items+=("$left|$desc")
done < <(parse_bindings)

if [[ ${#menu_items[@]} -eq 0 ]]; then
    echo "No se encontraron keybindings válidos." >&2
    exit 1
fi

printf '%s\n' "${menu_items[@]}" | while IFS='|' read -r left desc; do
    printf '%-*s   %s\n' "$max_left" "$left" "$desc"
done | rofi -dmenu -i -p "Hypr keybindings" -mesg "Modificador | Tecla | Descripción" -theme "$HOME/.config/rofi/keybindings.rasi"
