# using imagemagick system library

system2("montage", args = c("./code/98-paper/journal/imgs/10-defol.jpg",
                            "./code/98-paper/journal/imgs/20-defol.jpg",
                            #"./code/98-paper/journal/imgs/30-defol.jpg",
                            "./code/98-paper/journal/imgs/40-defol.jpg",
                            "./code/98-paper/journal/imgs/60-70-defol.jpg",
                            "-geometry +20+20",
                            "./code/98-paper/journal/imgs/defol-grid.jpg"))

system2("convert", args = c("./code/98-paper/journal/imgs/defol-grid.jpg",
                           "-resize 2000x3000",
                           "./code/98-paper/journal/defol-grid-3000px.jpg"))
