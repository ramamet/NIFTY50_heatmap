 #**********************************************************
 # Google API Portfolio tree map ploting; 
 # Author: Ramanathan Perumal
 # Date: 19.05.2016
 # contact: ramamet4@gmail.com
 #**********************************************************

 #supporting libraries
 suppressPackageStartupMessages(library("rvest"))
 suppressPackageStartupMessages(library("scales"))
 suppressPackageStartupMessages(library("tm"))
 suppressPackageStartupMessages(library("tm.plugin.webmining"))
 suppressPackageStartupMessages(library("dplyr"))
 suppressPackageStartupMessages(library("viridisLite"))
 suppressPackageStartupMessages(library("shiny"))
 suppressPackageStartupMessages(library("highcharter")) 


 # scrape function for extracting market trend with google API       
 scrape_api <- function(comp) {
 
 url=paste("http://finance.google.com/finance/info?client=ig&q=NSE:",
           comp,sep="")
   
      
 thepage = readLines(url)
 
 #current price
 cmp=thepage[[9]]
 cmp=gsub('\\D+[.]','', cmp)
 cmp=gsub('\"','', cmp) 
 cmp=gsub(',','', cmp) 
 cmp=gsub("l_cur : &#8377;","",cmp)
 cmp=as.numeric(as.character(cmp))
 
 #opening price
 op=thepage[[19]]
 op=gsub('[^((0-9)|(.))]','', op)
 op=as.numeric(as.character(op))
 
 #change (in Rs.)
 c=cmp-op
 
 #change (in %)
 cp=(c/op)
 cp=cp*100
 cp=round(cp, digits =2)
 
 df=cbind(cmp,op,c,cp)
 df=data.frame(df)
 rownames(df)=paste0(comp)
 return(df)
 
 }
 
 
 # extract all the symbols using lapply
  scrape_list <- function(){

  sp=read.csv("niftywt.csv")
  list_comp=sp$Security.Symbol
  list_comp=as.character(list_comp)
  

 result <- do.call("rbind", lapply(list_comp, scrape_api))
 
 df=result %>% add_rownames()
 
 df=data.frame(df) 
 colnames(df)[1]="Symbol"
 Df=cbind(df,sp)
 Df=mutate(Df,change=ifelse(cp>0,"gain","loss"))
 #Df=Df[1:10,]
 Df=select(Df,Symbol,Industry,Weightage,cmp,c,cp,Capital.Rs.,Volatility)
 Df$Comp=paste0(Df$Symbol," [",Df$cmp,"]",sep="")
 return(Df)
 
 }
  

