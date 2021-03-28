departement_centroids <- function() {
  dm <-
    st_read("data/departements2154_dm.geojson", stringsAsFactors = FALSE)
  dm$libelle[dm$code %in% c('2A', '2B')] <- "Corse"
  dm$code[dm$code %in% c('2A', '2B')] <- "2AB"
  dm <-
    dm %>% group_by(code, libelle) %>% summarise(geometry = st_union(geometry)) %>% ungroup()
  dm_centroid <- dm %>%
    st_centroid(of_largest_polygon = TRUE) %>%
    select(code = code, name = libelle)
  dm_centroid$geometry[dm_centroid$code == '2AB'] <-
    sf::st_point(x = c(1199785, 6124519))
  
  return(dm_centroid)
}


get_ODs <- function() {
  data <- read.csv('data/data.csv')
  
  od_before = data %>%
    select(code_from = departementRes,
           code_to = departementPres,
           flow = popPres_before)
  
  od_during = data %>%
    select(code_from = departementRes,
           code_to = departementPres,
           flow = popPres_after)
  
  return(list(od_before = od_before, od_during = od_during))
  
}


get_ODsGeo <- function(od, dm_centroid) {
  od(
    od,
    dm_centroid,
    col_orig = "code_from",
    col_dest = "code_to",
    col_id = "code"
  )
}

map_parameters <- function(langue = 'en-US') {
  # specific departments (in this example Paris) for which specific colors are used:
  if (langue == 'fr-FR') {
    highlight = c("Paris et petite couronne",
                  "Alpes (Savoie, Haute-Savoie, Hautes-Alpes)")
    groups = list(
      list(
        codes = c("75", "92", "94", "93"),
        longlat = c(2.3488, 48.8534),
        name = "Paris et petite couronne",
        code = "999",
        donut = TRUE,
        inflow = TRUE,
        outflow = TRUE
      ),
      list(
        codes = c("05", "73", "74"),
        longlat = c(6.3927, 45.6755),
        name = "Alpes (Savoie, Haute-Savoie, Hautes-Alpes)",
        code = "9999",
        donut = TRUE,
        inflow = TRUE,
        outflow = TRUE
      )
    )
    text = list(
      legend_title = "Département de nuitée",
      legend_other = "Autres départements",
      legend_stay = "Département de résidence",
      popup_residents = "Résidents",
      popup_stay = "Restant dans leur département",
      popup_outflow = "Allant dans un autre département",
      popup_to = "&nbsp;&nbsp;&nbsp;&nbsp;",
      # four spaces before highlighed regions
      popup_other = "&nbsp;&nbsp;&nbsp;&nbsp;autres départements",
      popup_inflow = "Provenant d'autres départements",
      edge_to = "vers",
      edge_flow = "Flux"
    )
    
    
  } else{
    highlight = c("Paris area", "Alps area")
    groups = list(
      list(
        codes = c("75", "92", "94", "93"),
        longlat = c(2.3488, 48.8534),
        name = "Paris area",
        code = "999",
        donut = TRUE,
        inflow = TRUE,
        outflow = TRUE
      ),
      list(
        codes = c("05", "73", "74"),
        longlat = c(6.3927, 45.6755),
        name = "Alps area",
        code = "9999",
        donut = TRUE,
        inflow = TRUE,
        outflow = TRUE
      )
    )
    text = list(
      legend_title = "Overnight Stay",
      legend_other = "Other area (département)",
      legend_stay = "Home département",
      popup_residents = "Residents",
      popup_stay = "Staying",
      popup_outflow = "Outflow",
      popup_to = "&nbsp;&nbsp;&nbsp;&nbsp;",
      # four spaces before highlighed regions
      popup_other = "&nbsp;&nbsp;&nbsp;&nbsp;other départements",
      popup_inflow = "Inflow",
      edge_to = "to",
      edge_flow = "Flow"
    )
    
  }
  
  # the color palette should consist of (length(highlight) + 2) colors, where the last two are recommended to be {blue} and {gray} (for other and home region respectively)
  pal <-
    c(setdiff(
      colorspace::qualitative_hcl(
        length(highlight),
        palette = "Dark3",
        c = 100,
        l = 50
      ),
      "#3573E2"
    ),
    "#3573E2" ,
    "gray70")
  
  list(
    highlight = highlight,
    groups = groups,
    text = text,
    pal = pal
  )
  
}


build_tmap <- function(od, inflow, langue, title) {
  param <- map_parameters(langue)
  bake_donuts(
    od,
    highlight = param$highlight,
    pal = param$pal,
    donut_size_max = 2.5e6,
    donut_size_min = .15e6,
    flow_max = 70000,
    flow_th = 5000,
    flow_buffer = 2000,
    text = param$text,
    groups = param$groups,
    edge_incoming = inflow,
    title = title,
    round_to = 1000
  )
  
}

# Write our own pandoc_self_contained_html function
# because rmarkdown::pandoc_self_contained_html
# and htmlwidgets:::pandoc_self_contained_html have some bugs
pandoc_self_contained_html <- function(input, output, lang) {
  if (!rmarkdown::pandoc_available("2.0.5")) {
    stop("Pandoc >= 2.0.5 must be available from R.")
  }
  
  input <- normalizePath(input)
  if (!file.exists(output)) {
    file.create(output)
  }
  output <- normalizePath(output)
  stopifnot(is.character(lang))
  stopifnot(length(lang) == 1)
  
  xml_tree <- xml2::read_html(input)
  html_head <- as.character(xml2::xml_find_all(xml_tree, ".//head/*"))
  include_in_header <- tempfile(fileext = ".html")
  writeLines(html_head, include_in_header)
  on.exit(unlink(include_in_header), add = TRUE)
  
  template <- tempfile(fileext = ".html")
  writeLines(con = template, c(
    "<!DOCTYPE html>",
    "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"$lang$\" xml:lang=\"$lang$\">",
    "<head>",
    "$for(header-includes)$",
    "  $header-includes$",
    "$endfor$",
    "</head>",
    "<body>",
    "$body$",
    "</body>",
    "</html>"
  ))
  on.exit(unlink(template), add = TRUE)
  
  outfile <- tempfile(fileext = ".html")
  on.exit(unlink(outfile), add = TRUE)
  
  cur_dir <- setwd(dirname(input))
  on.exit(setwd(cur_dir), add = TRUE)
  
  system2(
    rmarkdown::pandoc_exec(), 
    args = c(
      "--from=html-native_divs-native_spans+raw_html+empty_paragraphs",
      "--to=html",
      "--self-contained",
      sprintf("--include-in-header=%s", shQuote(include_in_header)),
      "--metadata", "title=' '",
      "--metadata", sprintf("lang='%s'", lang),
      sprintf("--template=%s", shQuote(template)),
      input
    ),
    stdout = outfile
  )
  
  file.copy(outfile, output, overwrite = TRUE)
  
  invisible(output)
}

save_tags <- function(tags, file, background = "white", lang = "en") {
  libdir <- paste0(tools::file_path_sans_ext(file), "_lib")
  htmltools::save_html(html = tags, 
                       file = file, 
                       background = background, 
                       libdir = basename(libdir), 
                       lang = lang)
  on.exit(unlink(libdir, recursive = TRUE), add = TRUE)
  pandoc_self_contained_html(file, file, lang)
  invisible(file)
}


sync_tmaps <- function(list_tmaps) {
  
  synctmaps <-
    lapply(
      seq(1, length(list_tmaps), 2),
      FUN = function(i)
        tmap_arrange(list_tmaps[[i]], list_tmaps[[i + 1]])
    )
  return(synctmaps)
}

