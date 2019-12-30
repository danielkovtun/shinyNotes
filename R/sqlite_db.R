#' @title Add schema to a sqlite database
#' @description Wrapper function to create a new schema in a sqlite database for local development.
#' @param schema Schema name
#' @param con A sqlite connection cursor
#' @examples
#' con <- connect_sqlite()
#' create_schema(con, schema = "demo")
#'
#' @importFrom magrittr "%>%"
#' @export
create_schema <- function(schema, con){
  # Add auxilary schema
  result <- tryCatch({
    tmp <- tempfile()
    DBI::dbExecute(con, paste0("ATTACH '", tmp, "' AS ", schema))
  })
  
}
#' @title Create a local sqlite connection
#' @description Wrapper function to return a sqlite connection cursor for local development.
#' @param auto_disconnect Should the connection be automatically closed when the src is deleted? Set to TRUE if you initialize the connection the call to src_dbi(). Pass NA to auto-disconnect but print a message when this happens. cursor
#' @examples
#' connect_sqlite()
#'
#' @importFrom magrittr "%>%"
#' @export
connect_sqlite <- function(auto_disconnect = TRUE){
  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  src <- dbplyr::src_dbi(con, auto_disconnect = auto_disconnect)
  return(con)  
}

#' @title Read remote database tables into data frames with validation
#' @description Wrapper function to read table from schema, return NA by default if permission error (or other).
#'
#' @param con A DBIConnection object, as returned by dbConnect().
#' @param table A character string specifying the DBMS table name.
#' @param schema A character string specifying the schema in which the table is nested.
#' @param collect A boolean specifying whether the query results should be collected into memory or left as a lazy query.
#' @param error_value Error value to return if dbReadTable fails. Default is NA.
#'
#' @examples
#' con <- connect_sqlite(auto_disconnect = FALSE)
#' dplyr::copy_to(con, iris, "df", temporary = FALSE)
#' db.read_table(con = con, table = 'df')
#'
#' @importFrom magrittr "%>%"
#' 
#' @export
db.read_table <- function(con, table, schema=NA, collect=TRUE, error_value=NA) {
  cat(file = stderr(), "Reading table ", table, "\n")
  res <- tryCatch({
    if("SQLiteConnection" %in% class(con)){
      if(is.na(schema)){
        tbl_qry <- DBI::dbReadTable(con, table)
      } else{
        tbl_qry <- DBI::dbReadTable(con, dbplyr::in_schema(schema = schema, table = table)) 
      }
      tbl_qry <- dplyr::as.tbl(tbl_qry)
    } else{
      if(is.na(schema)){
        qry <- paste0('SELECT * FROM "', table, '"')
      } else{
        qry <- paste0('SELECT * FROM "', schema, '".', '"', table, '"')
      }
      qry <- dplyr::sql(qry) 
      tbl_qry <- dplyr::tbl(con, qry)
      
      if (collect) {
        tbl_qry <- tbl_qry %>% dplyr::collect()
      }
    }
    tbl_qry
  },
  error = function(error_message) {
    return(error_value)
  }
  )
  return(res)
}


#' @title Read remote database tables into data frames with validation
#' @description Wrapper function to write data to table in schema, return TRUE if successful, FALSE otherwise.
#'
#' @param con A DBIConnection object, as returned by dbConnect().
#' @param data A data.frame, tbl, or other valid sql data type containing the data to write to the database.
#' @param table A character string specifying the DBMS table name.
#' @param schema A character string specifying the schema in which the table is nested.
#' @param append_only A boolean specifying whether the operation is INSERT or UPDATE.
#' Default of append_only = F means execute DELETE on table, and update with new data.
#' @param drop_overwrite A boolean specifying whether the operation is DROP and INSERT. This will overwrite any existing field types.
#'
#' @examples
#' connection <- connect_sqlite(auto_disconnect = FALSE)
#'
#' db.write_table(con = connection, table = 'iris', data = iris)
#'
#' @export
db.write_table <- function(con, data, table, schema = NA, append_only = F, drop_overwrite = NA){
  ## Add backup read - don't commit DELETE immediately
  if(!is.na(schema)){
    if("SQLiteConnection" %in% class(con)){
      qry <- paste0('DELETE FROM "', schema, '.', table, '";') %>% dplyr::sql()
      table_id <- dbplyr::in_schema(table = table, schema = schema)
    } else{
      qry <- paste0('DELETE FROM "', schema, '".', '"', table, '";') %>% dplyr::sql()
      table_id <- DBI::Id(table = table, schema = schema)
    }
  } else{
    qry <- paste0('DELETE FROM "', table, '";') %>% dplyr::sql()
    table_id <- table
  }

  res <- tryCatch({
    table_exists <- dplyr::db_has_table(con,table_id)
    if(!table_exists){
      write_status <- DBI::dbWriteTable(con, table_id, data, overwrite = T)
    } else{
      if(!is.na(drop_overwrite)){
        write_status <- DBI::dbWriteTable(con, table_id, data, overwrite = T)
      } else if(append_only){
        write_status <- DBI::dbWriteTable(con,  table_id, data, append = T)
      } else{
        rows_affected <- DBI::dbExecute(con, qry)
        write_status <- DBI::dbWriteTable(con, table_id, data, append = T)
        write_status <- list(rows_affected, write_status)
      }
    }
    write_status
  },
  error = function(error_message) {
    return(error_message)
  })
  
  if ("message" %in% names(res)) {
    cat(file = stderr(), paste0("Error writing table ", table, ":", res[["message"]], "\n"))
    return(FALSE)
  } else {
    cat(file = stderr(), paste0("Table ", table, " successfully updated ", Sys.time()), "\n")
    return(TRUE)
  }
}
