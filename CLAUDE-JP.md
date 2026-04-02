# CLAUDE-JP.md - マンデルブロ集合ポリグロット

## プロジェクト概要
マンデルブロ集合を複数言語（Haskell, Rust）で実装し、同一出力を得るプロジェクト。

## ビルド・テストコマンド

```bash
# Rust
cd rust && cargo test
cd rust && cargo run --release

# Haskell
cd haskell && stack test
cd haskell && stack build && stack exec mandelbrot

# 出力の一致を検証
diff haskell/mandelbrot.ppm rust/mandelbrot.ppm

# macOS で PPM を表示（Preview は PPM 非対応）
sips -s format png rust/mandelbrot.ppm --out rust/mandelbrot.png && open rust/mandelbrot.png
```

## アーキテクチャ

- 各言語はトップレベルディレクトリに独立したビルドシステムを持つ
- 計算ロジックとエントリポイントは全言語で分離:
  - Rust: `src/mandelbrot.rs`（ロジック）+ `src/main.rs`（I/O）+ `src/lib.rs`（re-export）
  - Haskell: `src/Mandelbrot.hs`（ロジック）+ `app/Main.hs`（I/O）
- 出力形式: PPM P3 ASCII、1ピクセル1行、LF改行のみ

## 重要な定数（全言語で同一であること）

- 画像: 800x600、X: [-2.5, 1.0]、Y: [-1.3125, 1.3125]
- 最大反復回数: 100、エスケープ条件: |z|^2 > 4.0（厳密な不等号）
- 16色循環パレット、集合内部は黒

## IEEE 754 決定性ルール

- Rust: `-C target-cpu=native` を使わない（FMA が有効になる可能性）
- Haskell: NCG バックエンド（デフォルト）を使用、`-fllvm` を使わない
- 言語間で式の構造を完全に一致させる
- Rust で `f64::mul_add()` を使わない

## テスト命名規則

グローバル CLAUDE.md に従い日本語テスト名を使用:
- Rust: `fn test_原点は集合の内部()`
- Haskell: `it "原点は集合の内部" $ ...`

## テスト用の既知の点

| cx | cy | 期待値 |
|------|------|----------|
| 0.0 | 0.0 | 100 (MAX) |
| -1.0 | 0.0 | 100 (MAX) |
| 2.0 | 0.0 | 2 |
| 1.0 | 0.0 | 3 |
| -2.1 | 0.0 | 1 |
| 0.5 | 0.5 | 5 |
