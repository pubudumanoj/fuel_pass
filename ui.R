#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(quadrangle)
library(magick)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Fuel PASS ID Creator"),
  
  # sidebar for inputs
  sidebarLayout(
    sidebarPanel(
      fileInput(inputId = "qr", label = "Insert your QR code"),
      textInput(inputId = "name", label = "Insert your name"),
      textInput(inputId = "telephone", label = "Insert your contact number"),
      radioButtons(inputId = "rb", "Fuel Type",
                   choiceNames = list(
                    "Petrol", "Diesel"
                   ),
                   choiceValues = list(
                     "Petrol", "Diesel"
                   )),
      actionButton(inputId = "createimage", label = "Create my ID"),
      br(), br(),
      
      downloadButton('downloadImage', 'Download your ID card')
      
      
    ),
    
    # Show the image
    mainPanel(
      
      
      imageOutput("image2"),
      imageOutput("image3")
      
    )
  )
))
