# Mandelbrot Polyglot

マンデルブロ集合を複数のプログラミング言語で実装して比較するプロジェクト。
全言語で同一のパラメータと色付けアルゴリズムを使い、出力画像が一致することを目標とする。

A project to implement and compare the Mandelbrot set across multiple programming languages.
All implementations use identical parameters and coloring algorithms, aiming for pixel-identical output.

## Rendering Parameters

全言語で以下のパラメータを統一する。

| Parameter | Value | Note |
|-----------|-------|------|
| Image size | 800 x 600 | Square pixels (0.004375 units/px) |
| X range | [-2.5, 1.0] | Real axis |
| Y range | [-1.3125, 1.3125] | Imaginary axis |
| Max iterations | 100 | |
| Escape radius^2 | 4.0 | Escape when \|z\|^2 > 4.0 (strict) |
| Output format | PPM P3 (ASCII) | One pixel per line, LF only |

## Coloring

集合内部の点は黒 (0, 0, 0)。発散した点は16色循環パレット（Wikipedia "Ultra Fractal" パレット）で着色。

```
color(n):
    if n == MAX_ITERATIONS: (0, 0, 0)      // black
    else:                   PALETTE[n % 16]
```

<details>
<summary>Palette (16 colors)</summary>

| Index | R | G | B |
|-------|-----|-----|-----|
| 0 | 66 | 30 | 15 |
| 1 | 25 | 7 | 26 |
| 2 | 9 | 1 | 47 |
| 3 | 4 | 4 | 73 |
| 4 | 0 | 7 | 100 |
| 5 | 12 | 44 | 138 |
| 6 | 24 | 82 | 177 |
| 7 | 57 | 125 | 209 |
| 8 | 134 | 181 | 229 |
| 9 | 211 | 236 | 248 |
| 10 | 241 | 233 | 191 |
| 11 | 248 | 201 | 95 |
| 12 | 255 | 170 | 0 |
| 13 | 204 | 128 | 0 |
| 14 | 153 | 87 | 0 |
| 15 | 106 | 52 | 3 |

</details>

## Supported Languages

| Language | Directory | Build System | Build & Run |
|----------|-----------|-------------|-------------|
| Rust | `rust/` | Cargo | `cd rust && cargo run --release` |
| Haskell | `haskell/` | Stack (lts-22.7) | `cd haskell && stack build && stack exec mandelbrot` |

## Testing

```bash
# Rust
cd rust && cargo test

# Haskell
cd haskell && stack test
```

## Verifying Output

全実装が同一の PPM ファイルを出力することを検証する。

```bash
diff haskell/mandelbrot.ppm rust/mandelbrot.ppm
```

## Adding a New Language

1. 新しいトップレベルディレクトリを作成 (例: `python/`)
2. 上記パラメータでマンデルブロ計算を実装
3. 同じ16色パレットを使用
4. `mandelbrot.ppm` を P3 形式で出力
5. この README の言語テーブルを更新

## Project Structure

```
mandelbrot-polyglot/
├── README.md
├── CLAUDE.md / CLAUDE-JP.md
├── LICENSE
├── .gitignore
├── devlog/           # Development diary
├── haskell/
│   ├── stack.yaml
│   ├── package.yaml
│   ├── src/Mandelbrot.hs
│   ├── app/Main.hs
│   └── test/Spec.hs
└── rust/
    ├── Cargo.toml
    ├── src/
    │   ├── lib.rs
    │   ├── main.rs
    │   └── mandelbrot.rs
    └── tests/mandelbrot_test.rs
```

## Algorithm

```
mandelbrot(c_re, c_im):
    z_re = 0.0, z_im = 0.0
    for i = 0 to MAX_ITERATIONS - 1:
        z_re_sq = z_re * z_re
        z_im_sq = z_im * z_im
        if z_re_sq + z_im_sq > 4.0: return i
        z_im = 2.0 * z_re * z_im + c_im
        z_re = z_re_sq - z_im_sq + c_re
    return MAX_ITERATIONS
```

Pixel-to-complex mapping (row 0 = Y_MAX, positive imaginary axis points up):
```
cx = X_MIN + col * (X_MAX - X_MIN) / WIDTH
cy = Y_MAX - row * (Y_MAX - Y_MIN) / HEIGHT
```

## License

MIT
