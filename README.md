# Mandelbrot Polyglot

マンデルブロ集合を複数のプログラミング言語で実装して比較するプロジェクト。
全言語で同一のパラメータと色付けアルゴリズムを使い、出力画像が一致することを目標とする。

A project to implement and compare the Mandelbrot set across multiple programming languages.
All implementations use identical parameters and coloring algorithms, aiming for pixel-identical output.

## Rendering Parameters

全言語で以下のパラメータを統一する。

| Parameter | Value | Note |
|-----------|-------|------|
| Base image size | 800 x 600 | スケール N に対し **N×800 × N×600**（N は正の整数） |
| Default scale | 2 | 省略時は 1600 x 1200（ベースの 2 倍） |
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
| Python | `python/` | Rye | `cd python && rye run mandelbrot` |

### 解像度（スケール）

ベースは **800×600**。CLI で整数スケール `N` を指定すると **N×800 × N×600** で描画する。

- **デフォルト**はスケール **2**（1600×1200）。そのときの出力ファイル名は従来どおり `mandelbrot.ppm`。
- スケールが **2 以外**のときは、デフォルトの出力パスは `mandelbrot-Nx.ppm`（例: `mandelbrot-1x.ppm`）。
- いずれの実装も `--output` / `-o` でパスを上書きできる。

```text
# Rust
cargo run --release -- --scale 1
cargo run --release -- --scale 3 -o /tmp/out.ppm

# Haskell
stack exec mandelbrot -- --scale 1
stack exec mandelbrot -- -s 3 -o /tmp/out.ppm

# Python
rye run mandelbrot -- --scale 1
rye run mandelbrot -- -s 3 -o /tmp/out.ppm
```

### 横並び比較（別ツール）

異なる解像度や別ディレクトリの PPM/PNG を **横一列**に並べ、1 枚の PNG にまとめる。Python の開発依存 [Pillow](https://python-pillow.org/) を使う。

```bash
cd python && rye run python -m mandelbrot_py.compare_layout \
  ../rust/mandelbrot-1x.ppm ../rust/mandelbrot.ppm \
  --output ../rust/compare-scales.png --align-height
```

（`rye run compare-mandelbrot-layout` でも呼べるが、`-o` が Rye 側に解釈される場合は上記の `python -m` か `--output=...` 形式を使う。）

`--align-height` は高さを揃えて（最も高い画像に合わせて）横に並べる。省略時は各画像の元のピクセルサイズのまま結合する。

## Testing

```bash
# Rust
cd rust && cargo test

# Haskell
cd haskell && stack test

# Python
cd python && rye run pytest tests/ -v
```

## Verifying Output

**同じスケール**で各言語を実行したうえで、出力 PPM が一致することを検証する（例: いずれもデフォルトのスケール 2）。

```bash
diff haskell/mandelbrot.ppm rust/mandelbrot.ppm
diff python/mandelbrot.ppm rust/mandelbrot.ppm
```

## Adding a New Language

1. 新しいトップレベルディレクトリを作成 (例: `go/`)
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
├── python/
│   ├── pyproject.toml
│   ├── src/mandelbrot_py/
│   │   ├── mandelbrot.py
│   │   ├── main.py
│   │   └── compare_layout.py   # 横並び比較（compare-mandelbrot-layout）
│   └── tests/test_mandelbrot.py
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
cx = X_MIN + col * (X_MAX - X_MIN) / width
cy = Y_MAX - row * (Y_MAX - Y_MIN) / height
```
（`width` / `height` はスケールに応じたピクセル幅・高さ）

## License

MIT
