# Code Review Rubric & Evaluation Checklist

Use this rubric to evaluate code changes against requirements and engineering standards before finishing a branch or merging to `main`.

---

## Evaluation Workflow

1. **Obtain the Git Range:**
   ```bash
   BASE_SHA=$(git merge-base origin/main HEAD 2>/dev/null || git merge-base main HEAD)
   git diff --stat "$BASE_SHA"..HEAD
   git diff "$BASE_SHA"..HEAD
   ```

2. **Evaluate against the Criteria below.**

3. **Produce Structured Findings:**
   - **Strengths:** Specific highlights of clean architecture or good patterns.
   - **Critical (Must Fix):** Bugs, data loss risks, broken features, security vulnerabilities.
   - **Important (Should Fix):** Architecture issues, unhandled errors, test coverage gaps.
   - **Minor (Nice to Have):** Code styling, comments, minor polish.

---

## Evaluation Criteria

### 1. Plan & Specification Alignment
- Does the diff fulfill all tasks and goals defined in the plan?
- Are there unintended file edits, accidental deletions, or unnecessary scope creep?
- The spec is a vision document: for behaviors the spec is silent on, judge by what a reasonable user/developer expects. Spec silence is not permission for poor UX or sloppy edge cases.

### 2. Code Quality & Hygiene
- **Separation of concerns:** Modules have single responsibilities and clear interfaces.
- **Error handling:** All async paths and I/O failures are caught or propagated cleanly.
- **Type safety:** Types are accurate; no loose `any` casts or unverified assumptions.
- **Cleanliness:** No leftover `console.log`, debug markers, dead code, or temporary mock data.

### 3. Testing Rigor
- Do tests exercise actual behavior instead of mocking away what needs testing?
- Are negative paths, boundaries, and error conditions tested?
- Does the full test suite pass cleanly with zero failures?

### 4. Production Readiness
- Are backward compatibility and migrations addressed if schemas/APIs changed?
- Are permissions, environment variables, and security checks intact?
- Is documentation (README, guides, comments) updated to reflect any user-visible changes?

---

## Calibration Guidelines

- **Critical:** Direct breakage, build failures, data corruption, or security risks. Fix immediately via TDD before completing branch.
- **Important:** Architectural flaws, missing tests for critical paths, or missing error handling. Fix before completing branch.
- **Minor:** Style suggestions or small non-blocking improvements. Note in summary for user.
