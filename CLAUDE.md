# CLAUDE.md - Mandelbrot Polyglot

## Project Overview
Mandelbrot set rendered in multiple languages (Haskell, Rust, Python) with identical output.

## Build & Test Commands

```bash
# Rust
cd rust && cargo test
cd rust && cargo run --release

# Haskell
cd haskell && stack test
cd haskell && stack build && stack exec mandelbrot

# Python
cd python && rye run pytest tests/ -v
cd python && rye run mandelbrot

# Verify output identity
diff haskell/mandelbrot.ppm rust/mandelbrot.ppm
diff python/mandelbrot.ppm rust/mandelbrot.ppm

# View PPM on macOS (Preview does not support PPM)
sips -s format png rust/mandelbrot.ppm --out rust/mandelbrot.png && open rust/mandelbrot.png
```

## Architecture

- Each language lives in its own top-level directory with independent build system
- Computation logic is separated from the entry point in every language:
  - Rust: `src/mandelbrot.rs` (logic) + `src/main.rs` (I/O) + `src/lib.rs` (re-export)
  - Haskell: `src/Mandelbrot.hs` (logic) + `app/Main.hs` (I/O)
  - Python: `src/mandelbrot_py/mandelbrot.py` (logic) + `src/mandelbrot_py/main.py` (I/O)
- Output format: PPM P3 ASCII, one pixel per line, LF-only line endings

## Critical Constants (must be identical across all languages)

- Image: 800x600, X: [-2.5, 1.0], Y: [-1.3125, 1.3125]
- Max iterations: 100, Escape: |z|^2 > 4.0 (strict)
- 16-color cycling palette, black for set interior

## IEEE 754 Determinism Rules

- Rust: Do NOT use `-C target-cpu=native` (may enable FMA)
- Haskell: Use NCG backend (default), do NOT use `-fllvm`
- Mirror expression structure exactly between languages
- Do NOT use `f64::mul_add()` in Rust

## Test Naming Convention

Use Japanese test names per global CLAUDE.md:
- Rust: `fn test_原点は集合の内部()`
- Haskell: `it "原点は集合の内部" $ ...`
- Python: `def test_原点は集合の内部():`

## Known Test Points

| cx | cy | Expected |
|------|------|----------|
| 0.0 | 0.0 | 100 (MAX) |
| -1.0 | 0.0 | 100 (MAX) |
| 2.0 | 0.0 | 2 |
| 1.0 | 0.0 | 3 |
| -2.1 | 0.0 | 1 |
| 0.5 | 0.5 | 5 |
