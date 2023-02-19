# common way to print error messages
errMsg <- function(x) {
  stop(sprintf("shinyNotes: %s", x), call. = FALSE)
}

#' Run shinyNotes examples
#'
#' Launch a \code{rpredictit} example Shiny app that shows how to
#' easily use \code{shinyNotes} in a Shiny app.\cr\cr
#' Run without any arguments to see a list of available example apps.
#'
#' @param example The app to launch
#' @return None. Runs a demo Shiny application. This function normally does not
#'   return; interrupt R to stop the application.
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'   # List all available example apps
#'   runExample()
#'
#'   runExample("demo")
#' }
#' @export
runExample <- function(example) {

  validExamples <-
    paste0(
      'Valid examples are: "',
      paste(list.files(system.file("examples", package = "shinyNotes")),
            collapse = '", "'),
      '"')

  if (missing(example) || !nzchar(example)) {
    message(
      'Please run `runExample()` with a valid example app as an argument.\n',
      validExamples)
    return(invisible(NULL))
  }

  appDir <- system.file("examples", example,
                        package = "shinyNotes")
  if (appDir == "") {
    errMsg(sprintf("could not find example app `%s`\n%s",
                   example, validExamples))
  }
  if(interactive()){
    shiny::runApp(appDir, display.mode = "showcase", launch.browser = TRUE)
  }
}
