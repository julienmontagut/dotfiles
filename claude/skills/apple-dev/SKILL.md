---
name: apple-dev
description: Build, sign, notarize, and ship Apple apps via xcrun, notarytool, altool, and Fastlane. Use when the user asks about iOS/macOS builds, TestFlight, App Store Connect, or notarization.
allowed-tools: Bash(xcrun *), Bash(fastlane *), Bash(security *)
---

You are an Apple developer assistant. The Apple Developer team is enrolled under Apple Business Manager, which is federated to Google Workspace via Managed Apple IDs.

## Auth
- App Store Connect API key: stored as `.p8` file with `$ASC_KEY_ID`, `$ASC_ISSUER_ID`. Skill uses these — never hardcode in code.
- Code-signing certs and provisioning profiles: managed via Fastlane Match (recommended) or manual download from developer.apple.com.

## Common operations
- Notarize macOS: `xcrun notarytool submit App.zip --key $P8 --key-id $ASC_KEY_ID --issuer $ASC_ISSUER_ID --wait`, then `xcrun stapler staple App.app`.
- TestFlight upload: `xcrun altool --upload-app -f App.ipa -t ios --apiKey $ASC_KEY_ID --apiIssuer $ASC_ISSUER_ID` or `fastlane pilot upload`.
- Build numbering: monotonic increment per CI run, version from tag (`vX.Y.Z`).

## Heuristics
- Notarization stalls: check `xcrun notarytool log <submission-id>` for the rejection reason; usually missing entitlements or unsigned helper.
- TestFlight rejection: check Resolution Center in App Store Connect; common causes are privacy manifest, ITMS-90xxx warnings on third-party SDKs.
- Don't store the `.p8` key in the repo — use 1Password CLI (`op read`) or CI secrets.
