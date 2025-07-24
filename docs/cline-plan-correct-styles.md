# CSS Fix Plan for Kue Dashboard

## 1. Scratchbook

### File Analysis Notes:

*   **`lib/http/public/stylesheets/main.scss`**:
    *   Imports other SCSS files: `nib.scss`, `config.scss`, `scrollbar.scss`, `menu.scss`, `context-menu.scss`, `job.scss`, `actions.scss`, `error.scss`.
    *   Defines a `font-smoothing` mixin.
    *   Uses mixins like `font-smoothing`, `bold-button`, `reset-table`.
    *   Uses variables like `$bg`, `$light`.
*   **`lib/http/public/stylesheets/mixins.scss`**:
    *   Defines `reset-list`, `decorated-box`, `bold-button` mixins.
    *   `bold-button` is used in `main.scss`.
*   **`lib/http/public/stylesheets/nib.scss`**:
    *   Contains a comprehensive set of mixins for positioning (`fixed`, `absolute`, `relative`), resets (`reset-table`, `global-reset`, `normalize-css`), vendor prefixes (`vendor`), flexbox, images, and gradients.
    *   Notably, it also defines a `font-smoothing` mixin and `reset-table` which are also used/defined elsewhere.
    *   The `fixed` mixin is likely the intended source for positioning, but it seems to be compiling incorrectly.
*   **`lib/http/public/stylesheets/config.scss`**:
    *   Defines color variables like `$dark`, `$light`, `$lighter`, `$bg`, and status/menu colors.
    *   `$dark` and `$light` are used in `main.scss`.
*   **`lib/http/public/stylesheets/main.css` (Compiled Output - *Stale/Incorrect*)**:
    *   **Critical Issue 1**: Large sections of crucial CSS (for `html`, `body` layout, and `::-webkit-scrollbar`) are commented out. This is the primary reason for the broken layout and unstyled scrollbars. This file is likely stale or incorrectly generated.
    *   **Critical Issue 2**: Invalid CSS property values for positioning. Examples:
        *   `#menu`: `top: top; right: left;`
        *   `#menu li .count`: `top: top 15px; right: left;`
        *   `.block h2`: `top: top 5px; right: left -15px;`
        *   `.job .block .progress`: `top: top 15px; right: right 20px;`
        *   `.job .block .remove`, `.job .block .restart`: `top: top 30px; right: right -6px;`
        *   `#actions`: `top: top -2px; right: right -2px;`
        *   `#error`: `fixed: top -50px right 15px;` (invalid property name `fixed` and values).
        This indicates a problem with how the `fixed`, `absolute`, or `relative` mixins from `nib.scss` are being called or compiled in the SCSS. The arguments (e.g., `top`, `left`, `right`) are being outputted as literal strings instead of being correctly interpreted as part of the mixin's logic.
    *   **Critical Issue 3**: Unresolved SCSS variable. `#sort, #filter, #search` have `color: dark;` instead of `color: #3b3b3b;` (from `$dark` in `config.scss`). This means the SCSS variable `$dark` is not being correctly interpolated.
    *   **Minor Issue**: Duplicate `font-smoothing` mixin definition in `main.scss` and `nib.scss`. The `nib.scss` version is more complete.
*   **`lib/http/views/layout.pug`**:
    *   Confirms `main.css` is linked: `link(rel='stylesheet', href='./stylesheets/main.css')`.
    *   Includes partials like `_menu`, `_search`, `_filter`, `_sort`, `_job`, `_row`.
*   **`lib/http/views/_job.pug`**:
    *   Defines the structure of a job block, using classes like `.job`, `.block`, `.remove`, `.restart`, `.progress`, `.details`. These classes are targeted by the CSS.
*   **`Makefile`**:
    *   Currently lacks a target for compiling SCSS files.

### Patterns Learned:

*   The project uses SCSS for styling, which is then compiled into `main.css`.
*   There's a clear modular structure with separate SCSS files for different components/concerns (e.g., `menu`, `job`, `scrollbar`).
*   Mixins are heavily used for reusability and vendor prefixing (from `nib.scss`).
*   Variables are used for colors and other configurations (from `config.scss`).
*   The compilation process seems to be failing or misinterpreting certain SCSS constructs, particularly mixin calls and variable interpolations, leading to invalid CSS. The commented-out sections in `main.css` suggest that the original SCSS might have had these sections commented out, or the compilation process itself is flawed and commenting them out.
*   A `Makefile` is used for build processes, and a new target is needed to automate SCSS compilation.

## 2. Image Analysis

### Image 1: Broken CSS (Current State)

The first image shows a dashboard with severely broken CSS. Key observations:
*   **Layout Disarray**: The main content area is not properly positioned. The "Search", "Filter by", and "Sort" elements are stacked horizontally on the top left, instead of being horizontally aligned on the top right.
*   **Missing Sidebar**: The left navigation menu (which should contain "Queued", "Active", "Failed", "Complete", "Delayed" job counts) is not visible as a distinct sidebar. Its contents overlap each other and job blocks overlap over it, rendering it not visible.
*   **Unstyled Job Blocks**: The individual job entries (e.g., "update_custom_field_cache") are simple white blocks with minimal styling. They lack proper padding, alignment, and the visual "decorated box" appearance suggested by `mixins.scss`. The text within them is also misaligned and overlapping.
*   **Unstyled Scrollbars**: The scrollbars are default browser scrollbars, indicating that the custom scrollbar styles defined in the SCSS (and commented out in `main.css`) are not applied.
*   **Text Overlap**: Text elements, particularly in the left menu and within job blocks, are overlapping, indicating issues with `width`, `height`, `padding`, `margin`, or `position` properties.
*   **Missing Icons/Buttons**: The "x" and "restart" icons/buttons on the job blocks are visible on hover but they are aigned on the top left instead of being aligned on the top right.

Overall, the page appears to have lost its entire structural and aesthetic styling, suggesting a fundamental breakdown in the CSS application or compilation.

### Image 2: Expected CSS (Target State)

The second image shows the dashboard as it is expected to be rendered, demonstrating a clean and functional UI. Key observations:
*   **Proper Layout**: The page has a clear two-column layout. A dark sidebar on the left contains the navigation menu, and the main content area on the right displays the job list.
*   **Styled Sidebar**: The left sidebar is a distinct, dark-colored navigation menu with clearly separated job status categories ("Queued", "Active", "Failed", "Complete", "Delayed") and their respective counts. The text is well-aligned and readable.
*   **Horizontal Top Bar**: The "Search", "Filter by", and "Sort" elements are horizontally aligned at the top of the main content area, functioning as a header for the job list.
*   **Styled Job Blocks**: Individual job entries are well-defined, visually appealing blocks with proper spacing, borders, and shadows (consistent with `decorated-box` mixin). The job ID is clearly visible in a styled tag on the top left of each block.
*   **Functional Icons/Buttons**: The "x" (delete) and "restart" icons are visible and correctly positioned on the top right of the job blocks, indicating proper styling and functionality.
*   **Styled Scrollbars**: Although not explicitly clear from the crop, a well-designed UI like this would typically have custom scrollbar styling, which was present in the commented-out CSS.

Comparing the two images, the goal is to restore the layout, positioning, and styling of all elements to match the expected screenshot. This primarily involves addressing the compilation issues and ensuring the SCSS is correctly processed.

## 3. Checklist of Todos

- [x] **Task 1: Update `Makefile` to compile SCSS**
    - [ ] Add a new target `css` to the `Makefile` that uses `node-sass` to compile `lib/http/public/stylesheets/main.scss` to `lib/http/public/stylesheets/main.css`.
    - [ ] Ensure `node-sass` is installed or add a step to install it if necessary.
- [x] **Task 2: Uncomment essential styles in SCSS**
    - [ ] Locate the SCSS files that correspond to the commented-out sections in the current `main.css` (likely `main.scss` or `scrollbar.scss`).
    - [ ] Uncomment or re-add the `html`, `body` (with `position: absolute` and related properties), and `::-webkit-scrollbar` styles in the relevant SCSS files.
    - [ ] Run the `css` target in the `Makefile` to recompile `main.css` and verify these styles are now present and active.
- [x] **Task 3: Fix incorrect position property compilation in SCSS**
    - [x] Identify the SCSS files where mixins like `fixed`, `absolute`, or `relative` are called with incorrect arguments (e.g., `top`, `left`, `right` as literal strings).
    - [x] Correct the mixin calls to pass valid CSS values (e.g., `0`, `15px`, `auto`) instead of literal keywords.
    - [x] Specifically target:
        - [x] `#menu` positioning.
        - [x] `#menu li .count` positioning.
        - [x] `.block h2` positioning.
        - [x] `.job .block .progress` positioning.
        - [x] `.job .block .remove` and `.job .block .restart` positioning.
        - [x] `#actions` positioning.
        - [x] `#error` positioning (correct `fixed` property usage).
    - [x] Run the `css` target in the `Makefile` to recompile `main.css` and verify correct CSS properties are generated.
- [x] **Task 4: Resolve unresolved SCSS variable `$dark`**
    - [x] Locate the SCSS file where `color: dark;` is used for `#sort, #filter, #search`.
    - [x] Change `color: dark;` to `color: $dark;` to correctly interpolate the variable.
    - [x] Run the `css` target in the `Makefile` to recompile `main.css` and verify the correct color value (`#3b3b3b`) is applied.
- [x] **Task 5: Review and potentially consolidate `font-smoothing` mixin**
    - [ ] Decide whether to keep the `font-smoothing` mixin in `main.scss` or rely solely on the one in `nib.scss`. Given `nib.scss`'s version is more complete, it's likely better to remove the duplicate from `main.scss` if it's causing conflicts or is redundant.
    - [ ] Run the `css` target in the `Makefile` to recompile `main.css`.
- [ ] **Task 6: Verify overall dashboard rendering**
    - [ ] After applying all SCSS fixes and recompiling, ensure the dashboard renders correctly according to the "Expected CSS" screenshot.
    - [ ] Pay attention to layout, element positioning, styling of job blocks, and visibility of action buttons/icons.
