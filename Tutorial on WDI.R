#World Bank provides data set of WORLD DEVELOPMENT INDICATORS
#It includes economic, social, demographic and many other types of country-level data
#You can explore all the data using this link: https://datatopics.worldbank.org/world-development-indicators/


#Goint to Poverty and Inequality section, I can see an interesting variable called "Gini", which coded as SI.POV.GINI
#Goint to People section, I can see "Mortality rate, under-5 (per 1,000 live births)", which coded as SH.DYN.MORT

#Suppose I have a research question whether these two variables are related to each other? How can I access this data?
#"WDI" package can help

#Installing and calling the package
install.package("WDI")
library(WDI)

#You can use function WDIsearch to search for things you want
#Let's try to search GDP per capita
View(WDIsearch("GDP per capita"))

#As you see WDIsearch provides many indicators containing GDP, 
#and some of them are interesting for us, like "GDP per capita (constant 2010 US$)"
#We see that it coded as NY.GDP.PCAP.KD

wdi_dat <- WDI(indicator = c("NY.GDP.PCAP.KD"), #Choosing an indicator
               start = 2000, #Selecting first year of observation
               end = 2000, #Selecting last year of observation
               extra = F) #Do you need additional data? Right now, I think, you do not

#REMEMBER! For purposes of this assignment do not import more than one year: start and end argument should be equal

str(wdi_dat)
View(wdi_dat)

#So we downloaded one variable we wanted. What about those two we wanted before? SI.POV.GINI and SH.DYN.MORT?
#We can add them together with GDP

wdi_dat_1 <- WDI(indicator = c("NY.GDP.PCAP.KD", "SI.POV.GINI", "SH.DYN.MORT"), #Choosing an indicator
               start = 2000, #Selecting first year of observation
               end = 2000, #Selecting last year of observation
               extra = F) #Do you need additional data? Right now, I think, you do not

str(wdi_dat_1) #Seems that everything in the right place
#But look closer
View(wdi_dat_1)
#Gini has many NA's
summary(wdi_dat_1) #216 countries has NA's on GINI variables (out of 264 countries)

#To check whether you have enough variables for analysis do the following
data_no_na <- na.omit(wdi_dat_1) #function which delete any row which has at least one NA
#Is it okay? 
str(data_no_na)
#Only 47 countries? Is it enough?
#For regression usually we need at least 10-20 observation for each independent variable. 
#So 47 is not so high number
#But let's have a look on countries' names
data_no_na$country
#Most of depevoped countries are present here, as well as some developing. 47 observation is still small number
#But you can try to do analysis on this base. But very carefully

#If you want more observations, you can change indicator or year of observation

#Let's change a year
wdi_dat_2 <- WDI(indicator = c("NY.GDP.PCAP.KD", "SI.POV.GINI", "SH.DYN.MORT"), #Choosing an indicator
                 start = 2010, #Selecting first year of observation
                 end = 2010, #Selecting last year of observation
                 extra = F) #Do you need additional data? Right now, I think, you do not
summary(wdi_dat_2)
#Now we have 181 NA's in GINI variable. It is 35 less than before

data_no_na <- na.omit(wdi_dat_2)
str(data_no_na) 
#Now we have 82 countries. It is safe number for analysis
#Let's do regression

model <- lm(SH.DYN.MORT ~ SI.POV.GINI + NY.GDP.PCAP.KD, data_no_na)
summary(model)
#Now we see that GINI is positively related to mortality rates
#while GDP negatively

#How to interpret coefficients - watch lectures.

#An important proviso:
#Do not use linear regression for time series and panel data. 
#When in your data one country was observed many years (e.g. 2010, 2011, 2012), Results of lm()
#will not be correct anymore. That is why in WDI() funciton we specifying just one year
