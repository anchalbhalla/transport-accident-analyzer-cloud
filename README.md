# RTA-accident-analyzer-cloud
This repository shows how its possible to use IBM Watson Studio and build a shiny application that will analyse the driver behavior and location risk. It also explains the business use case using Cognos Dashboards. 

## Data Engineering 
- The original dataset was in Arabic and hence had to be translated to English. I used Google sheets and <b>google translate</b> to perform the operation. 
- The dataset had to group age of drivers in 10 different age groups. This was performed on <b>Excel</b> using the <b>Vlookup</b> function. 
- The data also had to specify the time groups and <b>Vlookup</b> was used for this part as well 
- Next, only 6 locations needed to be selected, hence <b>Data Refinery</b> was used to filter out the locations

## Cognos Dashboards

## Modelling - SPSS 

## Shiny Application 

### Analysing Driver Profile Risk 
Features to be analysed: 
- Age 
- Gender
- Occupation
- Driving license issue date
- Car manufactured year

### Analysing Location Risk
Features to be analysed: 
- Accident Time
- Accident Location 
- Weather
- Type of accident
- Cause of accident
