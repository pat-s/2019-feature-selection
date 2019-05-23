########
# LIFE
########

# `defoliation-report` --------------- copy defoliation report to LIFE
rsync -rlptDvzog --chown=www-data:www-data --fake-super \
  /home/patrick/papers/2019-feature-selection/analysis/rmd/defoliation-maps.html \
  -e ssh patrick@jupiter.geogr.uni-jena.de:/home/www/life-healthy-forest/action-B1-spatial-mapping/report-defoliation.html

# `defoliation-maps` --------------- copy defoliation report to LIFE
rsync -rlptDvzog --chown=www-data:www-data --fake-super \
  /home/patrick/papers/2019-feature-selection/analysis/figures/defoliation-map* \
  -e ssh patrick@jupiter.geogr.uni-jena.de:/home/www/life-healthy-forest/action-B1-spatial-mapping/defoliation-maps/
