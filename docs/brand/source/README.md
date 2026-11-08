# Brand asset sources

Vector source of truth for EncueYPay identity assets.

## Files

| File | Purpose |
|---|---|
| `mark.svg` | The Ledger E mark, 64×64 tile |
| `app-icon.svg` | Full-bleed app icon, 1024×1024 |
| `app-icon-foreground.svg` | Android adaptive foreground, 432×432, transparent |
| `illustrations/*.svg` | Ledger-line state illustrations, 160×160 |

## Export pipeline

Flutter does **not** ship an SVG renderer by default and `flutter_svg` is not an
approved dependency. Export PNGs at density variants instead:

```bash
# one-off, using any local SVG renderer (rsvg-convert, Inkscape, or Figma export)
rsvg-convert -w 64  mark.svg -o ../../assets/brand/mark.png
rsvg-convert -w 128 mark.svg -o ../../assets/brand/2.0x/mark.png
rsvg-convert -w 192 mark.svg -o ../../assets/brand/3.0x/mark.png
```

Rules:

- Keep the SVG as the source; never edit the PNG.
- Wordmark is **text**, not an asset: Plus Jakarta Sans ExtraBold, −3% tracking.
- Export with a transparent background unless the asset is an app icon.
- Illustration exports: 80dp (1x), 160 (2x), 240 (3x).
- The app icon has no rounded corners and no transparency.
- Verify every export on both `#F8FAFC` and `#090D16`.

## Licensing

- Plus Jakarta Sans: SIL Open Font License.
- Material Symbols (when imported): Apache-2.0.
- KHQR/Bakong mark: official asset only, used under NBC brand rules.
- These illustrations are original work for EncueYPay.
