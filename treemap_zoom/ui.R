library("shiny")
library("highcharter")
library("treemap")

date=format(Sys.Date(), "%d-%m-%Y")

ui <- fluidPage(
 includeCSS("styles.css"),
 
  headerPanel(paste0("NIFTY50"," @",date)),
  fluidRow(
    column(width = 3, class = "panel",
          selectInput("type", label = "Type", width = "80%",
                       choices = c("value","comp","dens","depth","color")), 
                           
           selectInput("size", label = "Size variable",  width = "80%",
                       choices = c("Weightage","cmp","Capital.Rs.","Volatility")),
 
           selectInput("color", label = "Color variable",  width = "80%",
                       choices = c("cp", "c")),   
                       
           actionButton("refresh", "Refresh",icon("refresh"), 
                         style="color: #fff; background-color: #39ac73")
    ),
    column(width = 8,alighn="center",
           highchartOutput("hcontainer",height = "700px")
    )
  )
)

