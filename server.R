#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(quadrangle)
library(magick)

shinyServer(function(input, output, session) {
  
  image.data <- reactive({
    inImage <- input$qr
    
    if (is.null(inImage))
      return(NULL)
    img <- inImage$datapath
    return(img)
  })
  
  output$image2 <- renderImage({
    
    if(is.null(input$image)){
      return(list(src=""))
    }
    else {

      return(list(
        src = "fuel_pass_temp1.png",
        contentType = "image/png",
        alt = "wedding_card", width = "100%"
        
      )
      )

    }
    
  }, deleteFile = FALSE)
  
  
  add_overlay <- function(){
    
    
    qr <-  image_read(image.data()) %>% 
      image_resize(c(900,900))
    
    qr2 <- qr
    
    img2<-image_read("www/fuel_pass_temp1.png")
    
    regno <- qr_scan(image.data())$values$value %>% strsplit(" ") %>% unlist()
    img2 <- image_annotate(img2, as.character(input$name), size = 100, color = "black",
                           location = "+1460+623")
    img2 <- image_annotate(img2, regno[1], size = 100, color = "black",
                           location = "+1690+755")
    img2 <- image_annotate(img2, as.character(input$telephone), size = 100, color = "black",
                           location = "+1690+1025")
    
    
    img2 <- image_annotate(img2, as.character(input$rb), size = 100, color = "black",
                           location = "+1690+895")
    
    img3 <- image_composite(img2, qr2, offset = "+100+610")
    return(img3)
  }
  
  
  
  updated_img <- reactive({
    temp_file <- tempfile(fileext = ".png")
   
    image_write(add_overlay(), temp_file)
    temp_file
    #}
    

    
    
  })
  
  
  observeEvent(input$createimage, {
    
    output$image2 <-renderImage({
      
      temp_file <- updated_img()
      
      
      
      ####
      
      list(src = temp_file,
           width = "100%",
           
           alt = "This is alternate text")
    }, deleteFile = F)
    
  })
  
  
  output$downloadImage <- downloadHandler(
   
    filename = "fuelpass.png",
    contentType = "image/png",
    content = function(file) {
      img <- add_overlay() %>% image_write(tempfile(fileext='png'), format = 'png')
      ## copy the file from the updated image location to the final download location
      file.copy(img, file)
    }
  )
  


  
  
  
})
