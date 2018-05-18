

library(shiny)
library(shinythemes)

shinyUI(fluidPage(navbarPage(theme=shinytheme("flatly"),tags$b("Injection Molding Demo"),br(),
tabPanel("BU", 
        sidebarLayout(
          sidebarPanel(
            h3(tags$b("Background")),
            br(),
            h4(tags$b("About Injection Molding Machine")),
            tags$li("Thermoplastic injection molding is one of the most prevalent manufacturing processes"),
            br(),
            tags$li("Plastic pellets are fed to the injection molding machine, where they are first softened through heating zones, then forced under speed and pressure into the mold."),
            br(),
            tags$li("Product is cooled and hardened, then ejected from the mold."),
            br(),
            h4(tags$b("PoC:")),
            
            tags$li("To predict real-time production line failures through Plastic Injection Molding through machine  learning and multi-dimensional data modeling technique"),
            br(),
            h4(tags$b("Objective: ")),
            tags$li("To reduce the downtime of the machine"),
            br(),
            h4(tags$b("Scope: ")),
            tags$li("Analyze the process parameters like Plastic Temperature, Plastic Flow Rate, Plastic Pressure Gradient, Plastic Cooling Rate and Time"),
            br(),
            tags$li("To improve yield and reduce non-conformances")
          ),
          mainPanel(h4("High Level Overview of Plastic Injection Machine and Sensors",align="center"),
                    br(),br(),br(), img(src="project.png",height=600,width=900,align="center")
        )
          )                             
                             
                             
                             ),

tabPanel("DataProcessing",
         sidebarLayout(
           sidebarPanel(h3(tags$b("Highlights")),
                        
                        tags$li("First time leveraging raw machine text log conversion to structured data for analytics"),
                        br(),
                        tags$li("Stitch time data from disparate sources and machine logs "),
                        br(),
                        tags$li("Work cohesively with business to co-create logic to handle time data"),
                        br(),
                        
                        h3(tags$b("Details")),
                        h4("Machine Log Data: "), tags$li("Machine Log data is a semi-structured dataset which indicates the status of the injection molding machine at different time intervals
                                                          "),br(),
                        tags$li("Machine is considered to be running only when it is in",tags$b("Auto-Cycling"),p("state"))
                        ,
                        tags$li("Machine Log data is then expanded by 12 seconds so that it can be merged with the sensor data. 
                                "),br(),
                        h4("Sensor Data: "),
                        tags$li("Sensor data file contains sensor data from 91 different sensors available.
                                "),br(),
                        tags$li("The time difference between 2 sensor data records is approx. 12 seconds, as it takes about 12 seconds to complete 1 cycle. 
                                "),br(),
                        tags$li("Sensor data and Machine Log data are then merged based on the timestamp.")
                        
                        ),
           mainPanel(img(src="rawfile.png",height=700,width=1000, align = "center"))
         )
  
  
),


tabPanel("Data Profiling",
            sidebarLayout(
              sidebarPanel(h3(tags$b("Observation of variables during failure")),
                           br(),tags$li(h4("Average Fill speed of liquid is low during machine downtime.",color="black")),
                           br(),tags$li(h4("The Pressure per unit time at cavity 6 is also low during machine downtime",color="black"))
              ),
              mainPanel(img(src="avgfillspeed.jpeg",height=400,width=500),img(src="fillpackeoc6.jpeg",height=400,width=500)
            ,br(),br(),br(),tags$li(tags$p(class="text-danger","Red lines signify machine downtime")),
            br(),tags$li(tags$p(class="text-primary","Blue lines signify that the machine is currently running"))
              ))
            ),



tabPanel("Modeling Approach",
         sidebarLayout(
           sidebarPanel(
             h3("Variable Reduction "),
             tags$li("Applied missing value treatment and outlier correction on the 91 variables available"),
             br(),tags$li("Only", tags$b("14%"), "of the Variables actually impact machine failure"),
             br(),tags$li("A",tags$b("Hybrid ML Modeling Algorithm"), "is used to calculate the probability of machine failure")
             ,h3("Model Accuracy"),
             tags$li(tags$b("78.74%"),"of the failures were predicted correctly by the model")
             
           ),
           mainPanel(img(src="modelapproach.png",height=500,width=700))
         )
         
         ),

tabPanel("Predictor Importance",
            sidebarLayout(
              sidebarPanel( h3(tags$b("Factors Impacting Failure")),br(),
                            #print("working2"),
                            
                            tags$li(tags$b("Average Fill Speed of liquid has an inverse relationship with Machine Failure. ")),
                            #print("working3"),
                            
                            br(),tags$li(tags$b("Pressure per unit Time at cavity 6 has an inverse relationship with Machine Failure")),
                            #print("working4"),
                            
                            br(),tags$li(tags$b("Average Time to complete 1 Job has an inverse relationship with Machine Failure")),
                            #print("working5"),
                            
                            br(),  tags$li(tags$b("Pressure per unit Time at cavity 2 has an inverse relationship with Machine Failure")),
                            #print("working6"),
                            
                            br(),tags$li(tags$b("Time taken to move screw forward has a direct relationship with Machine Failure")),
                            # print("working7"),
                            
                            br(),tags$li(tags$b("Pressure per unit Time at cavity 1 has a direct relationship with Machine Failure")),
                            #  print("working8"),
                            
                            br(),tags$li(tags$b("Pressure per unit Time at cavity 6 after molding has an inverse relationship with Machine Failure"))
                            
                            #   print("$('li.active a').first().html()")
                            
              ###############  )
              
              
            ),
              mainPanel(br(),br(),img(src="pie.png",height = 600, width=850))
            )
            ),

  tabPanel("Contour Plot",
              sidebarLayout(
                sidebarPanel( fileInput("file", label = h3("File input"),accept = c('text/csv',
                                                                                    'text/comma-separated-values',
                                                                                    'text/tab-separated-values',
                                                                                    'text/plain',
                                                                                    '.csv',
                                                                                    '.tsv')),
                              
                              
                              
                              radioButtons("radio2", label = h5("Range (Keeping other parameters at)"),
                                           choices = list("Median" = 1, "Min" = 2,
                                                          "Max" = 3),selected = 1),
                              
                              
                              
                              sliderInput("var1", label = h3("Avg Fill Speed of Liquid"),
                                          min =  9, max = 13.5, value = c(10.5,13)),
                              
                              sliderInput("var2", label = h3("Pressure/Time for each cycle at cavity 6"),
                                          min = 200, max = 595, value = c(200.0066,500)),
                              br(),
                              h4("Reccomendation "),
                              tags$li("Fill Speed of liquid and the Pressure per unit time at Cavity 6 should be maintained at the higher end of it's range to reduce machine downtime")
                              ,tags$li("By Controlling the above parameters, Jabil can reduce Machine downtime from 30% to about 15%")
                                              
                ),
                mainPanel(plotOutput("contour",width = "100%"))
              ))





)))
  
