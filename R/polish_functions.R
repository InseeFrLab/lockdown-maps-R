
addLegendCustom <- function(map, colors, labels, sizes, shapes, borders, opacity = 0.5, group, className, title){
	n = length(colors)
	sizes = rep(sizes, length.out = n)
	shapes = rep(shapes, length.out = n)
	borders = rep(borders, length.out = n)
	
	make_shapes <- function(colors, sizes, borders, shapes) {
		shapes <- gsub("circle", "50%", shapes)
		shapes <- gsub("square", "0%", shapes)
		paste0(colors, "; width:", sizes, "px; height:", sizes, "px; border:0px solid ", borders, "; border-radius:", shapes)
	}
	make_labels <- function(sizes, labels) {
		paste0("<div style='display: inline-block;height: ", 
			   sizes, "px;line-height: ", 
			   sizes, "px;'>", labels, "</div>")
	}#margin-top: 2px;
	
	legend_colors <- make_shapes(colors, sizes, borders, shapes)
	legend_labels <- make_labels(sizes, labels)
	
	return(addLegend(map, colors = legend_colors, labels = legend_labels, opacity = opacity, group = group, className = className, title = title))
}

add_legends = function(lf, highlight, pal, group, text) {
	addLegendCustom(lf, pal, 
					labels = c(highlight, text$legend_other, text$legend_stay),
					sizes = 15,
					shapes = "sqaure",
					borders = "white",
					opacity = 1,
					group = group,
					className = paste("info legend", gsub(" ", "", group, fixed = TRUE)),
					title = text$legend_title
	)
}

