# GitHub Projects Integration Guide

This guide explains how to integrate Blueprint AI with GitHub Projects for a complete DevOps workflow.

## Overview

Blueprint AI agents can automatically update issues in GitHub Projects, providing a seamless workflow from ideation to deployment.

## Project Board Setup

### 1. Create a GitHub Project

1. Go to your repository's **Projects** tab
2. Click **New project**
3. Choose **Board** view
4. Name it "Development Workflow"

### 2. Configure Columns

Create the following columns:

1. **📋 Backlog** - New issues waiting for PO review
2. **✅ Ready** - Issues with PO agent content (user stories, BDD)
3. **💻 In Progress** - Issues being developed
4. **🧪 Testing** - Issues in QA review
5. **✅ Done** - Completed issues

### 3. Set Up Automation Rules

Configure automation to move cards automatically:

#### Column: Backlog → Ready
- **Trigger**: Issue labeled with `agent:po`
- **Action**: Move to "Ready" column

#### Column: Ready → In Progress
- **Trigger**: Issue labeled with `agent:dev`
- **Action**: Move to "In Progress" column

#### Column: In Progress → Testing
- **Trigger**: Issue labeled with `agent:qa`
- **Action**: Move to "Testing" column

#### Column: Testing → Done
- **Trigger**: Issue closed
- **Action**: Move to "Done" column

## Workflow Configuration

### Complete Project Integration Workflow

Create `.github/workflows/project-integration.yml`:

```yaml
name: Project Board Integration

on:
  issues:
    types: [opened, labeled, closed]
  project_card:
    types: [created, moved]

permissions:
  issues: write
  contents: read
  projects: write

jobs:
  # When issue is opened, add to backlog and run PO agent
  new-issue-handler:
    if: github.event_name == 'issues' && github.event.action == 'opened'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Add to Project Backlog
        uses: actions/add-to-project@v0.5.0
        with:
          project-url: https://github.com/users/YOUR_USERNAME/projects/PROJECT_NUMBER
          github-token: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Run PO Agent
        uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'PO'
          issue-number: ${{ github.event.issue.number }}
  
  # When PO label is added, move to Ready column
  po-complete-handler:
    if: |
      github.event_name == 'issues' && 
      github.event.action == 'labeled' &&
      github.event.label.name == 'agent:po'
    runs-on: ubuntu-latest
    steps:
      - name: Move to Ready Column
        uses: actions/github-script@v7
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          script: |
            // Update project card status
            console.log('Issue moved to Ready for development');
  
  # When issue is assigned, run DEV agent
  dev-agent-trigger:
    if: |
      github.event_name == 'issues' && 
      github.event.action == 'assigned'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run DEV Agent
        uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'DEV'
          issue-number: ${{ github.event.issue.number }}
  
  # When DEV label is added, run QA agent
  qa-agent-trigger:
    if: |
      github.event_name == 'issues' && 
      github.event.action == 'labeled' &&
      github.event.label.name == 'agent:dev'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run QA Agent
        uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'QA'
          issue-number: ${{ github.event.issue.number }}
```

## Project Automation with GitHub CLI

You can also manage projects programmatically:

```bash
# Add issue to project
gh issue edit ISSUE_NUMBER --add-project "Development Workflow"

# Move issue in project
gh project item-edit PROJECT_ID \
  --field "Status" \
  --value "In Progress"

# List project items
gh project item-list PROJECT_ID
```

## Advanced: Custom Field Integration

### Adding Custom Fields

1. In your project, click **Settings**
2. Add custom fields:
   - **Priority**: Single select (High, Medium, Low)
   - **Effort**: Number (story points)
   - **Sprint**: Iteration field

### Update Workflow to Set Fields

```yaml
- name: Set Priority and Effort
  uses: actions/github-script@v7
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    script: |
      // Set custom field values
      const projectItemId = 'PROJECT_ITEM_ID';
      // Add logic to update custom fields
```

## Best Practices

### 1. Issue Lifecycle

```
New Issue → PO Agent (Backlog → Ready) 
         → Assigned (Ready → In Progress)
         → DEV Agent adds implementation plan
         → QA Agent adds test cases (In Progress → Testing)
         → Tests Pass (Testing → Done)
```

### 2. Labels Strategy

- `agent:po` - PO agent has processed
- `agent:dev` - DEV agent has processed
- `agent:qa` - QA agent has processed
- `needs-review` - Requires human review
- `priority:high` - High priority items
- `copilot` - Copilot suggestions applied

### 3. Comment Commands

Team members can trigger agents manually:

```
/agent po   # Add user stories
/agent dev  # Add implementation plan
/agent qa   # Add test cases
/review     # Request review
```

## Integration with Pull Requests

Link issues to PRs for full traceability:

```yaml
name: Link PR to Issue

on:
  pull_request:
    types: [opened]

jobs:
  link-issue:
    runs-on: ubuntu-latest
    steps:
      - name: Extract Issue Number
        uses: actions/github-script@v7
        with:
          script: |
            const title = context.payload.pull_request.title;
            const issueMatch = title.match(/#(\d+)/);
            if (issueMatch) {
              const issueNumber = issueMatch[1];
              // Link PR to issue
              await github.rest.issues.createComment({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: issueNumber,
                body: `🔗 Linked to PR #${context.payload.pull_request.number}`
              });
            }
```

## Monitoring and Metrics

Track workflow metrics:

```yaml
name: Weekly Metrics

on:
  schedule:
    - cron: '0 9 * * 1'  # Monday 9 AM

jobs:
  generate-metrics:
    runs-on: ubuntu-latest
    steps:
      - name: Calculate Metrics
        uses: actions/github-script@v7
        with:
          script: |
            // Get issues processed by agents
            const issues = await github.rest.issues.listForRepo({
              owner: context.repo.owner,
              repo: context.repo.repo,
              state: 'all',
              labels: 'agent:po,agent:dev,agent:qa',
              since: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString()
            });
            
            console.log(`Issues processed this week: ${issues.data.length}`);
```

## Example Complete Flow

### Scenario: New Feature Request

1. **User creates issue**: "Add dark mode support"
2. **PO Agent** (automatic):
   - Adds user story: "As a user, I want dark mode..."
   - Adds BDD scenarios
   - Adds acceptance criteria
   - Issue moved to "Ready"
3. **Developer assigns issue to themselves**
4. **DEV Agent** (automatic on assignment):
   - Adds implementation plan
   - Adds unit test structure
   - Adds documentation requirements
   - Issue moved to "In Progress"
5. **Developer implements feature**
   - Uses Copilot with DEV agent context
   - Creates PR linking to issue
6. **QA Agent** (automatic when DEV label added):
   - Adds test cases
   - Adds QA checklist
   - Issue moved to "Testing"
7. **QA team tests**
   - Executes test cases
   - Updates status
8. **Issue closed** → Moved to "Done"

## Troubleshooting

### Issue not moving between columns
- Check project automation rules
- Verify labels are being applied correctly
- Check workflow permissions

### Agents not triggering
- Verify workflow file is in `.github/workflows/`
- Check workflow run logs in Actions tab
- Ensure proper event triggers are configured

### Labels not applying
- Check `issues: write` permission
- Verify GitHub token has proper scopes

## Resources

- [GitHub Projects Documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
- [GitHub CLI Projects Commands](https://cli.github.com/manual/gh_project)

---

For more information, see the main [README.md](../README.md)
