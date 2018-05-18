modelcoeff <- newcoeff

b0 <- modelcoeff$Estimate[1] #Intercept
b1 <- modelcoeff$Estimate[2] #Average.Value..Fill.Speed..FillSp.
b2 <- modelcoeff$Estimate[3] #Average.Value..Job.Cycle.Time..Job.Ct
#b3 <- modelcoeff$Estimate[4] #Average.Value..Post.Gate.Peak..PSTAvg.
b3 <- modelcoeff$Estimate[4] #Fill...Pack.Integral..End.of.Cavity..2..EOC.fpi..2.
b4 <- modelcoeff$Estimate[5] #Fill...Pack.Integral..End.of.Cavity..6..EOC.fpi..6.
b5 <- modelcoeff$Estimate[6] #Fill...Pack.Integral..Post.Gate..6..PST.fpi..6.
b6 <- modelcoeff$Estimate[7] #Fill...Pack.Time..End.of.Cavity..1..EOC.fpt..1
b7 <- modelcoeff$Estimate[8] #Sequence.Time..Injection.Forward..IF.tm.



x1 <- b0 + b1*train70$Average.Value..Fill.Speed..FillSp. + b2*quantile(train70$Average.Value..Job.Cycle.Time..Job.Ct.)[4]+
  b3*quantile(train70$Fill...Pack.Integral..End.of.Cavity..2..EOC.fpi..2.)[4]+
  b4*quantile(train70$Fill...Pack.Integral..End.of.Cavity..6..EOC.fpi..6.)[4] + b5*quantile(train70$Fill...Pack.Integral..Post.Gate..6..PST.fpi..6.)[4]+
  b6*quantile(train70$Fill...Pack.Time..End.of.Cavity..1..EOC.fpt..1.)[4]+
  b7*quantile(train70$Sequence.Time..Injection.Forward..IF.tm.)[4]


P1 <- exp(x1)/(1+exp(x1))

plot1 <- data.frame(train70$Average.Value..Fill.Speed..FillSp.,P1)
colnames(plot1)[1]<-"Avg_Speed_of_filling_liquid"
colnames(plot1)[2] <- "Probability_of_Machine_Failure"
# ggplot(plot1, aes(x = Average.Value..Fill.Speed..FillSp. , y = P1 )) + 
#   geom_line(colour = "blue") 



x2 <- b0 + b1*quantile(train70$Average.Value..Fill.Speed..FillSp.)[4] + b2*quantile(train70$Average.Value..Job.Cycle.Time..Job.Ct.)[4]+
  b3*quantile(train70$Fill...Pack.Integral..End.of.Cavity..2..EOC.fpi..2.)[4]+
  b4*(train70$Fill...Pack.Integral..End.of.Cavity..6..EOC.fpi..6.) + b5*quantile(train70$Fill...Pack.Integral..Post.Gate..6..PST.fpi..6.)[4]+
  b6*quantile(train70$Fill...Pack.Time..End.of.Cavity..1..EOC.fpt..1.)[4]+
  b7*quantile(train70$Sequence.Time..Injection.Forward..IF.tm.)[4]


P2 <- exp(x2)/(1+exp(x2))

plot2 <- data.frame(train70$Fill...Pack.Integral..End.of.Cavity..6..EOC.fpi..6.,P2)
colnames(plot2)[1]<-"Pressure_per_unit_time_for_each_cycle_at_cavity6"
colnames(plot2)[2] <- "Probability_of_Machine_Failure"

# ggplot(plot2, aes(x = Fill...Pack.Integral..End.of.Cavity..6..EOC.fpi..6. , y = P2 )) + 
#   geom_line(colour = "blue") 




# x1 <- seq(10.5,13,length=100)
# y1 <- seq( 200.0066,500,length = 100)


xconstant <- b0 +  b2*quantile(train70$Average.Value..Job.Cycle.Time..Job.Ct.)[4]+
  b3*quantile(train70$Fill...Pack.Integral..End.of.Cavity..2..EOC.fpi..2.)[4]+
  b5*quantile(train70$Fill...Pack.Integral..Post.Gate..6..PST.fpi..6.)[4]+
  b6*quantile(train70$Fill...Pack.Time..End.of.Cavity..1..EOC.fpt..1.)[4]+
  b7*quantile(train70$Sequence.Time..Injection.Forward..IF.tm.)[4]

ProbFunction<-function(a,d){
  P<-exp(b1*a+b4*d+xconstant)/(1+exp(b1*a+b4*d+xconstant))
  
}

#b1 & b7


#probmatrix <- outer(x1,y1,function(x,y) ProbFunction(x,y)) 

# filled.contour(x1,y1,probmatrix,plot.title = title(main = "The Topography of Probability of Failure",
#                                                  xlab = "Average.Value..Fill.Speed..FillSp.",asp=1,
#                                                  ylab = "Fill...Pack.Integral..End.of.Cavity..6..EOC.fpi..6."),color=terrain.colors)

# 
# write.csv(modelcoeff,"new_coefficients.csv")
# write.csv(checkacc,"new_pred_importance.csv")


