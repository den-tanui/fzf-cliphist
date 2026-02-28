# fzf-cliphist: Work Plan

## TL;DR

> **Quick Summary**: A fzf-based UI for viewing and selecting clipboard history on Wayland using cliphist. Provides interactive search with text/image preview and copies selected items to clipboard.

> **Deliverables**:
>
> - Main shell script (`bin/fzf-cliphist`)
> - Shell plugin file (`fzf-cliphist.plugin.zsh`)
> - README documentation

> **Estimated Effort**: Short
> **Parallel Execution**: YES - 2 waves
> **Critical Path**: Setup → Main script → Plugin wrapper

---

## Context

### Original Request

User wants fzf-cliphist - a fzf display of clipboard history for Wayland using cliphist as the backend.

### Interview Summary

**Key Discussions**:

- Platform: Wayland-focused with cliphist integration
- Entry Types: Text + images with kitty/ueberzug preview
- Selection: Copy only (Enter copies to clipboard)
- Daemon: Manual execution only (no auto-capture)
- Testing: Manual verification only

### Metis Review

**Identified Gaps** (addressed):

- Terminal graphics fallback: Will implement text-only fallback
- cliphist format stability: Using stable `cliphist list`/`decode` commands

---

## Work Objectives

### Core Objective

Create a fzf-based interactive clipboard history selector that:

1. Lists clipboard entries via `cliphist list`
2. Shows preview (text or image via kitty)
3. Copies selected item to clipboard on Enter

### Concrete Deliverables

- `fzf-cliphist/bin/fzf-cliphist` - Main executable script
- `fzf-cliphist/fzf-cliphist.plugin.zsh` - Zsh plugin wrapper
- `fzf-cliphist/README.md` - Usage documentation

### Definition of Done

- [ ] Running `fzf-cliphist` opens fzf with clipboard history
- [ ] Text entries show text preview
- [ ] Image entries show image preview (kitty)
- [ ] Pressing Enter copies selected item to clipboard

### Must Have

- Interactive fzf selection of clipboard history
- Text preview for text entries
- Image preview for image entries (kitty/ueberzug)
- Copy to clipboard on selection

### Must NOT Have

- Auto-capture daemon (future feature)
- Cross-platform backends (future feature)
- Test infrastructure

---

## Verification Strategy

### Test Decision

- **Infrastructure exists**: NO
- **Automated tests**: NO - Manual verification only
- **Framework**: N/A

### QA Policy

Every task includes agent-executed verification via shell commands.

---

## Execution Strategy

### Parallel Execution Waves

Wave 1 (Setup + Core):

- Task 1: Project scaffolding
- Task 2: Main fzf-cliphist script

Wave 2 (Integration + Docs):

- Task 3: Zsh plugin wrapper
- Task 4: README documentation

### Dependency Matrix

- **1**: — — 2, 3
- **2**: 1 — 3, 4
- **3**: 2 — 4
- **4**: 3 — —

---

## TODOs

- [ ] 1. Project scaffolding

  **What to do**:
  - Create directory structure following forgit pattern:
    - `fzf-cliphist/bin/` - Executable scripts
    - `fzf-cliphist/conf.d/` - Configuration (if needed)
    - `fzf-cliphist/completions/` - Shell completions
  - Create basic project files: .gitignore, LICENSE

  **Must NOT do**:
  - No test infrastructure
  - No CI/CD workflows

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Simple file creation and directory setup
  - **Skills**: None required

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1
  - **Blocks**: Task 2
  - **Blocked By**: None

  **References**:
  - `forgit/bin/` - Example bin structure
  - `forgit/forgit.plugin.zsh` - Plugin pattern

  **Acceptance Criteria**:
  - [ ] Directory structure created: `bin/`, `conf.d/`, `completions/`
  - [ ] .gitignore file exists

  **QA Scenarios**:

  Scenario: Verify directory structure
  Tool: Bash
  Preconditions: None
  Steps: 1. `ls -la fzf-cliphist/` 2. Verify bin/, conf.d/, completions/ exist
  Expected Result: All directories exist
  Evidence: Directory listing output

  Scenario: Verify .gitignore
  Tool: Bash
  Preconditions: None
  Steps: 1. `cat fzf-cliphist/.gitignore`
  Expected Result: Contains typical ignores (_.swp, _~, etc.)
  Evidence: File content

  **Commit**: NO

- [ ] 2. Main fzf-cliphist script

  **What to do**:
  - Create `bin/fzf-cliphist` executable shell script
  - Script should:
    1. Run `cliphist list` to get clipboard history
    2. Pipe to fzf with preview window
    3. For text items: show text preview using `cliphist decode`
    4. For image items: show image preview using kitty/ueberzug
    5. On selection: copy item to clipboard using `cliphist decode | wl-copy`
  - Handle edge cases:
    - Empty clipboard history
    - Invalid cliphist installation
    - Non-kitty terminals (fallback to text-only)
  - Make executable: `chmod +x bin/fzf-cliphist`

  **Must NOT do**:
  - No auto-capture functionality
  - No local storage (use cliphist only)

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
    - Reason: Shell scripting with fzf integration, clipboard operations
  - **Skills**: None required

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1
  - **Blocks**: Task 3, Task 4
  - **Blocked By**: Task 1

  **References**:
  - `forgit/bin/git-forgit` - Shell script pattern for fzf integration
  - cliphist documentation - `cliphist list`, `cliphist decode`
  - fzf --preview documentation - Preview window options
  - Kitty terminal graphics protocol - Image preview

  **Acceptance Criteria**:
  - [ ] Script is executable: `test -x fzf-cliphist/bin/fzf-cliphist`
  - [ ] Script has proper shebang: `head -1 bin/fzf-cliphist` shows `#!/usr/bin/env bash`
  - [ ] Script handles --help flag
  - [ ] Script detects missing cliphist

  **QA Scenarios**:

  Scenario: Script is executable
  Tool: Bash
  Preconditions: Task 1 complete
  Steps: 1. `ls -la fzf-cliphist/bin/fzf-cliphist`
  Expected Result: File has executable bit set
  Evidence: `-rwxr-xr-x` permissions

  Scenario: Shebang is correct
  Tool: Bash
  Preconditions: None
  Steps: 1. `head -1 fzf-cliphist/bin/fzf-cliphist`
  Expected Result: `#!/usr/bin/env bash` or `#!/usr/bin/env zsh`
  Evidence: Output matches expected shebang

  Scenario: Help flag works
  Tool: Bash
  Preconditions: None
  Steps: 1. `fzf-cliphist/bin/fzf-cliphist --help`
  Expected Result: Shows usage information
  Evidence: Help text output

  Scenario: Missing cliphist detection
  Tool: Bash
  Preconditions: None
  Steps: 1. `which cliphist` (check if installed, will fail gracefully if not)
  Expected Result: Command exists or script handles missing gracefully
  Evidence: Either cliphist exists or script shows error

  **Commit**: NO

- [ ] 3. Zsh plugin wrapper

  **What to do**:
  - Create `fzf-cliphist.plugin.zsh` following forgit pattern
  - Functions to register:
    - `fzf-cliphist` - Main command
  - Determine installation path automatically (like forgit does)
  - Export function for use in shell

  **Must NOT do**:
  - No autoload magic beyond basic function export
  - No additional shell integrations

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Simple wrapper file following existing pattern
  - **Skills**: None required

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2
  - **Blocks**: Task 4
  - **Blocked By**: Task 2

  **References**:
  - `forgit/forgit.plugin.zsh` - Exact pattern to follow
  - `fzf-tab/fzf-tab.plugin.zsh` - Another reference

  **Acceptance Criteria**:
  - [ ] Plugin file sourced without errors in zsh
  - [ ] `fzf-cliphist` function is available after sourcing

  **QA Scenarios**:

  Scenario: Plugin loads without errors
  Tool: Bash
  Preconditions: Task 2 complete
  Steps: 1. `zsh -c "source fzf-cliphist/fzf-cliphist.plugin.zsh; which fzf-cliphist"`
  Expected Result: Function is defined
  Evidence: Shows function path or definition

  **Commit**: NO

- [ ] 4. README documentation

  **What to do**:
  - Create `README.md` with:
    - Project description
    - Requirements (fzf, cliphist, wl-clipboard, kitty for images)
    - Installation instructions
    - Usage examples
    - Key bindings suggestion
    - Configuration options (if any)
  - Follow forgit README style

  **Must NOT do**:
  - No excessive documentation
  - No tutorial-style content

  **Recommended Agent Profile**:
  - **Category**: `writing`
    - Reason: Documentation writing
  - **Skills**: None required

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2
  - **Blocks**: None
  - **Blocked By**: Task 3

  **References**:
  - `forgit/README.md` - Documentation style reference
  - `fzf-tab/README.md` - Another reference

  **Acceptance Criteria**:
  - [ ] README.md exists
  - [ ] Contains requirements section
  - [ ] Contains usage section

  **QA Scenarios**:

  Scenario: README exists and has required sections
  Tool: Bash
  Preconditions: None
  Steps: 1. `cat fzf-cliphist/README.md | head -50`
  Expected Result: Contains Requirements and Usage sections
  Evidence: File content shows sections

  **Commit**: NO

---

## Final Verification Wave

- [ ] F1. **Plan Compliance Audit** — Read the plan, verify each task was implemented
      Output: `Tasks [N/N] | VERDICT: APPROVE/REJECT`

- [ ] F2. **Manual Functional Test** — Run the script and verify it works
      Output: `Script runs without errors | VERDICT: APPROVE/REJECT`

- [ ] F3. **Scope Fidelity Check** — Verify no creep, no missing features
      Output: `Must Have [N/N] | Must NOT Have [N/N] | VERDICT: APPROVE/REJECT`

---

## Success Criteria

### Verification Commands

```bash
# Check structure
ls -la fzf-cliphist/
ls -la fzf-cliphist/bin/

# Check executable
test -x fzf-cliphist/bin/fzf-cliphist
head -1 fzf-cliphist/bin/fzf-cliphist

# Check plugin
source fzf-cliphist/fzf-cliphist.plugin.zsh && which fzf-cliphist

# Check README
head -30 fzf-cliphist/README.md
```

### Final Checklist

- [ ] All "Must Have" present
- [ ] All "Must NOT Have" absent
- [ ] Project structure follows forgit pattern
- [ ] Script is executable
- [ ] README is complete
