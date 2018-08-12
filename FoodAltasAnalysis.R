#impotinf data
df <- read.csv
df<-file.choose()
FA.Variable<-read.csv(df)
FA.County<-read.csv(df)
FA.States<-read.csv(df)
FA.Access<-read.csv(df)
FA_Access<-FA.Access
FA.Stores<-read.csv(df)
FA.Restaurants<-read.csv(df)
FA.Assistance<-read.csv(df)
FA_Assistance<-FA.Assistance
FA.Insecurity<-read.csv(df)
FA_Insecurity<-FA.Insecurity
FA.Price_Taxes<-read.csv(df)
FA.Local<-read.csv(df)
FA.Health<-read.csv(df)
FA.Socioeco<-read.csv(df)
--------------------------------------------------------------------
  #installing libraries
  library('sqldf')

Analysis 1 for year 2010
#persistent poverty counties with 20% more poverty rates
FA_Socioeco<-FA.Socioeco
perpov10_1<-sqldf('select FA_Socioeco.County from FA_Socioeco where FA_Socioeco.PERPOV10=1 ')
#percent under 18 in descending order
perpov_1_young<- sqldf('select FA_Socioeco.FIPS,FA_Socioeco.PCT_18YOUNGER10,FA_Socioeco.County from FA_Socioeco where FA_Socioeco.PERPOV10=1 order by FA_Socioeco.PCT_18YOUNGER10 desc ')
#persistent poverty counties with less than 20% poverty rates
perpov10_0<-sqldf('select FA_Socioeco.County from FA_Socioeco where FA_Socioeco.PERPOV10=0 ')
#percent under 18 in descending order
perpov_0_young<- sqldf('select FA_Socioeco.FIPS,FA_Socioeco.PCT_18YOUNGER10,FA_Socioeco.County from FA_Socioeco where FA_Socioeco.PERPOV10=0 order by FA_Socioeco.PCT_18YOUNGER10 desc ')

#inner join access with perpov_0_young and perpov_1_young
mer_acess_perpov_1_young<-sqldf('select FA_Access.PCT_LACCESS_POP10,FA_Access.PCT_LACCESS_LOWI10,FA_Access.PCT_LACCESS_HHNV10
                                ,perpov_1_young.FIPS,perpov_1_young.PCT_18YOUNGER10,perpov_1_young.County from perpov_1_young inner join FA_Access ON perpov_1_young.FIPS=FA_Access.FIPS')
#ordering my low ascess to store population
lacess_perpov_1_young<-sqldf('select mer_acess_perpov_1_young.PCT_LACCESS_POP10, mer_acess_perpov_1_young.County from mer_acess_perpov_1_young order by PCT_LACCESS_POP10 desc')
#inner join access with perpov_0_young and perpov_1_young
mer_acess_perpov_0_young<-sqldf('select FA_Access.PCT_LACCESS_POP10,FA_Access.PCT_LACCESS_LOWI10,FA_Access.PCT_LACCESS_HHNV10
                                ,perpov_0_young.FIPS,perpov_0_young.PCT_18YOUNGER10,perpov_0_young.County from perpov_0_young inner join FA_Access ON perpov_0_young.FIPS=FA_Access.FIPS')
#taking the mean of parameters in the table of perpov_0_young and perpov_1_young
mean(mer_acess_perpov_0_young$PCT_LACCESS_POP10)
mean(mer_acess_perpov_1_young$PCT_LACCESS_POP10)
#the mean of low access population %, low income low pop% of more than 20% poverty rate is greater than the less 20 % one
Analysis 2 for year 2015
#inner join on socioeco database with poverty rate 2015 and some parameters of access database
mer_access_povrate_15<-sqldf("select FA_Access.PCT_LACCESS_POP15,FA_Access.PCT_LACCESS_LOWI15,FA_Access.PCT_LACCESS_HHNV15, FA_Socioeco.POVRATE15
                             ,FA_Access.FIPS,FA_Access.County from FA_Socioeco inner join FA_Access ON FA_Socioeco.FIPS=FA_Access.FIPS")
#omitting na's
mer_access_povrate_15<-na.omit(mer_access_povrate_15)
#taking mean of parameters
mean(mer_access_povrate_15$PCT_LACCESS_POP15)
mean(mer_access_povrate_15$PCT_LACCESS_LOWI15)
mean(mer_access_povrate_15$PCT_LACCESS_HHNV15)
#inner join on socioeco and assistance database
mer_assistance_povrate_15<-sqldf("select FA_Assistance.PC_SNAPBEN15,FA_Assistance.PCT_WIC15,FA_Assistance.PCT_CACFP15
                                 ,FA_Socioeco.FIPS,FA_Socioeco.County , FA_Socioeco.POVRATE15 from FA_Assistance inner join FA_Socioeco ON FA_Assistance.FIPS=FA_Socioeco.FIPS ")

#taking mean of parameters
mer_assistance_povrate_15<-na.omit(mer_assistance_povrate_15)
mean(mer_assistance_povrate_15$PC_SNAPBEN15)
mean(mer_assistance_povrate_15$PCT_WIC15)
mean(mer_assistance_povrate_15$PCT_CACFP15)
#highest 10 poverty rate counties analysis
mer_assistance_povrate_15<-sqldf("select FA_Assistance.PC_SNAPBEN15,FA_Assistance.PCT_WIC15,FA_Assistance.PCT_CACFP15
                                 ,FA_Socioeco.FIPS,FA_Socioeco.County , FA_Socioeco.POVRATE15 from FA_Assistance inner join FA_Socioeco ON FA_Assistance.FIPS=FA_Socioeco.FIPS 
                                 order by FA_Socioeco.POVRATE15 desc")
#selecting top 10 poverty rate counties and states
top10_povrate15<-sqldf("select  * from mer_assistance_povrate_15 limit 10")
top10_povrate15_states<-sqldf("select  FA_Socioeco.State, FA_Socioeco.County from top10_povrate15 inner join FA_Socioeco ON FA_Socioeco.FIPS=top10_povrate15.FIPS")
#lowest 10 poverty rate counties analysis
mer_assistance_povrate_15<-sqldf("select FA_Assistance.PC_SNAPBEN15,FA_Assistance.PCT_WIC15,FA_Assistance.PCT_CACFP15
                                 ,FA_Socioeco.FIPS,FA_Socioeco.County , FA_Socioeco.POVRATE15 from FA_Assistance inner join FA_Socioeco ON FA_Assistance.FIPS=FA_Socioeco.FIPS 
                                 order by FA_Socioeco.POVRATE15 asc")
mer_assistance_povrate_15<-na.omit(mer_assistance_povrate_15)
#selecting bottom 10 poverty rate counties and states
bottom10_povrate15<-sqldf("select  * from mer_assistance_povrate_15 limit 10")
bottom10_povrate15_states<-sqldf("select  FA_Socioeco.State, FA_Socioeco.County from bottom10_povrate15 inner join FA_Socioeco ON FA_Socioeco.FIPS=bottom10_povrate15.FIPS")
#This data from 2015 just gleaned on me the fact that the SNAP benefits per capita
#are higher than the mean for poverty high counties than the low poverty rate counties 
#which was contradictory according to me, the top poverty rated state is South Dakota with Corson county
#and the least poverty rated state is Colorado with county Douglas

Analysis 3 for year 2016
#selecting some parameters 
