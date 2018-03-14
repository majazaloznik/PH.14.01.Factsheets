suppressWarnings(suppressMessages(library(DiagrammeR)))
suppressWarnings(suppressMessages(library(DiagrammeRsvg)))
suppressWarnings(suppressMessages(library(rsvg)))
png::writePNG(rsvg(charToRaw(export_svg(grViz("data/processed/make.dot")))), "figures/make.png")
