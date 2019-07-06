## clase 4 de R
## Profesor Raimundo Sanchez
## Data Science UAI

setwd("/Users/manuelpozo/documents/magister/Programación R")


### Text Analysis. 
### Analisis de los ingredientes de los sandwiches

### lo primero es definir qu? queremos analizar:
### frecuencia de ingredientes
### relacion entre ingredientes y nota
### ejemplos visualizaciones

### comencemos por cargar los datos
dataset = read.table("sanguchez.csv",sep=";", header = T)

### ya que solo vamos a analizar la relacion entre ingredientes y nota, almacenaremos esa informacion
dataset$id = row.names(dataset) ## creamos un id para cada sandwich
Ingredientes = dataset[,c("Ingredientes","nota","id")]
Ingredientes = Ingredientes[complete.cases(Ingredientes),]
### en analisis de texto, lo primero que haremos es definir una unidad basica de analisis o tokens
### el token puede ser una palabra, combinacion de palabras, o incluso oraciones
### el texto se almacena en un objeto de la clase Corpus

### para esto, usaremos la libreria quanteda
library("quanteda")

### cambiamos el nombre de la columna a "text" para que quanteda sepa que ahi esta el texto que queremos analizar
colnames(Ingredientes)[1] = "text" 
### lo pasamos a formato caracter
Ingredientes$text = as.character(Ingredientes$text)

### construyo dataframe con ocurrencias de palabras por documentos
### se conoce como matrix documento-atributo o documento-token
matriz_documento_atributo <- tokens(corpus(Ingredientes), what = "word")  %>% ### le digo que tokenice las palabras del corpus construido a partir de los ingredientes
  tokens_remove("\\p{P}", valuetype = "regex", padding = TRUE) %>% ## remuevo la puntuacion
  tokens_remove(stopwords("spanish"), padding  = TRUE) %>% ## quito stopwords
  tokens_ngrams(n = 1) %>%  ## defino los tokens como de 1 sola palabra
  trimws( which = "both")   %>% ## quito espacio en blanco antes o despues de cada palabra
  iconv(from="UTF-8",to='ASCII//TRANSLIT') %>% ## quito caracteres extra?os
  tolower() %>% ## todo en minusculas
  dfm() ## aplico la funcion document-feature matrix a los tokens obtenidos del pipeline


nfeat(matriz_documento_atributo )

## exploramos 
sort(colnames(matriz_documento_atributo))
## existen muchos ingredientes que estan escritos con diferentes variantes
## por ejemplo "cebolla" "cebollas"  "cebollin"  "cebollita"  "cebollitas"

## esto se puede limpiar aplicando un algoritmo de stemming.
## la funcion dfm_wordstem genera un dataframe similar al anterior, pero corregido por las raices
matriz_documento_raiz =  dfm_wordstem(matriz_documento_atributo,language = "spanish")

## exploramos 
sort(colnames(matriz_documento_raiz))
## se redujeron las variantes a "ceboll" "cebollin" "cebollit"
## aun se puede limpiar mas, pero lo dejaremos hasta aca.

## el problema es que si lo queremos graficar en una nube de palabras, por ejemplo,
## van a aparecer las palabras cortadas

textplot_wordcloud( matriz_documento_raiz  ,min_count = 8, 
                    color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'))

### como se resuelve esto?
### debemos reemplazar la raiz por la palabra completa que tiene mayor frecuencia en el corpus
### por ejemplo, ceboll deberia ser reemplazado por cebolla, no por cebollas

### generamos data frame con los nombres de las columnas (palabras originales)
nombres_columnas = data.frame(colnames(matriz_documento_atributo))
colnames(nombres_columnas) = "palabra" ## cambiamos el nombre de la columna
nombres_columnas$palabra = as.character(nombres_columnas$palabra) ## cambiamos el tipo de variable
### generamos la frecuencia, contando cuantos documentos (sandwiches) aparece cada columna
nombres_columnas$frecuencia = colSums(matriz_documento_atributo)
### extraemos la raiz de la palabra con char_wordstem
nombres_columnas$raiz = char_wordstem(nombres_columnas$palabra,language="spanish")


## ordenamos por raiz y frecuencia descendiente. 
## con esto van a quedar las palabras que comparten raiz juntas, y ordenadas descendiente por frecuencia
## esto significa, que aquellas observaciones que tengan la misma raiz que la observacion superior, 
## tienen la segunda frecuencia de esa raiz
nombres_columnas = nombres_columnas[order(nombres_columnas$raiz,-nombres_columnas$frecuencia),] 


## exploramos
nombres_columnas[nombres_columnas$raiz == "ceboll",]

## si desplazamos el vector hacia abajo, podemos hacer la comparacion de 2 observaciones al comparar 2 columnas
## genero observacion anterior desplazando vector de raiz
nombres_columnas$anterior = c(0,nombres_columnas$raiz[-nrow(nombres_columnas)])

## creo columna identificando si esa palabra es la mas frecuente de su raiz
nombres_columnas$mayor_freq = 1 ## 1 significa que si

## cambiamos el valor de esta variable en los casos que la raiz sea igual a la anterior
nombres_columnas[nombres_columnas$raiz == nombres_columnas$anterior,]$mayor_freq = 0

## me quedo finalmente solo con la palabra mas frecuente de cada raiz
nombres_columnas = nombres_columnas[nombres_columnas$mayor_freq == 1,]

### ahora a cambiar las columnas del dataframe limpio

### primero extraemos los nombre actuales de las columnas
nombres_columnas2 = data.frame(colnames(matriz_documento_raiz))
colnames(nombres_columnas2) = "raiz" ## limpiamos nombre atributo
nombres_columnas2$id = 1:ncol(matriz_documento_raiz) ## creo columna de ID para preservar el orden
## combino tabla con nombres_columnas 
nombres_columnas2 = merge(nombres_columnas2,nombres_columnas,by="raiz")
### ordeno por ID para preservar el orden
nombres_columnas2 = nombres_columnas2[order(nombres_columnas2$id),] 

## reemplazo los valores de las raices por la palabra mas frecuente
colnames(matriz_documento_raiz) = nombres_columnas2$palabra

## volvemos a graficar nube de palabras
textplot_wordcloud( matriz_documento_raiz  ,min_count = 8, 
                    color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'))

str(matriz_documento_raiz)
dato = matriz_documento_raiz[Ingredientes$nota == 5,]

## podemos graficar para cada nota
textplot_wordcloud( matriz_documento_raiz[Ingredientes$nota == 1,]  ,min_count = 3, 
                    color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'))

textplot_wordcloud( matriz_documento_raiz[Ingredientes$nota == 2,]  ,min_count = 3, 
                    color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'))

textplot_wordcloud( matriz_documento_raiz[Ingredientes$nota == 3,]  ,min_count = 3, 
                    color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'))

textplot_wordcloud( matriz_documento_raiz[Ingredientes$nota == 4,]  ,min_count = 3, 
                    color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'))

textplot_wordcloud( matriz_documento_raiz[Ingredientes$nota == 5,]  ,min_count = 3, 
                    color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'))

## analicemos la nota promedio de cada igrediente
## primero multiplicamos la matriz de documento raiz (contiene 1 o 0) por la nota
matrix_nota_raiz = (matriz_documento_raiz * Ingredientes$nota) 



## creamos dataframe con los ingredientes
Ingredientes_clean = as.data.frame(colnames(matrix_nota_raiz))
colnames(Ingredientes_clean) = "ingrediente" ## formateamos nombre columna
## calculamos la cantidad de ocurrencias por ingrediente
Ingredientes_clean$ocurrencias = colSums(matriz_documento_raiz)
## calculamos la suma de nota por ingrediente
Ingredientes_clean$nota = colSums(matrix_nota_raiz)
## dividimos la suma de nota por ingrediente por las ocurrencias
Ingredientes_clean$nota = Ingredientes_clean$nota / Ingredientes_clean$ocurrencias
## reordenamos ingredientes por nota
Ingredientes_clean$ingrediente <- factor(Ingredientes_clean$ingrediente, 
                                         levels = Ingredientes_clean$ingrediente[order(-Ingredientes_clean$nota)])



## llamamos la libreria de graficos
library(ggplot2)
## hacemos un grafico de dispersion
ggplot(Ingredientes_clean[Ingredientes_clean$ocurrencias>8,], aes(nota, ingrediente)) +
  geom_point(aes(size=ocurrencias))



pairs(Ingredientes_clean)

as.numeric(dataset$Precio)
as.numeric(dataset$nota)


pairs(dataset)

