Detect the project ecosystem and fill in the `## Development Commands` section in CLAUDE.md (or the file given in `$ARGUMENTS` if provided).

!`find . -maxdepth 2 \( -name "package.json" -o -name "pyproject.toml" -o -name "Cargo.toml" -o -name "go.mod" -o -name "Makefile" -o -name "justfile" -o -name "Gemfile" -o -name "mix.exs" \) -not -path "*/node_modules/*" 2>/dev/null`

## Instructions

1. **Determine the target file**: Use `$ARGUMENTS` if set (e.g. `AGENTS.md`), otherwise default to `CLAUDE.md`.

2. **Read the target file** to find the current state of the `## Development Commands` section.

3. **Detect ecosystems** from the config files listed above and extract commands:

   | Config File | Commands to discover |
   |---|---|
   | `package.json` | Read the `scripts` object; map test/lint/typecheck/format/build entries to the matching command fields |
   | `pyproject.toml` | Check for `[tool.pytest]`, `[tool.ruff]`, `[tool.mypy]`, `[tool.black]` sections |
   | `Cargo.toml` | `cargo test`, `cargo clippy`, `cargo check`, `cargo fmt --check` |
   | `go.mod` + Makefile | `go test ./...`, `go vet ./...`; check Makefile for golangci-lint targets |
   | `Makefile` / `justfile` | Parse for targets matching test/lint/check/typecheck/format |
   | `Gemfile` | Check for rspec/rubocop gems |
   | `mix.exs` | `mix test`, `mix credo`, `mix dialyzer` |

4. **Present findings** to the user in a concise table before writing.

5. **Update the `## Development Commands` section** in the target file:
   - Replace only the empty placeholder lines (e.g. `Run tests:`, `Run linter:`, `Run type checks:`)
   - Preserve any lines that already have a command filled in
   - If the section doesn't exist, append it before the first `##` workflow section

6. **Confirm** what was written to the user.
