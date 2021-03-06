# Conversão da base de dados .dbc para .csv

library(read.dbc)

estado = ("RJ")
ano = as.character(11:21) #2011 até 2021
mes = c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")
pathfile = "Base de dados/LTRJ/"
proc = "Base de dados/Dados dos leitos/"

for( i in estado){
  for(j in ano){
    for(k in mes){
      inputfile = paste(pathfile, 'LT', i, j, k, '.dbc', sep='')
      data=read.dbc(inputfile)
      attach(data)
      data <- data.frame(CNES, CODUFMUN, REGSAUDE, MICR_REG, DISTRSAN, DISTRADM, 
                         TPGESTAO, PF_PJ, CPF_CNPJ, NIV_DEP,  CNPJ_MAN, ESFERA_A, 
                         ATIVIDAD, RETENCAO, NATUREZA, CLIENTEL, TP_UNID,  TURNO_AT, 
                         NIV_HIER, TERCEIRO, TP_LEITO, CODLEITO, QT_EXIST, QT_CONTR, 
                         QT_SUS,  QT_NSUS, COMPETEN)
      outputfile = paste(proc, i, j, k, '.csv', sep='')
      write.csv(data, outputfile, sep='\t', append=F, quote=F, row.names=F)
    }
  }
}
files  <- list.files(path = proc, pattern = '\\.csv', full.names = T)
tables <- lapply(files, read.csv, header = TRUE)
RJ <- do.call(rbind, tables)
write.csv(RJ, file = "Base de dados/Dados dos leitos/RJ.csv", row.names=F)

# Base de dados

library(readr)
Dados_RJ <- read_csv("Base de dados/Dados dos leitos/RJ.csv")

colfactor <- c("CNES", "CODUFMUN", "REGSAUDE", "MICR_REG", "DISTRSAN", "DISTRADM", 
               "TPGESTAO", "PF_PJ", "CPF_CNPJ", "NIV_DEP",  "CNPJ_MAN", "ESFERA_A", 
               "ATIVIDAD", "RETENCAO", "NATUREZA", "CLIENTEL", "TP_UNID", "TURNO_AT", 
               "NIV_HIER", "TERCEIRO", "TP_LEITO",  "CODLEITO")
Dados_RJ[colfactor] <- lapply(Dados_RJ[colfactor], factor)

Dados_RJ$COMPETEN <- as.character(Dados_RJ$COMPETEN/100)
Dados_RJ$COMPETEN <- as.Date(paste(Dados_RJ$COMPETEN,1,sep="."),"%Y.%m.%d")

