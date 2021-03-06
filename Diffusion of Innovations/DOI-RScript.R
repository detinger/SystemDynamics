## Diffusion of Innovations model


# install.packages("simecol")
library(simecol)

# install.packages("latticeExtra")
library(latticeExtra)

library(ggplot2)


##############################################################
#
# adoptionrate <- something_you_are_interested_in
# list(c(dPA, dAD), adoptionrate, other_interesting_value)
#
##############################################################


# AR - Adoption Rate, 
# AFA - Adoption from Advertising, 
# AFWOM - Adoption from Word of Mouth
# TP - Total Population, 
# AF - Adoption Fraction, 
# AE - Advertising Effectiveness
# CR - Contact Rate, 
# PA - Potential Adopters, 
# AD - Adopters




DOI <- new("odeModel",
           main = function (time, init, parms, ...) {
             x <- init
             p <- parms
             
             AFA    <- (x[1]*p["AE"])
             AFWOM  <- (x[1]*p["CR"]*p["AF"]*(x[2]/p["TP"])) 
             AR     <- ((x[1]*p["AE"]) + (x[1]*p["CR"]*p["AF"]*(x[2]/p["TP"])))
             
             dAD    <- ((x[1]*p["AE"]) + (x[1]*p["CR"]*p["AF"]*(x[2]/p["TP"])))
             dPA    <- - ((x[1]*p["AE"]) + (x[1]*p["CR"]*p["AF"]*(x[2]/p["TP"])))
             
             list(c(dPA, dAD), AR, AFA, AFWOM)
           },
           parms  = c(TP=10000, AF=0.015, AE=0.011, CR=100),
           times  = c(from=0, to=8, by=0.1),
           init   = c(PA=10000, AD=0),
           solver = "rk4")

# AR - Adoption Rate, AFA - Adoption from Advertising, AFWOM - Adoption from Word of Mouth
# TP - Total Population, AF - Adoption Fraction, AE - Advertising Effectiveness
# CR - Contact Rate, PA - Potential Adopters, AD - Adopters

DOI <- sim(DOI)
plot(DOI)

DOI.data <- out(DOI)

names(DOI.data)[1] <- "Year"
names(DOI.data)[4] <- "AR"
names(DOI.data)[5] <- "AFA"
names(DOI.data)[6] <- "AFWOM"



DOI.data$Type <- "Model simulation"


ggplot(DOI.data, aes(Year)) + 
  geom_line(aes(y = AFA, colour = "AFA")) + 
  geom_line(aes(y = AFWOM, colour = "AFWOM"))

ggplot(DOI.data, aes(Year)) + 
  geom_line(aes(y = AD, colour = "Adopters")) +
  geom_line(aes(y = PA, colour = "Potential Adopters")) +
  geom_line(aes(y = AR, colour = "Adoption Rate"))
  
  
write.table(DOI.data, "~/Desktop/DOI.txt", sep="\t")

