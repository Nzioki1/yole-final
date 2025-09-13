# Cursor Contract

## ASK-FIRST Rules

### Documentation Sources of Truth
- Follow `/docs/PRD.md` and `/docs/design-lock.json` as the single sources of truth
- If anything is missing or ambiguous, output a **QUESTION** list (with file:line if relevant) and STOP

### Development Constraints
- Do NOT invent tokens, endpoints, models, copy, or rules
- Do NOT hardcode `Color(...)`, `Colors.*`, `TextStyle(...)`, `EdgeInsets(...)` in screen code
- Use design tokens from `/docs/design-lock.json` for all styling

### Code Quality
- Follow Flutter best practices
- Use proper state management patterns
- Implement proper error handling
- Write clean, maintainable code

### Process
1. Always read PRD and design-lock.json before starting any work
2. Ask questions when specifications are unclear
3. Implement only what is specified
4. Do not add features not in the PRD
