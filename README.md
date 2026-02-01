# 🤖 Blueprint AI - Multi-Agent GitHub Workflow

[![GitHub Actions](https://img.shields.io/badge/GitHub-Actions-blue?logo=github-actions)](https://github.com/features/actions)
[![GitHub Copilot](https://img.shields.io/badge/GitHub-Copilot-purple?logo=github)](https://github.com/features/copilot)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A powerful GitHub Actions blueprint that orchestrates multi-agent workflows (PO, DEV, QA) to automate and enhance your development process with GitHub Projects and Copilot integration.

## 🎯 Overview

Blueprint AI provides an intelligent multi-agent system that automatically processes GitHub issues through three specialized agents:

- **🎯 PO Agent** (Product Owner): Creates user stories with BDD scenarios and acceptance criteria
- **💻 DEV Agent** (Developer): Generates implementation plans, unit test templates, and documentation structure
- **🧪 QA Agent** (Quality Assurance): Adds comprehensive test cases and QA plans

All agents work seamlessly with GitHub Projects and integrate with GitHub Copilot for enhanced intelligent assistance.

## ✨ Features

- 🔄 **Automated Workflow Orchestration**: Sequential execution of PO → DEV → QA agents
- 📋 **BDD User Stories**: Automatic generation of Behavior-Driven Development scenarios
- ✅ **Acceptance Criteria**: Clear, measurable success criteria for each feature
- 🧪 **Test Planning**: Comprehensive test cases and QA plans
- 📚 **Documentation Templates**: Structured documentation for implementation
- 💡 **Copilot Integration**: GitHub Copilot suggestions for enhanced development
- 🏷️ **Automatic Labeling**: Smart labeling of issues based on agent processing
- 🔀 **Manual Triggers**: Command-based agent execution via issue comments
- 📊 **Project Board Integration**: Works seamlessly with GitHub Projects

## 🚀 Quick Start

### As a GitHub Action (Marketplace)

1. Add the workflow to your repository:

```yaml
name: Blueprint AI Workflow

on:
  issues:
    types: [opened, labeled]

jobs:
  process-issue:
    runs-on: ubuntu-latest
    steps:
      - uses: celfons/blueprint-ai@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          agent-role: 'PO'
          issue-number: ${{ github.event.issue.number }}
```

### Local Setup

1. Clone this repository:
```bash
git clone https://github.com/celfons/blueprint-ai.git
cd blueprint-ai
```

2. Copy the workflow file to your project:
```bash
cp .github/workflows/multi-agent-orchestrator.yml your-project/.github/workflows/
```

3. Commit and push to enable the workflow.

## 📖 Usage

### Automatic Mode

The workflow automatically triggers when:
- A new issue is opened
- An issue receives specific labels
- An issue is added to a GitHub Project

### Manual Mode

Trigger specific agents by commenting on an issue:

```
/agent po   # Trigger PO Agent
/agent dev  # Trigger DEV Agent
/agent qa   # Trigger QA Agent
```

Or use the workflow dispatch:

```bash
gh workflow run multi-agent-orchestrator.yml \
  -f issue_number=123 \
  -f agent=ALL
```

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    GitHub Issue/Project                  │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│            Multi-Agent Orchestrator Workflow             │
└─────────────────────────────────────────────────────────┘
                           │
         ┌─────────────────┼─────────────────┐
         ▼                 ▼                 ▼
    ┌────────┐        ┌────────┐        ┌────────┐
    │   PO   │   →    │  DEV   │   →    │   QA   │
    │ Agent  │        │ Agent  │        │ Agent  │
    └────────┘        └────────┘        └────────┘
         │                 │                 │
         └─────────────────┼─────────────────┘
                           ▼
              ┌──────────────────────────┐
              │   Updated Issue with:    │
              │  - User Stories (BDD)    │
              │  - Implementation Plan   │
              │  - Test Cases            │
              │  - Documentation         │
              └──────────────────────────┘
                           │
                           ▼
              ┌──────────────────────────┐
              │   GitHub Copilot         │
              │   Enhancement Suggestions│
              └──────────────────────────┘
```

## 🎭 Agent Roles

### 🎯 PO Agent (Product Owner)

**Responsibilities:**
- Create user stories with "As a..., I want..., So that..." format
- Define BDD scenarios using Gherkin syntax
- Establish clear acceptance criteria
- Document business value and dependencies

**Output Template:**
- User Story structure
- 3+ BDD scenarios (happy path, alternative, edge cases)
- Measurable acceptance criteria
- Definition of Ready checklist

### 💻 DEV Agent (Developer)

**Responsibilities:**
- Generate technical implementation plans
- Create unit test templates
- Structure documentation requirements
- Define code quality checklist

**Output Template:**
- Technical design overview
- Implementation checklist
- Unit test structure with examples
- Documentation templates (JSDoc, README updates)
- Definition of Done

### 🧪 QA Agent (Quality Assurance)

**Responsibilities:**
- Create comprehensive test cases
- Define test coverage matrix
- Establish QA sign-off criteria
- Document bug tracking templates

**Output Template:**
- Test cases for multiple scenarios
- Test types checklist (functional, integration, performance, security)
- Bug report template
- Test metrics and coverage matrix

## ⚙️ Configuration

### Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `github-token` | GitHub token with issues write permission | Yes | - |
| `agent-role` | Agent to execute: PO, DEV, or QA | Yes | - |
| `issue-number` | Issue number to process | No | Current issue |
| `copilot-enabled` | Enable Copilot integration | No | `true` |

### Permissions Required

```yaml
permissions:
  issues: write
  contents: read
  pull-requests: write
```

## 🔧 Customization

### Modifying Templates

Templates are located in `/templates/`:
- `po-template.md` - Product Owner template
- `dev-template.md` - Developer template
- `qa-template.md` - QA template

Edit these files to customize the output for your team's needs.

### Adding Custom Agents

1. Create a new template in `/templates/`
2. Add agent logic to `/scripts/orchestrator.sh`
3. Update workflow file with new agent job

## 🤝 Integration with GitHub Projects

The workflow **automatically integrates** with GitHub Projects:

### Automatic Setup

1. **Set Project URL**: Add a repository variable `PROJECT_URL` with your project URL:
   ```
   https://github.com/users/YOUR_USERNAME/projects/PROJECT_NUMBER
   ```
   or
   ```
   https://github.com/orgs/YOUR_ORG/projects/PROJECT_NUMBER
   ```

2. **Issue Lifecycle**: Issues are automatically:
   - Added to the project when created
   - Labeled as agents process them (`agent:po`, `agent:dev`, `agent:qa`)
   - Moved through columns based on labels

3. **Project Board Columns** (recommended):
   - **📋 Backlog** - New issues
   - **✅ Ready** - After PO Agent (has `agent:po` label)
   - **💻 In Progress** - After DEV Agent (has `agent:dev` label)
   - **🧪 Testing** - After QA Agent (has `agent:qa` label)
   - **🎉 Done** - Closed issues

### Built-in Workflow Features

- **Automatic Project Addition**: New issues are added to the project board via `actions/add-to-project`
- **Status Comments**: Each agent posts a comment indicating project status changes
- **Label-Based Automation**: Use GitHub Projects built-in automation to move cards based on labels
- **Separate Integration Workflow**: The `project-integration.yml` workflow handles project-specific updates

### Setup Instructions

1. Create a GitHub Project (Projects tab → New project)
2. Add the project URL to repository variables:
   - Go to Settings → Secrets and variables → Actions → Variables
   - Create `PROJECT_URL` with your project URL
3. Configure project automation rules (optional but recommended):
   - When label `agent:po` is added → Move to "Ready"
   - When label `agent:dev` is added → Move to "In Progress"
   - When label `agent:qa` is added → Move to "Testing"
   - When issue is closed → Move to "Done"

**Note**: If `PROJECT_URL` is not set, the workflow will continue to work but won't add issues to projects automatically.

## 💡 Best Practices

1. **Sequential Processing**: Let agents run in sequence (PO → DEV → QA) for best results
2. **Clear Issue Titles**: Use descriptive titles for better agent understanding
3. **Review Agent Output**: Always review and refine agent-generated content
4. **Copilot Integration**: Enable Copilot for enhanced suggestions
5. **Template Customization**: Adapt templates to your team's workflow

## 📊 Example Workflow

1. **Developer creates issue**: "Add user authentication feature"
2. **PO Agent runs**: Adds user story, BDD scenarios, acceptance criteria
3. **DEV Agent runs**: Adds implementation plan, test templates, documentation structure
4. **QA Agent runs**: Adds test cases, QA checklist
5. **Copilot comments**: Provides intelligent suggestions at each stage
6. **Team refines**: Review and adjust the agent-generated content
7. **Development begins**: With comprehensive documentation in place

## 🛠️ Troubleshooting

### Agents not triggering
- Check workflow permissions in repository settings
- Verify GitHub token has `issues: write` permission
- Ensure workflow file is in `.github/workflows/`

### Templates not applying
- Check template file paths in `orchestrator.sh`
- Verify templates are valid Markdown
- Check GitHub CLI (`gh`) installation

### Copilot suggestions not appearing
- Ensure `copilot-enabled` is set to `true`
- Verify repository has Copilot access
- Check workflow logs for errors

## 🤖 Copilot Enhancement

This blueprint is designed to work seamlessly with GitHub Copilot:

- **Context-Aware Suggestions**: Each agent provides context for Copilot
- **Template Generation**: Use Copilot to fill in template sections
- **Code Generation**: DEV agent templates work with Copilot for test/code generation
- **Intelligent Comments**: Copilot analyzes agent output and suggests improvements

## 🌟 Use Cases

- **Feature Development**: Streamline feature planning and implementation
- **Bug Fixes**: Structure bug analysis and testing
- **Technical Debt**: Plan refactoring with clear acceptance criteria
- **Documentation**: Ensure comprehensive documentation for all features
- **Team Onboarding**: Provide consistent structure for new team members

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details

## 🙋 Support

- **Issues**: [GitHub Issues](https://github.com/celfons/blueprint-ai/issues)
- **Discussions**: [GitHub Discussions](https://github.com/celfons/blueprint-ai/discussions)

## 🔄 Changelog

### v1.0.0
- Initial release
- PO, DEV, and QA agents
- GitHub Copilot integration
- Template system
- Manual and automatic triggers

---

**Built with ❤️ for better software development workflows**