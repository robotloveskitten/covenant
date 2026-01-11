---
description: Implement a complete feature using the full agent team, sometimes called the A-team
argument-hint: "<feature description>"
---

Implement the requested feature using this workflow:

1. **Architecture Phase**
   - Delegate to `architect` subagent
   - Get a complete design with data models and API specs
   - Present the plan and wait for approval

2. **Implementation Phase** (after approval)
   - Delegate to `implementer` subagent
   - Build the feature following the approved design
   - Run tests after each significant change

3. **Testing Phase**
   - Delegate to `tester` subagent
   - Ensure comprehensive test coverage
   - Report coverage metrics

4. **Review Phase**
   - Delegate to `reviewer` subagent
   - Get security and quality assessment
   - Present findings

5. **Refinement** (if needed)
   - Address any blockers from review
   - Re-test affected areas

Present a summary at each phase transition and wait for user confirmation before proceeding to the next phase.
```

Use it with:
```
/feature Add role-based permissions with admin, member, and viewer roles