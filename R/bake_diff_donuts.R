bake_diff_donuts = function(x,

  text = list(  legend_title = "Region",
                
                period1 = "period 1",
                period2 = "period 2",
                stay_popup = "Stay",
                out_popup = "Out",
                during_popup = "during",
                and_popup = "and",
                add_popup = "Additional stay",
                sub_popup = "More out",
                inflow = "Inward flow",
                outflow = "Outward flow",
                
                flow = "Flow",
                to = "to"),
  
  groupname = "Data",
  
  pal_edges = pals::brewer.rdylgn(5),
  pal_donuts = c("red", "grey50", "grey80", "blue"),
  
  edge_breaks = c(50, 70, 90, 125, 150, 200),
  
  donut_size_min = NA,
  donut_size_max = NA,
  
  flow_th = NA,
  flow_max = NA,
  flow_buffer = NA,
  
  flow_scale = 10,
  
  donut_scale = 1.5,

  legend = TRUE,
  group_label_cex = 1, 
  group_trunc_m = 2000,
  border = NULL,
  tm = NULL
) {
  

  edge_range = c(.5, 1)
  edge_trunc = units::set_units(c(500, 0), "m")
  
  x$E$show = TRUE
  x$U$show = TRUE

  crs = st_crs(x$U)

  create_grobs <- function(U, scale = 1) {
    if (inherits(U, "sf")) U <- sf::st_drop_geometry(U)
    Ulong <- U %>%
      select(name, hh, ho, oh, oo) %>%
      pivot_longer(-name, names_to = "class", values_to = "value") %>%
      replace_na(list(value = 0))
    
    grobs <- lapply(U$name, function(nm) {
      df <- Ulong %>%
        filter(name == nm)
      
      k = nrow(df)
      
      # if (any(df$name == df$class)) {
      #   lvls = c(nm, setdiff(df$class, nm))
      # } else {
      #   lvls = c(df$class[k], df$class[1:(k-1)])
      # }
      # 
      # df = df %>% 
      #   mutate(class = factor(class, levels = lvls))
      singleCat <- sum(df$value != 0) <= 1L
      ggplotGrob(ggplot(df, aes(x=2, y=value, fill = class)) +
                   geom_bar(stat="identity", width=1, size = ifelse(singleCat, 0, 2 * scale), color = "white", show.legend = FALSE) +
                   geom_vline(xintercept = 2.5, color = "white", size = 5 * scale) +
                   geom_rect(xmin = 0, xmax = .75, ymin = 0, ymax = sum(df$value), size = 0, color = "white", fill = "grey90") +
                   geom_vline(xintercept = 1.5, color = "white", size = 5 * scale ) +
                   scale_fill_manual(values = pal_donuts[c(3, 1, 4, 2)]) +
                   coord_polar("y", start=0) +
                   xlim(.75, 2.5) +
                   theme_void())
    })
    names(grobs) <- U$name
    grobs
  }
  
  
  
  # transform to mercator (needed later to draw straight edges in interactive mode) and put name colunm first
  x$U <- x$U %>%
    sf::st_transform(3857) %>%
    select(name, everything())
  
  # create labels ("a to b") and add class_to variable (needed later to color edges)
  x$E <- x$E %>%
    #filter(muni_from != muni_to) %>%
    group_by(code_from, code_to) %>%
    summarize(flow1 = sum(flow1),
              flow2 = sum(flow2), 
              show = show[1]) %>%
    ungroup() %>%
    mutate(name_from = x$U$name[match(code_from, x$U$code)],
           name_to = x$U$name[match(code_to, x$U$code)],
           label = paste(name_from, text$to, name_to)) %>%
    select(label, everything())
  
  #browser()
  
  
  # calculate text$inflow and text$outflow
  x <- odf:::od_sum_out(x, "flow1")
  x <- odf:::od_sum_in(x, "flow1")
  x <- odf:::od_sum_stay(x, "flow1")
  x <- odf:::od_sum_out(x, "flow2")
  x <- odf:::od_sum_in(x, "flow2")
  x <- odf:::od_sum_stay(x, "flow2")
  
  if (is.na(donut_size_max)) {
    donut_size_max = max(x$U$flow1_stay[x$U$show] + x$U$flow1_out[x$U$show])
    message("donut_size_max set to ", donut_size_max)
  }
  if (is.na(donut_size_min)) {
    donut_size_min = donut_size_max / 20
    message("donut_size_min set to ", donut_size_min)
  }
  
  
  x$U <- x$U %>%
    #filter(!(name %in% c("Vlieland", "Terschelling",  "Ameland", "Schiermonnikoog"))) %>%
    mutate(size = pmin(donut_size_max, pmax(donut_size_min, flow1_stay + flow1_out)))
  
  # h = home, o = out
  x$U = x$U %>% 
    mutate(hh = pmin(flow1_stay, flow2_stay),
           ho = ifelse(flow1_stay > flow2_stay, flow1_stay - flow2_stay, 0),
           oh = ifelse(flow1_stay < flow2_stay, flow2_stay - flow1_stay, 0),
           oo = pmin(flow1_out, flow2_out))
  

  ###########################################################################################
  #### create lines and doughnuts
  ###########################################################################################
  grobs <- create_grobs(x$U %>% filter(show), scale = .25)
  
  if (is.na(flow_max)) {
    flow_max = max(x$E$flow1[x$E$code_from != x$E$code_to & x$E$show])
    message("flow_max set to ", flow_max)
  }
  
  if (is.na(flow_th)) {
    flow_th = flow_max / 40
    message("flow_th set to ", flow_th)
  }
  
  if (is.na(flow_buffer)) {
    flow_buffer = flow_th
    message("flow_buffer set to ", flow_buffer)
  }
    
  
  x$E <- x$E %>%
    filter(flow1 >= flow_th) %>% 
    mutate(flow_rel = round((flow2 / flow1) * 100))
  
  # create straight lines from midpoint to endpoints
  x <- od_add_lines(x, angle = 0, range = edge_range, trunc = edge_trunc, min_trunc_dist = units::set_units(1000, "m"))

  
  ###########################################################################################
  #### process data for popups
  ###########################################################################################

  vars = c("hh", "ho", "oh", "oo")         
  names(vars) = c(paste(text$stay_popup, text$during_popup, text$period1, text$and_popup, text$period2),
           paste(text$sub_popup, text$during_popup, text$period2),
           paste(text$add_popup, text$during_popup, text$period2),
           paste(text$out_popup, text$during_popup, text$period1, text$and_popup, text$period2))
  
  lns <- x$E %>%
    filter(show, name_from != name_to) %>%
    mutate(width = flow_buffer + pmin(flow1, flow_max)) %>%
    select(label, flow1, flow2, width, flow_rel) %>%
    arrange(desc(flow1))
  pnts <- x$U %>%
    filter(show) %>%
    rename(!!vars)
  
  names(lns)[names(lns) == "flow1"] = paste(text$flow, text$during_popup, text$period1)
  names(lns)[names(lns) == "flow2"] = paste(text$flow, text$during_popup, text$period2)
  pnts = pnts %>% 
    select( !!c("name", "size", names(vars)))
  
  set_precision <- function(x, precision = 4) {
    crs = st_crs(x)
    sf::st_geometry(x) <- sf::st_as_sfc(lapply(sf::st_geometry(x), function(y) {
      y[] <- round(y[], precision)
      y
    }))
    st_set_crs(x, crs)
  }
  
  
  lns <- lns %>%
    sf::st_transform(4326) %>%
    set_precision(4)
  
  
  pnts <- pnts %>%
    sf::st_transform(4326) %>%
    set_precision(4)
  
  
  if (is.null(tm)) {
    tm <- tm_basemap(c("Esri.WorldGrayCanvas", "OpenStreetMap"))  
  }

  if (!is.null(border)) {
    tm = tm + tm_shape(border) + tm_borders(col = "black", lwd = 2, group = groupname)
  }
  
  tm = tm +
    tm_shape(lns) +
    tm_lines(lwd = "width", scale = flow_scale, col = "flow_rel", id = "label", popup.vars = names(lns)[2:3], palette = rev(pal_edges), title.col = text$legend_title, group = groupname, legend.col.show = legend, breaks = edge_breaks)#c(50, 70, 90, 100, 125, 150, 200))
  
  

  tm = tm + tm_shape(pnts) +
    tm_symbols(size = "size", scale = donut_scale, size.max = donut_size_max, id = "name", popup.vars = names(vars),
               shape = "name", shapes = grobs, legend.shape.show = FALSE, grob.dim = c(width = 48, height = 48, render.width = 96, render.height = 96), group = groupname)
  

  #if (!is.null(view_args)) tm <- tm + do.call(tm_view, view_args)
  
  tm
  
}