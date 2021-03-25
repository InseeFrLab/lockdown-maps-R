if (!requireNamespace("odf")) remotes::install_github("mtennekes/odf")
library(odf) # this is a class package for OD data, but in development

library(leafsync)
library(tidyverse)
library(sf)
library(remotes)

remotes::install_github("r-spatial/leafsync") # requires the github version of leafsync
remotes::install_github("mtennekes/tmap") # latest github version of tmap required to improve the popups
library(tmap)
library(tmaptools)

#library(remotes)
library(htmlwidgets)
#library(htmltools)

# load script to make donuts
source("R/bake_donuts.R")

##################################################
#### load data
##################################################

dm = st_read("data/departements2154_dm.geojson", stringsAsFactors = FALSE)
dm$libelle[dm$code %in% c('2A','2B')] <- "Corse"
dm$code[dm$code %in% c('2A','2B')] <- "2AB"
dm <- dm %>% group_by(code,libelle) %>% summarise(geometry = st_union(geometry)) %>% ungroup()

# extract centroids
dm_centroid = dm %>% 
	st_centroid(of_largest_polygon = TRUE) %>% 
	select(code = code, name = libelle)
dm_centroid$geometry[dm_centroid$code == '2AB'] <- sf::st_point(x = c(1199785, 6124519))

# check dm and dm_centroid
tmap_mode("view")
qtm(dm) + qtm(dm_centroid)

data <- read.csv('data/data.csv')

# the OD dataset before lockdown
od_before = data %>% 
  select(code_from = departementRes,
         code_to = departementPres,
         flow = popPres_before)

# the OD dataset during lockdown
od_during = data %>% 
  select(code_from = departementRes,
         code_to = departementPres,
         flow = popPres_after)


##################################################
#### create OD data objects (class 'od') and set plot settings
##################################################


# Create od objects
x_before <- od(od_before, dm_centroid, col_orig = "code_from", col_dest = "code_to", col_id = "code")
x_during <- od(od_during, dm_centroid, col_orig = "code_from", col_dest = "code_to", col_id = "code")


# specific departments (in this example Paris) for which specific colors are used:
highlightFR = c("Paris et petite couronne","Alpes (Savoie, Haute-Savoie, Hautes-Alpes)")
highlightEN = c("Paris area","Alps area")

# the color palette should consist of (length(highlight) + 2) colors, where the last two are recommended to be {blue} and {gray} (for other and home region respectively)
pal <- c(setdiff(colorspace::qualitative_hcl(length(highlightFR), palette = "Dark3", c = 100, l = 50),"#3573E2" ), "#3573E2" ,"gray70")

##################################################
#### create plots
##################################################

textEN = list(legend_title = "Overnight Stay",  
			  legend_other = "Other area (département)",
			  legend_stay = "Home département",
			  
			  popup_residents = "Residents",
			  popup_stay = "Staying",
			  popup_outflow = "Outflow",
			  popup_to = "&nbsp;&nbsp;&nbsp;&nbsp;",  # four spaces before highlighed regions
			  popup_other = "&nbsp;&nbsp;&nbsp;&nbsp;other départements",
			  popup_inflow = "Inflow",
			  edge_to = "to",
			  edge_flow = "Flow")

textFR = list(legend_title = "Département de nuitée",  
			  legend_other = "Autres départements",
			  legend_stay = "Département de résidence",
			  popup_residents = "Résidents",
			  popup_stay = "Restant dans leur département",
			  popup_outflow = "Allant dans un autre département",
			  popup_to = "&nbsp;&nbsp;&nbsp;&nbsp;",  # four spaces before highlighed regions
			  popup_other = "&nbsp;&nbsp;&nbsp;&nbsp;autres départements",
			  popup_inflow = "Provenant d'autres départements",
			  edge_to = "vers",
			  edge_flow = "Flux")


groupsFR = list(
	list(codes = c("75", "92", "94", "93"), 
		 longlat = c(2.3488, 48.8534), 
		 name = "Paris et petite couronne", code = "999", donut = TRUE, inflow = TRUE, outflow = TRUE),
	list(codes = c("05", "73", "74"), longlat = c(6.3927, 45.6755), name = "Alpes (Savoie, Haute-Savoie, Hautes-Alpes)", code = "9999", donut = TRUE, inflow = TRUE, outflow = TRUE))


groupsEN = list(
	list(codes = c("75", "92", "94", "93"), 
		 longlat = c(2.3488, 48.8534), 
		 name = "Paris area", code = "999", donut = TRUE, inflow = TRUE, outflow = TRUE),
	list(codes = c("05", "73", "74"), longlat = c(6.3927, 45.6755), name = "Alps area", code = "9999", donut = TRUE, inflow = TRUE, outflow = TRUE))


map_version <- function(x, text = textEN, highlight = highlightEN, groups = groupsEN, inflows = TRUE, title = "Inflows before lockdown"){
	bake_donuts(x, highlight = highlight, pal = pal, donut_size_max = 2.5e6, donut_size_min = .15e6, flow_max = 70000, flow_th = 5000, flow_buffer = 2000, text = text, groups = groups, edge_incoming = inflows, title = title, round_to = 1000)
}

tm_before_in_EN <- map_version(x_before, textEN, highlightEN, groupsEN, inflows = TRUE,  title = "Inflows before the first lockdown")
tm_before_out_EN <- map_version(x_before, textEN, highlightEN, groupsEN, inflows = FALSE,  title = "Outflows before the first lockdown")
tm_during_in_EN <- map_version(x_during, textEN, highlightEN, groupsEN, inflows = TRUE,  title = "Inflows during the first lockdown")
tm_during_out_EN <- map_version(x_during, textEN, highlightEN, groupsEN, inflows = FALSE,  title = "Outflows during the first lockdown")

tm_before_in_FR <- map_version(x_before, textFR, highlightFR, groupsFR, inflows = TRUE,  title = "Flux entrants avant le premier confinement")
tm_before_out_FR <- map_version(x_before, textFR, highlightFR, groupsFR, inflows = FALSE,  title = "Flux sortants avant le premier confinement")
tm_during_in_FR <- map_version(x_during, textFR, highlightFR, groupsFR, inflows = TRUE,  title = "Flux entrants pendant le premier confinement")
tm_during_out_FR <- map_version(x_during, textFR, highlightFR, groupsFR, inflows = FALSE,  title = "Flux sortants pendant le premier confinement")

# plot side by side
tm_b_and_d_in_FR = tmap_arrange(tm_before_in_FR, tm_during_in_FR, sync = TRUE)
tm_b_and_d_out_FR = tmap_arrange(tm_before_out_FR, tm_during_out_FR, sync = TRUE)
tm_b_and_d_in_EN = tmap_arrange(tm_before_in_EN, tm_during_in_EN, sync = TRUE)
tm_b_and_d_out_EN = tmap_arrange(tm_before_out_EN, tm_during_out_EN, sync = TRUE)

##################################################
#### add text for side-by-side plot
##################################################

HTML_EN = "<div id='info' class='info legend leaflet-control' style='display:block;height:140px;position: absolute; bottom: 10px; right: 10px;background-color: rgba(255, 255, 255, 0.8);' >
		<div style='margin-top:5px;font-size:75%'>
		Circles represent the population staying overnight, usual residents and residents <br>
		from other département. The visualisation was build by CBS. The data were made <br>
		available by INSEE. They were statistically adjusted and combined from anonymous <br> 
		 counts provided by three MNOs (Bouygues telecom, SFR, Orange), see <a href='https://www.insee.fr/fr/statistiques/4635407'>Galiana et al (2020).</a><br>
		</div>
		</div>
	</div>"

HTML_FR = "<div id='info' class='info legend leaflet-control' style='display:block;height:120px;position: absolute; bottom: 10px; right: 10px;background-color: rgba(255, 255, 255, 0.8);' >
		<div style='margin-top:5px;font-size:75%'>
		Les cercles représentent la population présente en nuitées, résidents habituels <br>
		et résidents d'autres département en nuitées. La visualisation a été construite par CBS. <br>
	   Ces données, retraitées par l'Insee, combinent des comptages anonymes de trois <br> 
		opérateurs de téléphonie mobiles (Bouygues telecom, SFR, Orange) <a href='https://www.insee.fr/fr/statistiques/4635407'>Galiana et al (2020).</a><br>
		</div>
		</div>
	</div>"

lf_in_FR = print(tm_b_and_d_in_FR, show = FALSE, full.height = TRUE) %>%  
	htmlwidgets::appendContent(htmltools::HTML(HTML_FR)) 
lf_in_EN = print(tm_b_and_d_in_EN, show = FALSE, full.height = TRUE) %>%  
	htmlwidgets::appendContent(htmltools::HTML(HTML_EN)) 
lf_out_FR = print(tm_b_and_d_out_FR, show = FALSE, full.height = TRUE) %>%  
	htmlwidgets::appendContent(htmltools::HTML(HTML_FR)) 
lf_out_EN = print(tm_b_and_d_out_EN, show = FALSE, full.height = TRUE) %>%  
	htmlwidgets::appendContent(htmltools::HTML(HTML_EN)) 

# Autre option que d'exporter à la main? https://github.com/r-spatial/mapview/issues/35
# https://community.rstudio.com/t/save-viewer-object-rendered-in-rstudio-as-image/32796/6
lf_in_FR
lf_out_FR
lf_in_EN
lf_out_EN
# full.height?