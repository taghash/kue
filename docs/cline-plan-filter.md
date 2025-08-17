# Stylus to SCSS Conversion Plan

## Scratchbook

### Initial Analysis of `lib/http/public/stylesheets/actions.scss`

The file `actions.scss` exhibits Stylus-like syntax, which needs to be converted to valid SCSS. Key observations include:

*   **Missing Curly Braces:** Rule sets (e.g., `#actions`, `#sort`, `#filter`, `#search`) lack the opening and closing curly braces `{}` required by SCSS.
*   **Missing Semicolons:** Property declarations (e.g., `fixed: top -2px right -2px`, `z-index: 20`) do not terminate with semicolons `;`, which are mandatory in SCSS.
*   **Indentation-Based Nesting:** Nesting is primarily controlled by indentation, which is common in Stylus. While SCSS also supports nesting, it typically uses curly braces to define blocks. The current structure is compatible with SCSS's nesting, but the missing braces are the primary issue.
*   **Pseudo-classes:** `&:hover` syntax is used, which is compatible with SCSS.
*   **Color Arithmetic:** An expression like `#eee - 10%` is used for color manipulation. In SCSS, this needs to be converted to a built-in color function, such as `darken(#eee, 10%)`.

### Analysis of `lib/http/public/stylesheets/config.scss`

This file primarily defines variables.

*   **Variable Definition:** Stylus uses `=` for variable assignment (e.g., `dark = #3b3b3b`), while SCSS uses `$variable-name: value;` (e.g., `$dark: #3b3b3b;`).

### Analysis of `lib/http/public/stylesheets/context-menu.scss`

This file introduces `@import` statements and mixin calls.

*   **`@import` without quotes:** Stylus allows `@import mixins` while SCSS requires `@import 'mixins';` or `@import "mixins";`.
*   **Mixin Calls:** Stylus mixin calls (e.g., `reset-list()`, `decorated-box()`) need to be prefixed with `@include` in SCSS (e.g., `@include reset-list();`).
*   **Color Arithmetic with `+`:** Confirmed the need to convert `color + value` to SCSS color functions like `lighten(color, percentage)`.

### Analysis of `lib/http/public/stylesheets/error.scss`

This file demonstrates variable usage within CSS functions.

*   **Variable usage in functions:** When using variables within SCSS functions like `rgba()`, they must be prefixed with a `$` (e.g., `rgba($dark, .2)`).

### Analysis of `lib/http/public/stylesheets/job.scss`

This file introduces mixin definitions and local variable assignments.

*   **Mixin Definition:** Stylus mixin definitions (e.g., `bar(color)`) need to be converted to SCSS `@mixin` syntax (e.g., `@mixin bar($color) { ... }`).
*   **Local Variable Assignment:** Stylus allows local variable assignment within rules (e.g., `width: size = 20px`). In SCSS, this should be separated into a variable definition and then used (e.g., `$size: 20px; width: $size;`).

### Analysis of `lib/http/public/stylesheets/main.scss`

This file introduces mixin definitions with `arguments` and further confirms `@import` and mixin calls.

*   **Mixin Definition with `arguments`:** Stylus mixin definitions like `font-smoothing()` with `arguments` need to be converted to SCSS `@mixin` syntax with rest parameters (e.g., `@mixin font-smoothing($args...) { -webkit-font-smoothing: $args; }`).
*   **Mixin Calls with Named Arguments:** Stylus mixin calls with named arguments (e.g., `bold-button(glow:#00ABFA)`) are compatible with SCSS, but the mixin definition needs to be converted first.

### Analysis of `lib/http/public/stylesheets/menu.scss`

This file introduces conditional statements and color assignment with operators.

*   **Conditional Statements (`if`):** Stylus `if condition` needs to be converted to SCSS `@if condition { ... }`.
*   **Color Assignment with Operators:** Stylus `background: menu-bg -= 2%` needs to be converted to SCSS color functions like `background: darken($menu-bg, 2%);`.
*   **Color Arithmetic with Division:** `menu-fg + (menu-intensity / 2)` confirms the need for SCSS color functions.

### Analysis of `lib/http/public/stylesheets/mixins.scss`

This file contains mixin definitions without parameters.

*   **Mixin Definition without parameters:** Stylus mixin definitions like `reset-list()` and `decorated-box()` need to be converted to SCSS `@mixin` syntax (e.g., `@mixin reset-list() { ... }`).

### Analysis of `lib/http/public/stylesheets/scrollbar.scss`

This file confirms variable definitions, usage, and arithmetic operations.

*   **Variable Definitions and Usage:** Confirms the need to convert `=` to `:` for definitions and prefix with `$` for usage.
*   **Arithmetic Operations:** Confirms the need for SCSS arithmetic (e.g., `(width / 2)`).

### General Conversion Rules

Based on the comprehensive analysis of all files, the general rules for converting these Stylus-like SCSS files to proper SCSS syntax will be:

1.  **Add Curly Braces:** Enclose every rule set (selectors, nested rules, mixin calls, etc.) within `{}`.
2.  **Add Semicolons:** Terminate every property declaration with a semicolon `;`.
3.  **Convert Color Arithmetic:** Replace Stylus-style color arithmetic (e.g., `color - value`, `color + value`, `color / value`) with equivalent SCSS color functions (e.g., `darken(color, percentage)`, `lighten(color, percentage)`, `mix(color1, color2, percentage)` or direct arithmetic if applicable).
4.  **Convert Variable Definitions:** Replace Stylus variable definitions (`variable = value`) with SCSS variable definitions (`$variable: value;`).
5.  **Convert `@import` Statements:** Add quotes and semicolons to `@import` statements (e.g., `@import 'mixins';`).
6.  **Convert Mixin Calls:** Prefix mixin calls with `@include` and add a semicolon (e.g., `@include mixin-name();`).
7.  **Ensure Variable Prefix in Functions:** Ensure variables used within CSS functions (e.g., `rgba()`) are prefixed with `$`.
8.  **Convert Mixin Definitions:** Convert Stylus mixin definitions to SCSS `@mixin` syntax, including handling `arguments` with SCSS rest parameters and mixins without parameters.
9.  **Convert Local Variable Assignments:** Convert local variable assignments within rules to SCSS variable definitions and usage.
10. **Convert Conditional Statements:** Convert Stylus `if` statements to SCSS `@if` statements.
11. **Convert Color Assignment Operators:** Convert Stylus color assignment operators (e.g., `-=`, `+=`) to equivalent SCSS color functions.
12. **Review Functions:** If any Stylus-specific function definitions are encountered, they will need to be converted to SCSS `@function` syntax. (No explicit Stylus functions found beyond mixins, but will keep this in mind during implementation).

## To-Do Checklist

- [ ] **Phase 1: Planning and Analysis**
    - [x] Read `lib/http/public/stylesheets/actions.scss` to understand Stylus syntax.
    - [x] Create `docs/cline-plan-filter.md` with scratchbook and initial todos.
    - [x] Read `lib/http/public/stylesheets/config.scss` to identify more Stylus patterns.
    - [x] Read `lib/http/public/stylesheets/context-menu.scss` to identify more Stylus patterns.
    - [x] Read `lib/http/public/stylesheets/error.scss` to identify more Stylus patterns.
    - [x] Read `lib/http/public/stylesheets/job.scss` to identify more Stylus patterns.
    - [x] Read `lib/http/public/stylesheets/main.scss` to identify more Stylus patterns.
    - [x] Read `lib/http/public/stylesheets/menu.scss` to identify more Stylus patterns.
    - [x] Read `lib/http/public/stylesheets/mixins.scss` to identify more Stylus patterns (especially for mixin conversion).
    - [x] Read `lib/http/public/stylesheets/scrollbar.scss` to identify more Stylus patterns.
    - [x] Finalize conversion rules based on all analyzed files.
    - [**x**] Present the complete plan and ask to switch to Act Mode.

- [ ] **Phase 2: Implementation (Act Mode)**
    - [x] Convert `lib/http/public/stylesheets/actions.scss` to SCSS.
    - [x] Convert `lib/http/public/stylesheets/config.scss` to SCSS.
    - [x] Convert `lib/http/public/stylesheets/context-menu.scss` to SCSS.
    - [x] Convert `lib/http/public/stylesheets/error.scss` to SCSS.
    - [x] Convert `lib/http/public/stylesheets/job.scss` to SCSS.
    - [x] Convert `lib/http/public/stylesheets/main.scss` to SCSS.
- [x] Convert `lib/http/public/stylesheets/menu.scss` to SCSS.
- [x] Convert `lib/http/public/stylesheets/mixins.scss` to SCSS.
    - [x] Convert `lib/http/public/stylesheets/scrollbar.scss` to SCSS.
    - [x] Verify conversion by checking for compilation errors (if possible with `node-sass`).
    - [x] Confirm successful conversion and completion of the task.
