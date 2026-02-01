# GitHub Copilot Integration Guide

Blueprint AI is designed to work seamlessly with GitHub Copilot, providing context-aware assistance throughout the development workflow.

## Overview

The multi-agent system creates structured content that GitHub Copilot uses as context to provide better suggestions:

- **PO Agent** → Provides business context for Copilot
- **DEV Agent** → Provides technical specifications for code generation
- **QA Agent** → Provides test scenarios for test generation

## How It Works

### 1. Context Enhancement

Each agent adds structured information to issues that Copilot can use:

```markdown
## User Story
As a user, I want to login with email...

## BDD Scenarios
Given I am on the login page
When I enter valid credentials
Then I should be logged in
```

When you open a file in your IDE with Copilot enabled, this context helps Copilot understand:
- What feature you're building
- Expected behavior (BDD scenarios)
- Acceptance criteria
- Test cases needed

### 2. Copilot-Aware Comments

Blueprint AI adds comments that trigger Copilot suggestions:

```javascript
// Implement user login according to BDD scenario in Issue #123
// Given: User is on login page
// When: User enters valid credentials  
// Then: User should be authenticated and redirected
function handleLogin(email, password) {
  // Copilot will suggest implementation based on the context
}
```

### 3. Test Generation

The QA Agent provides test case structure that Copilot uses:

```javascript
// Test cases from QA Agent in Issue #123
describe('User Login', () => {
  // Test Case 1: Happy Path
  test('should login with valid credentials', () => {
    // Copilot generates test based on QA scenarios
  });
  
  // Test Case 2: Error Handling
  test('should show error with invalid credentials', () => {
    // Copilot generates negative test cases
  });
});
```

## Best Practices

### 1. Link Issues to Code

Reference issues in commit messages and PR descriptions:

```bash
git commit -m "feat: implement user login (closes #123)"
```

This helps Copilot understand the context when reviewing code.

### 2. Use Agent Output in Code Comments

Copy relevant sections from agent output into code:

```python
# User Story: As a user, I want to login with email/password
# Acceptance Criteria:
# - AC1: Valid credentials should authenticate user
# - AC2: Invalid credentials should show error message
# - AC3: Session should be created on successful login

def login_user(email: str, password: str) -> User:
    """Login user with email and password."""
    # Copilot will suggest implementation based on AC
```

### 3. Generate Documentation

Use DEV Agent templates with Copilot:

```markdown
## Feature: User Authentication

<!-- Copilot: Generate overview based on Issue #123 -->

### API Endpoints

<!-- Copilot: List endpoints based on implementation plan -->

### Usage Examples

<!-- Copilot: Generate examples based on BDD scenarios -->
```

### 4. Create Tests from QA Templates

```typescript
// Reference: QA Test Cases from Issue #123

describe('UserAuthentication', () => {
  // @copilot: Generate tests based on test case 1-5 in Issue #123
  
  describe('Happy Path Scenarios', () => {
    // Copilot will generate based on QA agent scenarios
  });
  
  describe('Edge Cases', () => {
    // Copilot will generate based on QA agent edge cases
  });
});
```

## Workflow Integration

### Complete Copilot-Enhanced Workflow

1. **Issue Creation**
   ```
   Create issue: "Add user authentication"
   ```

2. **PO Agent Adds Context**
   ```markdown
   User Story: As a user, I want to login...
   BDD Scenarios: Given/When/Then format
   Acceptance Criteria: AC1, AC2, AC3...
   ```

3. **Start Implementation**
   - Open your IDE with Copilot
   - Reference the issue number in comments
   - Copilot uses issue context for suggestions

4. **DEV Agent Adds Technical Details**
   ```markdown
   Implementation Plan:
   - Create LoginService class
   - Implement authentication logic
   - Add session management
   
   Unit Tests:
   - Test valid credentials
   - Test invalid credentials
   - Test session creation
   ```

5. **Use Copilot for Implementation**
   ```typescript
   // Implement LoginService from Issue #123
   // @copilot: Follow implementation plan from DEV agent
   
   class LoginService {
     // Copilot suggests methods based on DEV agent plan
   }
   ```

6. **QA Agent Adds Test Scenarios**
   ```markdown
   Test Case 1: Valid login
   Test Case 2: Invalid password
   Test Case 3: Account locked
   Test Case 4: Session expiry
   ```

7. **Generate Tests with Copilot**
   ```typescript
   // @copilot: Generate tests from QA agent cases in Issue #123
   
   describe('LoginService', () => {
     // Copilot generates complete test suite
   });
   ```

## Advanced Techniques

### 1. Copilot Chat Integration

In VS Code with Copilot Chat:

```
You: @workspace Implement the login feature from Issue #123
Copilot: [Analyzes issue and suggests implementation]

You: Generate tests based on QA scenarios in Issue #123
Copilot: [Generates tests matching QA agent output]

You: Add documentation for the authentication API
Copilot: [Creates docs based on DEV agent templates]
```

### 2. Code Review with Context

```typescript
// PR Description: Implements Issue #123 - User Authentication
// 
// This PR addresses:
// - AC1: Valid credentials authentication ✅
// - AC2: Invalid credentials error handling ✅
// - AC3: Session creation ✅
//
// Copilot will understand the acceptance criteria when reviewing
```

### 3. Refactoring Guidance

```javascript
// Refactor: Improve authentication based on Issue #123 feedback
// Original implementation doesn't handle edge case from QA agent
// @copilot: Suggest improvements based on QA test case 5

function improvedLogin(credentials) {
  // Copilot suggests enhanced implementation
}
```

### 4. Multi-File Context

Blueprint AI creates comprehensive context across multiple areas:

**Issue #123** (PO Agent)
```markdown
User Story: Login feature
BDD Scenarios: Given/When/Then
```

**src/auth.ts** (Your code)
```typescript
// Implements Issue #123
class AuthService {
  // Copilot has context from issue
}
```

**tests/auth.test.ts** (Your tests)
```typescript
// Tests for Issue #123
describe('AuthService', () => {
  // Copilot generates tests matching issue scenarios
});
```

**docs/api.md** (Your docs)
```markdown
# Authentication API

<!-- Based on Issue #123 DEV agent plan -->
<!-- Copilot generates docs with full context -->
```

## Copilot Suggestions by Agent

### PO Agent → Copilot Business Logic
```python
# User story context from PO agent helps Copilot understand:
# - User personas
# - Business requirements
# - Expected outcomes

def process_order(user, items):
    """Process order according to PO requirements in Issue #123."""
    # Copilot suggests business logic matching user stories
```

### DEV Agent → Copilot Architecture
```java
// DEV agent technical design helps Copilot understand:
// - Architecture patterns
// - Component structure
// - Integration points

// @copilot: Follow architecture from Issue #123 DEV agent
public class OrderService {
    // Copilot suggests methods matching technical design
}
```

### QA Agent → Copilot Test Coverage
```ruby
# QA agent test cases help Copilot understand:
# - Test scenarios
# - Edge cases
# - Expected behavior

# @copilot: Generate tests from Issue #123 QA agent
describe OrderService do
  # Copilot generates comprehensive test coverage
end
```

## Measuring Effectiveness

Track how Blueprint AI + Copilot improves your workflow:

### Before Blueprint AI
- Manual context switching to understand requirements
- Generic Copilot suggestions
- Incomplete test coverage

### After Blueprint AI
- Structured context always available
- Context-aware Copilot suggestions
- Comprehensive test generation

## Tips for Maximum Benefit

1. **Always reference issue numbers** in commits and code
2. **Keep issue content updated** as requirements change
3. **Use Copilot Chat** with @workspace for issue context
4. **Review agent suggestions** before accepting Copilot code
5. **Iterate templates** to match your team's patterns

## Example: Full Feature with Copilot

See the complete workflow:

```bash
# 1. Create issue
gh issue create --title "Add payment processing" --body "User needs to pay for orders"

# 2. Agents add context automatically
# - PO: User stories, BDD scenarios
# - DEV: Technical implementation plan
# - QA: Test cases and scenarios

# 3. Start coding with enhanced Copilot
# Open IDE, reference issue #456
# Copilot now has full context

# 4. Commit with context
git commit -m "feat: implement payment processing (#456)

Implements:
- AC1: Accept credit card payments
- AC2: Handle payment failures
- AC3: Send confirmation emails

Tests generated based on QA agent scenarios."

# 5. Create PR with context
gh pr create --title "Payment processing (#456)" \
  --body "Resolves #456. All acceptance criteria met. Tests pass."
```

## Troubleshooting

### Copilot not using issue context
- Ensure issue is open and accessible
- Reference issue number in comments
- Use @workspace in Copilot Chat

### Suggestions not matching requirements
- Review agent output for clarity
- Update templates to be more specific
- Add more detail in acceptance criteria

### Tests not comprehensive
- Review QA agent test cases
- Add more edge cases to templates
- Use explicit test case numbers in comments

## Resources

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Copilot Best Practices](https://github.blog/2023-06-20-how-to-write-better-prompts-for-github-copilot/)
- [Blueprint AI Templates](../templates/)

---

Maximize your development efficiency with Blueprint AI + Copilot! 🚀
