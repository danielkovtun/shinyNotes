# shinyNotes
Shiny module for taking free-form notes and displaying them in a customizable UI.

The `shinyNotes` package provides an easy way to incorporate free-form note taking or discussion boards into your shiny application. The package includes a shiny module, `shinynotes`, that can be included in any shiny application to create a panel containing searchable, editable text broken down by section headers of your choice.

## Installation

You may install the stable version from CRAN, or the development version using *devtools*:
```{r}
# install from CRAN
install.packages('shinyNotes')

# or the development version, via devtools
devtools::install_github('danielkovtun/shinyNotes')
```

## Usage

#### Demo Shiny Application
To start off, try running a demo Shiny application included with the package by running:
```{r}
library(shinyNotes)
runExample('demo')
```

See the full documentation at https://danielkovtun.github.io/shinyNotes. 
