# Para comentarios
# Declarar Variables
a = 1
b = "Hola"
c=TRUE
d= c(1:10)
e = matrix(1:4,2,2)
class(e)
is.numeric(a)
as.numeric(a)

# 3 tipos de variables especiales NA  NaN inf Null
# Operaciones matemáticas
suma = 5+3
valor =pi
valor1= 2^3

# Vectores
secuencia_1 = 1:5
secuencia_2=2:6
media = mean(secuencia_1)
suma_vector = sum(secuencia_2)
suma_acumulado=cumsum(secuencia_1)

#producto punto
trans=t(secuencia_1)

p_punto =trans %*%secuencia_2

#Diagrama de Flujo######
Num1=4
Num2=7
suma=Num1+Num2
print(suma)

if (suma==10){ 
  print("Good")} else {
  print("Bad")
  }

a==2 & b=="Hola"

#Datos externos
getwd()
setwd("/Users/manuelpozo/documents/magister/Programación R")
datos_curso =read.table("Perfil Alumnos MDS 2019.csv", header=T, sep=";", dec=".")
summary(datos_curso)
































