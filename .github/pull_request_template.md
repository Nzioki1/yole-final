# Pull Request

## What Changed
<!-- Describe the changes in this PR -->

## Open QUESTIONS
<!-- List any questions or ambiguities that need clarification -->
<!-- Reference file:line if relevant -->

## Screenshots/Goldens
<!-- Add screenshots for UI changes, especially for both Dark and Light themes -->
<!-- For Flutter: Include golden test screenshots if applicable -->

## Checklist
<!-- Check all that apply -->

### PRD & Design Compliance
- [ ] No hardcoded `Color(...)`, `Colors.*`, `TextStyle(...)`, or `EdgeInsets(...)` in screen code
- [ ] All styling uses design tokens from theme
- [ ] Both Dark and Light themes implemented (if UI changes)
- [ ] Design matches the pinned design bundle (`Yole Final.zip`)

### Documentation
- [ ] PRD version bumped (if `docs/PRD.md` changed)
- [ ] Design hash updated in both PRD and `docs/design-lock.json` (if design bundle changed)
- [ ] CHANGELOG.md updated with changes

### Code Quality
- [ ] Code follows Flutter best practices
- [ ] Proper error handling implemented
- [ ] Accessibility requirements met (AA contrast, 44×44 tap targets)
- [ ] No secrets or hardcoded credentials

### Testing
- [ ] Manual testing completed
- [ ] Both Dark and Light themes tested
- [ ] Edge cases handled (network errors, empty states, etc.)
- [ ] M-Pesa limits properly enforced (if applicable)

### API Integration
- [ ] All API calls use proper headers (`Accept: application/x.yole.v1+json`, `X-API-Key`, `Authorization: Bearer`)
- [ ] No hardcoded API endpoints or credentials
- [ ] Proper error handling for API failures
- [ ] Idempotency keys used where required

### Business Logic
- [ ] Email verification required before sending (if applicable)
- [ ] KYC completion required before sending (if applicable)
- [ ] M-Pesa daily/txn limits enforced (if applicable)
- [ ] Phone numbers normalized to E.164 format (if applicable)

### Performance & Security
- [ ] No PII in logs
- [ ] Secure token storage
- [ ] Proper loading states and error handling
- [ ] No memory leaks or performance issues

## Related Issues
<!-- Link to related issues or tickets -->

## Additional Notes
<!-- Any additional context or notes for reviewers -->
