# Example: Using Blueprint AI in Your Repository

This directory contains example configurations for using Blueprint AI in your repository.

## Simple Setup

### 1. Basic Workflow (Auto-trigger on new issues)

Create `.github/workflows/blueprint-ai.yml`:

```yaml
name: Blueprint AI

on:
  issues:
    types: [opened]

permissions:
  issues: write
  contents: read

jobs:
  run-agents:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run All Agents
        uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'ALL'
          issue-number: ${{ github.event.issue.number }}
          copilot-enabled: 'true'
```

### 2. Manual Trigger Workflow

Create `.github/workflows/manual-agent.yml`:

```yaml
name: Manual Agent Trigger

on:
  issue_comment:
    types: [created]

permissions:
  issues: write
  contents: read

jobs:
  po-agent:
    if: contains(github.event.comment.body, '/agent po')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'PO'
          issue-number: ${{ github.event.issue.number }}

  dev-agent:
    if: contains(github.event.comment.body, '/agent dev')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'DEV'
          issue-number: ${{ github.event.issue.number }}

  qa-agent:
    if: contains(github.event.comment.body, '/agent qa')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'QA'
          issue-number: ${{ github.event.issue.number }}
```

### 3. Label-Based Trigger

Create `.github/workflows/label-trigger.yml`:

```yaml
name: Label-Based Agent

on:
  issues:
    types: [labeled]

permissions:
  issues: write
  contents: read

jobs:
  trigger-agents:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: PO Agent
        if: github.event.label.name == 'needs-story'
        uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'PO'
          issue-number: ${{ github.event.issue.number }}
      
      - name: DEV Agent
        if: github.event.label.name == 'needs-implementation'
        uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'DEV'
          issue-number: ${{ github.event.issue.number }}
      
      - name: QA Agent
        if: github.event.label.name == 'needs-testing'
        uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'QA'
          issue-number: ${{ github.event.issue.number }}
```

## Usage Tips

1. **Start Simple**: Begin with the basic auto-trigger workflow
2. **Customize Templates**: Modify templates in `/templates/` to match your needs
3. **Use Labels**: Create labels like `agent:po`, `agent:dev`, `agent:qa` for tracking
4. **Manual Control**: Use comment commands for fine-grained control
5. **Combine Approaches**: Mix automatic and manual triggers

## Testing

To test the workflow:

1. Create a new issue in your repository
2. The PO agent should automatically add content
3. Try manual triggers: comment `/agent dev` on the issue
4. Check the Actions tab for workflow execution logs
