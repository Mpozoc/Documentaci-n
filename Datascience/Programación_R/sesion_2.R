## clase 2 de R
## Profesor Raimundo Sánchez
## Data Science UAI

setwd("C:/Users/raimundo.sanchez/Dropbox/01.Clases/2019.MDS_R para DataScience")

## CARGAR DATOS DESDE archivo de texto plano 
datos_curso = read.table("Perfil Alumnos MDS 2019.csv",header = TRUE,sep=";")

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
datos_curso[1:10, "Edad"]   ### obtengo filas de 1 a 10 y columna "Edad"
datos_curso[c(1,5),1]     ### obtengo filas de 1 y 5 y columna 1
datos_curso[-(1:14),]  ### quito las filas de la 1 a la 10000

#las variables de mencionan con el signo "$"
datos_curso$Edad[1:10]        ### obtengo los valores de 1 a 10 de la columna "Edad" 
datos_curso[datos_curso$Edad<30,]   ### obtengo las filas que cumplan con que Edad es menor a 30, y todas las columnas
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

##### Funciones ######

## creo una funcion que cambia campos en NAs por ceros
limpia_NAs_por_ceros <- function(datos){
  datos[is.na(datos)] = 0
  return(datos)
}

## creo un nuevo dataframe para almacenar datos limpios
datos_sin_NAs <- limpia_NAs_por_ceros(datos_curso)

##### Agregacion de tablas ########

agg1 = aggregate(Experiencia.Laboral ~ Nacionalidad  ,data=datos_curso,mean) ## para cada Nacionalidad, suma toda la Experiencia laboral
agg1

agg2 = aggregate(Edad ~ Nacionalidad,data=datos_curso,mean) ## para cada Nacionalidad, calcula el promedio de Edad
agg2

agg3 = aggregate(Edad ~ Nacionalidad,data=datos_curso,length) ## para cada Nacionalidad, calcula el largo de la base (similar a count en una tabla dinamica)
agg3

agg4 = aggregate(cbind(Edad,Experiencia.Laboral)~ Nacionalidad,data=datos_curso,mean) ## para cada Nacionalidad, calcula el promedio de 2 variables
agg4

### rm es remove, borra variables del ambiente de trabajo
rm(agg3)

##### COMBINAR TABLAS
## merge(datos X, datos Y, llave X, llave Y)
merg1 = merge(agg1,agg2,by="Nacionalidad",all.y = TRUE)
merg2 = merge(agg1,agg2,by.x="Nacionalidad",by.y="Nacionalidad")
merg3 = merge(datos_curso,agg4,by="Nacionalidad")

###### ORDERNAR TABLAS
datos_curso = datos_curso[order(datos_curso$Edad),]  ## ordena ascendiente segun Edad
datos_curso = datos_curso[order(-datos_curso$Edad),] ## ordena descendiente segun Edad
datos_curso = datos_curso[order(-datos_curso$Experiencia.Laboral,datos_curso$Edad),] ## ordena segun 2 criterios

###### EJEMPLO DE LIMPIAR COLUMNAS
## Columna de Antiguedad en el cargo, tiene los datos como factores
class(datos_curso$Antiguedad)
## cambiamos clase a caracter, para tratar este campo como texto
datos_curso$Antiguedad = as.character(datos_curso$Antiguedad)

## ademas hay 8 alumnos con este campo vacio
table(datos_curso$Antiguedad)
## poblamos la base de datos con algo distinto de vacio, asumimos cero experiencia
datos_curso[datos_curso$Antiguedad == "",]$Antiguedad = "0 Años 0 Meses"

### tenemos la base completa

### ahora queremos transformarla en numero
### haremos esto separando el texto en columnas

## creamos variable auxiliar "antiguedad", almacenamos ahi la separacion por columnas.
antiguedad = strsplit(datos_curso$Antiguedad," ")
class(antiguedad) ## antiguedad es una lista
## pasamos la lista a dataframe concatenando las sub-listas
antiguedad = do.call(rbind.data.frame,antiguedad )
## generamos nombres para las columnas
colnames(antiguedad) = c("anios","anios2","meses","meses2")
## pasamos las columnas que corresponden a numeros, a variable numerica
antiguedad$anios = as.numeric(antiguedad$anios)
antiguedad$meses = as.numeric(antiguedad$meses)

## creamos la variable numerica antiguedad en años con decimales incluidos. 
antiguedad$anios_tot = antiguedad$anios + antiguedad$meses / 12

## asignamos valor generado en variable auxiliar al dataframe que estabamos trabajando
datos_curso$Antiguedad = antiguedad$anios_tot
rm(antiguedad) # quitamos antiguedad del ambiente de trabajo para liberar espacio. 

##### EXPORTAR TABLA
write.table(datos_curso,"datos_procesados.csv",sep=";",dec=",",row.names = F)

#####  guardar calculos para poder retomar en cualquier momento
save(list = ls(all = TRUE), file= "calculos.RData")

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

#exportar grafico como figuras
dev.copy(png,"imagen.png")
dev.off()


######## PROBLEMA DE FORMACION DE GRUPOS   #######
## para formar grupos de igual handicap, necesitamos esa informacion 

### hay 2 caminos posibles, no excluyentes
### 1. Generar la informacion con una segunda fuente de datos
### 2. Inferir la informacion a partir de las columnas disponibles en el dataframe

### OPCION 1: Generemos la informacion a partir de Google Sheets
## llenen su handicap en el siguiente link
## https://docs.google.com/spreadsheets/d/1AUrwm7h9u1tblVE-09PKsjYpHSAgwsSOUF7PqL6jNmw/edit?usp=sharing
#### handicap es el logaritmo en base 10 del numero de horas de experiencia programando (aproximado)
#### 0 = 1 hora programando (clase pasada)
#### 1 = 10 horas programando
#### 2 = 100 horas programando
#### 3 = 1000 horas programando
#### 4 = 10000 o mas horas programando

## ahora necesitamos cargar esta data en R, desde google Drive
##### para esto, usaremos librerias 
#### ingesta de gdrive 
#### primero se instalan las librerias. esto solo deben hacerlo una vez
install.packages("googlesheets")
#### cada vez que se ejecute el programa debe invocar la libreria
library(googlesheets) ## en este caso libreria googlesheets permite conectarse directamente

#### lo primero es autentificar y darle permiso a R para conectarse a su cuenta de google
gs_auth(new_user = TRUE)
#### creo la variable hoja con el nombre de la llave
hoja_GSheet  = gs_key("1AUrwm7h9u1tblVE-09PKsjYpHSAgwsSOUF7PqL6jNmw")
#### leo el handicap desde la hoja seleccionada
handicap <- gs_read(hoja_GSheet)

## agregar esta info en el dataframe
datos_curso = merge(datos_curso,handicap,by=c("Nombres","Paterno","Materno"))

### OPCION 2: Generemos la informacion a partir de las columnas disponibles en el dataframe
## aca tenemos que hacer supuestos
## SUPUESTO: aquellos que pasaron por alguna carrera de ingenieria tienen algo de conocimiento de programacion
## EXCEPCION: ingenieria comercial
## exploremos casos unicos de Titulos
unique(datos_curso$Titulo)

## ingenieros aparecen de 8 formas diferentes
## Ingeniero, Ingeniera, Ingeniería, INGENIERO, Ing, ing, Ingenieria, ING, Engineering
## todos comparten la raiz ING, aunque en diferentes formatos
## la expresion regular de esto es "(?i)ing", donde (?i) denota que no distinga mayusculas y minusculas 
## creamos campo binario (verdadero falso) si el titulo contiene la raiz de ingeniero
datos_curso$profesion_ing = grepl("(?i)ing",datos_curso$Titulo) ## grepl devuelve T/F si el texto se encuentra en el vector

## esto aun considera ingenieros comerciales
## ingenieros aparecen de 8 formas diferentes
## COMERCIAL, Comercial  
## creamos campo binario (verdadero falso) si el titulo contiene la raiz de ingeniero y no contiene la raiz comercial
datos_curso$profesion_ing = grepl("(?i)ing",datos_curso$Titulo) & !grepl("(?i)comercial",datos_curso$Titulo)

## Ahora creamos grupos de igual handicap. grupos de N = 4
## ALGORITMO:
## paso 1: creamos puntaje de handicap con los 2 valores obtenidos hasta ahora.
datos_curso$puntaje = datos_curso$handicap + datos_curso$profesion_ing

## paso 2: ordenamos alumnos segun puntaje
datos_curso = datos_curso[order(datos_curso$puntaje),]  ## ordena ascendiente segun Edad

## paso 3: estimamos numero de grupos, casos borde son grupos de 5, no de 3
numero_de_grupos = floor(nrow(datos_curso)/4)

## paso 4: asignamos valores de cada grupo en orden descendiente 
datos_curso$grupo = rep(1:numero_de_grupos,5)[1:nrow(datos_curso)]

## guardar en gdrive
gs_edit_cells(hoja_GSheet, ws = "grupos", anchor = "A1", input = datos_curso[,c("Nombres","Paterno","Materno","grupo")], byrow = FALSE)
