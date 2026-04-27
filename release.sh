#!/bin/bash

# Release script for card_management_sdk Flutter plugin
# Usage: ./release.sh <version> <changelog_entry>

set -e  # Exit on any error

if [ $# -ne 2 ]; then
    echo "Usage: $0 <version> <changelog_entry>"
    echo "Example: $0 0.1.4 'Updated NICardManagementSDK to version 2.1.7'"
    exit 1
fi

VERSION=$1
CHANGELOG_ENTRY=$2

echo "🚀 Starting release process for version $VERSION"
echo "📝 Changelog entry: $CHANGELOG_ENTRY"

# Function to update version in file
update_version() {
    local file=$1
    local pattern=$2
    local replacement=$3
    sed -i '' -E "s/$pattern/$replacement/" "$file"
    echo "✅ Updated $file"
}

# 1. Update pubspec.yaml version
echo "📦 Updating pubspec.yaml version..."
update_version "pubspec.yaml" "^version: .*" "version: $VERSION"

# 2. Update iOS podspec version
echo "🍎 Updating iOS podspec version..."
update_version "ios/card_management_sdk.podspec" "^  s.version.*" "  s.version          = '$VERSION'"

# 3. Update Android build.gradle.kts version
echo "🤖 Updating Android build.gradle.kts version..."
update_version "android/build.gradle.kts" "^version = .*" "version = \"$VERSION\""

# 4. Update README installation snippet version
echo "📘 Updating README.md dependency version..."
update_version "README.md" "^[[:space:]]*card_management_sdk: \^.*" "	card_management_sdk: ^$VERSION"

# 5. Update CHANGELOG.md
echo "📝 Updating CHANGELOG.md..."
echo "📝 Updating CHANGELOG.md..."
CHANGELOG_CONTENT="## $VERSION\n\n* $CHANGELOG_ENTRY\n\n"
# Insert at the beginning after any header comments
sed -i '' "1s/^/$CHANGELOG_CONTENT/" "CHANGELOG.md"
echo "✅ Updated CHANGELOG.md"

# 7. Commit release changes before dry-run
echo "💾 Committing release changes before dry-run..."
git add pubspec.yaml ios/card_management_sdk.podspec android/build.gradle.kts README.md CHANGELOG.md
if git diff --cached --quiet; then
    echo "⚠️ No changes staged for commit."
else
    git commit -m "Prepare release v$VERSION"
fi

# 8. Run validation
echo "🧪 Running tests..."
flutter test

echo "🔍 Running code analysis..."
flutter analyze

echo "🍎 Validating iOS podspec..."
cd ios
pod lib lint card_management_sdk.podspec --allow-warnings
cd ..

echo "🤖 Building Android..."
if [ -x "android/gradlew" ]; then
    cd android
    ./gradlew build
    cd ..
else
    echo "⚠️ Skipping Android build: no gradle wrapper found in android/"
fi

# 9. Dry-run publish
echo "📤 Running publish dry-run..."
flutter pub publish --dry-run

# 10. Confirm and publish
read -p "✅ All validations passed! Ready to publish to pub.dev? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📤 Publishing to pub.dev..."
    flutter pub publish

    echo "🏷️ Creating git tag..."
    git tag "v$VERSION"
    git push origin main
    git push origin "v$VERSION"

    echo "🎉 Release v$VERSION completed successfully!"
else
    echo "❌ Publish cancelled. You can run 'flutter pub publish' manually when ready."
fi