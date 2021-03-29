# if (!requireNamespace("odf"))
#   remotes::install_github("mtennekes/odf")
# #install.packages('targets')
# 
# remotes::install_github("r-spatial/leafsync") # requires the github version of leafsync
# remotes::install_github("mtennekes/tmap") # latest github version of tmap required to improve the popups
# 
library(targets)

source("R/bake_donuts.R")
source("R/maps_utils.R")

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
  tar_target(
    titles,
    c(
      "Flux entrants avant le 1er confinement",
      "Inflows before the 1rst lockdown",
      "Flux sortants avant le 1er confinement",
      "Outflows before the 1rst lockdown",
      "Flux entrants après",
      "Inflows after the 1rst lockdown",
      "Flux sortants après",
      "Outflows after the 1rst lockdown"
    )
  ),
  tar_target(infos,
             rep(
               c(
                 "<div id='info' class='info legend leaflet-control' style='display:block;height:120px;position: absolute; bottom: 10px; right: 10px;background-color: rgba(255, 255, 255, 0.8);' >
		<div style='margin-top:5px;font-size:75%'>
		Les cercles représentent la population présente en nuitées, résidents habituels <br>
		et résidents d'autres département en nuitées. La visualisation a été construite par CBS. <br>
	   Ces données, retraitées par l'Insee, combinent des comptages anonymes de trois <br>
		opérateurs de téléphonie mobiles (Bouygues telecom, SFR, Orange) <a href='https://www.insee.fr/fr/statistiques/4635407'>Galiana et al (2020).</a><br>
		</div>
		</div>
	</div>",
                 "<div id='info' class='info legend leaflet-control' style='display:block;height:140px;position: absolute; bottom: 10px; right: 10px;background-color: rgba(255, 255, 255, 0.8);' >
		<div style='margin-top:5px;font-size:75%'>
		Circles represent the population staying overnight, usual residents and residents <br>
		from other département. The visualisation was build by CBS. The data were made <br>
		available by INSEE. They were statistically adjusted and combined from anonymous <br>
		 counts provided by three MNOs (Bouygues telecom, SFR, Orange), see <a href='https://www.insee.fr/fr/statistiques/4635407'>Galiana et al (2020).</a><br>
		</div>
		</div>
	</div>"
               ),2
             )),
  tar_target(
    htmls_files,
    c(
      'html/inflows_FR.html',
      'html/inflows_EN.html',
      'html/outflows_FR.html',
      'html/outflows_EN.html'
    )
  ),
  tar_target(
    htmls_langue,
    rep(langue, 2)),
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
                 ODsGeo, inflows, langue, titles
               )),
               pattern = map(cross(
                 ODsGeo, inflows, langue
               ), titles)),
    tar_target(synctmaps,
               sync_tmaps(tmaps), iteration = 'list'),
    tar_target(
      savehtmls,
      save_tags(
        print(synctmaps, show = FALSE, full.height = TRUE) %>%
          htmlwidgets::appendContent(htmltools::HTML(infos)),
        htmls_files,
        htmls_langue
      ),
      pattern = map(synctmaps, infos, htmls_files, htmls_langue)
    )
  )
  