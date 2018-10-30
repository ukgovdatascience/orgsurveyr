library(shiny)
library(orgsurveyr)

shinyApp(ui = test_viz_ui(),
         server = function(input, output) {
           test_viz_server(input, output)
         }
)
