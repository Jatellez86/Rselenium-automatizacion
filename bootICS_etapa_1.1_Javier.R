# **********************************************************************************************
#  @Nombre: Boot carga ics
#  @Autor: Javier Tellez
#  @Fecha: 20221110
#  @Cambios:
#  @Ayudas:
# **********************************************************************************************
# cargue de librerias
library(tidyverse)
library(RSelenium)
library(rvest)
library(netstat)
library(data.table)
library(stringr)
library(readxl)
library(lubridate)
 
# archivos de entrada para el boot

#archvo de la carpeta

ics_1_1 <- read_excel("Z:/01 base_datos/73 reclamos juridica/reclamos_ICS_20230117.xlsx") %>%
           janitor::clean_names() %>%
          select(id_ics) %>%
          mutate(id_ics = as.character(id_ics))

#ics_1_1 <- cruce_subidos

observacion_ics <- "Respecto del servicio perdido se informa que esta novedad se dio debido a la falta de 
disponibilidad de conductores. Lo anterior, teniendo en cuenta que el concesionario contaba con 
el veh?culo disponible conforme a lo programado para la operaci?n y en las condiciones para salir 
a prestar el servicio. Sin embargo, dada la problematica y el deficit de conductores que se tiene en 
el Sistema (problem?tica que ha sido reconocida p?blicamente por el Ente Gestor y que se 
presenta tanto a nivel nacional como internacional) el servicio no pudo ser prestado. Esta 
situaci?n, escapa del margen de maniobra del concesionario y, aunque se han adelantado distintas 
acciones tendientes a reclutar personal de conducci?n, no ha sido posible dar soluci?n de fondo a 
la problem?tica. Por lo tanto, al ser la causa de lo ocurrido ajena al concesionario, en tanto la 
misma no responde a ninguna falta, incumplimiento o desconocimiento respecto de las 
obligaciones contractuales a su cargo, la misma no podria configurarse como un evento negativo 
atribuible al Concesionario respecto del calculo de la EMIC. Por lo anterior, se solicita que este 
hallazgo no sea tenido en cuenta para el indicador del ICS e ICK"

imagen <- 'Y:\\20221211 boot carga ics_1.1\\input\\objecion_ics.PNG'


# creamos el objeto RemoteDriver
rs_driver_object <- rsDriver(browser = 'firefox',
                             chromever = '108.0.5359.71',
                             verbose = FALSE,
                             port = free_port())   #  free_port()   5467L

# establecemos cliente para navegar a la pagina deseada
remDr <- rs_driver_object$client

# pagina de Transmitools
remDr$navigate("http://transmitools.transmilenio.gov.co/")




# maximizamos la pagina
remDr$maxWindowSize()

# ingresamos credenciales
user <- "user"
pwd <- "pwd"

remDr$findElement(using = "name", value = "username2")$sendKeysToElement(list(user))
remDr$findElement(using = "name", value = "password2")$sendKeysToElement(list(pwd))
Sys.sleep(3) 

# damos click al boton ingresar
ingresar <- remDr$findElement(using = "id", "ingresar")
ingresar$clickElement()
Sys.sleep(3)
print("login Transmitools ok")

remDr$navigate("http://transmitools.transmilenio.gov.co/EIC/Menu.jsp")
print("plataforma eic ok ok")

# funcionar para ajsutar el zoom
zoom_firefox <- function(client, percent)
{
  store_page <- client$getCurrentUrl()[[1]]
  client$navigate("about:preferences")
  webElem <- client$findElement("css", "#defaultZoom")
  webElem$clickElement()
  webElem$sendKeysToElement(list(as.character(percent)))
  webElem$sendKeysToElement(list(key = "return"))
  client$navigate(store_page)
}

# se configura el zoom en 67 %
zoom_firefox(remDr, 0.67)
remDr$screenshot(display = TRUE)
print("zoom  ok")




df_subidos <- NULL

for (i in 1:length(ics_1_1$id_ics)) {
  
  tryCatch({


  
inicio_cargue <- now()
inicio_cargue <- as_datetime(inicio_cargue)

remDr$navigate("http://transmitools.transmilenio.gov.co/EIC/ShowInfoKpi.jsp?IdKpi=8#ETAPA01")
Sys.sleep(3)

etapa1.1 <- remDr$findElement(using = "xpath", "/html/body/div[6]/div/div/div/div/form/div[1]/ul/li[2]/a")
etapa1.1$clickElement()
Sys.sleep(3)

clean_id <- remDr$findElement(using = "css selector", "#info_etapa1_filter > label:nth-child(1) > input:nth-child(1)")
clean_id$clearElement()
Sys.sleep(1)
  

buscar_id <- remDr$findElement(using = "css selector", "#info_etapa1_filter > label:nth-child(1) > input:nth-child(1)")
buscar_id$sendKeysToElement(list(ics_1_1$id_ics[i], key = "enter"))
Sys.sleep(2)
print("PASO 1 OK")

cargue_id <- remDr$findElement(using = "css selector", "td.center:nth-child(35) > a:nth-child(1)")
cargue_id$clickElement()
Sys.sleep(3)
print("PASO 2 OK")

clik_bloque <- remDr$findElement(using = "id", "form-file")
clik_bloque$highlightElement()
clik_bloque$clickElement()
Sys.sleep(2)
print("PASO 3 OK")

odervacion <- remDr$findElement(using = "id", "observacion")
odervacion$sendKeysToElement(list(observacion_ics))
Sys.sleep(2)
print("PASO 4 OK")

remDr$findElement(using = "id", value = "file")$sendKeysToElement(list(imagen))
Sys.sleep(2)
print("PASO 5 OK")


clik_bloque_carga <- remDr$findElement(using = "id", "form-file")
clik_bloque_carga$highlightElement()
clik_bloque_carga$clickElement()
Sys.sleep(2)
print("PASO 7 OK")

carga_adjunto <- remDr$findElement(using = "id", "ButtonLoad")
carga_adjunto$clickElement()
Sys.sleep(27)
print("PASO 8 OK")

press_ok <- remDr$findElement(using = "class", "ZebraDialog_Button_0")
press_ok$clickElement()
Sys.sleep(2)
print("PASO 9 OK")


clean_id <- remDr$findElement(using = "css selector", "#info_etapa1_filter > label:nth-child(1) > input:nth-child(1)")
clean_id$clearElement()
Sys.sleep(1)

print("PASO 10 OK")


fin_cargue <- now()
fin_cargue <- as_datetime(fin_cargue)


tiempo_cargue <- (fin_cargue - inicio_cargue)
round(tiempo_cargue, digits = 1)
print(paste0("id # ", i, " ", ics_1_1$id_ics[i], " OK Tiempo ", round(tiempo_cargue, digits = 1) ))


df_subidos_ciclo <- data.frame("id_ics" = ics_1_1$id_ics[i]) %>%
                    mutate(status = "OK")

df_subidos <- rbind(df_subidos, df_subidos_ciclo)



  }, error = function(e) {
    print(paste0("Error en id # ", i, " ", ics_1_1$id_ics[i], ": ", e))
    
    
  })



}


cruce_subidos <- ics_1_1 %>%
                  left_join(df_subidos, by = "id_ics") %>%
                  filter(is.na(status))

print(paste0("proceso finalizado "))
print(ics_1_1$id_ics[i])



data.table::fwrite(cruce_subidos, str_c("Y:/20221211 boot carga ics/df_errores.csv"))


remDr$close()



