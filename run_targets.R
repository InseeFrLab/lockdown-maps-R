remotes::install_github("r-spatial/leafsync", force = TRUE)
# Hypothesis: full.height not taken into account because not last github version of leafsync == nope
library(targets)
tar_make()
