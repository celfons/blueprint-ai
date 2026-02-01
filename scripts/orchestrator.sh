#!/bin/bash
set -e

AGENT_ROLE=$1
ISSUE_NUMBER=$2
COPILOT_ENABLED=$3

echo "🤖 Blueprint AI - Multi-Agent Orchestrator"
echo "Agent Role: $AGENT_ROLE"
echo "Issue Number: $ISSUE_NUMBER"
echo "Copilot Enabled: $COPILOT_ENABLED"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/../templates"

# Function to update issue with agent content
update_issue() {
    local issue_num=$1
    local template_file=$2
    local label=$3
    
    echo "📝 Updating issue #$issue_num with $AGENT_ROLE template..."
    
    if [ -f "$template_file" ]; then
        # Read template content
        template_content=$(cat "$template_file")
        
        # Get current issue body
        current_body=$(gh issue view "$issue_num" --json body -q '.body' || echo "")
        
        # Create separator
        separator="\n\n---\n\n## 🤖 ${AGENT_ROLE} Agent Update\n\n"
        
        # Append template to issue
        new_body="${current_body}${separator}${template_content}"
        
        # Update issue
        echo "$new_body" | gh issue edit "$issue_num" --body-file -
        
        # Add label
        gh issue edit "$issue_num" --add-label "$label" || true
        
        echo "✅ Issue updated successfully"
    else
        echo "❌ Template file not found: $template_file"
        exit 1
    fi
}

# Execute agent-specific workflow
case "$AGENT_ROLE" in
    PO)
        echo "🎯 Executing Product Owner Agent..."
        update_issue "$ISSUE_NUMBER" "$TEMPLATES_DIR/po-template.md" "agent:po"
        
        # Add Copilot integration hint
        if [ "$COPILOT_ENABLED" = "true" ]; then
            echo "💡 Copilot: Suggested enhancements for user story..."
            gh issue comment "$ISSUE_NUMBER" --body "💡 **GitHub Copilot Suggestion**: Review the BDD scenarios and acceptance criteria added by the PO agent. Consider edge cases and non-functional requirements." || true
        fi
        ;;
        
    DEV)
        echo "💻 Executing Developer Agent..."
        update_issue "$ISSUE_NUMBER" "$TEMPLATES_DIR/dev-template.md" "agent:dev"
        
        if [ "$COPILOT_ENABLED" = "true" ]; then
            echo "💡 Copilot: Suggested implementation approach..."
            gh issue comment "$ISSUE_NUMBER" --body "💡 **GitHub Copilot Suggestion**: Implementation checklist has been added. Use Copilot to generate unit tests and documentation based on the acceptance criteria." || true
        fi
        ;;
        
    QA)
        echo "🧪 Executing QA Agent..."
        update_issue "$ISSUE_NUMBER" "$TEMPLATES_DIR/qa-template.md" "agent:qa"
        
        if [ "$COPILOT_ENABLED" = "true" ]; then
            echo "💡 Copilot: Suggested test scenarios..."
            gh issue comment "$ISSUE_NUMBER" --body "💡 **GitHub Copilot Suggestion**: Test cases have been added. Consider adding performance, security, and accessibility tests." || true
        fi
        ;;
        
    *)
        echo "❌ Unknown agent role: $AGENT_ROLE"
        echo "Valid roles: PO, DEV, QA"
        exit 1
        ;;
esac

echo "✅ $AGENT_ROLE agent workflow completed successfully"
