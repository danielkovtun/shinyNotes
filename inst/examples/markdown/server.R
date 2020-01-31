server <- function(input, output, session){
  
  connection<-connect_sqlite(auto_disconnect = F)
  create_schema("notes", connection)
  db.write_table(connection, schema = "notes", table = "markdown_demo", markdown_notes)
  
  callModule(module = shinynotes, 
             id = "Markdown",
             style_options = reactive({list(
               "type" = input$note_style, 
               "header" = list("color" = input$header_color),
               "panel" = list(
                 "status" = input$status,
                 "background" = input$background_color, 
                 "scrollY" = input$overflow_y, 
                 "padding" = paste0(input$padding, "px"),
                 "width" = paste0(input$width, "%"),
                 "max_height" = paste0(input$height, "px"),
                 "border_color" = input$border_color,
                 "border_style" = input$border_style,
                 "border_width" = paste0(input$border_width, "px")
                 )
             )}),
             group_column = "formatting",
             selected_group = reactive(input$note_group),
             group_options = c("markdown"),
             table_id = list(table = "markdown_demo", schema = "notes"),
             db_conn = connection
  )
  
  # Register function to be called after client has disconnected
  session$onSessionEnded(function() {
    
    isolate({
      cat(file = stderr(), "Client session has ended", "\n")
      db_close <- tryCatch(
        { 
          DBI::dbDisconnect(connection)
        },
        error=function(error_message){return(FALSE)}
      )
      msg <- ifelse(db_close, "Connection to database successfully closed", "Error disconnecting from database")
      cat(file = stderr(), msg, "\n")
    })
  })
}