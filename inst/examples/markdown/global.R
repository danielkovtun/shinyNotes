suppressMessages(require(shiny, quietly = T)) 
suppressMessages(require(shinyWidgets, quietly =T))
suppressMessages(require(shinyNotes, quietly = T))

color_opts <- list(
  list("black", "white", "blanchedalmond", "steelblue", "forestgreen"),
  as.list(RColorBrewer::brewer.pal(n = 9, name = "Blues")),
  as.list(RColorBrewer::brewer.pal(n = 9, name = "Greens")),
  as.list(RColorBrewer::brewer.pal(n = 11, name = "Spectral")),
  as.list(RColorBrewer::brewer.pal(n = 8, name = "Dark2"))
)