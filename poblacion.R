library(jsonlite)
library(rjson)


# URL del API
url <- "https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/1002000001/es/00000/false/BISE/2.0/af2d1a87-37aa-4c76-0d9e-56471598b0f7?type=json"

# Llamada al API usando curl
json_data <- readLines(url(url, "r"), warn = FALSE)
respuesta <- fromJSON(paste(json_data, collapse = ""))

datosGenerales<-content(respuesta,"text")
flujoDatos<-paste(datosGenerales,collapse = " ")

#Obtención de la lista de observaciones 
flujoDatos<-fromJSON(flujoDatos)
flujoDatos<-flujoDatos $Series
flujoDatos<-flujoDatos[[1]] $OBSERVATIONS

# Combinar todas las listas en flujoDatos en un solo dataframe
poblacion <- do.call(rbind, flujoDatos)
poblacion <- as.data.frame(poblacion)

poblacion$OBS_VALUE <- as.double(poblacion$OBS_VALUE)
poblacion$TIME_PERIOD <- as.double(poblacion$TIME_PERIOD)


# Carga el paquete ggplot2
library(ggplot2)

# Crea la gráfica de líneas
ggplot(poblacion, aes(x = TIME_PERIOD, y = OBS_VALUE)) +
  geom_line() +
  labs(title = "Gráfica de oblación",
       x = "Fecha",
       y = "Población") +
  theme_minimal()
