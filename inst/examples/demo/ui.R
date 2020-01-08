ui <- fixedPage(
  shinyjs::useShinyjs(),
  fixedRow(
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        width = 5,
        radioGroupButtons("note_group", label = "Note Group:", 
                          choices = c("shiny", "shinyWidgets", "dplyr"), selected = "shiny",
                          status = "primary",
                          justified = T
        ),
        fluidRow(
          column(6, align = "center",
                 awesomeRadio(
                   inputId = "note_style",
                   label = "Style",
                   choices = c("bullets", "paragraph"),
                   selected = "bullets",
                   inline = T,
                   status = "primary", 
                   checkbox = FALSE, 
                   width = "100%"
                   )
          ),
          column(6, align = "center",
                 br(),
                 materialSwitch(
                   inputId = "overflow_y", 
                   label = "Scroll", 
                   value = TRUE,
                   status = "default", 
                   inline = T, 
                   width = "100%"
                 )
          )
        ),
        fluidRow(
          column(6,
                 noUiSliderInput(
                   inputId = "height", label = "Max Panel Height:",
                   min = 1, max = 2000, value = 600,
                   color = "#96b8d5",
                   format = wNumbFormat(decimals = 0, suffix = "px"),
                   width = "100%"
                 ),
                 spectrumInput(
                   inputId = "header_color",
                   label = "Header color:",
                   selected = "steelblue",
                   choices = color_opts,
                   options = list(`toggle-palette-more-text` = "Show more")
                 )
          ),
          column(6,
                 noUiSliderInput(
                   inputId = "width", label = "Panel Width:",
                   min = 1, max = 100, value = 90,
                   color = "#96b8d5",
                   format = wNumbFormat(decimals = 0, suffix = "%"),
                   width = "100%"
                 ),
                 spectrumInput(
                   inputId = "background_color",
                   label = "Background color:",
                   selected = "#fdfeff",
                   choices = color_opts,
                   options = list(`toggle-palette-more-text` = "Show more")
                 )
          )
        ),
        numericInput("padding", label = "Padding", value = 4, min = 0, max = 100),
        selectizeInput(
          inputId = "status",
          label = "Bootstrap Status",
          choices = c("default", "primary", "info", "warning", "danger", "success"),
          selected = "default",
          width = "100%",
          multiple = TRUE,
          options = list(maxItems = 1, create = F, placeholder = 'Select a status...')
        )
      ),
      mainPanel = column(7, shinynotesUI('Package'))
    )
  )
)
