all: /home/patrick/PhD/R/hyperspectral/02_hyperspectral-ndvi-raster.Rmd /home/patrick/PhD/R/hyperspectral/03_hyperspectral-ndvi-analysis.Rmd /home/patrick/PhD/R/hyperspectral/03_hyperspectral-ndvi-analysis.Rmd /home/patrick/PhD/R/hyperspectral/04_hyperspectral-all-vegindex.Rmd /home/patrick/PhD/R/hyperspectral/05_narrow-band-indices.Rmd /home/shares/data/LIFE/mod/tree-per-tree/laukiz1/all-indices-laukiz1.rda /home/shares/data/LIFE/mod/tree-per-tree/laukiz2/all-indices-laukiz2.rda /home/shares/data/LIFE/mod/tree-per-tree/oiartzun/all-indices-oiartzun.rda /home/shares/data/LIFE/mod/tree-per-tree/luiando/all-indices-luiando.rda /home/patrick/PhD/R/hyperspectral/03_hyperspectral-ndvi-analysis.Rmd
.DELETE_ON_ERROR: 
/home/patrick/PhD/R/hyperspectral/02_hyperspectral-ndvi-raster.Rmd: /home/shares/data/LIFE/mod/hyperspectral/wavelength.Rds
	Rscript -e 'rmarkdown::render("/home/patrick/PhD/R/hyperspectral/02_hyperspectral-ndvi-raster.Rmd")'
 
/home/patrick/PhD/R/hyperspectral/03_hyperspectral-ndvi-analysis.Rmd: /home/shares/data/LIFE/mod/hyperspectral/atm-cropped/all-cropped.rds /home/patrick/PhD/R/tmp/files_atm_with_values.rda R/helper.funs/get.values.row.by.row.R
	Rscript -e 'rmarkdown::render("/home/patrick/PhD/R/hyperspectral/03_hyperspectral-ndvi-analysis.Rmd")'
 
/home/patrick/PhD/R/hyperspectral/04_hyperspectral-all-vegindex.Rmd: /home/shares/data/LIFE/mod/hyperspectral/wavelength.Rds
	Rscript -e 'rmarkdown::render("/home/patrick/PhD/R/hyperspectral/04_hyperspectral-all-vegindex.Rmd")'
 
/home/patrick/PhD/R/hyperspectral/05_narrow-band-indices.Rmd: /home/shares/data/LIFE/mod/hyperspectral/wavelength.Rds
	Rscript -e 'rmarkdown::render("/home/patrick/PhD/R/hyperspectral/05_narrow-band-indices.Rmd")'
 
/home/shares/data/LIFE/mod/tree-per-tree/laukiz1/all-indices-laukiz1.rda: /home/patrick/PhD/R/hyperspectral/06_extract-indices-to-points.Rmd
	Rscript -e 'rmarkdown::render("/home/patrick/PhD/R/hyperspectral/06_extract-indices-to-points.Rmd")'
 
/home/shares/data/LIFE/mod/tree-per-tree/laukiz2/all-indices-laukiz2.rda: /home/patrick/PhD/R/hyperspectral/06_extract-indices-to-points.Rmd
	Rscript -e 'rmarkdown::render("/home/patrick/PhD/R/hyperspectral/06_extract-indices-to-points.Rmd")'
 
/home/shares/data/LIFE/mod/tree-per-tree/luiando/all-indices-luiando.rda: /home/patrick/PhD/R/hyperspectral/06_extract-indices-to-points.Rmd
	Rscript -e 'rmarkdown::render("/home/patrick/PhD/R/hyperspectral/06_extract-indices-to-points.Rmd")'
 
/home/shares/data/LIFE/mod/tree-per-tree/oiartzun/all-indices-oiartzun.rda: /home/patrick/PhD/R/hyperspectral/06_extract-indices-to-points.Rmd
	Rscript -e 'rmarkdown::render("/home/patrick/PhD/R/hyperspectral/06_extract-indices-to-points.Rmd")'
 
