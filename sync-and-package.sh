#!/usr/bin/env bash
# Pulls the live Confetti workflow's info.plist, icon.png, and compiled
# binary out of Alfred's synced preferences into this repo, and rebuilds
# Confetti.alfredworkflow from them. Does NOT touch git — review the diff
# yourself, then commit, push, bump the version in Alfred's Configure
# Workflow, and tag a release.
#
# The `confetti` binary itself is not rebuilt here — see build-binary.sh
# for compiling + signing + notarizing a fresh one from confetti.swift.
set -euo pipefail

BUNDLE_ID="com.twobit-consulting.confetti"
ALFRED_WORKFLOWS="$HOME/Documents/Software/Alfred.alfredpreferences/workflows"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find the live workflow's folder by Bundle ID rather than a hardcoded UUID,
# since that UUID isn't stable across a workflow being recreated.
WF_DIR=""
for dir in "$ALFRED_WORKFLOWS"/*/; do
	info="$dir/info.plist"
	[ -f "$info" ] || continue
	id=$(/usr/libexec/PlistBuddy -c "Print :bundleid" "$info" 2>/dev/null || true)
	if [ "$id" = "$BUNDLE_ID" ]; then
		WF_DIR="$dir"
		break
	fi
done

if [ -z "$WF_DIR" ]; then
	echo "Could not find a live Alfred workflow with bundle id $BUNDLE_ID" >&2
	exit 1
fi

echo "Found live workflow: $WF_DIR"

cp "$WF_DIR/info.plist" "$REPO_DIR/info.plist"
cp "$WF_DIR/icon.png" "$REPO_DIR/icon.png"
if [ -f "$WF_DIR/confetti" ]; then
	cp "$WF_DIR/confetti" "$REPO_DIR/confetti"
	chmod +x "$REPO_DIR/confetti"
fi

echo "Repackaging Confetti.alfredworkflow (info.plist + icon.png + confetti binary, no prefs.plist)..."
rm -f "$REPO_DIR/Confetti.alfredworkflow"
(cd "$REPO_DIR" && zip -X -q Confetti.alfredworkflow info.plist icon.png confetti)

echo ""
echo "Done. Diff against the last commit:"
echo ""
cd "$REPO_DIR"
git --no-pager diff --stat
git --no-pager diff -- info.plist

echo ""
echo "Next steps, if this looks right:"
echo "  git add -A && git commit -m '...'"
echo "  git push"
echo "  bump the version in Alfred's Configure Workflow, then:"
echo "  gh release create vX.Y.Z Confetti.alfredworkflow --title vX.Y.Z --notes '...'"
