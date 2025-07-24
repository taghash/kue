`# Reimplementing Nib Mixins in SCSS

## Scratchbook

### Initial Understanding
The project `kue` previously used `stylus` with the `nib` library. The `stylus` dependency has been removed, and now the styling is handled by `sass`. Some `nib` mixins have already been refactored, but some are incorrect or missing. The goal is to fix the incorrect mixins, add the missing ones, and consolidate all `nib`-related mixins into a single `nib.scss` file in `lib/http/public/stylesheets/`.

The provided `stylus-nib` directory contains the original `stylus` mixins, which will be the reference for reimplementing them in SCSS.

The image provided shows some visual issues, likely due to the missing or incorrectly implemented mixins. The text "Queued", "Search", "filter by", "sort" and the job titles are barely visible, suggesting issues with text styling, possibly `text-shadow` or `opacity` related. The overall layout seems off, which could be related to `flexbox` or `positioning` mixins.

### Files to Examine:
- `lib/http/public/stylesheets/main.scss`: To see how `nib` was imported and how other styles are structured.
- `lib/http/public/stylesheets/mixins.scss`: To see what mixins have already been refactored.
- `stylus-nib/lib/nib/*.styl`: To understand the original `nib` mixins.
- `stylus-nib/lib/nib/text/*.styl`: For text-related mixins.
- `stylus-nib/lib/nib/normalize/*.styl`: For normalize/reset mixins.
- `stylus-nib/lib/nodes/vendor-helpers.js`: To understand how vendor prefixes and gradient normalization were handled in Stylus.

### Analysis of `stylus-nib/lib/nib/border-radius.styl`
The `border-radius` mixin in Stylus provides an augmented syntax that allows for specifying individual corner radii in a flexible way (e.g., `border-radius: top left 10px`). Directly translating this complex parsing and dynamic property generation to SCSS is not straightforward due to differences in language features. For the SCSS implementation, I will focus on providing a standard `border-radius` mixin that accepts one to four values, consistent with standard CSS. If the augmented syntax is found to be heavily used and critical, a more complex SCSS implementation or a different approach might be considered, but for now, the priority is standard `border-radius`.

### Analysis of `stylus-nib/lib/nib/border.styl`
The `border` mixin in Stylus checks if the first argument is a color. If it is, it defaults to `1px solid` and appends any additional arguments. Otherwise, it applies all arguments directly to the `border` property. This behavior can be directly translated to SCSS using `@if` and `@else` with variable arguments (`...`).

### Analysis of `stylus-nib/lib/nib/clearfix.styl`
The `clearfix` mixin in Stylus uses `::before` and `::after` pseudo-elements to clear floats and includes `zoom: 1` for IE support, conditional on a `support-for-ie` variable. This can be directly translated to SCSS.

### Analysis of `stylus-nib/lib/nib/color-image.styl`
The `color-image` mixin relies on `node-canvas` for image generation, which is a Node.js library. This functionality cannot be directly translated to pure SCSS as SCSS does not have the capability to generate images or data URIs dynamically at compile time. If this functionality is critical, it would require a server-side implementation or a different approach for handling color images. For now, I will note that this mixin cannot be directly translated to SCSS.

### Analysis of `stylus-nib/lib/nib/flex.styl`
This file provides comprehensive Flexbox support, including vendor prefixes and fallbacks to older Flexbox syntaxes (e.g., `-webkit-box`, `-moz-box`). This is achieved through the `vendor` mixin (which will be analyzed later) and conditional logic based on `flex-version` and `box` in `flex-version`. Translating this to SCSS will involve reimplementing each Flexbox property as an SCSS mixin, handling vendor prefixes, and carefully translating the logic for obsolete syntaxes if they are still required by the project. This will be a substantial part of the refactoring.

### Analysis of `stylus-nib/lib/nib/gradients.styl`
The `gradients.styl` file provides mixins for `linear-gradient` and `linear-gradient-image`. The `linear-gradient` mixin can be translated to SCSS by leveraging native SCSS gradient functions and vendor prefixing (which will be handled by a generic vendor mixin). However, the `linear-gradient-image` mixin explicitly requires `node-canvas` for image generation, which is a Node.js library. This functionality cannot be directly translated to pure SCSS and would require a server-side implementation or a different approach if it's critical for the project.

### Analysis of `stylus-nib/lib/nib/iconic.styl`
The `iconic-stroke` mixin defines a `@font-face` rule for the 'IconicStroke' font, taking a `path` argument to construct the URLs for the font files. This can be directly translated to SCSS.

### Analysis of `stylus-nib/lib/nib/image.styl`
The `image` mixin handles responsive images by providing a `@2x` variant for high-resolution displays using media queries. It also handles `background-size`. This can be translated to SCSS. SCSS supports `@media` queries and string manipulation for path concatenation. The Stylus functions `extname`, `dirname`, `basename`, and `pathjoin` would need to be replicated or handled using SCSS string functions. I will aim to replicate the path manipulation as closely as possible.

### Analysis of `stylus-nib/lib/nib/overflow.styl`
The `overflow` mixin in Stylus checks if the argument is `ellipsis`. If so, it calls the `ellipsis()` mixin (defined in `lib/nib/text/ellipsis.styl`). Otherwise, it applies the arguments directly to the `overflow` property. This can be directly translated to SCSS.

### Analysis of `stylus-nib/lib/nib/positions.styl`
The `positions.styl` file defines `fixed`, `absolute`, and `relative` mixins, which are shorthands for setting `position` and `top`, `right`, `bottom`, `left` properties. The `fixed()` and `absolute()` mixins are already present in `lib/http/public/stylesheets/mixins.scss`. I will compare their existing SCSS implementation with the Stylus version to ensure correctness and then move them to `nib.scss`. The `relative()` mixin is missing and needs to be implemented. For the SCSS implementation, I will use a simpler approach with explicit `$top`, `$right`, `$bottom`, `$left` parameters, similar to the existing `fixed` and `absolute` implementations, rather than trying to replicate the complex Stylus argument parsing.

### Analysis of `stylus-nib/lib/nib/reset.styl`
The `reset.styl` file contains several reset mixins: `global-reset()`, `nested-reset()`, `reset-box-model()`, `reset-font()`, `reset-body()`, `reset-table()`, `reset-table-cell()`, and `reset-html5()`. The `reset-table()` mixin is already present in `lib/http/public/stylesheets/mixins.scss`. I will compare its existing SCSS implementation with the Stylus version to ensure correctness and then move it to `nib.scss`. All other reset mixins are missing and need to be implemented in SCSS. These are generally straightforward translations.

### Analysis of `stylus-nib/lib/nib/size.styl`
The `size` mixin sets `width` and `height`. If one argument is provided, it applies to both; if two, it applies them as `width` and `height` respectively. This is a straightforward translation to SCSS.

### Analysis of `stylus-nib/lib/nib/vendor.styl`
This file is extensive and defines a core `vendor` mixin along with many transparent mixins for various CSS properties (e.g., `box-shadow`, `user-select`, `transform`, `transition`, `opacity`, `box-sizing`, `animation`, `hyphens`, `appearance`, `placeholder`, `background`, `cursor`, `list-style`). The `vendor` mixin dynamically generates vendor-prefixed properties and values, and also calls a `normalize` function (defined in `lib/nodes/vendor-helpers.js`) for certain properties like gradients and transforms. Translating this to SCSS will be complex. SCSS doesn't have direct equivalents for dynamic property generation or the `normalize` function's logic. For simple vendor prefixing, I will create a generic `@mixin vendor-prefix($property, $value)` that iterates through common prefixes. For properties that require value normalization (like gradients or transforms), the logic from `lib/nodes/vendor-helpers.js` will need to be translated into SCSS functions or mixins. This is a significant task. Many individual mixins like `box-shadow()`, `user-select()`, `transform()`, `opacity()`, etc., simply call the main `vendor()` mixin. These will need to be reimplemented to use the new SCSS vendor prefixing strategy.

### Analysis of `stylus-nib/lib/nib/text/` directory
This directory contains `aliases.styl`, `ellipsis.styl`, `hide-text.styl`, `index.styl`, `replace-text.styl`, and `shadow-stroke.styl`.
- **`aliases.styl`**: Defines `no-wrap` alias and `whitespace()` mixin. Straightforward translation.
- **`ellipsis.styl`**: Applies `white-space: nowrap`, `overflow: hidden`, and `text-overflow: ellipsis`. Directly translatable.
- **`hide-text.styl`**: Hides text using `text-indent`, `white-space`, and `overflow`. Directly translatable.
- **`replace-text.styl`**: Replaces text with a background image, using `hide-text()` and setting background properties. Directly translatable.
- **`shadow-stroke.styl`**: Creates a text outline using `text-shadow`. Directly translatable.

### Analysis of `stylus-nib/lib/nib/normalize/` directory
This directory contains `base.styl`, `embed.styl`, `forms.styl`, `groups.styl`, `html5.styl`, `index.styl`, `links.styl`, `tables.styl`, and `text.styl`. The `normalize-css()` mixin in `index.styl` imports all these. These are direct translations of Normalize.css rules into Stylus mixins and can be directly translated to SCSS mixins.

### Analysis of `stylus-nib/lib/nodes/vendor-helpers.js`
This JavaScript file contains the `normalize` function which is called by the Stylus `vendor` mixin. It handles:
- **Gradient normalization:** Reorders color stops (`color pos` to `pos color`), fixes degrees for legacy syntax, and converts `to top` to `bottom` etc.
- **Transform prefixing:** Adds prefixes to `transform` values within `transition` properties.
- **Border-image `fill` keyword removal:** Removes `fill` keyword from legacy `border-image` properties.
Translating this JavaScript logic into SCSS functions will be crucial for accurate vendor prefixing and gradient handling. SCSS has string manipulation functions (`str-replace`, `str-index`, `str-slice`, `unit`, `unquote`, `quote`) and math functions that can be used to replicate this logic, but it will be complex and require careful implementation.

## Checklist

- [x] Create `docs/cline-plan-reimplement-mixins.md` (Done)
- [x] Read `lib/http/public/stylesheets/main.scss` to understand the current SCSS structure.
- [x] Read `lib/http/public/stylesheets/mixins.scss` to identify already refactored mixins.
- [x] Analyze `stylus-nib/lib/nib/` and its subdirectories to understand the original Stylus mixins.
- [x] Compare existing SCSS mixins with original Stylus mixins to identify incorrect implementations.
- [x] Identify missing mixins from the original `nib` library.
- [x] Create `lib/http/public/stylesheets/nib.scss`.
- [x] Reimplement/correct `border-radius` mixin in `nib.scss`.
- [x] Reimplement/correct `border` mixin in `nib.scss`.
- [x] Reimplement/correct `clearfix` mixin in `nib.scss`.
- [x] Reimplement/correct `color-image` mixin in `nib.scss`. (Not directly translatable, noted in analysis)
- [x] Reimplement/correct `flex` mixins (`display`, `flex-direction`, `flex-wrap`, `flex-flow`, `order`, `flex-grow`, `flex-basis`, `flex-shrink`, `flex`) in `nib.scss`.
- [x] Reimplement/correct `gradients` mixins (`linear-gradient`, `linear-gradient-image`) in `nib.scss`. (Image not directly translatable, noted in analysis)
- [x] Reimplement/correct `iconic-stroke` mixin in `nib.scss`.
- [x] Reimplement/correct `image` mixin in `nib.scss`.
- [x] Reimplement/correct `overflow` mixin in `nib.scss`.
- [x] Reimplement/correct `positions` mixins (`fixed`, `absolute`, `relative`) in `nib.scss`.
- [x] Reimplement/correct `reset` mixins (`global-reset`, `nested-reset`, `reset-box-model`, `reset-font`, `reset-body`, `reset-table`, `reset-table-cell`, `reset-html5`) in `nib.scss`.
- [x] Reimplement/correct `size` mixin in `nib.scss`.
- [x] Reimplement/correct `text` mixins (`no-wrap`, `whitespace`, `ellipsis`, `hide-text`, `replace-text`, `shadow-stroke`) in `nib.scss`.
- [x] Reimplement/correct `vendor` mixins (`vendor`, `vendor-value`, `box-shadow`, `user-select`, `column-count`, `column-gap`, `column-rule`, `column-rule-color`, `column-rule-width`, `column-rule-style`, `column-width`, `column-span`, `column-fill`, `legacy-bg-values`, `background-clip`, `background-origin`, `transform`, `transform-origin`, `transform-style`, `border-image`, `transition`, `transition-property`, `transition-duration`, `transition-timing-function`, `transition-delay`, `backface-visibility`, `perspective`, `perspective-origin`, `opacity`, `text-size-adjust`, `whitespace`, `box-sizing`, `box-orient`, `box-flex-group`, `box-ordinal-group`, `box-align`, `box-pack`, `box-direction`, `animation`, `animation-name`, `animation-duration`, `animation-delay`, `animation-direction`, `animation-iteration-count`, `animation-timing-function`, `animation-play-state`, `animation-fill-mode`, `hyphens`, `appearance`, `tab-size`, `overflow-scrolling`, `text-overflow`, `font-smoothing`, `placeholder`, `input-placeholder`, `background`, `background-image`, `cursor`, `list-style`, `list-style-image`) in `nib.scss`.
- [x] Reimplement/correct `normalize` mixins (`normalize-base`, `normalize-embed`, `normalize-forms`, `normalize-groups`, `normalize-html5`, `normalize-links`, `normalize-tables`, `normalize-text`, `normalize-css`) in `nib.scss`.
- [x] Update `main.scss` to import `nib.scss`.

- [ ] Verify the visual styles are fixed by running the test server (if applicable) or by checking the provided screenshots.
