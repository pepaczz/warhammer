textInput3<-function (inputId, label, value = "",...) 
{
      div(style="display:inline-block",
          tags$label(label, `for` = inputId), 
          tags$input(label = label,id = inputId, type = "number", value = value,...))
}

shinyUI(bootstrapPage(
      tabsetPanel(
            tabPanel("main",
                  hr(),
                  column(
                        width=10,offset=1,
                        h3("Warhammer combat calculator"),
                        hr(),
                        h4("Unit 1 stats:"),
                        fluidRow(
                              textInput3(inputId="a1.ws", label="WS", value = 3, class="input-small",min = 1, max = 10),
                              textInput3(inputId="a1.s", label="S", value = 3, class="input-small",min = 1, max = 10),
                              textInput3(inputId="a1.t", label="T", value = 3, class="input-small",min = 1, max = 10),
                              textInput3(inputId="a1.save", label="SAVE", value = 7, class="input-small",min = 1, max = 7),
                              textInput3(inputId="a1.wsave", label="WSAVE", value = 7, class="input-small",min = 1, max = 7),
                              textInput3(inputId="a1.poison", label="POISON", value = 0, class="input-small",min = 0, max = 1),
                              textInput3(inputId="a1.killb", label="KILLB", value = 0, class="input-small",min = 0, max = 1)
                        ),
                        h4("Unit 2 stats:"),
                        fluidRow(
                              textInput3(inputId="d1.ws", label="WS", value = 3, class="input-small",min = 1, max = 10),
                              textInput3(inputId="d1.s", label="S", value = 3, class="input-small",min = 1, max = 10),
                              textInput3(inputId="d1.t", label="T", value = 3, class="input-small",min = 1, max = 10),
                              textInput3(inputId="d1.save", label="SAVE", value = 7, class="input-small",min = 1, max = 7),
                              textInput3(inputId="d1.wsave", label="WSAVE", value = 7, class="input-small",min = 1, max = 7),
                              textInput3(inputId="d1.poison", label="POISON", value = 0, class="input-small",min = 0, max = 1),
                              textInput3(inputId="d1.killb", label="KILLB", value = 0, class="input-small",min = 0, max = 1)
                        ),
                        hr(),
                        h4("Probability of inflicting a wound: "),
                        h5("Unit 1 attacks Unit 2: "),
                        textOutput('prob_ad'),
                        
                        h5("Unit 2 attacks Unit 1: "),
                        textOutput('prob_da'),
                        hr(),
                        h4("Attack success histogram"),
                        h5("Probability density plot for number of successful attacks (horizontal axis, in percentage). 
                           Mean value of the distibution is the probability above."),
                        h5("It takes several seconds to render the plot"),
                        actionButton("render", "render plot"),
                        plotOutput('plot1')
                  )
            ),
            tabPanel("readme",
                  h3("Warhammer tabletop game combat calculator - readme"),
                  h4("Probability calculation"),
                  h5("This utility calculates probability of causing a wound according to Warhammer Fantasy Battles 8th edition rules. 
                  User have to input stats for the two fighting units. 
                  Resulting probability should be immediatelly displayed in the middle part of the window.The following abbreviations are used:"), 
                  h5("WS-weapon skill, S-strength, T-toughness, SAVE-armour save, WSAVE-ward save, POISON-poisonous attacks, KILLB-killing blow."),

#                   tags$ul(
#                       tags$li(), 
#                       tags$li("Second list item"), 
#                       tags$li("Third list item")
#                   ),
                  h5("In reality each player rolls consecutively several rolls on six-sided dices and compare the rolls with tabeled needed values. 
                     Here the probability is calculated using the following formula:"),
                     
                     tags$code("result <- ((hit-poison)*(wound-killb) * save * wsave) / (6^4) + "),
                     br(),
                     tags$code("(poison*save*wsave)/(6^3) + ((hit-poison)*killb*wsave)/(6^3)"),
                     
                     h5("where: "),

                     tags$ol(
                           tags$li("hit and wound are numbers of dice values connected to a success (e.g. equals to 5 when rolling on 2+) "), 
                           tags$li("save and wsave are respective values of both saving throws minus 1"), 
                           tags$li("killb and poison are 0/1 variables")),
                     
                     h4("Probability density plot"),
                     h5("Probability density is displayed for all possible percentage values of successful attacks with nonzero value of density.
                        Underlying data are not calculated analytically, but they are sampled using a random numbers generator.
                        There are 5000 samples of 100 attacks used in to calculate the probability.")
                    
            )
      )
))