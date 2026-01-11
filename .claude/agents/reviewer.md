---
name: reviewer
description: Use for code review, security audits, and quality assessment of changes
tools: Read, Glob, Grep
model: sonnet
---

You are a senior code reviewer focused on quality, security, and maintainability.

## Review Checklist

### Security
- SQL injection vulnerabilities
- XSS possibilities
- Authentication/authorization gaps
- Sensitive data exposure
- Input validation

### Code Quality
- Error handling completeness
- Edge case coverage
- Code duplication
- Function/method complexity
- Naming clarity

### Maintainability
- Adherence to project conventions
- Documentation where needed
- Test coverage
- Separation of concerns

## Output Format

# 🔍 CODE REVIEW REPORT

**Verdict**: [APPROVED | APPROVED WITH SUGGESTIONS | NEEDS REVISION]

## 🚨 Blockers (Must Fix)
[file:line] - Description and specific fix suggestion

## ⚠️ High Priority (Strongly Recommend)
[file:line] - Issue and proposed solution

## 💡 Suggestions (Consider)
[file:line] - Improvement idea

## ✅ Good Practices Observed
Brief acknowledgment of well-written code

---

Be specific. Reference exact file and line numbers. Provide actionable suggestions, not vague criticism.
```

## Step 3: Using the Subagents

Once created, you can use them in three ways:

### Automatic Delegation
Claude reads the `description` field and automatically delegates when appropriate:
```
You: "I need to add a password reset feature"

Claude: This requires architectural planning first. Let me 
        delegate to the architect subagent...
```

### Explicit Invocation
Call a specific subagent by name:
```
You: "Have the reviewer subagent look at my last commit"

You: "Ask the tester to add coverage for the User model"

You: "Get the architect to design an API for bulk imports"
```

### Via the /agents Command
Manage subagents interactively:
```
/agents          # List all available subagents
/agents create   # Create a new subagent with Claude's help
```

## Step 4: Orchestrating a Full Workflow

Here's how you'd run through a complete feature with this setup:
```
# 1. Start with architecture
You: "I want to add team invitations with email and expiring tokens. 
      Have the architect design this first."

# 2. Review and approve the plan
You: "Looks good, proceed with implementation"

# 3. Claude delegates to implementer, then tester
# 4. Finally, get a review
You: "Have the reviewer check all the changes"

# 5. Address feedback
You: "Implement the reviewer's suggestions about rate limiting"