server <- function(input, output, session){
  
  connection<-connect_sqlite(auto_disconnect = F)
  create_schema("notes", connection)
  db.write_table(connection, schema = "notes", table = "scroll_demo", shinyNotes::demo_notes)
  
  callModule(module = shinynotes, 
             id = "paragraph",
             style_options = reactive({list(
               "type" = input$note_style, 
               "header" = list("color" = input$header_color),
               "panel" = list("background" = input$background_color, "scrollY" = input$overflow_y)
             )}),
             group_column = "package",
             selected_group = reactive(input$paragraph_group),
             group_options = c("shiny", "shinyWidgets", "dplyr"),
             table_id = list(table = "scroll_demo", schema = "notes"),
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