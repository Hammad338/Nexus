# Contributing to NEXUS

Thank you for your interest in contributing to NEXUS! This document provides guidelines and instructions for contributing.

## 🎯 Ways to Contribute

- **Bug Reports**: Found a bug? Let us know!
- **Feature Requests**: Have an idea? We'd love to hear it!
- **Code Contributions**: Fix bugs or add features
- **Documentation**: Improve or add documentation
- **Design**: Contribute to UI/UX improvements

## 🚀 Getting Started

### Prerequisites

- Node.js (v16+)
- npm (v8+)
- Git
- Code editor (VS Code recommended)

### Setup Development Environment

1. **Fork the repository**
   ```bash
   # Click "Fork" on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/nexus-project.git
   cd nexus-project
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Create environment file**
   ```bash
   cp .env.example .env
   # Edit .env with your local settings
   ```

4. **Run development server**
   ```bash
   # Frontend only (simple)
   npm run serve

   # Full stack (with backend)
   npm run dev
   ```

5. **Open in browser**
   ```
   http://localhost:8000
   ```

## 📝 Development Workflow

### 1. Create a Branch

Always create a new branch for your work:

```bash
git checkout -b feature/amazing-feature
# or
git checkout -b fix/bug-description
```

**Branch naming conventions:**
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Adding tests
- `chore/` - Maintenance tasks

### 2. Make Your Changes

- Write clean, readable code
- Follow the existing code style
- Add comments for complex logic
- Update documentation if needed

### 3. Test Your Changes

```bash
# Run tests (when implemented)
npm test

# Check linting
npm run lint

# Format code
npm run format
```

### 4. Commit Your Changes

Use clear, descriptive commit messages:

```bash
git add .
git commit -m "feat: add task filtering by date range"
```

**Commit message format:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `style:` - Formatting, missing semicolons, etc.
- `refactor:` - Code restructuring
- `test:` - Adding tests
- `chore:` - Maintenance

### 5. Push and Create Pull Request

```bash
git push origin feature/amazing-feature
```

Then create a Pull Request on GitHub.

## 💻 Code Style Guidelines

### JavaScript

```javascript
// ✅ Good
function createTask(title, description) {
    const task = {
        id: generateId(),
        title,
        description,
        createdAt: new Date().toISOString()
    };
    
    return task;
}

// ❌ Bad
function create_task(t,d){
const task={id:generateId(),title:t,description:d,createdAt:new Date().toISOString()}
return task
}
```

**Guidelines:**
- Use `const` and `let`, avoid `var`
- Use arrow functions for callbacks
- Use template literals for string concatenation
- Use meaningful variable names
- Add JSDoc comments for functions
- Keep functions small and focused

### CSS

```css
/* ✅ Good */
.task-card {
    display: flex;
    flex-direction: column;
    padding: 1.5rem;
    background: var(--bg-card);
    border: 1px solid var(--border);
    transition: all 0.3s ease;
}

.task-card:hover {
    transform: translateY(-4px);
    box-shadow: var(--shadow-lg);
}

/* ❌ Bad */
.task-card{display:flex;padding:24px;background:#1e1e2e}
.task-card:hover{transform:translateY(-4px)}
```

**Guidelines:**
- Use CSS custom properties for colors
- Use relative units (rem, em, %)
- Group related properties
- Use meaningful class names (BEM-style)
- Add comments for complex styles

### HTML

```html
<!-- ✅ Good -->
<div class="task-card" data-task-id="123">
    <h3 class="task-title">Design System</h3>
    <p class="task-description">Create component library</p>
</div>

<!-- ❌ Bad -->
<div class="tc" data-id="123">
    <h3>Design System</h3>
    <p>Create component library</p>
</div>
```

**Guidelines:**
- Use semantic HTML
- Add ARIA labels for accessibility
- Use data attributes for JavaScript hooks
- Keep markup clean and organized

## 🧪 Testing Guidelines

### Writing Tests

```javascript
// Example test structure
describe('Task Management', () => {
    describe('createTask', () => {
        it('should create a task with valid data', () => {
            const task = createTask('Test Task', 'Description');
            expect(task).toHaveProperty('id');
            expect(task.title).toBe('Test Task');
        });

        it('should throw error with empty title', () => {
            expect(() => createTask('', 'Description')).toThrow();
        });
    });
});
```

### Test Coverage

Aim for:
- **Unit Tests**: 80%+ coverage
- **Integration Tests**: Critical paths
- **E2E Tests**: Main user flows

## 📚 Documentation Guidelines

### Code Comments

```javascript
/**
 * Creates a new task with the provided information
 * @param {string} title - Task title (required)
 * @param {string} description - Task description (optional)
 * @param {Object} options - Additional options
 * @param {string} options.status - Initial status
 * @param {string} options.priority - Task priority
 * @returns {Object} The created task object
 * @throws {Error} If title is empty
 */
function createTask(title, description = '', options = {}) {
    // Implementation
}
```

### README Updates

When adding features:
1. Update features list
2. Add usage examples
3. Update screenshots if UI changed
4. Update installation steps if needed

## 🐛 Bug Reports

Good bug reports should include:

1. **Description**: Clear description of the issue
2. **Steps to Reproduce**: Numbered steps to reproduce
3. **Expected Behavior**: What should happen
4. **Actual Behavior**: What actually happens
5. **Screenshots**: If applicable
6. **Environment**: Browser, OS, Node version

Example:
```markdown
## Bug: Tasks not saving to localStorage

**Description:**
Tasks are not being saved after creation in Firefox.

**Steps to Reproduce:**
1. Open NEXUS in Firefox
2. Click "New Task"
3. Fill in task details
4. Click "Save"
5. Refresh page

**Expected:**
Tasks should persist after refresh.

**Actual:**
All tasks disappear after refresh.

**Environment:**
- Browser: Firefox 110
- OS: macOS 13.0
- Node: 18.12.0
```

## ✨ Feature Requests

Good feature requests should include:

1. **Problem Statement**: What problem does this solve?
2. **Proposed Solution**: How should it work?
3. **Alternatives**: Other solutions considered?
4. **Additional Context**: Screenshots, mockups, etc.

## 🔍 Pull Request Guidelines

### Before Submitting

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] All tests passing
- [ ] No console errors or warnings

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How has this been tested?

## Screenshots
If applicable, add screenshots

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes
```

### Review Process

1. Maintainer reviews code
2. Feedback/changes requested (if needed)
3. You make updates
4. Approval and merge

## 🎨 Design Contributions

For UI/UX improvements:

1. Create mockups or prototypes
2. Explain design decisions
3. Consider accessibility
4. Maintain consistent aesthetic
5. Test on multiple screen sizes

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 💬 Questions?

- Open an issue with the `question` label
- Join our community discussions
- Contact maintainers

## 🙏 Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Given credit in commit history

Thank you for contributing to NEXUS! 🚀
