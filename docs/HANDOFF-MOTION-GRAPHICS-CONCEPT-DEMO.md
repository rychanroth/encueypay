````markdown
# Context Handoff: Flutter Concept Demo & AI Motion Graphics (v2 — take-first)

> **Status:** working handoff, not a specification. The authoritative source for the product is the
> code in this repo; the authoritative source for the film is `~/encueypay-demo/` (its `AGENTS.md`,
> `docs/STATUS.md`). This document records **decisions, measurements and traps** so the next session
> does not relearn them.

Last updated: 2026-11-18

---

## 1. Objective

An **8–11 minute**, 16:9, **1920×1080** concept demo of **R67** (the app in this repo), presented as
a course project: Khmer narration, real app footage, $0 tooling.

The film follows **one order all the way down** — a buyer places it, the seller processes it, the
records reconcile — rather than touring features.

## 2. Where everything lives

| What | Path |
|---|---|
| **Production workspace** (beats, captures, audio, renders) | `~/encueypay-demo/` |
| Film status, per beat | `~/encueypay-demo/docs/STATUS.md` |
| b03 script (Khmer + English) | `~/encueypay-demo/docs/script-b03.md` |
| b03 measured timings | `~/encueypay-demo/docs/b03-timing.json`, `b03-cues.json` |
| b03 shooting handoff (manual) | `~/encueypay-demo/docs/HANDOFF-B03-SHOOT.md` |
| Scorecard / rules / springs | `~/encueypay-demo/reference/` |
| **The product** (source of truth) | this repo |

## 3. The pivot (the most important decision)

**v1 was stills + motion graphics**: real screenshots of the app, animated with camera pushes and
spring typography. It reads as a slide deck with a fancy zoom. The user rejected it explicitly:

> "static image and animating on top of it is not cinematic"

**v2 is real takes**: the real app, driven by a real pointer, recorded, then cut.

| | v1 (stills) | v2 (takes) |
|---|---|---|
| Picture | screenshots | screen recording |
| Motion | camera animated over a still | the app actually moves |
| Clock | synthesized VO | **the take** (VO fitted to it) |
| Detail shots | 2–2.5× crop of a 3× plate | **none — see §6** |

The consequence: **the take is the clock.** Narration is written first, synthesized, measured, and
each scene *holds* for its measured length. Narration is never squeezed to fit what the app did.

## 4. What was ruled out (do not re-litigate)

- **Code→Figma mirroring via Figma MCP** — creates a second artefact that drifts, hits plan quotas,
  and omits widget detail.
- **Autonomous agent UI crawling** — noise, staging states on film, wasted tokens.
- **Multi-agent swarms** — one agent with vision is enough; the human is the creative director.
- **Diffusion Studio** — desktop app is macOS/Windows only; skills/CLI/MCP cannot run on Linux.
- **Remotion** — React-only, source-available licence.
- **Veo / Sora / diffusion video** — seconds per frame, real money; never the spine of a film.
- **Xvfb + x11grab** — captures beautifully (60 fps, zero drops) but **renders in software**: measured
  **8.8–11.7 fps** for a scrolling Flutter screen. Unusable for takes.
- **CDP screencast** — fully scripted, but encode-bound at ~40 Mpx/s: 8–13 fps at 1560×3376,
  20 fps at 1170×2532, 30 fps at 780×1688. Only viable at low resolution.
- **KDE virtual monitor (`krfb-virtualmonitor`)** — creates a 1560×3376 output, Chrome reports it, but
  the compositor paints only the desktop: the window is listed in that screen's taskbar and never
  drawn. Abandoned after several attempts.
- **High-DPR phone (DPR 4, 1560×3376)** — needs a screen taller than the 1080 panel; see above.
  Also made the pointer unreachable, because the invisible output sat at `0,0`.

## 5. The pipeline in order

```
1  script          phrases, one idea each, in the audience's language
2  VO              synthesize per phrase, measure each (ffprobe)
3  holds           scene length = measured speech + 0.45 s breath/phrase + 0.6 s settle
4  takes           record the real app, one take per scene, holding for that length
5  marks           tap/type/scroll timestamps per take → SFX, labels, cuts
6  compose         crop, 1–2 % breathing push, labels
7  mix             −14 LUFS, TP ≤ −1 dBTP
```

**Never** start at step 4. Scene lengths come from the measured speech, not from vibes.

## 6. Capture — what actually works

| | |
|---|---|
| Geometry | 390×844 CSS at `--force-device-scale-factor=1.28` → **~500×1080 device px** |
| Window | **no title bar** (KWin rule `r67-nodeco`), so the viewport is a real phone's 844 tall |
| Capture | the **window** (PipeWire portal) or the screen; window capture survives you switching apps |
| Crop | `500×1080` at the window origin (was `(710, 0)`) — **width must be even** or H.264 refuses |
| FPS | 30, cursor **visible** |

**No zoom.** At 500 px wide, the phone occupies about a quarter of the frame and UI text is ~10 px.
Detail shots are therefore gone by design: **labels carry the numbers**, not crops. This was chosen
deliberately after attempting high-DPR capture.

**Measured on this machine** (Ryzen 5 4600H, GTX 1650 Ti, 1920×1080@144 KDE/Wayland):
GPU render of the same 5.3 Mpx Flutter screen: **117 fps**. Software (Xvfb): **8.8 fps**. The GPU is
not optional.

## 7. Rules learned the hard way

1. **Pause before every click.** A click between frames is invisible and worthless.
2. **One action at a time.** Fast sequences skip states and read as a glitch.
3. **Search submits on Enter** — it does not filter while typing.
4. **Never mix the category chips with the search field in one scene**: focusing search clears the
   category, and the result count flips 8 → 2 → 8.
5. **Interact before scrolling.** Flutter's accessibility rects go stale after a drag; a click after a
   scroll lands where the element used to be.
6. **Onboarding needs a blur**: type the phone, tap empty space, *then* Start shopping, or the app
   reports "Enter a valid phone" for a valid number.
7. **Never launch Chrome with `--no-sandbox` or `--disable-blink-features`** — both paint an
   "unsupported command-line flag" infobar into every take.
8. **Disable Chrome's update bubble** (`--disable-component-update`) or it lands mid-take.
9. **Serve the app on port 8080.** Supabase's local allow-list contains only
   `http://localhost:8080`; on another port Google OAuth returns to the API host and the browser shows
   `{"message":"no Route matched with those values"}` (Kong).
10. **Blind sequencing lies.** A tap that worked at identical coordinates failed twice. Every step
    should assert its result and retry, not fire and hope.
11. **Screen capture films whatever is on top.** If you must record the screen (not the window), stay
    off the machine for the take.

## 8. Film structure (v2)

| Beat | Job | Length |
|---|---|---|
| b00 | class open | 33 s *(v1, keep)* |
| b01 | the problem — three broken truths | 73 s *(v1, keep)* |
| b02 | the answer — the record | 85 s *(v1, keep; composition known-weak)* |
| **b03** | **buyer: sign-in → pending** | **198.8 s (12 scenes)** |
| b04 | seller: processes the same order | ~110 s *to rewrite* |
| b05 | seller: shelf + promotions + instruments | ~190 s *to write* |
| b06 | payoff: verified payment, reconcile, CTA | ~65 s *to write* |

Delete or rewrite b04–b06 in the same take-first style; their v1 plate versions are superseded.

## 9. b03 in detail (the beat in flight)

- **42 Khmer phrases**, user-authored (never invented by the agent).
- Speech **172.66 s** measured → **198.8 s** of film across 12 scenes.
- Scene holds: 12.3 · 14.6 · 17.5 · 21.4 · 23.4 · 16.3 · 23.0 · 14.4 · 20.8 · 7.4 · 17.4 · 10.3 s.
- Flow: sign in → onboarding → discover → product (variant) → cart → address (**"Use my current
  location"**) → checkout → coupon → KHQR → placed → **pending (amber)** → hand-off.
- **No emerald anywhere**: `#059669` appears exactly once in the whole film, at b06's verified payment.
- Shooting is **manual** as of 2026-11-18: see `~/encueypay-demo/docs/HANDOFF-B03-SHOOT.md`.

## 10. Environment notes (this machine)

- **KDE Plasma 6.8 / KWin on Wayland**, single 1920×1080@144 panel (`eDP-1`).
- Chrome ignores `--window-position` under Wayland; read the real geometry from KWin. A KWin script
  that prints `workspace.windowList()` geometries is the reliable way.
- `workspace.outputs` is **empty** in this KWin scripting API — the virtual monitor could not be
  addressed programmatically.
- Chrome window rules live in `~/.config/kwinrulesrc`; `noborder=true` + `noborderrule=2` +
  `wmclass=chrome-localhost__-Default` removes the title bar.
- Capturing needs the xdg-desktop-portal ScreenCast (KDE) grant; **window** grants are bound to a
  specific window, so they must be re-approved when Chrome restarts. Monitor grants persist.
- Chrome's automation flags are visible to the app: keep `--enable-automation` off and never add flags
  that trip the infobar.

## 11. App-side facts worth carrying

- **Local stack:** `supabase start` runs Postgres/PG `:54322`, API `:54321`, Studio `:54323`.
- **Migrations drift.** The local DB was 15 migrations behind `HEAD` and onboarding failed with
  `Could not find the 'onboarded_at' column of 'users'`. Fix: `supabase migration up --local`.
- **Coupon seeded for the film:** `R67DEMO`, percent, 10, min order 2000 minor.
- **Address auto-fill is real:** `address_edit_screen.dart:108–114` fills recipient name and phone from
  the profile **only when those fields are empty** — a good beat ("you do not type it").
- **Review is gated on delivery**: a pending order cannot be reviewed, so the review belongs to b06.
- Deep links: the hash router works (`/#/home/product/:id`). Path deep links need an SPA fallback in
  the static host and the app restores unknown paths to home anyway.

## 12. Open decisions

1. **Manual vs scripted shooting.** As of 2026-11-18 the user records takes by hand; the agent cuts and
   labels. Revisit if a reliable window-capture + scripted-input loop is built.
2. **Labels and graphics pass** for b03 — not started; the numbers must be legible without zooms.
3. **b04–b06** need the same treatment: script → VO → holds → takes.
4. **b02** is the weakest surviving beat (composition). Decide: re-stage, or cut to a 40 s bridge.
5. **Demo identity** on screen: the presenter's own account is the buyer (ruling 2026-11-17); no third
   party appears.

## 13. Quickstart

```bash
# local stack + schema
cd /mnt/data/projects/flutter/encueypay
supabase start
supabase migration up --local

# app on the port Supabase allows
flutter build web -o build/web-local --dart-define-from-file=config/.env
python3 - <<'PY'   # SPA fallback static server
import http.server, os
ROOT="build/web-local"
class H(http.server.SimpleHTTPRequestHandler):
    def __init__(s,*a,**k): super().__init__(*a,directory=ROOT,**k)
    def translate_path(s,p):
        q=super().translate_path(p)
        return q if os.path.exists(q) and not os.path.isdir(q) else os.path.join(ROOT,"index.html")
http.server.ThreadingHTTPServer(("127.0.0.1",8080),H).serve_forever()
PY

# app window for takes (no title bar comes from the KWin rule)
google-chrome-stable --app="http://localhost:8080/" \
  --window-size=390,844 --force-device-scale-factor=1.28 \
  --user-data-dir=/tmp/opencode/profile-film \
  --disable-component-update --disable-background-networking
```
````
