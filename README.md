# Automatización Web para la Carga de Datos ICS :computer: :rocket:

Este proyecto está diseñado para automatizar el proceso de carga de datos ICS. Utiliza varias bibliotecas como `tidyverse`, `RSelenium`, `rvest` y otras para la manipulación de datos, web scraping y automatización.

## :star: Características
- Lee los datos ICS desde un archivo Excel :file_folder:
- Inicia sesión en una plataforma web :key:
- Automatiza el proceso de entrada de datos :robot:

## :wrench: Requisitos
- R
- RSelenium
- Firefox
- tidyverse
- rvest
- netstat
- data.table
- stringr
- readxl
- lubridate

## :floppy_disk: Configuración y Ejecución
1. Clona el repositorio
2. Ejecuta el script `tu_script.R` en tu entorno de R

## :page_facing_up: Bibliotecas Utilizadas
```R
library(tidyverse)
library(RSelenium)
library(rvest)
library(netstat)
library(data.table)
library(stringr)
library(readxl)
library(lubridate)
```

## :rocket: Cómo Funciona

1. **Lectura de Datos de Entrada**: Lee los datos ICS desde un archivo Excel.
```R
ics_1_1 <- read_excel("Z:/01 base_datos/73 reclamos juridica/reclamos_ICS_20230117.xlsx") %>% janitor::clean_names() %>% select(id_ics) %>% mutate(id_ics = as.character(id_ics))
```

2. **Inicializar RSelenium**: Inicializa el WebDriver de Selenium para Firefox.
```R
rs_driver_object <- rsDriver(browser = 'firefox', chromever = '108.0.5359.71', verbose = FALSE, port = free_port())
```

3. **Proceso de Inicio de Sesión**: Inicia sesión en la plataforma Transmitools.
```R
remDr$navigate("http://transmitools.transmilenio.gov.co/")
...
remDr$findElement(using = "name", value = "username2")$sendKeysToElement(list(user))
```

4. **Entrada de Datos**: Automatiza el proceso de entrada de datos, subida de archivos e ingreso de observaciones.
```R
remDr$navigate("http://transmitools.transmilenio.gov.co/EIC/ShowInfoKpi.jsp?IdKpi=8#ETAPA01")
...
```

5. **Manejo de Errores**: Maneja los errores de forma eficiente, imprimiendo los ID donde falló la carga.
```R
tryCatch({
    ...
}, error = function(e) {
    print(paste0("Error en id # ", i, " ", ics_1_1$id_ics[i], ": ", e))
})
```

## :exclamation: Nota
Esta es una visión general. Para más detalles, consulte el código fuente.

## :mailbox: Contacto
Para cualquier problema o mejora, no dude en abrir un problema o solicitud de extracción.

---
