m= 1:10
m
dim(m) = c(2,5)
m

getwd()


setwd("/Users/manuelpozo/documents/github/orange-economy")
datos_curso =read.table("orangeec.csv", header=T, sep=",", dec=".")
head(datos_curso)
tail(datos_curso)
glimpse(datos_curso)

qplot(datos_curso$Country,
       geom="histogram",
       xlab="paises",
       main="paises por cantidad")

mtcars=read.table("mtcars.csv", header=T, sep=",", dec=".")

qplot(mtcars$hp,
      geom="histogram",
      xlab="caballos",
      main="autos por caballos")

mtcars

plot(mtcars$mpg ~ mtcars$cyl,
     xlab="cilindros", ylab="millas por galón",
     main="relacion cilindros vs galon")
class(mtcars)
str(mtcars)

plot(datos_curso$Unemployment ~ datos_curso$Education.invest...GDP,
     xlab="cinversión educación", ylab="desempleo",
     main="relacion inversión educación")

ggplot(mtcars, aes(x=hp)) + 
  geom_histogram(binwidth = 30) + 
  labs(x="HP fuerza", y ="#autos", title = "HP en autos seleccionados" +
         theme(legend.position = "none")) +
  theme(panel.background = element_blank(), panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

boxplot(mtcars$hp,
        ylab="HP",
        main="HP por autos"
        )

ggplot(mtcars, aes(x=as.factor(cyl),y=hp,fill=cyl)
       ) +
  geom_boxplot() +
  labs(x="cilindros", y ="HP",
       title = "HP segun cilindros") +
  theme(panel.background = element_blank(), panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())


?mtcars
?datos_curso

economy = mean(datos_curso$GDP.PC)

datos_curso = datos_curso %>%
  mutate(strong_econo = ifelse(GDP.PC < economy,
                            "Debajo Pib","'Sobre Pin"))

ggplot(datos_curso, aes(x= strong_econo, y= Creat.ind...GDP, fill= strong_econo)) + 
  geom_histogram(binwidth = 30) + 
  labs(x="HP fuerza", y ="#autos", title = "HP en autos seleccionados" +
         theme(legend.position = "none")) +
  theme(panel.background = element_blank(), panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())


ggplot(datos_curso, aes(x= strong_econo, y= Creat.Ind...GDP, fill= strong_econo)
       ) +
  geom_boxplot(alpha=0.4) +
  labs(x="Tipo Pais", y ="aporte Economia",
       title = "Paises y sus aportes") 
 
str(datos_curso)
pairs(mtcars[,2:6])cor(mtcars[,2:6])


summary(mtcars)
















