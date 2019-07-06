## clase 3 de R
## Profesor Raimundo S?nchez
## Data Science UAI

setwd("C:/Users/raimundo/Dropbox/01.Clases/2019.MDS_R para DataScience")

### Webscraping. 
### Ejemplo para una pagina de rankings de Sandwiches.
### www.sanguchez.com

### homepage dinamica: webscraping dinamico
### pagina de cada sandwich estatica: webscraping estatico

### hoy veremos del 2do tipo

### objetivo del webscraping es llevar informacion que esta en una pagina web, a un dataframe

### ejemplo de pagina https://365sanguchez.com/alba-hotel-matanzas/
### de cada pagina queremos extraer informacion relevante:
### nota 
### nombre
### direccion
### precio
### ingredientes
### descripcion


### creo la varialbe url donde almacen la direccion del ejemplo
url = "https://365sanguchez.com/alba-hotel-matanzas/"

### usamos liberia rvest que tiene funciones para ingestar html
library('rvest')

### cargo el contenido desde el sitio
contenido_pagina <- read_html(url)

### de la estructura de html, extraigo el nodo que se llama ".bdt-heading-title"
### este nodo corresponde al cuadro de la derecha, con nombre, direccion, precio e ingredientes
### nombre de este nodo lo obtengo a partir de inspeccionar la pagina, utilizo selector gadget para esto
### https://chrome.google.com/webstore/detail/selectorgadget/mhjhnkcfbdhnjickkkdbjoemdmbfginb?hl=en

cuadro <- html_text(html_nodes(contenido_pagina,'.bdt-heading-title'))
cuadro <- gsub("\n","",cuadro) ### quito saltos de pagina convertidos en texto
cuadro <- gsub("\t","",cuadro) ### quito tabuladores convertidos en texto

cuadro
## extraigo informacion del cuadro
Local = gsub("Local: ","",cuadro[1]) ## le quito el texto "Local: " al primer objeto del vector cuadro
Direccion = gsub("Direcci?n: ","",cuadro[2]) # idem
Precio = gsub("Precio: ","",cuadro[3]) #idem
Ingredientes = gsub("Ingredientes: ","",cuadro[4])

cuadro[1]

### ya explotamos ese nodo.
### ahora queremos saber la nota.
### la nota, medida en narices de cerdo, esta como imagen #facepalm
### pero el nombre de la imagen contiene el numero de puntos obtenidos

### nuevamente con selectorgadget, identificamos el nombre del nodo 
### que contiene la imagen de la nota como ".size-full"
nota <- html_attr(html_nodes(contenido_pagina,'.size-full'), "src")[2]

nota
### extraigo el numero de la nota desde el nombre del archivo
nota =  as.numeric(substr(strsplit(nota,"nota")[[1]][2],1,1))

### finalmente, con selectorgadget, identificamos el nombre del nodo 
### de la descripcion ".elementor-element-populated"

### extraemos el texto de descripcion ese nodo
texto <-   html_text(html_nodes(contenido_pagina,'.elementor-element-populated'))
texto <- texto[[3]] ## tercer elemento del nodo contiene la descripcion
texto <- gsub("\n","",texto) ## limpiamos texto
texto <- gsub("\t","",texto) ## limpiamos texto

# creo lista con la data
list(c(Local,Direccion,Precio,Ingredientes,nota,texto))

###### CREAMOs UNA FUNCION CON LO DE ARRIBA

extrae_data_url = function(url){
  library(rvest)
  ## creo variable dataframe para devolver una fila de informacion
  data_url = as.data.frame(url)
  #Reading the HTML code from the website
  contenido_pagina <- read_html(as.character(url))
  
  cuadro <- html_text(html_nodes(contenido_pagina,'.bdt-heading-title'))
  cuadro <- gsub("\n","",cuadro)
  cuadro <- gsub("\t","",cuadro)
  data_url$Local = gsub("Local: ","",cuadro[1])
  data_url$Direccion = gsub("Direcci?n: ","",cuadro[2])
  data_url$Precio = gsub("Precio: ","",cuadro[3])
  data_url$Ingredientes = gsub("Ingredientes: ","",cuadro[4])
  
  nota <- html_attr(html_nodes(contenido_pagina,'.size-full'), "src")[2]
  
  data_url$nota =  as.numeric(substr(strsplit(nota,"nota")[[1]][2],1,1))
  
  texto <-   html_text(html_nodes(contenido_pagina,'.elementor-element-populated'))
  texto <- texto[[3]]
  texto <- gsub("\n","",texto)
  texto <- gsub("\t","",texto)
  
  data_url$texto = texto
  
  return(data_url)
}


#load directorio
direc = read.csv("directorio.csv",header=F)

## creo base de datos vacia para ir poblando con las paginas
dataset = NULL
# para cada url
for (i in 1:nrow(direc)) {
  ## para cada direccion, genero la fila y la anexo a la base de datos
  dataset = rbind(dataset,extrae_data_url(direc[i,1]))
}

### guardo base de datos en algun lado
write.table(dataset,"sanguchez.csv",sep=";",row.names = F, header = T)
