### Esto es un comentario, ayudan a ordenar el codigo y mantener el proceso documentado.

###### Variables ######

a = 1 ## Numeric ##
b = "hola" ## Character ##
c = TRUE ## Logical ##
d = c(1:10) ## Vector ##
e = matrix(1:4,2,2) ## Matrix ##
f = list(a,b,c)   ## List ##

## devuelve la clase de la variable
class(a)

## Funciones IS, AS 
## Se puede ver la clase que pertenece una variable
is.numeric(a)
is.character(b)
is.logical(c)
is.vector(d)
is.matrix(e)
is.list(f)

is.numeric(f)
is.character(c)

? is.numeric ## HELP nativo de R, primer paso ante dudas, el segundo paso es google

## Se puede cambiar el tipo de una variable
a1 = as.character(a)
is.numeric(a1)

b1 = as.numeric(b)
b1
## Existen diferentes tipos de valores especiales. A veces aparecen
# NA : not available
# NaN: not a number
# inf: infinito

###### Operaciones matematicas comunes ######

## Suma 
suma = 4 + 9
suma

## Resta 
Resta = 8 - 3
Resta

## Multiplicacion
multiplicacion = 4 * 12
multiplicacion

## Division
Division = 8 / 4
Division

## Potencia 

Potencia = 5 ^ 9
Potencia

## Pi
pi

## Se respeta el orden de las operaciones
OP1 = ((2^3)*4-2)/10
OP1

## Exponencial
exp1=exp(2)
exp2=exp(0)

## Logaritmo natural
ln=log(0)
ln1=log(1)

###### Funciones matematicas para vectores ######

sequencia = 1:5  
vector= c(sequencia)
vector

## promedio
promedio=mean(vector)
promedio

## sumatoria
suma=sum(vector)
suma

## suma acumulada
suma_a=cumsum(vector)
suma_a

## Producto acumulado
prod_a=cumprod(vector)
prod_a

## transposicion
trans=t(vector)
trans

## Producto punto
vector_2=2:6
p_punto=trans %*% vector_2 
p_punto

#### FIN variables

###### FLOWCHART 1 ####
## START ##
num1 = 5 #ingresa primer numero
num2 = 6 #ingresa segundo numero
sum = num1 + num2
print(sum)

###### Condicional If-Else ###### 

a=2
b="Palabra"

### condicion simple
if(is.character(b)==T){
  print("hola mundo")
}

### condicion compuesta
if(is.character(b)==T){
  print("hola mundo")
} else{
  print("La variable no es de tipo caracter")
}

if(is.character(a)==T){
  print("hola mundo")
}else{
  print("La variable no es de tipo caracter")
}

### Fin condicional

###### FLOWCHART 2 ###### 
## START ##
num1 = 3 #ingresa primer numero
num2 = 2 #ingresa segundo numero
num3 = 8 #ingresa tercer numero

if (num1 > num2) {
  if (num1 > num3)   {
    print(num1)
  } else {
    print(num2)
  }
} else {
  if( num2 > num3)   {
    print(num3)
  } else {
    print(num2)
  }
}

###### Ciclos While ###### 

a1=10
b1=1

while(b1<a1){
  print(b1)
  b1=b1+1
}

###### Ciclos For ###### 

for(i in 1:10){
  print(i^2) 
}

###### Combinacion de estructuras ###### 
l=100
aux=0
for(i in 1:l){
  if(i<(l/2) ){
    print(i) 
  }else{
    break
    aux=1
  }
  if(aux == 1){
    print("flag") 
  }
}

###### FLOWCHART 3 ######
## START ##
fterm = 0
sterm = 1
temp = NULL

while(sterm<=1000){
  print(sterm)
  temp = sterm
  sterm = fterm+sterm
  fterm = temp
}

### FIN PRIMERA PARTE

####### Cargar y explorar datos externos ###### 

## SETEAR EL DIRECTORIO DE TRABAJO
getwd()
setwd("C:/Users/Raimundo/Dropbox/01.Clases/2019.MDS_R para DataScience")


## CARGAR DATOS DESDE archivo de texto plano 
datos_curso = read.table("Perfil Alumnos MDS 2019.csv",header = TRUE,sep=";")
datos_curso = read.table(file.choose(),header = TRUE,sep=";")
## Leer texto plano desde el portapapeles
datos_curso = read.table("clipboard",sep="\t",header=T)


## ALGUNOS COMANDOS PARA EXPLORAR LA TABLA 
summary(datos_curso)  ## resumen de estadisticas
head(datos_curso)     ## encabezados
dim(datos_curso)      ## revisar las dimnesiones
names(datos_curso)    ## Nombre de las variables o las columnas
str(datos_curso)      ## Estructura de las variables
colnames(datos_curso) ## Nombres de las columnas


###### TRABAJAR CON FILAS O COLUMNAS
datos_curso[1,1]          ### estructura de la matriz es RC (row, column) datos_curso[1,1] da el valor de la fila 1 y columna 1

datos_curso[1,]           ### obtengo solo la fila 1 y todas las columnas
datos_curso[1:4,]         ### obtengo filas de 1 a la 4 y todas las columnas
datos_curso[,1:4]         ### obtengo columnas de 1 a la 4 y todas las filas
datos_curso[1:10, "Edad"]   ### obtengo filas de 1 a 10 y columna "PV"
datos_curso[c(1,5),1]     ### obtengo filas de 1 y 5 y columna 1
datos_curso[-(1:14),]  ### quito las filas de la 1 a la 10000

#las variables de mencionan con el signo "$"
datos_curso$Edad[1:10]        ### obtengo los valores de 1 a 10 de la columna "Edad" 
datos_curso[datos_curso$Edad<30,]   ### obtengo las filas que cumplan con que AP es menor a 30, y todas las columnas
### asigno sub base anterior a una nueva variable
datos_curso_sub30 = datos_curso[datos_curso$Edad<30,]

#tabla de Frecuencia de una variable
frecuencias = table(datos_curso$Edad)

#crear nuevas variables
datos_curso$ID = paste(datos_curso$Nombres,datos_curso$Paterno,datos_curso$Materno,sep="@")  ## paste es como CONCATENAR
datos_curso$inicio_laboral = datos_curso$Edad - datos_curso$Experiencia.Laboral ## puede ser cualquier operacion matematica


mean(datos_curso$Edad) #Media de Edad
var(datos_curso$Edad) #Varianza de Edad
sd(datos_curso$Edad) #Desviacion Estandard de Edad
cov(datos_curso$Edad, datos_curso$Experiencia.Laboral) #Covarianza de dos variables
cor(datos_curso$Edad, datos_curso$Experiencia.Laboral) #Correlacion de dos variables


##### Transformaciones de tablas ########

agg1 = aggregate(Experiencia.Laboral ~ Nacionalidad  ,data=datos_curso,mean) ## para cada ID_tramo, suma todos los Fare tramos
agg1

agg2 = aggregate(Edad ~ Nacionalidad,data=datos_curso,mean) ## para cada ID_tramo, calcula el promedio de Edad
agg2

agg3 = aggregate(Edad ~ Nacionalidad,data=datos_curso,length) ## para cada ID_tramo, calcula el largo de la base (similar a count en una tabla dinamica)
agg3

agg4 = aggregate(cbind(Edad,Experiencia.Laboral)~ Nacionalidad,data=datos_curso,mean) ## para cada ID_tramo, calcula el promedio de 2 variables
agg4

### rm es remove, borra variables del ambiente de trabajo
rm(agg3)

##### COMBINAR TABLAS

## merge(datos X, datos Y, llave X, llave Y)
merg1 = merge(agg1,agg2,by="Nacionalidad",all.y = TRUE)
merg2 = merge(agg1,agg2,by.x="Nacionalidad",by.y="Nacionalidad")
merg3 = merge(datos_curso,agg4,by="Nacionalidad")

###### ORDERNAR TABLAS
datos_curso = datos_curso[order(datos_curso$Edad),]  ## ordena ascendiente segun tarifa media
datos_curso = datos_curso[order(-datos_curso$Edad),] ## ordena descendiente segun tarifa media
datos_curso = datos_curso[order(-datos_curso$Experiencia.Laboral,datos_curso$Edad),] ## ordena segun 2 criterios

##### EXPORTAR TABLA
write.table(datos_curso,"output/datos_procesados.csv",sep=";",dec=",",row.names = F)

##### Crear graficos #####
plot(table(datos_curso$Edad)) ### grafico de frecuencias

#Diagrama de cajas (box plot)
boxplot(Edad~Nacionalidad, data=datos_curso)

#Histograma
hist(datos_curso$Edad)

#Densidad
plot(density(datos_curso$Edad))

# Grafico de dispersion (Scatter plot)           
plot(datos_curso$Edad, datos_curso$Experiencia.Laboral)