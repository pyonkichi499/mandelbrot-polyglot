use mandelbrot_lib::mandelbrot::*;

use std::fs::File;
use std::io::{BufWriter, Result, Write};

fn main() -> Result<()> {
    let file = File::create("mandelbrot.ppm")?;
    let mut writer = BufWriter::new(file);

    write!(writer, "P3\n{} {}\n255\n", WIDTH, HEIGHT)?;

    for row in 0..HEIGHT {
        for col in 0..WIDTH {
            let (cx, cy) = pixel_to_complex(row, col);
            let n = mandelbrot(cx, cy);
            let (r, g, b) = color(n);
            write!(writer, "{} {} {}\n", r, g, b)?;
        }
    }

    writer.flush()?;
    println!("Written mandelbrot.ppm");

    Ok(())
}
