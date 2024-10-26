library(jsonlite)
library(rjson)
library(dplyr)

# URL del API
url <- "https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/1002000001/es/00000/false/BISE/2.0/af2d1a87-37aa-4c76-0d9e-56471598b0f7?type=json"

# Llamada al API usando curl
json_data <- readLines(url(url, "r"), warn = FALSE)
respuesta <- fromJSON(paste(json_data, collapse = ""))

# Inicializamos una lista vacía para almacenar las observaciones de cada serie
observaciones_list <- list()

# Iteramos sobre cada serie en la lista "Series"
for (i in seq_along(respuesta$Series)) {
  serie <- respuesta$Series[[i]]
  
  # Convertimos las observaciones de la serie en un data frame
  poblacion <- do.call(rbind, lapply(serie$OBSERVATIONS, function(obs) {
    data.frame(
      INDICADOR = serie$INDICADOR,
      FREQ = serie$FREQ,
      TOPIC = serie$TOPIC,
      UNIT = serie$UNIT,
      UNIT_MULT = serie$UNIT_MULT,
      NOTE = serie$NOTE,
      SOURCE = serie$SOURCE,
      LASTUPDATE = serie$LASTUPDATE,
      TIME_PERIOD = obs$TIME_PERIOD,
      OBS_VALUE = obs$OBS_VALUE,
      OBS_STATUS = obs$OBS_STATUS,
      COBER_GEO = obs$COBER_GEO,
      stringsAsFactors = FALSE
    )
  }))
  
  # Agregamos el data frame de observaciones a la lista
  observaciones_list[[i]] <- poblacion
}

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
