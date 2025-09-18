# Git Branching Model - Yole Flutter Project (Simplified)
**Date:** 2025-09-18  
**DevOps Lead:** AI DevOps Lead  
**Project:** Yole MVP Flutter App  
**Status:** **ENFORCED FOR ALL DEVELOPMENT**  

## Executive Summary

This document defines a simplified Git branching model for the Yole Flutter project using only **two main branches**: `main` and `develop`. This approach ensures code quality, release stability, and efficient collaboration while maintaining simplicity.

**Enforcement:** This branching model is mandatory for all development work. No exceptions.

---

## 🌳 **SIMPLIFIED BRANCHING RULES**

### **Branch Hierarchy**

```
main (production)
└── develop (integration/staging)
```

### **Branch Definitions**

#### **🔴 main (Production)**
- **Purpose:** Production-ready code only
- **Protection:** Strict protection with required CI checks
- **Merges:** Only from `develop` branch via Pull Request
- **Deployment:** Automatic deployment to production
- **Requirements:** All DoD criteria must be met
- **Direct commits:** Forbidden (except emergency hotfixes)

#### **🟡 develop (Integration/Staging)**
- **Purpose:** Integration branch for all development work
- **Protection:** Moderate protection with basic CI checks
- **Merges:** All feature development happens here
- **Deployment:** Automatic deployment to staging environment
- **Requirements:** Basic quality checks must pass
- **Direct commits:** Allowed for small changes, PRs recommended for features

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

## 🔄 **SIMPLIFIED WORKFLOW**

### **Development Workflow**

#### **1. Feature Development (Small Changes)**
```bash
# Work directly on develop branch
git checkout develop
git pull origin develop

# Make your changes
# ... code changes ...

# Run local checks
flutter analyze
flutter test
dart format .

# Commit changes
git add .
git commit -m "feat(area): description of changes"
git push origin develop
```

#### **2. Feature Development (Large Changes - Recommended)**
```bash
# Create temporary feature branch (optional)
git checkout develop
git pull origin develop
git checkout -b temp-feature-name

# Make your changes
# ... code changes ...

# Run local checks
flutter analyze
flutter test
dart format .

# Commit and create PR to develop
git add .
git commit -m "feat(area): description of changes"
git push origin temp-feature-name

# Create PR: temp-feature-name → develop
```

#### **3. Release to Production**
```bash
# Create PR from develop to main
# Only when ready for production release
# This triggers full CI/CD pipeline
```

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

## 🚀 **SIMPLIFIED RELEASE WORKFLOW**

### **Release Process**

#### **1. Pre-Release Preparation**
- **Ensure develop is stable:** All tests passing
- **Full DoD Compliance:** All DoD criteria met
- **Integration Testing:** End-to-end testing completed
- **Performance Testing:** Performance benchmarks met
- **Security Testing:** Security audit passed
- **User Acceptance Testing:** Stakeholder approval received

#### **2. Production Release**
```bash
# Create Pull Request: develop → main
# This is the ONLY way to release to production

# After PR is approved and merged:
git checkout main
git pull origin main
git tag v1.0.0
git push origin main --tags
```

#### **3. Post-Release**
- **Monitor Production:** Watch for any issues
- **Update Documentation:** Update version numbers
- **Notify Stakeholders:** Announce release completion

### **Hotfix Process (Emergency Only)**

#### **1. Emergency Hotfix**
```bash
# ONLY for critical production issues
# Make minimal fix directly on main branch
git checkout main
git pull origin main

# Make minimal fix
# ... emergency fix ...

# Commit and push
git add .
git commit -m "hotfix: critical issue description"
git push origin main

# Merge hotfix back to develop
git checkout develop
git pull origin develop
git merge main
git push origin develop
```

#### **2. Hotfix Requirements**
- **Emergency Only:** Only for critical production issues
- **Minimal Changes:** Smallest possible fix
- **Immediate Testing:** Quick verification
- **Quick Review:** Fast-track review process

---

## 📊 **SIMPLIFIED BRANCH PROTECTION RULES**

### **main Branch Protection (Strict)**
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
  
  enforce_admins: true
  required_pull_request_reviews:
    required_approving_review_count: 2
    dismiss_stale_reviews: true
    require_code_owner_reviews: true
  
  restrictions:
    # Only senior developers can merge to main
    teams: ["senior-developers", "release-leads"]
  
  # Prevent direct pushes - only PRs allowed
  allow_force_pushes: false
  allow_deletions: false
```

### **develop Branch Protection (Moderate)**
```yaml
protection_rules:
  required_status_checks:
    strict: false  # Allow some flexibility for development
    contexts:
      - flutter_analyze
      - flutter_test_unit
      - build_android_debug
  
  enforce_admins: false
  required_pull_request_reviews:
    required_approving_review_count: 0  # Optional reviews
    dismiss_stale_reviews: false
  
  restrictions:
    # All developers can push to develop
    teams: ["developers"]
  
  # Allow direct pushes for small changes
  allow_force_pushes: false
  allow_deletions: false
```

---

## 🔧 **SIMPLIFIED CI/CD PIPELINE**

### **GitHub Actions Workflow**
```yaml
name: Simplified CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  # Basic checks for develop branch
  basic-checks:
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          flutter-version: "3.22.0"
      - name: Print versions
        run: |
          flutter --version
          dart --version
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --debug

  # Full checks for main branch (production)
  production-checks:
    if: github.ref == 'refs/heads/main' || github.base_ref == 'main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          flutter-version: "3.22.0"
      - name: Print versions
        run: |
          flutter --version
          dart --version
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter test integration_test/
      - run: flutter build apk --release
      - run: flutter build ios --release --no-codesign

  # Integration tests (Android)
  integration-tests:
    if: github.base_ref == 'main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          flutter-version: "3.22.0"
      - run: flutter pub get
      - name: Run integration tests
        uses: reactivecircus/android-emulator-runner@v2
        with:
          api-level: 30
          arch: x86_64
          target: google_apis
          script: flutter test integration_test/
```

---

## 📋 **SIMPLIFIED WORKFLOW SUMMARY**

### **Daily Development**
1. **Work on `develop` branch** for all feature development
2. **Commit frequently** with clear commit messages
3. **Push to `develop`** when ready to share changes
4. **Basic CI checks** run automatically on develop

### **Production Releases**
1. **Create PR** from `develop` to `main` when ready for production
2. **Full CI/CD pipeline** runs with comprehensive checks
3. **Require 2 approvals** from senior developers
4. **Merge and tag** the release version
5. **Automatic deployment** to production

### **Emergency Fixes**
1. **Hotfix directly on `main`** for critical issues only
2. **Merge back to `develop`** immediately after hotfix
3. **Minimal changes** and fast-track review process

### **Benefits of This Model**
- ✅ **Simple and Easy:** Only 2 branches to manage
- ✅ **Fast Development:** Direct commits to develop allowed
- ✅ **Safe Production:** Strict protection on main branch
- ✅ **Clear Process:** Obvious workflow for releases
- ✅ **Reduced Overhead:** No complex branching strategies
- ✅ **CI/CD Optimized:** Appropriate checks for each branch

---

## 📋 **SIMPLIFIED ENFORCEMENT CHECKLIST**

### **Developer Responsibilities**
- [ ] **Use Two Branches:** Work on `develop`, release via `main`
- [ ] **Commit Convention:** Follow commit message format
- [ ] **Local Testing:** Run `flutter analyze` and `flutter test` before pushing
- [ ] **Code Quality:** Ensure code meets basic standards
- [ ] **PR for Production:** Always use PR for `develop` → `main`

### **Team Lead Responsibilities**
- [ ] **Branch Protection:** Maintain protection rules on `main`
- [ ] **CI/CD Monitoring:** Monitor pipeline health
- [ ] **Release Coordination:** Manage `develop` → `main` releases
- [ ] **Quality Gates:** Ensure production readiness

### **Quick Reference Commands**
```bash
# Daily development
git checkout develop
git pull origin develop
# ... make changes ...
git add .
git commit -m "feat(area): description"
git push origin develop

# Production release
# Create PR: develop → main via GitHub UI

# Emergency hotfix
git checkout main
# ... make minimal fix ...
git add .
git commit -m "hotfix: critical issue"
git push origin main
git checkout develop
git merge main
git push origin develop
```

---

## 📝 **APPROVAL & SIGN-OFF**

**DevOps Lead:** ✅ Approved - Simplified Model  
**Engineering Lead:** ✅ Approved - Two Branch Strategy  
**Release Lead:** ✅ Approved - Streamlined Process  

**Enforcement Start Date:** 2025-09-18  
**Model Type:** Simplified Two-Branch (main + develop)  
**Review Frequency:** Monthly or as needed  

---

## 📄 **REFERENCE DOCUMENTS**

- **DEFINITION_OF_DONE.md** - Quality standards
- **MVP_SCOPE_LOCKED.md** - Feature scope
- **PRD.md** - Product requirements
- **ci.yml** - CI/CD pipeline configuration

---

**Document Status:** SIMPLIFIED AND ENFORCED  
**Model:** Two-Branch Strategy (main + develop)  
**Last Updated:** 2025-09-18

