data <- read.csv("AllDataB.csv")

names(data)[grep("Total.Hg.Wet..ppm.", names(data))] <- "ppm"
names(data)[grep("TROPHIC.LEVEL", names(data))] <- "TROPHIC"
data[,"TROPHIC"] <- factor(data[,"TROPHIC"], label=c("T1", "T2", "T3"))
data[,"Season"] <- factor(data[,"Season"], label=c("Wet", "Dry"))
data[,"MIGRATORY"] <- factor(data[,"MIGRATORY"], label=c("NoM", "M"))
data[, "RawPpm"] <- (data[, "ppm"])
data[, "ppm"] <- log(data[, "ppm"])
data[,"RiverShort"] <- data[,"River"]
data[,"River"] <- factor(data[,"RiverShort"], labels=c("Heath", "Malinowski", "Tambopata"))
data[,"River"] <- factor(data[,"River"], levels=c("Tambopata", "Malinowski", "Heath"))

table(data$River, data$RiverShort)

plot(ppm~RTP, data=data, col=data$River)

png("RTP_River.png", width=800, height=800)
par(mfrow=c(2,2))
for(r in levels(data$River)){
  subData <- data[data$River==r,]
  plot(ppm~RTP, data=subData, col=subData$Season, main=r, ylab="Total Hg (mg/kg)")
  legend("topleft", levels(data$Season), fill=1:2, bty="n")
}
dev.off()

png("RTP_Season.png",, width=800, height=800)
par(mfrow=c(2,2))
for(ss in levels(data$Season)){
  subData <- data[data$Season==ss,]
  plot(ppm~RTP, data=subData, col=subData$River, main=ss, ylab="Total Hg (mg/kg)")
  legend("topleft", levels(data$River), fill=1:3, bty="n")

}
dev.off()



for(ss in levels(data$Season)){
for(r in levels(data$River)){
  subData <- data[data$Season==ss & data$River==r,]
  # plot(ppm~RTP, data=subData, col=subData$River, main=ss)
  a<- summary(glm(ppm~RTP, data=subData))
  cat(ss, r, a$coefficients[2, c(1,4)], fill=T)
}
}

a<- summary(glm(ppm~RTP, data=data))
cat(a$coefficients[2, c(1,4)], fill=T)



a<- summary(glm(ppm~RTP + RTP:River + RTP:Season + (River+Season)^2, data=data))
a
cat(a$coefficients[2, c(1,4)], fill=T)