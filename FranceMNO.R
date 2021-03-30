# if (!requireNamespace("odf")) remotes::install_github("mtennekes/odf")
# remotes::install_github("r-spatial/leafsync") # requires the github version of leafsync
# remotes::install_github("mtennekes/tmap") # latest github version of tmap required to improve the popups

library(odf) 
library(tidyverse)
library(sf)
library(remotes)
library(tmap)
library(tmaptools)
library(leafsync)
library(htmlwidgets)
library(htmltools)


source("R/bake_donuts.R")
source("R/maps_utils.R")

vizLink <- 'https://InseeFrLab.github.io/lockdown-maps-R/'
# -- load data
dm_centroid <- departement_centroids()
ODs <- get_ODs()

# -- create od objects
ODsGeo <- lapply(ODs, FUN = function(od) get_ODsGeo(od, dm_centroid))

# -- tmaps
langue <- c("fr-FR", "en-US")
inflows <- c(TRUE,FALSE)

dir.create('html')

html_names <- function(inflows, langue){
  names <- data.frame(name = c(
    'html/inflows_FR.html',
    'html/inflows_EN.html',
    'html/outflows_FR.html',
    'html/outflows_EN.html'
  ), 
  name_link_langue = c(
    'To English Version',    
    'vers Version Française',
    'To English Version',    
    'vers Version Française'
  ),
  name_link_flows = c(
    'vers Flux Sortants',
    'To Outflows',
    'vers Flux Entrants',
    'To Inflows'
    ),
  inflow = rep(c(TRUE,FALSE), each = 2),
  lang = rep(c("fr-FR", "en-US"), 2))
  names[names$inflow==inflows & names$lang == langue, c("name","name_link_langue","name_link_flows")]
}

title <- function(i, inflows, langue){
  titles <- data.frame(title = c(
    'Flux entrants avant le 1er confinement',
    "Inflows before the 1rst lockdown",
    "Flux sortants avant le 1er confinement",
    "Outflows before the 1rst lockdown",
    "Flux entrants après",
    "Inflows after the 1rst lockdown",
    "Flux sortants après",
    "Outflows after the 1rst lockdown"
  ), before = rep(c(1,2), each = 4), 
     inflow = rep(rep(c(TRUE,FALSE), each = 2),2),
     lang = rep(c("fr-FR", "en-US"), 4))
  titles[titles$before == i & titles$inflow==inflows & titles$lang == langue, "title"]
}

tMaps <- lapply(langue, FUN = function(lang)
                lapply(inflows, FUN = function(inflow)
                  lapply(1:2, FUN = function(i)
                              build_tmap(ODsGeo[[i]], inflow, lang, title(i = i, inflows = inflow, langue = lang)))))


# -- Synchronized tmaps
synctMaps <- lapply(1:length(langue), FUN = function(i_lang)
                lapply(1:length(inflows), FUN = function(i_inflow)
                  tmap_arrange(tMaps[[i_lang]][[i_inflow]])))
    
HTMLInfos <- c(
	"<div id='info' class='info legend leaflet-control' style='display:block;height:80px;position: absolute; bottom: 10px; right: 10px;background-color: rgba(255, 255, 255, 0.8);' >
		<div style='margin-top:5px;font-size:75%'>
		Les cercles représentent la population présente en nuitées, résidents habituels <br>
		et résidents d'autres département en nuitées. La visualisation a été construite par CBS. <br>
		XXXLINKLINEXX
	   Ces données, retraitées par l'Insee, combinent des comptages anonymes de trois <br> 
		opérateurs de téléphonie mobiles (Bouygues telecom, SFR, Orange) <a href='https://www.insee.fr/fr/statistiques/4635407'>Galiana et al (2020).</a><br>
		</div>
		</div>
	</div>",
	"<div id='info' class='info legend leaflet-control' style='display:block;height:80px;position: absolute; bottom: 10px; right: 10px;background-color: rgba(255, 255, 255, 0.8);' >
		<div style='margin-top:5px;font-size:75%'>
		Circles represent the population staying overnight, usual residents and residents from other <br>
		département. The visualisation was build by CBS. The data were made available by INSEE.<br>
		XXXLINKLINEXX
	 They were statistically adjusted and combined from anonymous <br> 
		 counts provided by three MNOs (Bouygues telecom, SFR, Orange), see <a href='https://www.insee.fr/fr/statistiques/4635407'>Galiana et al (2020).</a><br>
		</div>
		</div>
	</div>")

HTMLInfos <- lapply(1:2, FUN = function(i_lang)
       lapply(inflows, FUN = function(inflow)
         gsub('XXXLINKLINEXX',
                      sprintf("<a href='%s%s'>%s</a>  <a href=' %s%s '>%s</a><br>", 
                              vizLink,html_names(!inflow, langue[i_lang])$name,html_names(inflow, langue[i_lang])$name_link_flows,
                              vizLink,html_names(!inflow, langue[(i_lang+1)%/%2])$name,html_names(inflow, langue[i_lang])$name_link_langue), HTMLInfos[i_lang])
              ))


# --- With infos.
tmap_mode('view')
synctMapsInfo <- lapply(1:length(langue), FUN = function(i_lang)
                    lapply(1:length(inflows), FUN = function(i_inflow)
                              print(synctMaps[[i_lang]][[i_inflow]], show = FALSE, full.height = TRUE) %>%  
    htmlwidgets::appendContent(htmltools::HTML(HTMLInfos[[i_lang]][[i_inflow]]))))
  

# --- save htmls
lapply(1:length(langue), FUN = function(i_lang)
  lapply(1:length(inflows), FUN = function(i_inflow)
    save_tags(synctMapsInfo[[i_lang]][[i_inflow]], html_names(inflows = (i_inflow == 1),langue[i_lang])$name, lang = langue[i_lang])
  )
)
    
