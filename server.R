#
# This is the server logic of a "DDP_App" Shiny web application.
#

library(shiny)
library(ISLR2)
library(plotly)
library(marginaleffects)
data("Default")

# binomial logistic regression model
model <- glm( default ~ student + balance + income, family="binomial", data=Default )

# dataset for plotting
data2 <- cbind( Default , predictions = model$fitted.values )

# Define server logic
shinyServer(function(input, output) {

    
# making predictions
    predicted <- reactive({
        
        predict.glm( model, newdata=data.frame(
            student=input$student, balance=input$balance, income=input$income) ,
            type="response" )
    })
    
    CI_low <- reactive({
        
        predictions( model, newdata=data.frame(
            student=input$student, balance=input$balance, income=input$income) )$conf.low
    })
    
    CI_high <- reactive({
        
        predictions( model, newdata=data.frame(
            student=input$student, balance=input$balance, income=input$income) )$conf.high
    })
    
    
# draw the 3D scatter plot 
    output$Plot3D <- renderPlotly({

    plot3D <- plot_ly( data2 %>% filter(student=="No"),
             x=~balance, y=~income, z=~predictions, type="scatter3d",
             mode="markers", color=~student, symbol=I("circle"), opacity=0.7,
             width=800, height=600, size=I(16), name="non-student" ) %>%
    add_trace( data=data2 %>% filter(student=="Yes"), x=~balance, y=~income,
               z=~predictions, type="scatter3d", mode="markers", color=~student,
               symbol=I("circle"), opacity=0.7, size=I(16), name="student" ) %>%
    layout( autosize=FALSE, title=list(
        text='Fitted logistic model and prediction of default',
        xanchor='center'), scene=list(zaxis=list(title="probability of default"),
                                      camera=list(center=list(x=0, y=0, z=-0.3),
                                                  eye=list(x=-1, y=-1.7, z=-0.1))),
        legend=list(title=list(text=""), y=0.9) ) %>%
    add_markers( x=input$balance, y=input$income, z=predicted(), type="scatter3d",
                 mode="markers", color=I("red"), symbol=I("diamond"), size=I(64),
                 name="prediction of default" )
        
        if (input$show_CI) {
            
            plot3D <- add_markers( plot3D , x=c(input$balance,input$balance),
                            y=c(input$income,input$income),
                            z=c(CI_low(),CI_high()),
                            type="scatter3d",
                            mode="markers", color=I("black"), symbol=I("diamond"),
                            name="confidence interval", size=I(64) )
        }
    
    plot3D
        
    })
    

# text for tab 1        
    output$pred1 <- renderText({
        round( predicted() , 4 )
        })
    
    output$pred2 <- renderText({
        round( predicted() * 100 , 2 )
        })
    
    output$CI_limits1 <- renderText({
        ifelse(input$show_CI, " , CI limits:" , "")
        })
    
    output$CI_limits2 <- renderText({
        ifelse(input$show_CI,
               paste( round( CI_low() , 4 ) ,
                " - " ,
                round( CI_high() , 4 ) ) , "" )
        })

    
# text for tab 2           
    output$AboutDataset0 <- renderText({
        "The <b>{Default}</b> dataset is provided in the <b>ISLR2</b> package."
    })
    
        output$AboutDataset1 <- renderPrint({
        str( Default )
    })
    
    output$AboutDataset2 <- renderPrint({
        tools:::Rd2HTML(utils:::.getHelpFile(help("Default",package="ISLR2")))
    })

    
# text for tab 3        
    output$AboutModel0 <- renderText({
        "This app computes the probability of default for any given credit card balance, income, and student status."
    })
    
    output$AboutModel1 <- renderText({
        "The following binomial logistic regression model provides a response using multiple predictors:"
    })
    
    output$AboutModel2 <- renderPrint({
        summary( model )
    })    

})
