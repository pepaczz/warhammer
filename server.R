loadData <- function(){
      require(xlsx)
      # require(memisc)  # perhaps not needed?
      # setwd("C:/Dropbox/Warhammer")
      result<-read.xlsx("wh_data_v01.xlsx", 1,stringsAsFactors=FALSE)
      return(result)
}

################################################################

hitMatrix <- function(i,j){
      # to hit matix (attacker in rows)
      # RETURNS HOW MANY PASSES, NOT HOW MUCH TO BE ROLLED
      # I.E. 2+ THROW RETURNS 5 
      mat <- matrix(3,10,10)
      for(k in 1:10){
            a<-rep(3,10)
            a[k:(k*2)] <- 4
            a[(1+k*2):(10+k*2)] <- 5
            mat[k,] <- a[1:10]
      }
      return(7-mat[i,j])
}  

################################################################

woundMatrix <- function(i,j){
      # to wound matrix (attacker in rows)
      # RETURNS HOW MANY PASSES, NOT HOW MUCH TO BE ROLLED
      # I.E. 2+ THROW RETURNS 5 
      mat <- matrix(6,10,10)
      for(k in 1:10){
            a<-rep(6,15)
            a[0:k] <- 2
            a[k:(k+4)] <- 2:6
            a[k+5]<-6
            # a[(k+5):(k+10)]
            mat[k,] <- a[3:12]
      }
      return(7-mat[i,j])
}

################################################################


getKillProb <- function(a,d,weapMod = 0){
      ### MODIFIED STRENGTH (WEAPON)
      str <- a$s + weapMod
      
      ### TO HIT
      hit <- hitMatrix(a$ws,d$ws)
      
      ### POISONED ATTACKS
#       pa <- 0
#       if(a$poison == 1){
#             hit <- hit - 1
#             pa <- 1
#       }
      
      ### TO WOUND
      wound <- woundMatrix(str,d$t)
      
      ### KILLING BLOW
      kb <- 0
      if(a$killb == 1){
            wound <- wound - 1
            kb <- 1
      }
      
      ### SAVE
      # calculated reciprocaly, i.e. from attacker's point of view
      saveModif <- max(0, str-3)
      save <- min(6, d$save - 1 + saveModif)
      
      ### WARD SAVE / REGENERATION
      # calculated reciprocaly, i.e. from attacker's point of view
      wsave <- min(6, d$wsave - 1)
      
      ### RESULT
      result <- (((hit-a$poison)*wound)/36+a$poison/6) * (save*wsave/36) + (kb/(6^2))
      
      return(result)
      
}

################################################################

initializeEmptyDf <- function(){
      df <-  data.frame(ws=numeric(0),
                        s=numeric(0),
                        t=numeric(0),
                        save=numeric(0),
                        wsave=numeric(0),
                        poison=numeric(0),
                        killb=numeric(0)
                        )
}

################################################################

shinyServer(function(input, output) {
      
      attacker <- reactive({
            c(input$a1.ws, input$a1.s, input$a1.t)
            
      })
      
      attacker <- initializeEmptyDf()
      defender <- initializeEmptyDf()
      
#       a1 <- reactive({
#             as.numeric(c(input$a1.ws, 
#                          input$a1.s, 
#                          input$a1.t,
#                          input$a1.save,
#                          input$a1.wsave,
#                          input$a1.poison,
#                          input$a1.killb))
#       }) 
      
      a1 <- reactive({
            data.frame(ws = input$a1.ws, 
                         s = input$a1.s, 
                         t = input$a1.t,
                         save = input$a1.save,
                         wsave = input$a1.wsave,
                         poison = input$a1.poison,
                         killb = input$a1.killb)
      }) 
      
      d1 <- reactive({
            data.frame(ws = input$d1.ws, 
                       s = input$d1.s, 
                       t = input$d1.t,
                       save = input$d1.save,
                       wsave = input$d1.wsave,
                       poison = input$d1.poison,
                       killb = input$d1.killb)
      }) 
      
      prob <- reactive({ getKillProb(a1(),d1())})

            
      # Show the values using an HTML table
      output$values <- renderPrint({ (prob()) })
})