#' Testviz shiny UI
#'
#' Creates a shiny UI object for the test_viz shiny app
#'
#' @return shiny ui object
#' @import shiny
#' @export
#'
#' @examples
#' \dontrun{
#' library(shiny)
#'
#' shinyApp(ui = test_viz_ui(),
#'         server = function(input, output) {
#'           test_viz_server(input, output)
#'         }
#' )
#' }
test_viz_ui <- function() {

  fluidPage(

    # Application title
    titlePanel("Simple Interactive Organisation Plot"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        sliderInput("n_children", "Number of children:", min = 1, max = 10, value = 4),
        sliderInput("max_depth", "Maximum depth:", min = 1, max = 10, value = 3),
        sliderInput("selected_prob", "Probability of deletion:", min = 0, max = 0.7, value = .3, step = 0.02),
        checkboxInput('delete_units', 'Delete units (uncheck to just highlight):', value = TRUE),
        checkboxInput('is_circular', 'Circularlize?:', value = FALSE),
        checkboxInput('is_dendrogram', 'Dendrogram?:', value = TRUE),
        actionButton("button", "Create new org plot")
      ),

      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("plot")
      )
    )
  )

}

#' Testviz shiny server
#'
#' Creates a shiny server object for the test_viz shiny app
#'
#' @param input shiny input
#' @param output shiny output
#'
#' @return shiny server function
#' @export
#'
#' @examples
#' \dontrun{
#' library(shiny)
#'
#' shinyApp(ui = test_viz_ui(),
#'         server = function(input, output) {
#'           test_viz_server(input, output)
#'         }
#' )
#' }
test_viz_server <- function(input, output) {

  values <- reactiveValues(tg_seed=10001)

  observeEvent(input$button, {
    values$tg_seed <- sample(1:10000, 1)
  })

  reactive_tg <- reactive({

    set.seed(values$tg_seed)
    create_realistic_org(input$n_children,input$max_depth, prob=input$selected_prob,
                         delete_units=input$delete_units) %>%
      simulate_unit_size()


  })

  reactive_df <- reactive({

    # simulate individual data and summarise
    indiv_df <- reactive_tg() %>%
      simulate_individuals_df() %>%
      dplyr::mutate(test_var2 = purrr::map_dbl(individual_id, ~rnorm(1, 20,3)))

    calc_summary_df(reactive_tg(), indiv_df, NULL,
                                  c('test_var', 'test_var2'), TRUE)

  })

  output$plot <- renderPlot({

    if(!input$delete_units) {
      reactive_tg() %>%
        dplyr::mutate(to_delete=as.factor(to_delete)) %>%
        plot_org(fill_var='to_delete', is_circular = input$is_circular)
    } else {
      plot_org(reactive_tg(), fill_var='test_var2', df=reactive_df(),
               is_circular = input$is_circular, is_dendrogram = input$is_dendrogram)
    }

  })
}

#' Testviz shiny app
#'
#' Convenience function to run the test_viz shiny app within an R session.
#'
#' The test_viz shiny app allows interactive simulation and visualisation of organisations of different shapes and
#' sizes.
#'
#' @return runs a shiny app
#' @export
#' @import shiny
#'
#' @examples
#' \dontrun{
#'
#' test_viz()
#'
#' }
test_viz <- function() {
  shinyApp(ui = test_viz_ui, server = test_viz_server)
}

