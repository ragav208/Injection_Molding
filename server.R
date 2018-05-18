library(shiny)
library(datasets)
#library(caret)
#library(pROC)
# 


# train60 <- read.csv("train60.csv")
# train50 <- read.csv("train50.csv")
#training70 <- train70


options(shiny.maxRequestSize=400*1024^2)

#train701 <<- read.csv("train70.csv")
load("my_model.rda")
# checkacc <- varImp(modelequal)
# checkacc$PCT <- (checkacc$Overall/sum(checkacc$Overall))*100
# checkacc <- checkacc[with(checkacc,order(-PCT)),]
# checkacc$Overall <- NULL
# checkacc$Var <- rownames(checkacc)
# cheac <- data.frame("Var"=checkacc$Var,"PCT"=checkacc$PCT)
 ch <- summary(modelequal)





# test <- read.csv("test30.csv")
# test$pred <- predict(modelequal,newdata = test,type = "response")
#roc(formula(modelequal),data = train70,plot=TRUE,smooth)


newcoeff <<- as.data.frame(ch$coefficients)

rownames(newcoeff) <- c("Intercept","Avg Fill Speed of Liquid",
                        "Pressure/Time for each cycle at cavity 6",
                        "Average Time to Complete 1 Job Cycle",
                        "Pressure/Time for each cycle at cavity 2",
                        "Time taken to move screw forward",
                        "Pressure/Time for each cycle at cavity 1",
                        "Pressure/Time at cavity 6 after completion of a cycle")

#  par(las=2)
#  barplot(checkacc$PCT,horiz = T, names.arg = rownames(checkacc),cex.names=0.6)
# Define server logic required to summarize and view the selected
# dataset
t70 <- NULL
shinyServer(function(input, output) {
  
  dataset <- reactive({
    
    infile <- input$file
    if(is.null(infile))
      return (NULL) 
    
    filename <- infile$name
  t70 <<-   read.csv(filename, header = T, sep = ",")
  
  
  })
  

  output$view <- renderTable({
    dataset()
   # print(head(t70,5))
    head(t70)
  })
  
  output$plot <- renderPlot({
    
    hist(train701$Average.Value..Fill.Speed..FillSp.,xlab = "Average Fill Speed")
    
    
  })
  
  


  
  output$sensitivity1 <- renderPlot({
    dataset()
    train70 <<- t70
    
    
    if(input$radio==1){
      source("newplots.R")}else{
        if(input$radio==2){
          source("minplot.R")
        }else{
          source("maxplot.R")
        }
      }
    
    ggplot(plot1, aes(x = Avg_Speed_of_filling_liquid , y = Probability_of_Machine_Failure)) + 
      geom_line(colour = "blue") +xlab("Avg Fill Speed of Liquid")+ylab("Probability of Machine Fail")
    
    
    
  })
  
  
  output$sensitivity2 <- renderPlot({
    dataset()
    train70 <<- t70
    print(head(train70),5)
    
    if(input$radio==1){
    source("newplots.R")}else{
      if(input$radio==2){
        source("minplot.R")
      }else{
        source("maxplot.R")
      }
    }
    
    ggplot(plot2, aes(x = Pressure_per_unit_time_for_each_cycle_at_cavity6 , y = Probability_of_Machine_Failure )) + 
      geom_line(colour = "blue")+xlab("Pressure/Time for each cycle at cavity 6") +ylab("Probability of Machine Fail")
    
    
    
    
  })
  

#   output$rocPlot <- renderPlot({
#   
#     library(pROC)
#     
#     pred <- predict(modelequal,type = "response",newdata=train701)
#     train701$pred <- pred
#     
#     auc <- roc(train701$Flag, train701$pred)
#     
#     
#     ggplot(auc, ylim=c(0,1), print.thres=TRUE, main=paste('AUC:',round(auc$auc[[1]],2)))
#     abline(h=1,col='blue',lwd=2)
#     abline(h=0,col='red',lwd=2) 
#     
#   })
#   
  
  
  output$modelTable <- renderTable({
    pred <- predict(modelequal,type = "response",newdata=train701)
    train701$pred <- pred
    train701$L_Flag[train701$pred<=0.5] <- 0
    train701$L_Flag[train701$pred>0.5] <- 1
    ch2 <- xtabs(~train701$Flag+train701$L_Flag)
    ch2
    
  })
  
  
  output$modelaccuracy <- renderText({
    pred <- predict(modelequal,type = "response",newdata=train701)
    train701$pred <- pred
    train701$L_Flag[train701$pred<=0.5] <- 0
    train701$L_Flag[train701$pred>0.5] <- 1
    ch <- xtabs(~train701$Flag+train701$L_Flag)
    x <- round(((ch[1]+ch[4])/(sum(ch)))*100,digits = 2)
    paste0(x,"%")
    
    
  })
  
  output$tp <- renderText({
    pred <- predict(modelequal,type = "response",newdata=train701)
    train701$pred <- pred
    train701$L_Flag[train701$pred<=0.5] <- 0
    train701$L_Flag[train701$pred>0.5] <- 1
    ch <- xtabs(~train701$Flag+train701$L_Flag)
    y <- round((ch[4]/(ch[4]+ch[2]))*100,digits = 2)
    
    paste0(y,"%")
    
    
  })
  
    
  
  output$contour <- renderPlot({
    
    dataset()
    train70 <<- t70 
    if(input$radio2==1){
      source("newplots.R")}else{
        if(input$radio2==2){
          source("minplot.R")
        }else{
          source("maxplot.R")
        }
      }
    x1 <- seq(input$var1[1],input$var1[2],length=100)
    y1 <- seq( input$var2[1],input$var2[2],length = 100)
    probmatrix <- outer(x1,y1,function(x,y) ProbFunction(x,y)) 
    
    filled.contour(x1,y1,probmatrix,plot.title = title(main = "The Topography of Probability of Failure of Machine",
                                                                                                        xlab = "Avg Fill Speed of Liquid",asp=1,
                                                                                                         ylab = "Pressure/Time for each cycle at cavity 6"),color=terrain.colors)
                                                       
                                                       
    
    
  })
  
  
  
  output$check <- renderPrint({
    input$var1[1]
    input$var2[1]
  })
  
  
    
})
  
  