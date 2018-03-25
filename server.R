# loadData <- function(){
#       # require(xlsx)
#       # require(memisc)  # perhaps not needed?
#       # setwd("C:/Dropbox/Warhammer")
#       # result<-read.xlsx("wh_data_v01.xlsx", 1,stringsAsFactors=FALSE)
#       result<- read.csv2("GitApp/wh_data_v01.csv", stringsAsFactors=FALSE)
#       return(result)
# }
require(ggplot2)

loadData <- function(){
      # require(xlsx)
      # require(memisc)  # perhaps not needed?
      # setwd("C:/Dropbox/Warhammer")
      # result<-read.xlsx("wh_data_v01.xlsx", 1,stringsAsFactors=FALSE)
      result<- read.csv2("https://raw.githubusercontent.com/pepaczz/warhammer/master/wh_data_v01.csv", stringsAsFactors=FALSE)
      return(result)
}

################################################################

hitMatrix <- function(i,j){
      # to hit matix (attacker in rows)
      mat <- matrix(3,10,10)
      for(k in 1:10){
            a<-rep(3,10)
            a[k:(k*2)] <- 4
            a[(1+k*2):(10+k*2)] <- 5
            mat[k,] <- a[1:10]
      }
      return(mat[i,j])
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
      return(mat[i,j])
}

################################################################

getKillProb <- function(a,d){
      ### TO HIT
      hit <- 7 - hitMatrix(a$ws,d$ws)
      ### TO WOUND
      wound <- 7 - woundMatrix(a$s,d$t)
      ### SAVE
      # calculated reciprocaly, i.e. from attacker's point of view
      saveModif <- max(0, a$s-3)
      save <- min(6, d$save - 1 + saveModif)
      ### WARD SAVE / REGENERATION
      # calculated reciprocaly, i.e. from attacker's point of view
      wsave <- min(6, d$wsave - 1)
      
      ### RESULT
      result <- ((hit-a$poison)*(wound-a$killb) * save * wsave) / (6^4) +
            (a$poison*save*wsave)/(6^3) + ((hit-a$poison)*a$killb*wsave)/(6^3)
            
      
      return(result)
}

################################################################

evaluateCombatRound <- function(a,d,sampAtt){
      ### TO HIT
      toHit <- hitMatrix(a$ws,d$ws)
      rollh <- sample(6,sampAtt,replace=T)
      # poisoned attacks
      rollh_6 <- 0
      if(a$poison==1){
            rollh_6 <- sum(rollh==6)
            rollh <- rollh[! rollh %in% 6]
      }
      hits <- sum(rollh >= toHit)

      ### TO WOUND
      toWound <- woundMatrix(a$s,d$t)
      rollw <- sample(6,hits,replace=T)
      # killing blow
      rollw_6 <- 0
      if(a$killb == 1){
            rollw_6 <- sum(rollw==6)
            rollw <- rollw[! rollw %in% 6]
      }
      wounds <- sum(rollw >= toWound) + rollh_6
      
      ### SAVE
      defSave <- d$save + max(0,a$s-4)
      unsaved <- wounds - sum(sample(6,wounds,replace=T) >= defSave)
      
      ### WARD SAVE
      unwsaved <- unsaved - sum(sample(6,unsaved,replace=T) >= d$wsave) + rollw_6
       
      return(unwsaved)
}

################################################################

simulateCombatRound <- function(a,d,nm,sampAtt=100,nSimul=5000){
      passed <- replicate(nSimul,evaluateCombatRound(a,d,sampAtt))
      res <- data.frame(passed = passed, name = nm,stringsAsFactors = F)
      return(res)
}

################################################################

shinyServer(function(input, output) {
      
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
      
      prob_ad <- reactive({ getKillProb(a1(),d1())})
      prob_da <- reactive({ getKillProb(d1(),a1())})

      # Show the values using an HTML table
      # output$prob_ad <- renderPrint({ paste0("Unit 1 attcks Unit 2: ", prob_ad()) })
      # output$prob_da <- renderPrint({ paste0("Unit 2 attcks Unit 1: ", prob_da()) })
      output$prob_ad <- renderPrint({ prob_ad() })
      output$prob_da <- renderPrint({ prob_da() })
      
      output$statA <- renderPrint({ a1() })
      
      observeEvent(input$render,
            output$plot1 <- renderPlot({ 
                  x1 <- isolate(simulateCombatRound(a1(),d1(),nm="player1Attacks"))
                  x2 <- isolate(simulateCombatRound(d1(),a1(),nm="player2Attacks"))
                  x <- rbind(x1,x2)
                  
                  bins <- max(x$passed) - min(x$passed)
                  
                  pl <-ggplot(data=x,aes(passed,fill = name)) +
                              geom_density(alpha = 0.5)
                  print(pl)
            })
      )
})

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
