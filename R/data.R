#' Demo notes for testing \code{shinynote} module.
#'
#' A dataset containing package functions and their titles for the \code{shiny}, \code{shinyWidgets} and \code{dplyr} packages.
#' Formatted in a structure compatible with the \code{shinyNotes::shinynotes} module.
#'
#' @format A \code{tibble} with 274 rows and 3 variables:
#' \describe{
#'   \item{package}{package title, character class}
#'   \item{category}{function name, character class}
#'   \item{update}{function title, character class}
#'   ...
#' }
#' @source \href{https://CRAN.R-project.org/package=shiny}{shiny help pages}
#' @source \href{https://CRAN.R-project.org/package=shinyWidgets}{shinyWidgets help pages}
#' @source \href{https://CRAN.R-project.org/package=dplyr}{dplyr help pages}
"demo_notes"

#' Demo notes formatted with markdown for testing \code{shinynote} module.
#'
#' A dataset containing examples of markdown syntax for including emojis, headers, and code blocks.
#' Formatted in a structure compatible with the \code{shinyNotes::shinynotes} module.
#'
#' @format A \code{tibble} with 3 rows and 3 variables:
#' \describe{
#'   \item{formatting}{text format type, character class}
#'   \item{category}{type of markdown formatter, character class}
#'   \item{update}{text with markdown syntax, character class}
#'   ...
#' }
"markdown_notes"

#' Demo notes for testing \code{shinynote} module.
#'
#' A dataset containing package functions and their titles for the \code{shiny}, \code{shinyWidgets} and \code{dplyr} packages.
#' Formatted in a structure compatible with the \code{shinyNotes::shinynotes} module.
#'
#' @format A named list of length 2 with elements of length 1510:
#' \describe{
#'   \item{name}{emoji name, character class}
#'   \item{url}{emoji image url, character class}
#'   ...
#' }
#' @source \href{https://api.github.com/emojis}{GitHub emojis API}
"emojis"
