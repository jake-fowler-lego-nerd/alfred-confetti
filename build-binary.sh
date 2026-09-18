#!/usr/bin/env bash
# Compiles confetti.swift into a signed, notarized universal binary
# (arm64 + x86_64), so the workflow doesn't require Xcode Command Line
# Tools on the machine that runs it -- only on the machine that builds it.
#
# Requires:
#   - A "Developer ID Application" certificate in your keychain
#   - A stored notarytool credential profile named "notarytool-profile"
#     (one-time setup: xcrun notarytool store-credentials "notarytool-profile" ...)
#   - Xcode-beta.app (or full Xcode) installed for x86_64 cross-compilation --
#     bare Command Line Tools were missing the x86_64 compatibility libraries
#     when this was first built (Sep 2026).
#
# Does NOT copy the result into the live Alfred workflow or touch git --
# review the output, then copy `confetti` into the live workflow's folder
# yourself, or via sync-and-package.sh in reverse.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SIGNING_IDENTITY="Developer ID Application: Jacob Fowler (9CK7A6M7M3)"
NOTARY_PROFILE="notarytool-profile"
XCODE_FOR_X86_64="/Applications/Xcode-beta.app/Contents/Developer"

cd "$REPO_DIR"

echo "==> Compiling arm64..."
swiftc -target arm64-apple-macos11 confetti.swift -o confetti-arm64

echo "==> Compiling x86_64 (via $XCODE_FOR_X86_64)..."
DEVELOPER_DIR="$XCODE_FOR_X86_64" swiftc -target x86_64-apple-macos11 confetti.swift -o confetti-x86_64

echo "==> Merging into a universal binary..."
lipo -create confetti-arm64 confetti-x86_64 -output confetti
rm -f confetti-arm64 confetti-x86_64
lipo -info confetti

echo "==> Signing with hardened runtime..."
codesign --sign "$SIGNING_IDENTITY" --options runtime --timestamp confetti
codesign -dv confetti

echo "==> Submitting for notarization (this polls Apple and can take a few minutes)..."
ditto -c -k --keepParent confetti confetti-for-notarization.zip
xcrun notarytool submit confetti-for-notarization.zip --keychain-profile "$NOTARY_PROFILE" --wait
rm -f confetti-for-notarization.zip

# Note: stapling deliberately skipped -- `stapler staple` only works on
# .app/.pkg/.dmg bundles, not bare executables (confirmed: exit code 73,
# "the code is valid but does not seem to be an app"). Gatekeeper checks
# the notarization ticket online against Apple's servers on first run
# instead, which needs network access at that moment but works fine
# afterward. This is a real, known limitation for standalone CLI tools,
# not a mistake -- there's nothing to staple onto here.

echo ""
echo "Done. ./confetti is signed and notarized."
echo "Copy it into the live workflow folder to test, then run sync-and-package.sh"
echo "to pull everything (including this binary) back into the repo."
