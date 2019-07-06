getwd()
setwd("/Users/manuelpozo/documents/magister/Programación R")
datos_curso =read.table("Perfil Alumnos MDS 2019.csv", header=T, sep=";", dec=".")

summary(datos_curso)
names(datos_curso)
datos_curso[1:10,"Edad"]
colnames(datos_curso)
datos_curso[1:10,"Titulo"]
frecuencias = table(datos_curso$Edad)
view(datos_curso)
table(datos_curso$Edad)
paste(datos_curso$Nombres,datos_curso$Paterno,datos_curso$Materno,sep="@") 

mean(datos_curso$Edad) #Media de Edad
var(datos_curso$Edad) #Varianza de Edad
sd(datos_curso$Edad) #Desviacion Estandard de Edad
cov(datos_curso$Edad, datos_curso$Experiencia.Laboral) #Covarianza de dos variables
cor(datos_curso$Edad, datos_curso$Experiencia.Laboral) #Correlacion de dos variables

limpia_NAs_por_cerosfunction(datos){
  datos[is.na(datos)] = 0
  return(datos)
}

limpia_NAs_por_ceros = function(datos){
  datos[is.na(datos)] = 0
  return(datos)
}

datos_sin_NAs = limpia_NAs_por_ceros(datos_curso)

sd(datos_sin_NAs$Edad)

agg1 = aggregate(Experiencia.Laboral ~ Nacionalidad  ,data=datos_curso,mean) ## para cada Nacionalidad, suma toda la Experiencia laboral

agg1

agg3 = aggregate(Edad ~ Nacionalidad,data=datos_curso,length) ## para cada Nacionalidad, calcula el largo de la base (similar a count en una tabla dinamica)
agg3

?merge


merg1 = merge(agg1,agg2,by="Nacionalidad",all.y = TRUE)
merg1

unique(datos_curso$Titulo)
?grepl
 
colnames(datos_curso)


edad_max= max.col(datos_curso$Antiguedad)




