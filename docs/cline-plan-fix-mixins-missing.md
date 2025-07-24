# Plan to Fix Missing Mixins from Nib

## Scratchbook

### Initial Problem Understanding

The SCSS compilation is failing with `Error: no mixin named reset-table`. This indicates that the `reset-table` mixin, likely originating from the `nib` library (which is no longer imported), is missing its definition. This is similar to the `bold-button` issue previously resolved.

### Learnings from `docs/cline-plan-filter.md`

*   Comprehensive Stylus to SCSS conversion rules were established, including how to convert mixin definitions and calls.
*   The conversion process involved adding curly braces, semicolons, converting color arithmetic, variable definitions, `@import` statements, and mixin calls.

### Learnings from `docs/cline-plan-fix-mixin.md`

*   The `bold-button` mixin was missing because `nib` was no longer imported.
*   The solution was to re-implement the `bold-button` mixin in `lib/http/public/stylesheets/mixins.scss` based on its implied functionality. This approach will be used for `reset-table` and any other missing `nib` mixins.

### Strategy for Identifying Missing Mixins

1.  **Search for `reset-table`:** Locate where `reset-table` is being called to understand its context. This will involve searching all `.scss` files.
2.  **Iterative Search for `@include` calls:** Systematically search all `.scss` files for `@include` statements. For each `@include` call, I will check if a corresponding `@mixin` definition exists in `lib/http/public/stylesheets/mixins.scss` or other relevant imported files. If a mixin call results in a compilation error (as `reset-table` currently does), or if I cannot find its definition, it will be considered a candidate for re-implementation.
3.  **Re-implement Missing Mixins:** For each identified missing mixin, I will create a functional equivalent in `lib/http/public/stylesheets/mixins.scss`. This re-implementation will be based on the mixin's name and common CSS reset patterns, similar to how `bold-button` was handled.

## To-Do Checklist

- [ ] **Phase 1: Planning and Analysis**
    - [x] Read `docs/cline-plan-filter.md` for conversion context.
    - [x] Read `docs/cline-plan-fix-mixin.md` for `bold-button` resolution context.
    - [x] Create `docs/cline-plan-fix-mixins-missing.md` with scratchbook and initial todos.
    - [x] Search for `reset-table` usage in SCSS files. (Found in `main.scss`)
    - [x] Identify other potentially missing `nib` mixins by searching for `@include` calls and comparing with existing `mixins.scss`. (Identified `font-smoothing`)
    - [x] Define the re-implementation for `reset-table` mixin.
    - [x] Define the re-implementation for `font-smoothing` mixin.
    - [ ] Present the complete plan and ask to switch to Act Mode.

- [ ] **Phase 2: Implementation (Act Mode)**
    - [ ] Add the re-implemented `reset-table` mixin to `lib/http/public/stylesheets/mixins.scss`.
    - [ ] Add any other re-implemented missing mixins to `lib/http/public/stylesheets/mixins.scss`.
    - [ ] Verify the fix by running the application and checking for compilation errors.
    - [ ] Confirm successful compilation and resolution of all missing mixin errors.
    - [ ] Update `docs/cline-plan-fix-mixins-missing.md` with completion status.
