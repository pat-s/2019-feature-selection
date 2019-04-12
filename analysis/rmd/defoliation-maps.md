---
title: "Creation of prediction maps"
output: html_document
author: "Patrick Schratz, FSU Jena"
---


```r
knitr::opts_knit$set(base.dir = 'analysis/rmd/')
knitr::opts_chunk$set(fig.retina=3, fig.align = 'center',
                      out.width = "100%")

loadd(defoliation_raster_2017, defoliation_raster_2018,
      defoliation_df_2017, defoliation_df_2018)
```

# Defoliation evaluation {.tabset .tabset-fade}

## Maps


```r
create_prediction_map(list(defoliation_raster_2017), "xgboost")
```

```
## [[1]]
```

```
## Zoom: 8
```

```
## Warning: Removed 29621091 rows containing missing values (geom_raster).
```

<img src="../../analysis/figures/defoliation-map-2017-1.png" title="plot of chunk defoliation-map-2017" alt="plot of chunk defoliation-map-2017" width="100%" style="display: block; margin: auto;" />


```r
create_prediction_map(list(defoliation_raster_2018), "xgboost")
```

```
## [[1]]
```

```
## Zoom: 8
```

```
## Warning: Removed 29621091 rows containing missing values (geom_raster).
```

<img src="../../analysis/figures/defoliation-map-2018-1.png" title="plot of chunk defoliation-map-2018" alt="plot of chunk defoliation-map-2018" width="100%" style="display: block; margin: auto;" />

## Histograms


```r
ggplot(defoliation_df_2017, aes(x = defoliation)) +
  geom_histogram() +
  labs(x = "Defoliation (%)") +
  theme_pubr()
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<img src="figure/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="100%" style="display: block; margin: auto;" />


```r
ggplot(defoliation_df_2018, aes(x = defoliation)) +
  geom_histogram() +
  labs(x = "Defoliation (%)") +
  theme_pubr()
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<img src="figure/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="100%" style="display: block; margin: auto;" />
