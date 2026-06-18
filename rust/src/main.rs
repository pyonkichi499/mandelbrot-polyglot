use mandelbrot_lib::mandelbrot::*;

use std::env;
use std::fs::File;
use std::io::{BufWriter, Result, Write};
use std::process;

fn print_usage() {
    eprintln!(
        "Usage: mandelbrot [--scale N] [--output PATH]\n\
         \n\
         --scale N, -s N   Integer scale relative to base 800×600 (default: {}). \
         1→800×600, 2→1600×1200, …\n\
         --output PATH, -o PATH   Output PPM (default: mandelbrot.ppm for scale {}, else mandelbrot-Nx.ppm)\n",
        DEFAULT_SCALE, DEFAULT_SCALE
    );
}

fn default_output_path(scale: u32) -> String {
    if scale == DEFAULT_SCALE {
        "mandelbrot.ppm".to_string()
    } else {
        format!("mandelbrot-{}x.ppm", scale)
    }
}

fn parse_args() -> std::result::Result<(u32, String), String> {
    let mut scale = DEFAULT_SCALE;
    let mut output: Option<String> = None;
    let mut args = env::args().skip(1);

    while let Some(a) = args.next() {
        match a.as_str() {
            "--help" | "-h" => {
                print_usage();
                process::exit(0);
            }
            "--scale" | "-s" => {
                let s = args
                    .next()
                    .ok_or_else(|| "--scale requires a number".to_string())?;
                let n: u32 = s
                    .parse()
                    .map_err(|_| format!("invalid scale: {}", s))?;
                if n < 1 {
                    return Err("scale must be >= 1".to_string());
                }
                scale = n;
            }
            "--output" | "-o" => {
                let p = args
                    .next()
                    .ok_or_else(|| "--output requires a path".to_string())?;
                output = Some(p);
            }
            other => {
                return Err(format!("unknown argument: {}", other));
            }
        }
    }

    let path = output.unwrap_or_else(|| default_output_path(scale));
    Ok((scale, path))
}

fn main() -> Result<()> {
    let (scale, path) = match parse_args() {
        Ok(x) => x,
        Err(e) => {
            eprintln!("Error: {}", e);
            print_usage();
            process::exit(1);
        }
    };

    let (width, height) = dimensions(scale);
    let file = File::create(&path)?;
    let mut writer = BufWriter::new(file);

    write!(writer, "P3\n{} {}\n255\n", width, height)?;

    for row in 0..height {
        for col in 0..width {
            let (cx, cy) = pixel_to_complex(row, col, width, height);
            let n = mandelbrot(cx, cy);
            let (r, g, b) = color(n);
            write!(writer, "{} {} {}\n", r, g, b)?;
        }
    }

    writer.flush()?;
    println!("Written {}", path);

    Ok(())
}
