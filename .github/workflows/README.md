# GitHub Actions CI/CD Workflows

This directory contains GitHub Actions workflows for automated testing, building, and deployment of the PokedexPocket iOS app.

## Workflows Overview

### 1. `ci.yml` - Main CI/CD Pipeline
**Triggers:**
- Push to `main` or `development` branches
- Pull requests to `main` branch

**Jobs:**
- **test**: Runs unit tests and UI tests on macOS runners
- **build-and-archive**: Creates release archive (only on main branch pushes)
- **code-quality**: Runs SwiftLint analysis and static code analysis

**Features:**
- Swift Package Manager dependency caching
- SwiftLint integration with strict mode
- Test result artifacts and PR comments
- Xcode project building and archiving

### 2. `pr-checks.yml` - Pull Request Validation
**Triggers:**
- Pull request opened, synchronized, or reopened to `main`

**Jobs:**
- **pr-validation**: Fast validation checks for PRs
- **security-scan**: Security scanning for sensitive information

**Features:**
- Merge conflict detection
- SwiftLint on changed files only (faster)
- Test coverage reporting
- Security checks for hardcoded secrets
- Debug statement detection

### 3. `release.yml` - Release Pipeline
**Triggers:**
- Git tags matching `v*.*.*` pattern
- Manual workflow dispatch

**Jobs:**
- **create-release**: Creates GitHub release with changelog
- **build-and-upload**: Builds IPA and uploads to release
- **notify**: Sends notifications about release status

**Features:**
- Automatic changelog generation
- Full test suite execution before release
- IPA file creation and upload
- Release asset management

## Environment Variables

All workflows use these common environment variables:

```yaml
SCHEME: PokedexPocket
CONFIGURATION: Debug  # Release for production builds
SIMULATOR_DEVICE: iPhone 15
SIMULATOR_OS: latest
```

## Requirements

### GitHub Repository Settings
- Enable Actions in repository settings
- Ensure `GITHUB_TOKEN` has appropriate permissions

### Xcode Project Requirements
- Scheme must be shared and committed to repository
- Swift Package Manager dependencies
- Unit tests in `PokedexPocketTests` target
- UI tests in `PokedexPocketUITests` target

## Usage Examples

### Running Tests on PR
1. Create a pull request to `main` branch
2. PR checks workflow automatically runs
3. Status checks appear on the PR
4. Merge only after all checks pass

### Creating a Release
1. **Automatic:** Push a tag like `v1.0.0`
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Manual:** Use GitHub Actions tab
   - Go to Actions → Release Pipeline
   - Click "Run workflow"
   - Enter version number

### Monitoring Workflows
- Check Actions tab for workflow runs
- Download artifacts (test results, archives)
- Review job logs for debugging

## Workflow Status Badges

Add these badges to your main README.md:

```markdown
[![CI](https://github.com/muhAzri/PokedexPocket/actions/workflows/ci.yml/badge.svg)](https://github.com/muhAzri/PokedexPocket/actions/workflows/ci.yml)
[![PR Checks](https://github.com/muhAzri/PokedexPocket/actions/workflows/pr-checks.yml/badge.svg)](https://github.com/muhAzri/PokedexPocket/actions/workflows/pr-checks.yml)
[![Release](https://github.com/muhAzri/PokedexPocket/actions/workflows/release.yml/badge.svg)](https://github.com/muhAzri/PokedexPocket/actions/workflows/release.yml)
```

## Customization

### Adding New Test Targets
Update the test commands in workflows:
```yaml
-only-testing:YourNewTestTarget
```

### Changing Simulators
Modify environment variables:
```yaml
SIMULATOR_DEVICE: iPhone 14 Pro
SIMULATOR_OS: 16.0
```

### Adding Code Coverage
Coverage is enabled in release workflow. To add coverage reports:
```yaml
- name: Generate Coverage Report
  run: |
    xcrun xccov view --report --json DerivedData/Logs/Test/*.xcresult > coverage.json
```

## Troubleshooting

### Common Issues

1. **Build Failures**
   - Check Xcode version compatibility
   - Verify scheme is shared
   - Review dependency versions

2. **Test Timeouts**
   - Increase timeout values in workflow
   - Check for blocking UI tests
   - Review simulator performance

3. **SwiftLint Failures**
   - Update `.swiftlint.yml` configuration
   - Fix code style violations
   - Consider disabling specific rules for tests

### Debug Tips
- Enable detailed logging with `-verbose` flag
- Use `xcpretty` for better formatted output
- Check artifact uploads for detailed reports
- Review individual job logs in Actions tab

## Security Considerations

- Secrets scanning prevents hardcoded API keys
- Debug statement detection for production code
- Dependency vulnerability scanning via package resolution
- Limited artifact retention (7 days for archives)

## Performance Optimizations

- SPM dependency caching reduces build times
- Parallel job execution where possible
- Fast-fail PR checks for quick feedback
- Selective file linting in PR checks
- DerivedData cleanup between builds