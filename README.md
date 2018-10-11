# Food-Atlas-Analysis
The factors that affect the food choices and health lifestyle of US
This dataset was picked up at the link below:
https://catalog.data.gov/dataset/food-environment-atlas-f4a22
https://www.ers.usda.gov/data-products/food-environment-atlas/data-access-and-documentation-downloads/

To begin with this dataset is quite diverse.It has lot of data ranging from years 2008-2016. One problem I faced while working with 
this dataset was that I could not base my analysis on the different parameters that I wanted for specific years as they were not
consistently recorded for every year. Nevertheless, I picked by 2010,2015,2016 as my years for analysis.
In  Analysis 1 ,I focussed on year 2010 and the access parameters affecting the persistent poverty counties in 2010
In Analysis 2, I focussed on year 2015 and the access, food assistance parameters affecting the poverty rate in 2015
In Analysis 3, I focussed on year 2016 and the farmers market analysis across the states and counties in US.

I played around with R to gather different ways of implementing the same logical result.I hope you enjoy visiting it. This analysis is purely descriptive and exploratory analysis to gain insights.

Analysis 1 and 2:
I heavily used the SQLDF package in R for this analysis. SQLDF package is offered in R that can be used to access the SQL functionlaities in the R dataframe. The best part of using this package is that it converts the analysis to a table so you can manipulate the result table as well. I used SQL clauses like inner join, order by, limit, select clause, group by, having, where clause.

You can learn more about the package in this link :https://cran.r-project.org/web/packages/sqldf/sqldf.pdf

Analysis 3:
I used R function for manipulating the dataset.I relied on Tapply and dataframe indexing for the analysis. Tapply is a handy function that helps in summarizing certain columns in your data by a condition of another column in the dataset, much like group by and having clause.
Except for the output in tapply is a vector and not like a table as we get in sqldf.

You can learn more about the tapply function in this link :https://www.rdocumentation.org/packages/base/versions/3.5.1/topics/tapply

Besides, head and tail in built function in R is also very useful for ranking feature in R and is very easy to implement.
