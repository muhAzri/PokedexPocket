#!/bin/bash

# Install Git Hooks Script
# This script installs all necessary Git hooks for the PokedexPocket project

echo "🔧 Installing Git hooks for PokedexPocket..."

# Create scripts directory if it doesn't exist
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
HOOKS_DIR="$PROJECT_ROOT/.git/hooks"

# Check if we're in a Git repository
if [ ! -d "$PROJECT_ROOT/.git" ]; then
    echo "❌ Error: Not in a Git repository!"
    echo "   Please run this script from the project root directory."
    exit 1
fi

# Check if SwiftLint is installed
if ! command -v swiftlint &> /dev/null; then
    echo "⚠️  SwiftLint is not installed."
    echo "   Installing SwiftLint via Homebrew..."
    
    if command -v brew &> /dev/null; then
        brew install swiftlint
    else
        echo "❌ Homebrew is not installed. Please install SwiftLint manually:"
        echo "   https://github.com/realm/SwiftLint#installation"
        exit 1
    fi
fi

# Install pre-commit hook
echo "📋 Installing pre-commit hook..."
if [ -f "$HOOKS_DIR/pre-commit" ]; then
    echo "   Pre-commit hook already exists. Backing up..."
    mv "$HOOKS_DIR/pre-commit" "$HOOKS_DIR/pre-commit.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Copy the pre-commit hook (assuming it's already in place)
if [ -f "$HOOKS_DIR/pre-commit" ]; then
    chmod +x "$HOOKS_DIR/pre-commit"
    echo "✅ Pre-commit hook installed successfully!"
else
    echo "❌ Pre-commit hook file not found!"
    exit 1
fi

echo ""
echo "🎉 Git hooks installation completed!"
echo ""
echo "📝 What this does:"
echo "   • Pre-commit hook: Runs SwiftLint validation before each commit"
echo "   • Ensures code quality by preventing commits with SwiftLint violations"
echo "   • Helps maintain consistent code style across the project"
echo ""
echo "💡 Tips:"
echo "   • Run 'swiftlint --fix' to auto-fix some common issues"
echo "   • Run 'swiftlint' manually to check for violations"
echo "   • Use 'git commit --no-verify' to bypass hooks (not recommended)"
echo ""