# Plan to Fix `bold-button` Mixin Error

## Scratchbook

### Problem Understanding

The `main.scss` file, which was converted from `main.styl`, contains a call to a mixin: `@include bold-button($glow: #00ABFA);`. This call is causing an `Error: no mixin named bold-button` during SCSS compilation. This indicates that while the *call* to the mixin was updated to SCSS syntax (`@include`), the *definition* of the `bold-button` mixin itself has not been correctly converted to SCSS syntax, or it's not accessible.

### Learnings from `docs/cline-plan-filter.md`

The `docs/cline-plan-filter.md` document provided a comprehensive analysis of Stylus to SCSS conversion rules. Key relevant learnings for this task include:

*   **Mixin Definition Conversion:** Stylus mixin definitions (e.g., `mixin-name(param)`) need to be converted to SCSS `@mixin` syntax (e.g., `@mixin mixin-name($param) { ... }`). This includes handling mixins with and without parameters, and those using `arguments` (which convert to SCSS rest parameters like `$args...`).
*   **Mixin Call Conversion:** Stylus mixin calls (e.g., `mixin-name()`) need to be prefixed with `@include` and end with a semicolon (e.g., `@include mixin-name();`). This part seems to have been done correctly for the `bold-button` call in `main.scss`.
*   **Variable Definitions:** Stylus uses `=` for variable assignment, while SCSS uses `$variable-name: value;`. Mixin parameters in SCSS also use the `$` prefix.
*   **General SCSS Syntax:** SCSS requires curly braces `{}` for rule sets and semicolons `;` for property declarations.

Given the error and the fact that `bold-button` definition was not found in `mixins.scss` or `main.scss` after searching, it is highly probable that this mixin was originally provided by the `nib` library, which is currently commented out (`// @import 'nib';`) in `main.scss`.

Since `nib` is no longer being imported, the `bold-button` mixin needs to be re-implemented. As the original `nib` definition is unavailable, I will create a functional equivalent based on its name and the `$glow` parameter.

**Re-implementation Details:**

1.  **Core Functionality:** The mixin will apply `font-weight: bold;` to make the text bold.
2.  **Glow Effect:** The `$glow` parameter will be used to create a `text-shadow` effect. A default value of `#00ABFA` will be provided, matching the existing call in `main.scss`. The `text-shadow` property will be `0 0 5px $glow;` to create a subtle, blurred glow around the text.
3.  **SCSS Structure:** The mixin will be defined using the `@mixin` directive in `lib/http/public/stylesheets/mixins.scss`.

The complete re-implemented mixin will be:

```scss
@mixin bold-button($glow: #00ABFA) {
  font-weight: bold;
  text-shadow: 0 0 5px $glow;
}
```

This implementation aims to provide the core functionality implied by the mixin's name and parameter, resolving the compilation error.

## To-Do Checklist

- [ ] **Phase 1: Planning and Analysis (Current Phase)**
    - [x] Read `docs/cline-plan-filter.md` to understand the conversion context.
    - [x] Create `docs/cline-plan-fix-mixin.md` with scratchbook and initial todos.
    - [x] Locate the `bold-button` mixin definition. (Confirmed not present in `mixins.scss` or `main.scss`, likely from commented-out `nib` import).
    - [ ] Re-implement the `bold-button` mixin with a default "glow" effect.
    - [ ] Add the new `bold-button` mixin definition to `lib/http/public/stylesheets/mixins.scss`.
    - [ ] Present the complete plan and ask to switch to Act Mode.

- [ ] **Phase 2: Implementation (Act Mode)**
    - [x] Add the re-implemented `bold-button` mixin definition to `lib/http/public/stylesheets/mixins.scss`.
    - [x] Troubleshoot `Error: Cannot find module 'kue'` when running `bin/kue-dashboard`.
    - [x] Troubleshoot `Error: Missing binding ... node-sass`.
    - [ ] Troubleshoot `Error: listen EADDRINUSE: address already in use :::3000`.
    - [ ] Verify the fix by running the application and checking for compilation errors.
    - [ ] Confirm successful compilation and resolution of the `no mixin named bold-button` error.
    - [ ] Update `docs/cline-plan-fix-mixin.md` with completion status.
