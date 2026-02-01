# Quick Start Guide

Get Blueprint AI up and running in your repository in 5 minutes!

## Prerequisites

- GitHub repository
- GitHub Actions enabled
- Write access to the repository

## Step 1: Copy the Workflow File

Create a new file `.github/workflows/blueprint-ai.yml` in your repository:

```yaml
name: Blueprint AI

on:
  issues:
    types: [opened]

permissions:
  issues: write
  contents: read

jobs:
  multi-agent-workflow:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Run Blueprint AI
        uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'PO'
          issue-number: ${{ github.event.issue.number }}
```

## Step 2: Test the Workflow

1. Go to your repository
2. Create a new issue with title: "Add new feature X"
3. Wait a few seconds for the workflow to run
4. Check the issue - it should now have:
   - User story structure
   - BDD scenarios
   - Acceptance criteria

## Step 3: Enable All Agents (Optional)

To run all agents automatically, update your workflow:

```yaml
name: Blueprint AI - All Agents

on:
  issues:
    types: [opened, labeled]
  issue_comment:
    types: [created]

permissions:
  issues: write
  contents: read

jobs:
  po-agent:
    if: github.event_name == 'issues' && github.event.action == 'opened'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'PO'
          issue-number: ${{ github.event.issue.number }}

  dev-agent:
    needs: po-agent
    if: contains(github.event.issue.labels.*.name, 'agent:po')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'DEV'
          issue-number: ${{ github.event.issue.number }}

  qa-agent:
    needs: dev-agent
    if: contains(github.event.issue.labels.*.name, 'agent:dev')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'QA'
          issue-number: ${{ github.event.issue.number }}
```

## Step 4: Manual Triggers (Optional)

Add manual triggers via comments:

```yaml
name: Manual Agent Trigger

on:
  issue_comment:
    types: [created]

permissions:
  issues: write
  contents: read

jobs:
  manual-trigger:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: PO Agent
        if: contains(github.event.comment.body, '/agent po')
        uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'PO'
          issue-number: ${{ github.event.issue.number }}
      
      - name: DEV Agent
        if: contains(github.event.comment.body, '/agent dev')
        uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'DEV'
          issue-number: ${{ github.event.issue.number }}
      
      - name: QA Agent
        if: contains(github.event.comment.body, '/agent qa')
        uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'QA'
          issue-number: ${{ github.event.issue.number }}
```

Now comment `/agent dev` on any issue to trigger the DEV agent!

## Step 5: Customize Templates (Optional)

Fork this repository and modify the templates:

1. Edit `/templates/po-template.md` for PO agent output
2. Edit `/templates/dev-template.md` for DEV agent output
3. Edit `/templates/qa-template.md` for QA agent output

Then use your fork in the workflow:

```yaml
- uses: YOUR_USERNAME/blueprint-ai@main
```

## Common Use Cases

### Feature Development
```
1. Create issue: "User authentication"
2. PO agent adds user stories → Label: agent:po
3. Assign to developer
4. Comment: /agent dev → Adds implementation plan
5. Comment: /agent qa → Adds test cases
6. Developer implements following the plan
```

### Bug Fixes
```
1. Create issue: "Login button not working"
2. Comment: /agent qa → Adds test reproduction steps
3. Comment: /agent dev → Adds fix implementation plan
4. Developer fixes and adds tests
```

### Documentation
```
1. Create issue: "Update API docs"
2. Comment: /agent dev → Adds documentation structure
3. Use GitHub Copilot to fill content
```

## Troubleshooting

### Workflow not running
- Check Actions tab for error messages
- Verify workflow file is in `.github/workflows/`
- Check that Actions are enabled in repository settings

### Agent not updating issue
- Check workflow logs in Actions tab
- Verify `github-token` has `issues: write` permission
- Ensure issue number is being passed correctly

### Templates not loading
- Verify template files exist in `/templates/`
- Check file permissions (should be readable)
- Review orchestrator.sh for correct paths

## Next Steps

- 📚 Read the full [README](../README.md)
- 🔧 Learn about [Project Integration](project-integration.md)
- 💡 Check out [Examples](../examples/README.md)
- 🤝 See [Contributing Guide](../CONTRIBUTING.md)

## Need Help?

- 📝 [Create an issue](https://github.com/celfons/blueprint-ai/issues)
- 💬 [Start a discussion](https://github.com/celfons/blueprint-ai/discussions)

---

Happy automating! 🚀
