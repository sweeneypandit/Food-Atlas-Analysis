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
FA_Local<-FA.Local
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
#selecting monetary related parameters from local database
farmers_local_monet<-sqldf('select FA_Local.County,FA_Local.State, FA_Local.PCT_FMRKT_SNAP16,FA_Local.PCT_FMRKT_WIC16,FA_Local.PCT_FMRKT_WICCASH16,FA_Local.PCT_FMRKT_SFMNP16
,FA_Local.PCT_FMRKT_CREDIT16,FA_Local.FIPS  from FA_Local')
#omitting NA's
farmers_local_monet<-na.omit(farmers_local_monet)
#calculating mean of the parameters
mean_SNAP<-mean(farmers_local_monet$PCT_FMRKT_SNAP16)  #24.26
mean_WIC<-mean(farmers_local_monet$PCT_FMRKT_WIC16)   #21.92
mean_WICcash<-mean(farmers_local_monet$PCT_FMRKT_WICCASH16) #10.54
mean_SFMNP<-mean(farmers_local_monet$PCT_FMRKT_SFMNP16)   #25.93
mean_credit<-mean(farmers_local_monet$PCT_FMRKT_CREDIT16) #49.27
#counties and state having % above the mean of SNAP facility
above_mean_snap<-farmers_local_monet[farmers_local_monet$PCT_FMRKT_SNAP16>mean_SNAP,c(1:3,8)]
#count of counties in a state that have above the mean of SNAP facility
tapply(above_mean_snap$State,above_mean_snap$State,length)
#simple barplot to visualize the number of counties in a state having above the mean SNAP 
barplot(table(above_mean_snap$State))
#counties and state having % beloew the mean of SNAP facility
below_mean_snap<-farmers_local_monet[farmers_local_monet$PCT_FMRKT_SNAP16<mean_SNAP,c(1:3,8)]
#count of counties in a state that have above the mean of SNAP facility
tapply(below_mean_snap$State,below_mean_snap$State,length)
#the states with the highest number of counties having above the mean SNAP facility % is Michigan,New York,
#California and the states with the highest number of counties below the mean is
#North Carolina,Texas,Illinios. 
#counties and state having % above the mean of accepting credit cards
above_mean_credit<-farmers_local_monet[farmers_local_monet$PCT_FMRKT_CREDIT16>mean_credit,c(1,2,7,8)]
#count of counties in a state that have above the mean of SNAP facility
tapply(above_mean_credit$State,above_mean_credit$State,length)
#simple barplot to visualize the number of counties in a state having above the mean SNAP 
barplot(table(above_mean_credit$State))
#counties and state having % below the mean of credit card accepting facility
below_mean_credit<-farmers_local_monet[farmers_local_monet$PCT_FMRKT_CREDIT16<mean_credit,c(1:2,7:8)]
#count of counties in a state that have above the mean of SNAP facility
tapply(below_mean_credit$State,below_mean_credit$State,length)
#the states with the highest number of counties having above the mean credit accepting facility % is Virginia,Montana,
#North Carolina and the states having highest number of counties below the mean credit accepting facility % is
# Kentucky,Alabama,Nebraska

#selecting food related parameters from local database
farmers_local_food<-sqldf('select FA_Local.County,FA_Local.State, FA_Local.PCT_FMRKT_FRVEG16,FA_Local.PCT_FMRKT_ANMLPROD16,FA_Local.PCT_FMRKT_BAKED16,
                           FA_Local.FIPS  from FA_Local')
#omitting NA's
farmers_local_food<-na.omit(farmers_local_food)
#finding mean of the food option facility %
mean_FR<-mean(farmers_local_food$PCT_FMRKT_FRVEG16)  #62.52
mean_ANI<-mean(farmers_local_food$PCT_FMRKT_ANMLPROD16)  #53.57
mean_Bake<-mean(farmers_local_food$PCT_FMRKT_BAKED16)  #57.36
#counties and state having % above the mean of selling fruits and veggies
above_mean_FR<-farmers_local_food[farmers_local_food$PCT_FMRKT_FRVEG16>mean_FR,c(1:3,6)]
#count of counties in a state that have % above the mean of selling fruits and veggies
above_mean_FR_df<-data.frame(tapply(above_mean_FR$State,above_mean_FR$State,length))
colnames(above_mean_FR_df)<-c("count of counties")
#sorting the dataframe according to the number of counties in a state
above_mean_FR_df<-data.frame(above_mean_FR_df[order(above_mean_FR_df$`count of counties`),])
#taking the bottom 5 and top 5 states in the dataframe
above_mean_FR_df_bottom5<-head(above_mean_FR_df,n=5)
above_mean_FR_df_top5<-tail(above_mean_FR_df,n=5)
#counties and state having % below the mean of selling fruits and veggies
below_mean_FR<-farmers_local_food[farmers_local_food$PCT_FMRKT_FRVEG16<mean_FR,c(1:3,6)]
#count of counties in a state that have % below the mean of selling fruits and veggies
below_mean_FR_df<-data.frame(tapply(below_mean_FR$State,below_mean_FR$State,length))
colnames(below_mean_FR_df)<-c("count of counties")
#sorting the dataframe according to the number of counties in a state
below_mean_FR_df<-data.frame(below_mean_FR_df[order(below_mean_FR_df$`count of counties`),])
na.omit(below_mean_FR_df)
#taking the bottom 5 and top 5 states in the dataframe
below_mean_FR_df_bottom5<-head(below_mean_FR_df,n=5)
below_mean_FR_df_top5<-tail(below_mean_FR_df,n=5)
dim(na.omit(above_mean_FR))  #1276 records in total 
dim(na.omit(below_mean_FR))   #972 records in total
#North Carolina, Kentucky, Georgia have the highest % of farmers market selling fruits and veggies
#Ohio and Iowa have the most counties having least % of farmers market selling fruits and veggies
#the number of counties having farmers market selling veggies and fruits above the mean
#is higher than the number of counties below the mean %

#counties and state having % above the mean of selling animal products
above_mean_Animal<-farmers_local_food[farmers_local_food$PCT_FMRKT_ANMLPROD16>mean_ANI,c(1,2,4,6)]
#count of counties in a state that have % above the mean of selling animal products
above_mean_Ani_df<-data.frame(tapply(above_mean_Animal$State,above_mean_Animal$State,length))
colnames(above_mean_Ani_df)<-c("count of counties")
#sorting the dataframe according to the number of counties in a state
above_mean_Ani_df<-data.frame(above_mean_Ani_df[order(above_mean_Ani_df$`count of counties`),])
#taking the bottom 5 and top 5 states in the dataframe
above_mean_Ani_df_bottom5<-head(above_mean_Ani_df,n=5)
above_mean_Ani_df_top5<-tail(above_mean_Ani_df,n=5)
#counties and state having % below the mean of selling animal products
below_mean_Ani<-farmers_local_food[farmers_local_food$PCT_FMRKT_ANMLPROD16<mean_FR,c(1,2,4,6)]
#count of counties in a state that have % below the mean of selling animal products
below_mean_Ani_df<-data.frame(tapply(below_mean_Ani$State,below_mean_Ani$State,length))
colnames(below_mean_Ani_df)<-c("count of counties")
#sorting the dataframe according to the number of counties in a state
below_mean_Ani_df<-data.frame(below_mean_Ani_df[order(below_mean_Ani_df$`count of counties`),])
na.omit(below_mean_FR_df)
#taking the bottom 5 and top 5 states in the dataframe
below_mean_Ani_df_bottom5<-head(below_mean_Ani_df,n=5)
below_mean_Ani_df_top5<-tail(below_mean_Ani_df,n=5)
dim(na.omit(above_mean_Animal))  #1102 records in total 
dim(na.omit(below_mean_Ani))   #1233 records in total
#Ohio, Iowa have the most number of counties having below the mean % for farmers market selling animal products
# Virginia , Montana have the most counties having above the mean % of farmers market selling animal products ,the number of counties having below the mean % for farmers market selling animal products
#are higher than above the mean % counties
