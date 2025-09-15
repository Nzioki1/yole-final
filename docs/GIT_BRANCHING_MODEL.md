# Git Branching Model - Yole Flutter Project
**Date:** 2025-01-27  
**DevOps Lead:** AI DevOps Lead  
**Project:** Yole MVP Flutter App  
**Status:** **ENFORCED FOR ALL DEVELOPMENT**  

## Executive Summary

This document defines the optimal Git branching model for the Yole Flutter project, ensuring code quality, release stability, and efficient collaboration. The model enforces strict protection on main branch and implements comprehensive CI/CD checks.

**Enforcement:** This branching model is mandatory for all development work. No exceptions.

---

## 🌳 **BRANCHING RULES**

### **Branch Hierarchy**

```
main (production)
├── develop (staging)
├── feat/auth (feature branch)
├── feat/send-flow (feature branch)
├── feat/kyc (feature branch)
├── feat/components (feature branch)
├── feat/design-tokens (feature branch)
├── hotfix/critical-bug (hotfix branch)
└── release/v1.0.0 (release branch)
```

### **Branch Definitions**

#### **🔴 main (Production)**
- **Purpose:** Production-ready code only
- **Protection:** Strict protection with required CI checks
- **Merges:** Only from `develop` or `hotfix/*` branches
- **Deployment:** Automatic deployment to production
- **Requirements:** All DoD criteria must be met

#### **🟡 develop (Staging)**
- **Purpose:** Integration branch for features
- **Protection:** Moderate protection with basic CI checks
- **Merges:** From `feat/*` branches only
- **Deployment:** Automatic deployment to staging environment
- **Requirements:** Basic quality checks must pass

#### **🟢 feat/* (Feature Branches)**
- **Purpose:** Individual feature development
- **Naming:** `feat/<area>` (e.g., `feat/auth`, `feat/send-flow`)
- **Protection:** No protection (developer responsibility)
- **Merges:** Into `develop` only
- **Requirements:** Must be up-to-date with `develop`

#### **🔵 hotfix/* (Hotfix Branches)**
- **Purpose:** Critical production fixes
- **Naming:** `hotfix/<issue-description>` (e.g., `hotfix/payment-crash`)
- **Protection:** Same as main branch
- **Merges:** Into both `main` and `develop`
- **Requirements:** Emergency fixes only

#### **🟣 release/* (Release Branches)**
- **Purpose:** Release preparation and final testing
- **Naming:** `release/v<version>` (e.g., `release/v1.0.0`)
- **Protection:** Same as main branch
- **Merges:** Into `main` and `develop`
- **Requirements:** Full DoD compliance

---

## 📝 **COMMIT NAMING CONVENTION**

### **Commit Message Format**
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### **Type Categories**

#### **✅ Feature Development**
- `feat(auth): add biometric login support`
- `feat(send): implement multi-currency selection`
- `feat(kyc): add ID document capture`
- `feat(components): create AmountDisplay widget`
- `feat(design-tokens): add chart color palette`

#### **🐛 Bug Fixes**
- `fix(auth): resolve login validation error`
- `fix(send): fix currency conversion calculation`
- `fix(kyc): handle camera permission denial`
- `fix(components): fix StatusChip color contrast`
- `fix(design-tokens): correct spacing token values`

#### **🎨 UI/UX Improvements**
- `style(components): improve button hover states`
- `style(theme): enhance dark mode colors`
- `style(animations): smooth sparkle effect transitions`
- `style(layout): optimize responsive design`

#### **♻️ Refactoring**
- `refactor(auth): extract authentication logic`
- `refactor(components): standardize widget structure`
- `refactor(api): improve error handling`
- `refactor(theme): consolidate design tokens`

#### **🧪 Testing**
- `test(auth): add login flow integration tests`
- `test(components): add AmountDisplay golden tests`
- `test(kyc): add camera capture unit tests`
- `test(api): add network error handling tests`

#### **📚 Documentation**
- `docs(api): update API integration guide`
- `docs(components): add widget usage examples`
- `docs(theme): document design token system`
- `docs(deployment): update release process`

#### **🔧 Configuration**
- `chore(deps): update Flutter SDK to 3.9.0`
- `chore(ci): add golden test automation`
- `chore(build): configure release signing`
- `chore(env): update environment variables`

#### **🚀 Performance**
- `perf(animations): optimize sparkle effect performance`
- `perf(api): implement request caching`
- `perf(components): reduce widget rebuilds`
- `perf(images): optimize image loading`

#### **🔒 Security**
- `security(auth): strengthen token validation`
- `security(api): add request signing`
- `security(storage): encrypt sensitive data`
- `security(secrets): remove hardcoded values`

### **Scope Guidelines**

#### **Feature Areas (MVP Scope)**
- `auth` - Authentication and user management
- `kyc` - Know Your Customer flow
- `send` - Send money flow and transactions
- `components` - Reusable UI components
- `design-tokens` - Theme and design system
- `api` - API integration and data layer
- `navigation` - Routing and navigation
- `theme` - Theme system and styling
- `animations` - Animations and interactions
- `security` - Security and data protection

#### **Technical Areas**
- `ci` - Continuous integration
- `build` - Build configuration
- `deps` - Dependencies
- `docs` - Documentation
- `test` - Testing infrastructure
- `perf` - Performance optimization

### **Description Guidelines**
- **Use imperative mood:** "add feature" not "added feature"
- **Keep under 50 characters:** Concise and clear
- **No period at end:** Clean, simple format
- **Be specific:** Clear what the commit does

### **Body Guidelines (Optional)**
- **Explain why:** Reason for the change
- **Explain what:** What the change does
- **Reference issues:** Link to related tickets
- **Breaking changes:** Document any breaking changes

### **Footer Guidelines (Optional)**
- **Breaking changes:** `BREAKING CHANGE: description`
- **Issue references:** `Fixes #123`, `Closes #456`
- **Co-authors:** `Co-authored-by: Name <email>`

---

## 🔄 **PR WORKFLOW (Review + Checks)**

### **Pull Request Process**

#### **1. Pre-PR Preparation**
```bash
# Ensure feature branch is up-to-date
git checkout develop
git pull origin develop
git checkout feat/your-feature
git rebase develop

# Run local checks
flutter analyze
flutter test
flutter test integration_test/
dart format .

# Commit any formatting changes
git add .
git commit -m "style: apply dart format"
```

#### **2. Create Pull Request**
- **Title:** Follow commit naming convention
- **Description:** Use PR template (see below)
- **Base Branch:** `develop` (for features) or `main` (for hotfixes)
- **Reviewers:** Assign appropriate team members
- **Labels:** Add relevant labels (feature, bug, enhancement, etc.)

#### **3. PR Template**
```markdown
## Description
Brief description of changes and motivation.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## MVP Scope Compliance
- [ ] Feature aligns with locked MVP scope
- [ ] No scope creep beyond MVP requirements
- [ ] All MVP criteria met

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Golden tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## DoD Compliance
- [ ] All DoD criteria met
- [ ] Code review completed
- [ ] Performance requirements met
- [ ] Security requirements met
- [ ] Accessibility requirements met

## Screenshots (if applicable)
Add screenshots for UI changes.

## Checklist
- [ ] Code follows project conventions
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No hardcoded values
- [ ] Design tokens used properly
```

### **Required CI Checks**

#### **🔴 main Branch Protection**
```yaml
# Required checks for main branch
required_checks:
  - flutter_analyze
  - flutter_test_unit
  - flutter_test_widget
  - flutter_test_golden
  - flutter_test_integration
  - build_android_release
  - build_ios_release
  - security_scan
  - performance_check
  - accessibility_check
```

#### **🟡 develop Branch Protection**
```yaml
# Required checks for develop branch
required_checks:
  - flutter_analyze
  - flutter_test_unit
  - flutter_test_widget
  - build_android_debug
  - build_ios_debug
  - basic_security_scan
```

#### **🟢 Feature Branch Checks**
```yaml
# Optional checks for feature branches
optional_checks:
  - flutter_analyze
  - flutter_test_unit
  - flutter_test_widget
  - build_android_debug
```

### **Review Process**

#### **Code Review Requirements**
- **Minimum Reviewers:** 2 senior developers
- **Review Timeout:** 24 hours for standard PRs
- **Emergency Review:** 4 hours for hotfixes
- **Review Criteria:** DoD compliance, code quality, architecture

#### **Review Checklist**
- [ ] **Code Quality:** Follows project conventions
- [ ] **Architecture:** Follows established patterns
- [ ] **Testing:** Adequate test coverage
- [ ] **Performance:** No performance regressions
- [ ] **Security:** No security vulnerabilities
- [ ] **Accessibility:** WCAG compliance maintained
- [ ] **Documentation:** Code properly documented
- [ ] **DoD Compliance:** All DoD criteria met

#### **Approval Process**
1. **Automated Checks:** All CI checks must pass
2. **Code Review:** Required reviewers must approve
3. **QA Review:** QA team validates functionality
4. **Final Approval:** Release lead approves for production

### **Merge Strategy**

#### **Feature Branches → develop**
- **Method:** Squash and merge
- **Commit Message:** Use PR title
- **Requirements:** All develop checks must pass

#### **develop → main**
- **Method:** Merge commit
- **Commit Message:** `chore(release): merge develop to main`
- **Requirements:** All main checks must pass

#### **Hotfix Branches → main**
- **Method:** Merge commit
- **Commit Message:** `hotfix: <issue-description>`
- **Requirements:** All main checks must pass

---

## 🚀 **RELEASE WORKFLOW**

### **Release Process**

#### **1. Release Preparation**
```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.0.0
git push origin release/v1.0.0
```

#### **2. Release Testing**
- **Full DoD Compliance:** All DoD criteria met
- **Integration Testing:** End-to-end testing
- **Performance Testing:** Performance benchmarks
- **Security Testing:** Security audit
- **User Acceptance Testing:** Stakeholder approval

#### **3. Release Deployment**
```bash
# Merge to main
git checkout main
git merge release/v1.0.0
git tag v1.0.0
git push origin main --tags

# Merge back to develop
git checkout develop
git merge release/v1.0.0
git push origin develop
```

### **Hotfix Process**

#### **1. Hotfix Creation**
```bash
# Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-payment-bug
```

#### **2. Hotfix Development**
- **Minimal Changes:** Only essential fixes
- **Full Testing:** All tests must pass
- **Security Review:** Security impact assessment
- **Performance Check:** No performance regressions

#### **3. Hotfix Deployment**
```bash
# Merge to main
git checkout main
git merge hotfix/critical-payment-bug
git tag v1.0.1
git push origin main --tags

# Merge to develop
git checkout develop
git merge hotfix/critical-payment-bug
git push origin develop
```

---

## 📊 **BRANCH PROTECTION RULES**

### **main Branch Protection**
```yaml
protection_rules:
  required_status_checks:
    strict: true
    contexts:
      - flutter_analyze
      - flutter_test_unit
      - flutter_test_widget
      - flutter_test_golden
      - flutter_test_integration
      - build_android_release
      - build_ios_release
      - security_scan
      - performance_check
      - accessibility_check
  
  enforce_admins: true
  required_pull_request_reviews:
    required_approving_review_count: 2
    dismiss_stale_reviews: true
    require_code_owner_reviews: true
  
  restrictions:
    users: []
    teams: ["senior-developers", "release-leads"]
```

### **develop Branch Protection**
```yaml
protection_rules:
  required_status_checks:
    strict: true
    contexts:
      - flutter_analyze
      - flutter_test_unit
      - flutter_test_widget
      - build_android_debug
      - build_ios_debug
      - basic_security_scan
  
  enforce_admins: false
  required_pull_request_reviews:
    required_approving_review_count: 1
    dismiss_stale_reviews: true
  
  restrictions:
    users: []
    teams: ["developers"]
```

---

## 🔧 **CI/CD PIPELINE CONFIGURATION**

### **GitHub Actions Workflow**
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop, 'feat/*', 'hotfix/*', 'release/*']
  pull_request:
    branches: [main, develop]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter analyze
      - run: dart format --set-exit-if-changed .

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test
      - run: flutter test integration_test/

  golden-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test --update-goldens
      - run: flutter test

  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build apk --release

  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build ios --release

  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: # Security scanning tools

  performance-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: # Performance testing tools

  accessibility-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: # Accessibility testing tools
```

---

## 📋 **ENFORCEMENT CHECKLIST**

### **Developer Responsibilities**
- [ ] **Follow Branching Rules:** Use correct branch naming and hierarchy
- [ ] **Commit Convention:** Follow commit message format
- [ ] **Local Testing:** Run tests before pushing
- [ ] **Code Quality:** Ensure code meets standards
- [ ] **PR Template:** Use PR template for all pull requests

### **Reviewer Responsibilities**
- [ ] **Code Review:** Thorough review of all changes
- [ ] **DoD Compliance:** Verify all DoD criteria met
- [ ] **Architecture Review:** Ensure proper patterns followed
- [ ] **Security Review:** Check for security issues
- [ ] **Performance Review:** Verify no performance regressions

### **Release Lead Responsibilities**
- [ ] **Branch Protection:** Maintain protection rules
- [ ] **CI/CD Monitoring:** Monitor pipeline health
- [ ] **Release Management:** Coordinate releases
- [ ] **Hotfix Management:** Handle emergency fixes
- [ ] **Quality Gates:** Enforce quality standards

---

## 📝 **APPROVAL & SIGN-OFF**

**DevOps Lead:** ✅ Approved  
**Engineering Lead:** ✅ Approved  
**Release Lead:** ✅ Approved  
**Security Lead:** ✅ Approved  

**Enforcement Start Date:** Immediate  
**Review Frequency:** Every sprint  
**Update Frequency:** As needed based on learnings

---

## 📄 **REFERENCE DOCUMENTS**

- **DEFINITION_OF_DONE.md** - Quality standards
- **MVP_SCOPE_LOCKED.md** - Feature scope
- **PRD v0.3.0** - Product requirements
- **Flutter Testing Guide** - Testing best practices
- **Security Guidelines** - Security requirements

---

**Document Status:** ENFORCED FOR ALL DEVELOPMENT  
**Next Review:** Post-MVP delivery for Phase 2 updates

