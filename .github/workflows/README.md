# GitHub Actions CI/CD Workflow

This directory contains the lightweight GitHub Actions workflow for automated testing and code quality validation of the PokedexPocket iOS app.

## Workflow Overview

### `ci.yml` - Lightweight CI Pipeline
**File**: `.github/workflows/ci.yml`

**Triggers:**
- Push to `main` or `development` branches
- Pull requests to `main` branch

**Jobs:**
- **test-swift**: Runs unit tests on iOS simulator with SwiftLint validation
- **lint-only**: Dedicated code quality checks with strict SwiftLint rules
- **pr-summary**: Generates test summary for pull requests

**Features:**
- ⚡ **Fast execution**: 5-10 minutes total runtime
- 🆓 **Free to run**: No Apple Developer account required
- 📱 **Smart simulator detection**: Automatically finds available iOS simulators
- 💾 **Dependency caching**: Swift Package Manager caching for faster builds
- 🔍 **Code quality**: SwiftLint integration with strict validation
- 🧪 **Unit testing**: Automated test execution on iOS simulator

## Environment Variables

The workflow uses these simple environment variables:

```yaml
SCHEME: PokedexPocket
CONFIGURATION: Debug
```

## Requirements

### GitHub Repository Settings
- Enable Actions in repository settings (free tier sufficient)
- `GITHUB_TOKEN` permissions are automatically provided

### Xcode Project Requirements
- Scheme must be shared and committed to repository
- Swift Package Manager dependencies
- Unit tests in `PokedexPocketTests` target
- SwiftLint configuration (`.swiftlint.yml`)

## How It Works

### Automatic Execution
1. **Push to `main/development`** → Full pipeline runs
2. **Create PR to `main`** → Pipeline runs with summary
3. **Status checks** appear on PR automatically
4. **Merge** only after all checks pass

### Manual Execution
- Go to **Actions** tab in GitHub
- Select **CI/CD Pipeline**
- Click **Run workflow**

## Workflow Status Badge

Add this badge to your README.md:

```markdown
[![CI](https://github.com/muhAzri/PokedexPocket/actions/workflows/ci.yml/badge.svg)](https://github.com/muhAzri/PokedexPocket/actions/workflows/ci.yml)
```

## Simulator Detection

The workflow automatically detects available simulators:

```bash
# Finds first available iPhone simulator
SIMULATOR=$(xcrun simctl list devices available | grep -E "iPhone.*\(" | head -1)

# Extracts device name
DEVICE_NAME=$(echo "$SIMULATOR" | sed -E 's/^[[:space:]]*([^(]+).*/\1/' | xargs)

# Falls back to generic if none found
if [ -z "$DEVICE_NAME" ]; then
  DEVICE_NAME="Any iOS Simulator Device"
fi
```

## Customization

### Testing Different Targets
To test additional targets, modify the test command:
```yaml
test -only-testing:PokedexPocketTests
# Add more targets:
# test -only-testing:PokedexPocketTests -only-testing:YourNewTests
```

### SwiftLint Configuration
Customize `.swiftlint.yml` in project root:
```yaml
disabled_rules:
  - trailing_whitespace
line_length:
  warning: 120
  error: 200
```

### Timeout Adjustments
Each job has a 15-minute timeout by default:
```yaml
timeout-minutes: 15  # Adjust as needed
```

## Troubleshooting

### Common Issues

1. **"No matching simulator found"**
   - The workflow automatically handles this
   - Falls back to generic simulator placeholder
   - Check GitHub Actions runner's available simulators

2. **SwiftLint Failures**
   - Fix code style violations locally
   - Run `swiftlint lint --strict` before pushing
   - Update `.swiftlint.yml` if rules are too strict

3. **Test Failures**
   - Check test logs in Actions tab
   - Run tests locally first: `xcodebuild test -scheme PokedexPocket`
   - Fix threading issues in async tests

4. **Dependency Resolution**
   - Clear SPM cache if needed
   - Check `Package.resolved` is committed
   - Verify package compatibility

### Debug Tips
- Click on failed job to see detailed logs
- Use `echo` statements to debug workflow steps
- Test commands locally before adding to workflow
- Check Xcode version compatibility

## Performance & Cost

### Free Tier Limits
- **2,000 minutes/month** for macOS runners (free accounts)
- **5-10 minutes** per workflow run
- **~200-400 runs/month** possible on free tier

### Optimization Features
- **Dependency caching**: Speeds up subsequent runs
- **Parallel jobs**: `lint-only` runs independently
- **Timeout limits**: Prevents runaway jobs
- **Minimal output**: `--quiet` flags reduce log noise

## What's Excluded

To keep it **free and lightweight**:
- ❌ No IPA generation (requires Apple Developer account)
- ❌ No code signing or provisioning profiles
- ❌ No TestFlight deployment
- ❌ No device testing (simulator only)
- ❌ No UI tests (resource intensive)
- ❌ No complex artifact storage

This approach ensures the CI/CD pipeline works reliably within GitHub's free tier while providing essential code quality and testing validation.