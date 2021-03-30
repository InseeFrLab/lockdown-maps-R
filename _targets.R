# if (!requireNamespace("odf"))
#   remotes::install_github("mtennekes/odf")
# #install.packages('targets')
# 
# remotes::install_github("r-spatial/leafsync") # requires the github version of leafsync
# remotes::install_github("mtennekes/tmap") # latest github version of tmap required to improve the popups
# 
library(targets)

source("R/bake_donuts.R", encoding = "UTF-8")
source("R/maps_utils.R", encoding = "UTF-8")

tar_option_set(
  packages = c(
    "tidyverse",
    "tmaptools",
    "tmap",
    "odf",
    "sf",
    "htmltools",
    "htmlwidgets",
    "leafsync"
  )
)


list(
  tar_target(langue, c("fr-FR", "en-US")),
  tar_target(inflows, c(TRUE, FALSE)),
  tar_target(before_after, 1:2),
  tar_target(vizLink, 'https://InseeFrLab.github.io/lockdown-maps-R/'),
  tar_target(totals, get_residents()),
  tar_target(infos, unlist(HTMLInfos(vizLink, inflows, langue))),
  tar_target(htmls_files, html_names(inflows, langue)$name, pattern = cross(inflows,langue)),
  tar_target(htmls_langue, rep(langue, 2)),
  tar_target(dm_centroid, departement_centroids()),
  tar_target(ODs, get_ODs(), iteration = "list"),
  tar_target(
      ODsGeo,
      get_ODsGeo(ODs, dm_centroid),
      pattern = map(ODs),
      iteration = "list"
    ),
  tar_target(tmaps,
               list(tmaps = build_tmap(
                 ODsGeo[[before_after]], totals,  inflows, langue, title(before_after, inflows, langue)
               )),
               pattern = map(cross(
                 before_after, inflows, langue
               ))),
    tar_target(synctmaps,
               sync_tmaps(tmaps), iteration = 'list'),
    tar_target(
      savehtmls,
      save_tags(
        {
        tmap_mode('view');
        library(leafsync);
        print(synctmaps, show = FALSE, full.height = TRUE) %>%
          htmlwidgets::appendContent(htmltools::HTML(infos))},
        htmls_files,
        htmls_langue
      ),
      pattern = map(synctmaps, infos, htmls_files, htmls_langue)
    )
  )
  