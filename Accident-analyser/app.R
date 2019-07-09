#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(httr)
library(splitstackshape) # for the text to colummns
library(reshape2) 
library(devtools) 
library(plotly)

library(shinyWidgets)
library(shinydashboard)

packageVersion('plotly')

devtools::install_github(repo = 'IBMDataScience/R4WML')
library(R4WML)

watson_ml_creds_url      <- 'https://us-south.ml.cloud.ibm.com'
watson_ml_creds_username <- '3e406396-c801-44e9-bb04-1e7175f5f1f8'
watson_ml_creds_password <- '1d6781d5-7832-45b2-a974-5739f71fabd2' 

ml_endpoint.model        <- 'https://us-south.ml.cloud.ibm.com/v3/wml_instances/6d6b7d87-8ed7-4009-8a10-18227473c93c/deployments/255a56c1-db72-49a2-b8bb-833fd6fa65ef/online'

ml_endpoint.model2 <- 'https://us-south.ml.cloud.ibm.com/v3/wml_instances/6d6b7d87-8ed7-4009-8a10-18227473c93c/deployments/960a5c26-e00e-480e-940b-07399c493242/online'
watson_ml_creds_auth_headers <- get_wml_auth_headers(watson_ml_creds_url, watson_ml_creds_username, watson_ml_creds_password)


# Define UI for application that draws a histogram
ui <-  dashboardPage(
 
  
  dashboardHeader(title = "RTA Analyser"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Driver Profile Analysis", tabName = "Driver", icon = icon("th")),
      menuItem("Location Risk Analysis", tabName = "Location", icon = icon("th"))
    )
  ),
  
  dashboardBody(
    
    # Application title
    
    # Sidebar with a slider input for number of bins 
    
    tabItems(
      # First tab content 
      
      tabItem(tabName = "Driver",
              sidebarLayout(
                sidebarPanel(
                  tags$head(tags$style(
                    HTML('
         #sidebar {
            background-color: #404040;
        }

        label { 
          font-family: "Arial";
          color: #FFFFFF;
        }')
                  )),
                   id="sidebar",
                  selectInput("age", label = "Age", 
                              choices = list("20 - 29" = "20 - 29", "30 - 39" = "30 - 39", "40 - 49" = "40 - 49", "50 - 59" = "50 - 59", "60 - 69" = "60 - 69", "70 - 79" = "70 - 79", "80 - 89" = "80 - 89"), 
                              selected = 1), 
                  
                  selectInput("Gender", label = "Gender", 
                              choices = list("Male" = "M", "Female" = "F"), 
                              selected = 1),
                  
                  
                  
                  selectInput("Occupation", label = "Occupation", 
                              choices = list("A major computer player" = "A major computer player" ,"Account Manager" = "Account Manager", "Agricultural worker" = "Agricultural worker", "Architect" = "Architect","Assistant Carpenter Buildings" = "Assistant Carpenter Buildings","Assistant cooker / Pastry" = "Assistant cooker / Pastry" ,"Assistant Mechanical conditioning" = "Assistant Mechanical conditioning", "Automatic control industry equipment officer" = "Automatic control industry equipment officer","Barbers" = "Barbers", "Bartender (Gerson)" = "Bartender (Gerson)", "Building bricks" = "Building bricks","Building carpenter" = "Building carpenter","bus driver" = "bus driver","Carpenter Furniture" = "Carpenter Furniture", "civil engineer" = "civil engineer", "Cleaning agent / Public Buildings" = "Cleaning agent / Public Buildings", "cleaning worker" = "cleaning worker", "Commercial Pilot" = "Commercial Pilot", "Computer programmer" = "Computer programmer", "Conditioning and cooling technician / installation" = "Conditioning and cooling technician / installation", "diesel mechanic" = "diesel mechanic", "dish cleaner" = "dish cleaner","District official" = "District official","does not work" = "does not work","Driver" = "Driver","Driver light vehicle" = "Driver light vehicle",
                                             "Drivers of small cars and light transport" = "Drivers of small cars and light transport","Electric circuit extensions" = "Electric circuit extensions", "Employee" = "Employee","Executive Director" = "Executive Director","Falafel Maker" = "Falafel Maker","Follower writer" = "Follower writer","General Doctor" = "General Doctor","guard" = "guard","Haddad doors Aluminum" = "Haddad doors Aluminum","Housewife" ="Housewife","Lieutenant / 2" = "Lieutenant / 2","Longshoremen" = "Longshoremen","Machinery Operator" = "Machinery Operator","Mderoadarat Statistics, Economy and Planning" = "Mderoadarat Statistics, Economy and Planning","Mechanical Maintenance Assistant" = "Mechanical Maintenance Assistant","Models Fashion Show" = "Models Fashion Show","motorcycle driver" = "motorcycle driver","Normal factor" = "Normal factor","not working" = "not working","Other manual packaging workers and industry" = "Other manual packaging workers and industry",
                                             "Other personal services workers" = "Other personal services workers","Paint buildings" = "Paint buildings","partner" = "partner","Plumber" = "Plumber","Private car driver" = "Private car driver","Project Engineer" = "Project Engineer","Promotional representative" = "Promotional representative","Public Accountant" = "Public Accountant","Purification of metal ores machines operator" = "Purification of metal ores machines operator","Quality Control Manager" = "Quality Control Manager","Real Estate Agents" = "Real Estate Agents","Repairman vehicle tires" = "Repairman vehicle tires","Reporter" = "Reporter","retired" ="retired","Sales executive" = "Sales executive",
                                             "Sales Representative" = "Sales Representative","Sales Supervisor" = "Sales Supervisor","Sandwich maker (sandwich)" = "Sandwich maker (sandwich)","Security officer" = "Security officer","Sellers of vehicles" = "Sellers of vehicles","Server / maid and house managers" = "Server / maid and house managers","Shepherd" = "Shepherd","Skilled workers in the fields of agriculture and fisheries" = "Skilled workers in the fields of agriculture and fisheries","Starter Archive" = "Starter Archive","Starter reception in" = "Starter reception in",
                                             "student" = "student","Students in military schools" = "Students in military schools","Switchboard operator" = "Switchboard operator","Teachers Assistants Others" = "Teachers Assistants Others","truck driver" = "truck driver","Unemployed" = "Unemployed","Unknown function" = "Unknown function","Vendor" = "Vendor","visitor" = "visitor" ), 
                              selected = "student"),   
                  

                  
                  sliderInput("manufacturer",
                              "Year of Car manufacture", 
                              sep = "",
                              min = 1995,
                              max = 2017,
                              value = 2012), 
                  
                  dateInput("drivinglicense", "Driving License Issue", min = NULL, max = NULL,
                            format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                            language = "en", width = NULL, value = "2017-01-01"),
                  
                  HTML('<center><img src="policeman.png" width="200" height="190"></center>')
                ),
                
                
                # Show a plot of the generated distribution
                mainPanel(
                 
                  
                  #img(src='mortgage.png', align = "right", height = 300, weight = 300),
                  
                    plotlyOutput("plot"),
                    
                 
                  br(),
                  br(),
                 # h2("The graph above explains the results retrieved from the mortgage prediction model on ICP for Data"), 
                  br(),
                 #HTML('<center><img src="policeman.png" width="210" height="200"> <body bgcolor="#E6E6FA"></center>'),
                 fluidRow(
                   column(5,img(src='accident.png',  height = 130, weight = 130)),
                   column(5, img(src='car-crash.png', height = 145, weight = 145)),
                   img(src='accident1.png', height = 130, weight = 130)
                 ) 
                 
                )
                
              )), 
      
      tabItem(tabName = "Location",
              sidebarLayout(
                sidebarPanel( 
                  
                  tags$head(tags$style(
                    HTML('
         #sidebar {
            background-color: #404040;
        }

        label { 
          font-family: "Arial";
          color: #FFFFFF;
        }')
                  )),
                  id="sidebar",
                  
                  selectInput("time", label = "Accident Time", 
                              choices = list("Early Morning" = "Early Morning", "Morning" = "Morning", "Early Afternoon" = "Early Afternoon", "Afternoon" = "Afternoon", "Early Evening" = "Early Evening", "Evening" = "Evening", "Night" = "Night", "Late Night" = "Late Night"), 
                              selected = "Early Morning"),  
                  
                  selectInput("location", label = "Location", 
                              choices = list("Emirates Road" = "Emirates Road" , "El-Shikh Zayed street" = "El-Shikh Zayed street", "Sheikh Mohammed Bin Zayed Road" = "Sheikh Mohammed Bin Zayed Road", "Horse Street" = "Horse Street", "Jebel Ali Soot Street" = "Jebel Ali Soot Street", "Dubai Eye Street" = "Dubai Eye Street"), 
                              selected = "Emirates Road"),
                  
                  
                  radioButtons("weather", label = "Weather",
                               choices = list("Sunny" = "Sunny", "Rainy" = "Raining"), 
                               selected = "Sunny"),  
                  
                  selectInput("cause", label = "Cause of Accident", 
                              choices = list("Not leaving enough distance" = "Not leaving enough distance","Neglect and lack of attention" = "Neglect and lack of attention",
                                             "Driving under the influence of drugs" = "Driving under the influence of drugs","Sudden deviation" = "Sudden deviation",
                                             "Driving under the influence of alcohol" = "Driving under the influence of alcohol","Reversing Car" = "Sir Unlike Sir","Stand in the middle of the road" = "Stand in the middle of the road","Lack of commitment to walk line" = "Lack of commitment to walk line","Frame explosion" = "Frame explosion","Hit an animal" = "Flail animal"), 
                              selected = "Emirates Road"),
                  
                  selectInput("type", label = "Type of Accident", 
                              choices = list("Hit a vehicle" = "Shocked - vehicle" , "Hit a concrete barrier" = "Rammed a concrete barrier", "Hit an iron barrier" = "Rammed an iron barrier", "Deterioration" = "Deterioration", "Hit pier" = "Shocked pier", "Hit an animal" = "Shocked - animal", "Fire" = "fire"), 
                              selected = "Emirates Road") ,
              
                  HTML('<center><img src="location-pin.png" width="200" height="190"></center>')
                  
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                  
                 plotlyOutput("plot2"),
                    
                 br(),
                 br(),
                 br(),
                 #HTML('<center><img src="policeman.png" width="210" height="200"> <body bgcolor="#E6E6FA"></center>'),
                 fluidRow(
                   column(5,img(src='accident.png',  height = 130, weight = 130)),
                   column(5, img(src='car-crash.png', height = 145, weight = 145)),
                   img(src='accident1.png', height = 130, weight = 130)
                 ) 
                )
                
              )) 
      
    ))
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  
  
  output$plot <- renderPlotly({
    payload1 <- paste0('{"fields":["age-group", "gender", "driving_license_issue_date", "occupation_eng", "year_manufactured"],"values":[[','"', input$age, '","', input$Gender, '","', input$drivinglicense, '","' , input$Occupation, '",' , input$manufacturer, ']]}' ) 
    print(payload1)
    results <- wml_score(ml_endpoint.model, watson_ml_creds_auth_headers, payload1) 
    print(results)
    print(results$values[3]) 
    print(results$values[4])
    print(results$values[5]) 
    print(results$values[6])
    little <- 0
    medium <- 0
    severe <- 0
    death <- 0
 
    little <- as.numeric(results$values[3]) * 100
    medium <- as.numeric(results$values[4]) * 100
    severe <- as.numeric(results$values[5]) * 100
    death <- as.numeric(results$values[6]) * 100
  
    dat <- data.frame(
      PREDICTION = factor(c("LITTLE","MEDIUM", "SEVERE", "DEATH"), levels=c("LITTLE","MEDIUM", "SEVERE", "DEATH")),
      CONFIDENCE = c(little, medium, severe, death)
    )
    
    p <- ggplot(data=dat, aes(x=PREDICTION, y=CONFIDENCE, fill=PREDICTION)) +
      geom_bar(stat="identity") + ggtitle("Injury Severity Analysis") + theme(plot.title = element_text(hjust = 0.5))
    
    p <- ggplotly(p) 
    hide_legend(p)
    
  })
  
  output$plot2 <- renderPlotly({
    payload1 <- paste0('{"fields":["acd_time_group", "acd_location_eng", "acd_type_eng", "acd_cause_eng", "weather_eng"],"values":[[','"', input$time, '","', input$location, '","', input$type, '","' , input$cause, '","' , input$weather, '"]]}' ) 
    print(payload1)
    results <- wml_score(ml_endpoint.model2, watson_ml_creds_auth_headers, payload1) 
    print(results)
    print(results$values[3]) 
    print(results$values[4])
    print(results$values[5]) 
    print(results$values[6])
    little <- 0
    medium <- 0
    severe <- 0
    death <- 0
    
    little <- as.numeric(results$values[3]) * 100
    medium <- as.numeric(results$values[4]) * 100
    severe <- as.numeric(results$values[5]) * 100
    death <- as.numeric(results$values[6]) * 100
    
    dat <- data.frame(
      PREDICTION = factor(c("LITTLE","MEDIUM", "SEVERE", "DEATH"), levels=c("LITTLE","MEDIUM", "SEVERE", "DEATH")),
      CONFIDENCE = c(little, medium, severe, death)
    )
    
    p <- ggplot(data=dat, aes(x=PREDICTION, y=CONFIDENCE, fill=PREDICTION)) +
      geom_bar(stat="identity") + ggtitle("Injury Severity Analysis") + theme(plot.title = element_text(hjust = 0.5))
    
    p <- ggplotly(p) 
    hide_legend(p)
    
    
  }) 
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)