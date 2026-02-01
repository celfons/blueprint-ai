#!/bin/bash
# Demo script to show Blueprint AI functionality

set -e

echo "🤖 Blueprint AI - Demo Script"
echo "=============================="
echo ""

# Check if we have the necessary tools
echo "Checking prerequisites..."
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed"
    echo "   Install from: https://cli.github.com/"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub CLI"
    echo "   Run: gh auth login"
    exit 1
fi

echo "✅ All prerequisites met"
echo ""

# Show help
show_help() {
    echo "Usage: ./demo.sh [command]"
    echo ""
    echo "Commands:"
    echo "  test-po     - Test PO Agent with a sample issue"
    echo "  test-dev    - Test DEV Agent with a sample issue"
    echo "  test-qa     - Test QA Agent with a sample issue"
    echo "  test-all    - Test all agents sequentially"
    echo "  validate    - Validate all templates and scripts"
    echo ""
}

# Validate templates
validate_templates() {
    echo "🔍 Validating templates..."
    
    for template in templates/*.md; do
        if [ -f "$template" ]; then
            echo "  ✓ $(basename $template)"
        else
            echo "  ✗ Missing: $template"
            return 1
        fi
    done
    
    echo "✅ All templates present"
}

# Validate scripts
validate_scripts() {
    echo "🔍 Validating scripts..."
    
    if bash -n scripts/orchestrator.sh; then
        echo "  ✓ orchestrator.sh"
    else
        echo "  ✗ orchestrator.sh has syntax errors"
        return 1
    fi
    
    if [ -x scripts/orchestrator.sh ]; then
        echo "  ✓ orchestrator.sh is executable"
    else
        echo "  ⚠ orchestrator.sh is not executable (will be fixed)"
        chmod +x scripts/orchestrator.sh
    fi
    
    echo "✅ All scripts valid"
}

# Test PO Agent
test_po_agent() {
    echo "🎯 Testing PO Agent..."
    echo ""
    echo "This will test the PO Agent template generation."
    echo "Template preview:"
    echo "----------------------------------------"
    head -20 templates/po-template.md
    echo "----------------------------------------"
    echo "✅ PO Agent template is ready"
}

# Test DEV Agent
test_dev_agent() {
    echo "💻 Testing DEV Agent..."
    echo ""
    echo "This will test the DEV Agent template generation."
    echo "Template preview:"
    echo "----------------------------------------"
    head -20 templates/dev-template.md
    echo "----------------------------------------"
    echo "✅ DEV Agent template is ready"
}

# Test QA Agent
test_qa_agent() {
    echo "🧪 Testing QA Agent..."
    echo ""
    echo "This will test the QA Agent template generation."
    echo "Template preview:"
    echo "----------------------------------------"
    head -20 templates/qa-template.md
    echo "----------------------------------------"
    echo "✅ QA Agent template is ready"
}

# Main command routing
case "${1:-help}" in
    test-po)
        test_po_agent
        ;;
    test-dev)
        test_dev_agent
        ;;
    test-qa)
        test_qa_agent
        ;;
    test-all)
        test_po_agent
        echo ""
        test_dev_agent
        echo ""
        test_qa_agent
        ;;
    validate)
        validate_templates
        echo ""
        validate_scripts
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac

echo ""
echo "✅ Demo completed successfully!"
