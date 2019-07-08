# RTA-accident-analyzer-cloud
This repository shows how its possible to use IBM Watson Studio and build a shiny application that will analyse the driver behavior and location risk. It also explains the business use case using Cognos Dashboards. 

## Data Engineering 
- The original dataset was in Arabic and hence had to be translated to English. I used Google sheets and <b>google translate</b> to perform the operation. 
- The dataset had to group age of drivers in 10 different age groups. This was performed on <b>Excel</b> using the <b>Vlookup</b> function. 
- The data also had to specify the time groups and <b>Vlookup</b> was used for this part as well 
- Next, only 6 locations needed to be selected, hence <b>Data Refinery</b> was used to filter out the locations

## Cognos Dashboards 
### Insights Gained: 
#### Driver Age: 
- People between the age 20 - 29 cause lot of accidents and when the injury severity is increased the age group rises to 30 - 39 
<pic> 
  
#### Accident Timing: 
- Most of the accidents happen Early in the morning or Morning time. This could be because of the increase in traffic on roads. 

pic -here
  
#### Driver profile analysis: 
pic 
- Most of the accidents are caused by drivers in the age 20 - 29 and most of them are students or students in a military school. 
- Blue Collar occupations such as painters, car drivers, etc. also between the age of 20 - 29 cause a lot accidents. Hence safer driving awarness has to be spread to this community. 

 gif

#### Location and Cause analysis: 
pic
- Main kind of accidents is Hitting another vehicle 
- Emirates Road has the most number of accidents 
- So the main cause of accident at Emirates Road is Hitting another vehicle and hitting into an iron barrier, this could mean there is some design malfunction which needs to be manually accessed by the authorities.
 gif

## Modelling - SPSS 

#### Driver Risk Model 
Various classification models were tried and tested for this case. But most of them gave a very low accuracy. But the best one was XG Boost Trees which gave an accuracy above 75%. Below is the list of the models tested: 
- <b>XG Boost Trees</b>
- Random forest 
- Neural networks
- Chaid
- Logistic Regression 
  
 This was the flow created for this model. This flow can be retrieved from flow2.str file in this repositary: 
 pic -here


#### Location Risk Model 
Various classification models were tried and tested for this case. But most of them gave a very low accuracy. But the best one was CHAID which gave an accuracy above 75%. Below is the list of the models tested: 
- <b>CHAID</b>
- Random forest 
- Neural networks
- XG Boost Trees
- Logistic Regression 
- Auto Classifier models
  
 This was the flow created for this model. This flow can be retrieved from flow3.str file in this repositary: 
 pic -here


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
