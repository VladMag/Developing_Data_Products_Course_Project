#
# This is the user-interface definition of a "DDP_App" Shiny web application.
#

library(shiny)
library(plotly)

# Define UI for application
shinyUI(fluidPage(

# Application title
titlePanel("Predicting the probability of default with credit card default data",
           windowTitle = "DDP course project"),

# Sidebar with controls
    sidebarLayout(
        sidebarPanel( width=3 , 
            h4( strong("Enter new customer data") ) ,
            hr() ,
            radioButtons("student", "Customer type:", 
                         c("student"="Yes","non-student"="No") , "No") ,
            numericInput("income", "Customer income:", 
                         value = 35000, min = 1, max = 70000, step = 1) ,
            numericInput("balance", "Credit card balance:", 
                         value = 2200, min = 1, max = 2500, step = 1) ,
            checkboxInput("show_CI", "Show/Hide Prediction CI", value = FALSE) ,
            submitButton("Submit")
            ),
        

# Main panel with 3 tabs
        mainPanel( width=9 ,
            tabsetPanel(type = "tabs",
                        
                tabPanel("Default Probability",
                    
            h4( "probability of default = " , 
                strong( textOutput("pred1",inline = TRUE) ) ,
               " (" , 
               strong( textOutput("pred2",inline = TRUE) ) ,
               "% )" , 
               textOutput("CI_limits1",inline = TRUE) ,
               strong( textOutput("CI_limits2",inline = TRUE) )
               ) ,
            hr() , 
            plotlyOutput("Plot3D")
            ) , 
            
                tabPanel( "about Training Data",
                          br(), htmlOutput("AboutDataset0") , hr() ,
                          verbatimTextOutput("AboutDataset1") , hr() ,
                          htmlOutput("AboutDataset2") , hr()
                          ) ,
            
                tabPanel( "Information about the App",
                          br(), textOutput("AboutModel0") ,
                          textOutput("AboutModel1") , br() ,
                          verbatimTextOutput("AboutModel2") , hr()
                          )
            ) )
    )
))
