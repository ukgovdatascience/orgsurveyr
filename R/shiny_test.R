#' Test visualisation UI
#'
#' @return shiny ui object
#' @import shiny
#' @export
#'
#' @examples
#' NULL
test_viz_ui <- function() {

  fluidPage(

    # Application title
    titlePanel("Simple Interactive Organisation Plot"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        sliderInput("n_children", "Number of children:", min = 1, max = 10, value = 4),
        sliderInput("max_depth", "Maximum depth:", min = 1, max = 10, value = 3)
      ),

      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("plot")
      )
    )
  )

}

#' Test visualisation server
#'
#' @param input shiny input
#' @param output shiny output
#'
#' @return shiny server function
#' @export
#'
#' @examples
#' NULL
test_viz_server <- function(input, output) {

  reactive_tg <- reactive({

    set.seed(10001)
    create_realistic_org(input$n_children,input$max_depth, prob=0.3)

  })

  output$plot <- renderPlot({

    plot_org(reactive_tg())

  })
}

#' Test visualisation shiny app
#'
#' @return runs a shiny app
#' @export
#' @import shiny
#'
#' @examples
#' NULL
test_viz <- function() {
  shinyApp(ui = test_viz_ui, server = test_viz_server)
}

