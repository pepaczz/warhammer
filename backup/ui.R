# ui.R

shinyUI(fluidPage(
      
      titlePanel("Basic widgets"),
      

      div(
            column(10, 
                   tags$style(type='text/css', ".selectize-input { font-size: 12px; line-height: 12px;} .selectize-dropdown { font-size: 12px; line-height: 12px; }"),
                   numericInput("num1", 
                                label = h3("Numeric input"), 
                                value = 1),
            
                  numericInput("num1", 
                               label = h3("Numeric input"), 
                               value = 1),
                  
                  numericInput("num1", 
                               label = h3("Numeric input"), 
                               value = 1),
            
                  numericInput("num1", 
                               label = h3("Numeric input"), 
                               value = 1)), 
            style = "font-size:80%")

))