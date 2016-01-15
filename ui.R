textInput3<-function (inputId, label, value = "",...) 
{
      div(style="display:inline-block",
          tags$label(label, `for` = inputId), 
          tags$input(label = label,id = inputId, type = "number", value = value,...))
}

shinyUI(bootstrapPage(
            hr(),
            fluidRow(
                  textInput3(inputId="a1.ws", label="WS", value = 3, class="input-small",min = 1, max = 10),
                  textInput3(inputId="a1.s", label="S", value = 3, class="input-small",min = 1, max = 10),
                  textInput3(inputId="a1.t", label="T", value = 3, class="input-small",min = 1, max = 10),
                  # textInput3(inputId="P4", label="A", value = 3, class="input-small",min = 0, max = 10),
                  # textInput3(inputId="P5", label="HATRED", value = 3, class="input-small",min = 0, max = 10),
                  # textInput3(inputId="P5", label="FRENZY", value = 3, class="input-small",min = 0, max = 10),
                  textInput3(inputId="a1.save", label="SAVE", value = 7, class="input-small",min = 1, max = 7),
                  textInput3(inputId="a1.wsave", label="WSAVE", value = 7, class="input-small",min = 1, max = 7),
                  textInput3(inputId="a1.poison", label="POISON", value = 0, class="input-small",min = 0, max = 1),
                  textInput3(inputId="a1.killb", label="KILB", value = 0, class="input-small",min = 0, max = 1)
            ),
            
            fluidRow(
                  textInput3(inputId="d1.ws", label="WS", value = 3, class="input-small",min = 1, max = 10),
                  textInput3(inputId="d1.s", label="S", value = 3, class="input-small",min = 1, max = 10),
                  textInput3(inputId="d1.t", label="T", value = 3, class="input-small",min = 1, max = 10),
                  # textInput3(inputId="P4", label="A", value = 3, class="input-small",min = 0, max = 10),
                  # textInput3(inputId="P5", label="HATRED", value = 3, class="input-small",min = 0, max = 10),
                  # textInput3(inputId="P5", label="FRENZY", value = 3, class="input-small",min = 0, max = 10),
                  textInput3(inputId="d1.save", label="SAVE", value = 7, class="input-small",min = 1, max = 7),
                  textInput3(inputId="d1.wsave", label="WSAVE", value = 7, class="input-small",min = 1, max = 7),
                  textInput3(inputId="d1.poison", label="POISON", value = 0, class="input-small",min = 0, max = 1),
                  textInput3(inputId="d1.killb", label="KILB", value = 0, class="input-small",min = 0, max = 1)
            ),
            verbatimTextOutput('values')
      )
)