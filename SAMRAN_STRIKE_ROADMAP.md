# Samran Ops — Development Roadmap

This document tracks the phased plan for turning the forked "FPS Multiplayer
Template" into **Samran Ops**, a private multiplayer tactical FPS. It is
updated as phases complete or scope changes.

All work happens on the `samran-ops-dev` branch (and short-lived branches off
it). `main` is preserved untouched as the original template baseline.

## Phase 0 — Baseline (current)
- Verify the forked template runs/loads correctly as-is.
- Establish `samran-ops-dev` as the working branch.
- Document this roadmap and the Phase 1 file scope.
- No gameplay or networking behavior changes.

## Phase 1 — Project Identity & Rebrand
- Rename project metadata (window title, project name/tags) from the
  template's identity to Samran Ops.
- Update README to describe Samran Ops instead of the generic template.
- Review/adjust licensing notices for the rebrand (keep MIT attribution to
  the original template author where code/assets are reused).
- No gameplay logic, scene structure, or networking changes.

## Phase 2 — Networking Hardening
- Move hit/damage authority from client-trusting RPCs toward
  server-authoritative validation.
- Add reconnect/disconnect handling and basic cheating mitigations.
- Revisit UPnP/hosting flow for private-match use.

## Phase 3 — Core Gameplay Systems
- Replace the single fixed pistol with a weapon-system framework
  (loadouts, switching, ADS, recoil).
- Expand health/armor/damage model beyond the current 2-hit placeholder.
- Add player state (crouch, sprint, lean) as needed for tactical play.

## Phase 4 — Game Modes & Match Flow
- Round-based tactical mode (buy phase, round win/loss, team sides).
- Match/lobby management beyond simple host/join.

## Phase 5 — Maps & Environment
- Replace/extend the placeholder warehouse map with Samran Ops maps.
- Iterate on lighting/environment art direction.

## Phase 6 — UI/UX Overhaul
- Rebrand and rebuild HUD, scoreboard, kill feed, menus for Samran Ops.
- Persist player settings (currently in-memory only via `Global.gd`).

## Phase 7 — Audio & Polish
- Replace placeholder menu/gunshot audio with Samran Ops audio direction.
- General bug fixing and balance pass.

## Phase 8 — Release Prep
- Packaging/export presets, final licensing/asset audit, distribution.

---
Status: Phase 0 complete (this commit). Phase 1 not yet started — see
`PHASE1_FILE_SCOPE` section below for the identified minimum file set.

### Phase 1 file scope (identification only — not yet modified)
- `project.godot` — `config/name`, `config/tags` (project identity).
- `README.md` — replace template description/branding with Samran Ops.
- `LICENSE` — confirm/adjust copyright and attribution language for the
  fork; no license change, wording only.
- `icon.svg` (+ its `.import`) — placeholder engine icon, likely replaced
  with Samran Ops branding at this stage or deferred to Phase 6.

No scripts, scenes, or networking code are in scope for Phase 1.
