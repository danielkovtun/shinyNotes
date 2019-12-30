ui <- fixedPage(
  shinyjs::useShinyjs(),
  fixedRow(
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        radioGroupButtons("paragraph_group", label = "Paragraph Group:", 
                          choices = c("shiny", "shinyWidgets", "dplyr"), selected = "shiny",
                          status = "primary",
                          justified = T
        ),
        radioButtons("note_style", label = "Style", choices = c("bullets", "paragraph"), selected = "bullets", inline = T),
        spectrumInput(
          inputId = "header_color",
          label = "Header color for sections:",
          selected = "steelblue",
          choices = color_opts,
          options = list(`toggle-palette-more-text` = "Show more")
        ),
        spectrumInput(
          inputId = "background_color",
          label = "Background color for text area:",
          selected = "#fffbf3",
          choices = color_opts,
          options = list(`toggle-palette-more-text` = "Show more")
        ),
        materialSwitch(
          inputId = "overflow_y", 
          label = "Scroll", 
          value = TRUE,
          status = "default", 
          inline = T, 
          width = "100%"
        )
      ),
      mainPanel = column(8, shinynotesUI('paragraph'))
    )
  )
)
