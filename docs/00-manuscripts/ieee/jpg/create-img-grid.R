# using imagemagick system library

# paper ------------------------------------------------------------------------

system2("montage", args = c("./code/98-paper/ieee/jpg/10-defol.jpg",
                            "./code/98-paper/ieee/jpg/20-defol.jpg",
                            "./code/98-paper/ieee/jpg/40-defol.jpg",
                            "./code/98-paper/ieee/jpg/60-70-defol.jpg",
                            "-geometry +20+20",
                            "-tile 2x2",
                            "./code/98-paper/ieee/jpg/defol-grid-2000px.jpg"))

# resize
system2("convert", args = c("./code/98-paper/ieee/jpg/defol-grid-2000px.jpg",
                           "-resize 2000x2000",
                           "./code/98-paper/ieee/jpg/defol-grid-2000px.jpg"))

# presentation -----------------------------------------------------------------

system2("montage", args = c("./code/98-paper/ieee/jpg/10-defol.jpg",
                            "./code/98-paper/ieee/jpg/20-defol.jpg",
                            "./code/98-paper/ieee/jpg/40-defol.jpg",
                            "./code/98-paper/ieee/jpg/60-70-defol.jpg",
                            "-geometry +20+20",
                            "-tile 4x1",
                            "./code/98-paper/ieee/jpg/defol-grid-pres-1500px.jpg"))

# resize
system2("convert", args = c("./code/98-paper/ieee/jpg/defol-grid-pres-1500px.jpg",
                            "-resize 2000x1500",
                            "./code/98-paper/ieee/jpg/defol-grid-pres-1500px.jpg"))
