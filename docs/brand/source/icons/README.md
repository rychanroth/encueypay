# Icon sources

Material Symbols (outlined) 24px SVGs from Google's `material-design-icons`
repository.

- Source: https://github.com/google/material-design-icons
- License: Apache License 2.0
- Style: `materialsymbolsoutlined`, 24px, fill0 (outlined) except `favorite`,
  which uses `favorite_fill1_24px.svg` for the filled state.
- Naming: the component name matches the app's semantic name, not always the
  upstream file name (`notifications_none` comes from `notifications`,
  `favorite_border` from `favorite`).

These are imported into Figma as editable vector nodes. The runtime app still
uses Flutter's bundled Material Icons font; the Symbols set is the design-side
library.
