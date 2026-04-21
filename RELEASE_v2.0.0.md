# YutubuDownload v2.0.0 Release Notes

Release date: 2026-04-20  
Codename: Multi-Instance Shared-Cookie Edition

## Highlights
- Added safe multi-instance downloads for parallel terminal usage.
- Added shared cookie service with lock-based refresh.
- Added session-isolated temp/log structure for cleaner concurrent runs.
- Improved exact quality targeting with fallback to nearest lower available format.
- Added adaptive progress behavior with low-network fallback when transfer conditions degrade.
- Introduced `ytd` as the simplified command alias while keeping `YutubuDownload` compatibility.

## Why This Release Matters
v2.0.0 is focused on reliability under real-world network constraints. It combines anti-bot handling, resilient download controls, and user-friendly progress behavior so downloads keep moving even in unstable conditions.

## User-Facing Improvements
- Cleaner single-line progress experience in normal conditions.
- Low-network status messaging when transfer telemetry is unstable.
- Better single vs playlist output organization.
- More consistent high-quality selection behavior.

## Technical Upgrades
- Cookie architecture shifted to shared file + lock refresh model.
- Session isolation implemented for temp/log paths.
- Runtime support remains Deno-first with Node fallback.
- Retry/resume protections improved for unstable links.

## Compatibility
- Primary launch command: `ytd`
- Compatibility launch command: `YutubuDownload`
- Ubuntu terminal workflows supported.

## Upgrade
```bash
sudo bash -c "$(curl -sL https://raw.githubusercontent.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal/main/install.sh)"
```

## Verification
```bash
ytd --version
```
Expected format:
`ytd (YutubuDownload) v2.0.0 (2026-04-20) ...`

## Notes
This release is tuned for reliability, not just speed. On unstable networks, UI behavior may intentionally simplify to preserve trust and reduce noisy ETA/speed swings.
