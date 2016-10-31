 #****************************
 #+ scrape  portfolio dataframe from google finance API
 source('load.R', local=TRUE)
 #++++++++++++++++++++

server = function(input, output) {
  
  output$hcontainer <- renderHighchart({
   
    rawdata <- reactive({
    input$refresh
    isolate(scrape_list())
    
    })
    
    ram=rawdata()

    tm <- ram %>% 
    group_by(Industry,Comp     ) %>%
    treemap::treemap(index = c("Industry","Comp"),
                   vSize = input$size, 
                   vColor = input$color,
                   type = input$type,
                   border.col="black",
                   border.lwds="1",
                   draw=FALSE)               
                   
 
 tm$tm <- tm$tm %>%
  tbl_df() 

  hctm <- highchart() %>% 
  hc_add_series_treemap(tm, allowDrillToNode = TRUE,
                        layoutAlgorithm = "squarified")%>% 
             hc_tooltip(pointFormat =paste0( "<b>{point.name}</b>
                                            <br>{point.valuecolor:,.2f}<br>"))                
  
  hctm
 
  })
  
}