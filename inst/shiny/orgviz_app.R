library(shiny)
library(orgsurveyr)

#modify by providing a tidygraph and dataframe rather than NULL

shinyApp(ui = orgviz_ui(),
         server = function(input, output) {
           orgviz_server(input, output, tg = NULL, df = NULL)
         }
)
