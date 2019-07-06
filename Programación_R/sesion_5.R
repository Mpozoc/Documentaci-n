## clase 5 de R
## Profesor Raimundo S?nchez
## Data Science UAI

setwd("/Users/manuelpozo/documents/magister/Programación R")

## Aplicar modelos simples 
## Ejemplo de clasificacion de vuelos comerciales.

## CARGAR DATOS DESDE archivo de texto plano 
datos_vuelos = read.table("kpi.csv",header = TRUE,sep=";",dec=",")
library(lubridate)
datos_vuelos$fec_vuelo = as.Date(substr(datos_vuelos$fec_vuelo,1,10),"%Y/%m/%d")

## el objetivo es agrupar vuelos similares en desempe?o comercial, de manera de encontrar patrones
## comenzaremos por explorar la tabla, para ver con que nos encontramos.


summary(datos_vuelos)



## la base tiene 25 columnas
## dow es dia de la semana
## origen y destino son codigos IATA de aeropuertos
## cabina Y es economy, J y W es business y premium economy respectivamente
## ingresos del vuelo esta en dolares
## tramos cerrados es dias con quiebres de stock
## pax es pasajeros. 
## no show son pax que no llegaron al vuelo
## FF, FX, LE y SP representan 4 tipos de tarifas, que van desde Full Flexible, hasta la mas restrictiva
## grupo son pasajeros que compraron a traves de agencias de viajes
## conex son pax en conexion, hacia un destino domestico, o internacion
## directo son los pax que solo volaron ese tramo

## debemos elegir las variables relevantes para segmentar los vuelos.
## lo primero es comparar unidades equivantes
## haremos el ejercicio solo para cabina economy
datos_vuelos = datos_vuelos[datos_vuelos$cabina =="Y",]

## Revenue Management busca maximizar los ingresos totales
## ingresos = precio promedio * cantidad
## esto significa que estas 2 variables son lo minimo que deberiamos analizar (P y Q)

## calculamos el precio promedio del vuelo, o tarifa media
datos_vuelos$Tarifa_media = datos_vuelos$ingresos / datos_vuelos$pax

## exploramos la relacion entre P y Q
plot(datos_vuelos$Tarifa_media,datos_vuelos$pax)

## el alto volumen de los datos dificulta la visualizacion
## creamos una base de muestra para inspeccionar visualmente
muestra_vuelos = datos_vuelos[sample(1:nrow(datos_vuelos),5000),]
plot(muestra_vuelos$Tarifa_media,muestra_vuelos$pax)

## vemos que hay diferentes grupos de vuelo, segun tarifa media y pax
## la tarifa media tambien esta relacionada con el largo del vuelo, no solo desempe?o comercial
plot(muestra_vuelos$Tarifa_media,muestra_vuelos$distancia)

## construimos entonces un indice, que llamaremos yield
## es la tarifa media dividido en el numero de kilometros
datos_vuelos$yield = datos_vuelos$Tarifa_media / datos_vuelos$distancia * 100


## a su vez, los pax estan relacionados con la capacidad del avion
plot(muestra_vuelos$asientos,muestra_vuelos$pax)

## construimos entonces un indicador de ocupacion, o factor de ocupacion (FO)
datos_vuelos$FO = datos_vuelos$pax / datos_vuelos$asientos

## generamos muestra con nuevas variables y visualizamos
muestra_vuelos = datos_vuelos[sample(1:nrow(datos_vuelos),5000),]

## visualizamos ambas metricas
plot(muestra_vuelos$Tarifa_media,muestra_vuelos$pax)
plot(muestra_vuelos$yield,muestra_vuelos$FO)
hist(muestra_vuelos$yield)
## la base presenta diversos ouliers en la dimension yield
## vamos a limpiarlos, manteniendo el 95% de los datos
## generamos nueva tabla sin outliers (SO)
datos_vuelos_SO = datos_vuelos[
                  datos_vuelos$yield < quantile(datos_vuelos$yield,.975) & 
                    datos_vuelos$yield > quantile(datos_vuelos$yield,.025) , ]   

## generamos muestra de vuelos sin ouliers
muestra_vuelos_SO = datos_vuelos_SO[sample(1:nrow(datos_vuelos_SO),5000),]

## visualizamos vuelos sin outliers
plot(muestra_vuelos_SO$yield,muestra_vuelos_SO$FO)
plot(density(muestra_vuelos_SO$yield,muestra_vuelos_SO$FO))
## antes de la transformacion, PxQ = ingresos
## ahora, Yield*FO es igual a:
## Tarifa media / distancia * pax / asientos
## es igual a ingresos / (distancia*asientos)
## a distancia * asientos le llamaremos ASK (available seat kilometer)
##a ingresos / ASK lo llamaremos rask (revenues per ask)

## calculamos el rask
datos_vuelos_SO$rask = datos_vuelos_SO$yield * datos_vuelos_SO$FO

## exploramos el rask
hist(datos_vuelos_SO$rask)

## existen muchas combinaciones de FO y Yield que generan el mismo rask
## a estas combinaciones las llamaremos iso-rask

plot(muestra_vuelos_SO$yield,muestra_vuelos_SO$FO)
## graficamos las curvas iso-rask que dividen los diferentes cuartiles
lines(quantile(datos_vuelos_SO$rask,.25)/(1:25), col = "red")
lines(quantile(datos_vuelos_SO$rask,.5)/(1:25), col = "red")
lines(quantile(datos_vuelos_SO$rask,.75)/(1:25), col = "red")
## agregamos una division al ultimo decil de mejor desempe?o
lines(quantile(datos_vuelos_SO$rask,.9)/(1:25), col = "red")

#####  
