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
FA.Insecurity<-read.csv(df)
FA_Insecurity<-FA.Insecurity
FA.Price_Taxes<-read.csv(df)
FA.Local<-read.csv(df)
FA.Health<-read.csv(df)
FA.Socioeco<-read.csv(df)
--------------------------------------------------------------------
  #installing libraries
  library('sqldf')
#maximum percent low acess in 2010 by county and state
max_pct_lacess.state.county<-sqldf('select max(FA_Access.PCT_LACCESS_POP10), FA_Access.County,FA_Access.State
, FA_Access.FIPS from FA_Access group by FA_Access.State')
#merge the above max laccess and insecurity datasets
mer_lacess_insecurity<-merge(max_pct_lacess.state.county, FA.Insecurity, by="FIPS")
#maximum percent food insecurity in 2010-2012 by county and state
max_pct_foodinsec.state.county<-sqldf('select max(FA_Insecurity.FOODINSEC_10_12), FA_Insecurity.County,FA_Insecurity.State
, FA_Insecurity.FIPS from FA_Insecurity group by FA_Insecurity.State')
