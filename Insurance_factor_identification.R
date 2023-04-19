setwd()
getwd()
# Import the dataset
insurance_data<-read.csv("Insurance_factor_identification.csv")
View(insurance_data)

# 1. The committee is interested to know each field of the data collected through 
# descriptive analysis to gain basic insights into the data set and to prepare for 
#further analysis.
# statistical summary of the insurance data
summary(insurance_data)
str(insurance_data) # structure of the insurance data 

# 2. The total value of payment by an insurance company is an important factor to be 
# monitored. So the committee has decided to find whether this payment is related to 
# the number of claims and the number of insured policy years. They also want to 
# visualize the results for better understanding. 
# correlation of claims and no. of insured years with payment
cor(insurance_data$Claims, insurance_data$Payment)
# correlation of Claims with Payment = 99.54%. They are positively correlated
cor(insurance_data$Insured, insurance_data$Payment)
# correlation of insured with payment = 93.32%. They are positively corrrelated

# Regression model to check the relation between Claims, Insured 
# with dependent variable Payment
result<-lm(formula = Payment~Insured + Claims, data = insurance_data)
summary(result)
# Visualizing the data
plot(insurance_data$Claims, insurance_data$Payment)
plot(insurance_data$Insured, insurance_data$Payment)

# 3. The committee wants to figure out the reasons for insurance payment increase and decrease.
# So they have decided to find whether distance, location, bonus, make, and insured amount or 
# claims are affecting the payment or all or some of these are affecting it.
# Regression model to check the relation between the dependent variable, Payments with all the 
#independent variables.
result1 <- lm(formula= Payment~ .,data = insurance_data)
summary(result1)  
# From the summary of the regression model, we can conclude that distance, location,
# Insured and Claims have very strong significance with the dependent variable, Payment.
# p-value of Kilometers = 1.18e-05, Zone = 0.027, Insured < 2e-16, Claims < 2e-16
# Bonus and Make have p-value>0.05. hence they are not significant

# 4. The insurance company is planning to establish a new branch office, so they are interested 
# to find at what location, kilometre, and bonus level their insured amount, claims, and 
# payment gets increased.
agg_kilometer<-aggregate(x=insurance_data[,5:7], by=insurance_data[c(1)], FUN=mean)
agg_kilometer
# At a distance of < 1000 Kilometer, the number of Insured in policy-years is maximum, but
# the Claims and Payments are higher in the Kilometer range of 1000-15000.
 

agg_location<-aggregate(x=insurance_data[,5:7], by = insurance_data[(2)], FUN=mean)
agg_location
# The Insured, the Claims and the Payments are maximum in the Zone 4, ie, the rural areas
# in Southern Sweden.

agg_bonus<-aggregate(x=insurance_data[,5:7], by = insurance_data[(3)], FUN=mean)
agg_bonus
# At a bonus level of 7, the Insured, Claims and Payments are maximum.

# 5. The committee wants to understand what affects their claim rates so as to decide 
# the right premiums for a certain set of situations. Hence, they need to find whether 
# the insured amount, zone, kilometre, bonus, or make affects the claim rates and to what extent. 
# Regression model to check the effect of insured amount, zone, kilometre, bonus, 
# make on the claim rates 
claim_result<-lm(formula=Claims~Insured+Zone+Kilometres+Bonus+Make, data = insurance_data)
summary(claim_result)
# The summary of the Regression model shows that all the independent variables
# have a strong impact on the Claim rates.
