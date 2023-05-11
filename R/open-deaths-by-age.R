


# * MOST SIMPLE CODE -----

source("00_common.R")

release_dates <- c(paste0(dateToday," (Live)") , 
                   "2022-12-08",
                   # "2022-11-10",
                   "2022-09-08", 
                   # "2022-08-11", 
                   # "2022-07-14", 
                   "2022-06-09",
                   # "2022-05-12", 
                   "2022-04-14")

# Compare to https://www.mortality.watch/

if (F) {
  dtAll <- readRDS("13100768-all-releases.Rds")
} else {
  
  dtAll <- data.table()
  
  for (release in release_dates[-1]) {
    print(release)
    if (release == release_dates[1]) {
      dt <- cansim::get_cansim("13-10-0768-01") %>%  setDT() 
      if (F) {  
        fwrite(dt, paste0("13100768-", dateToday, ".csv"))
      }
    } else {
      dt <- fread(paste0("13100768-", release, ".csv")) # , stringsAsFactors = F); 
      
      if (is.null(dt$Date)) setnames(dt, "REF_DATE", "Date") %>%  try2
      
      if (is.null(dt$val_norm))  try2( setnames(dt, "VALUE", "val_norm") )
    }
    
    dt$dummy <- 0
    dt[, ( names(dt) %wo% c("Date", "GEO", "val_norm","Age at time of death", "Sex") ):= NULL]
    
    dt$release = release
    
    for (col in which(sapply (dt,is.factor)) )  dt[, (col) := as.character(dt[[col]])] #fastest
    
    dt[, Date:=ymd(Date)]
    setcolorder(dt, c("Date",    "GEO" ,  "Age at time of death","Sex",   "release", "val_norm"  ) )   
    
    dtAll <- dtAll %>% rbind (dt)
  }
  
  setnames(dtAll, "val_norm", "weekly") 
  setnames(dtAll, "Age at time of death", "Age")
  dtAll[, GEO := gsub(", place of occurrence", "", GEO)]
  dtAll[, Age := gsub("Age at time of death, ", "", Age)]
  setorder(dtAll, -Date,GEO,Sex,Age,-release)
  
  # for (col in which(sapply (dtAll,is.character)) )  dtAll[, (col) := as.ordered(dtAll[[col]])] #fastest
  
  
  # dtAll0 <- dtAll
  # 
  # dtAll0[!is.na(val_norm), .(Last_entry_Date=max(Date), `Deaths / week` = val_norm),  by=.(GEO,Age,Sex,)] [order(-Last_entry_Date)]
  # dtAll0[!is.na(val_norm), .(Last_entry_Date=max(Date)),   by=GEO] [order(-Last_entry_Date)]
  # 
  
  # 
  # dtAll <- dtAll0 %>% unique(by=c("Date",    "GEO" ,  "Age","Sex",  "val_norm"), fromLast=T )
  
  if (F) 
    saveRDS(dtAll, "13100768-all-releases.Rds")
  
  dtAll[, ':=' (monthly=sum(weekly, na.rm = F), N=.N), by=.(month(Date), year(Date),GEO,Age,Sex,release)][, monthly:=as.integer(monthly/N*4.34524)][, N:=NULL]
  dtAll[, ':=' (quarterly=sum(weekly, na.rm = F), N=.N), by=.(quarter(Date), year(Date),GEO,Age,Sex,release)][, quarterly:=as.integer(quarterly/N*4.34524*3)][, N:=NULL]
  # dtAll[, ':=' (quarterly2=sum(weekly, na.rm = F), N=.N), by=.(quarter(Date), year(Date),GEO,Age,Sex,release)][, quarterly:=as.integer(quarterly/N*4.34524*3)][, N:=NULL]
  dtAll[, ':=' (annually=sum(weekly, na.rm = F), N=.N), by=.(year(Date),GEO,Age,Sex,release)][, annually:=as.integer(annually/N*52.1429)][, N:=NULL]
  dtAll[, ':=' (ww=week(Date), mm=month(Date), qq=quarter(Date), yy=year(Date))]
  
}


if (F) {
  
  observe({
    
    r$date1 <- ym("2019-01")
    r$geo <- dtAll$GEO %>% unique %wo% c("Canada","Yukon", "Nunavut","Northwest Territories")
    r$sex = dtAll$Sex %>% unique() %>% .[1:2]
    r$age = dtAll$Age %>% unique() %>% .[1:2]
    r$release = dtAll$release %>% unique() %>% .[c(1,5,9)]
    
    r$dt0 <- dtAll [Date > r$date1 & GEO %in% r$geo & Age %in% r$age & release %in% r$release & Sex %in% r$sex ]
    
    
    r$statcan.title <- "Provisional weekly death counts, by age group and sex"
    r$statcan.table <- "13-10-0768-01"
    
    r$granularity <- "weekly"
    r$granularity <- "quarterly"
    r$granularity <- input$granularity
    
    # r$dt0[, deaths:=get(r$granularity )]
    r$dt0$deaths <- r$dt0[[r$granularity ]]
    
    
    r$convolution_window <- 4
    r$convolution_window <- input$convolution_window
    
    if (r$convolution_window > 1) {  # average ----
      r$dt0[, deaths := as.integer(frollmean(deaths, convolution_window, align = "right", fill = 0)), by = .(GEO, `Cause of death (ICD-10)`)]
    }
    
    
    
  })
  
  renderDataTable(
    r$dt0 %>% datatable.title()
  )
  
  
  renderPlot({
    
    g <-  r$dt0  %>% 
      unique(by=c( "GEO"  , "Age"  , "Sex"  ,  "release", "deaths", "yy")) %>% 
      ggplot(aes(Date, deaths, col=Sex, alpha = release )) + 
      theme(legend.position = "bottom")  +
      
      geom_line() + 
      
      # facet_grid(Age ~ GEO, scales =  "free" , space="fixed") +
      
      
      theme_gray() +
      guides(x =  guide_axis(angle = 60)) +
      labs( title = r$statcan.title,
            x=NULL,
            y=paste0("Deaths ", r$granularity), # "Deaths per week", 
            caption = paste0 ("Source: Statistics Canada - Table ",  r$statcan.table ) ) 
    
    if (F) {
      g <- g + geom_smooth(method = lm) 
    }
    
    if (T) {
      qq <- quote(Age ~ GEO)
    } else {
      qq <- quote(GEO ~ Age)
    }
    g <- g + facet_grid(eval(qq), scales = ifelse(F, "fixed", "free") )
    # 
    # facets <- paste(r$var.facetX, '~', r$var.facetY)
    # if (facets != '. ~ .')
    #   g <- g + facet_grid(facets, scales = "free")
    
    r$g <- g
    g
    
    
    
    ggsave(paste0("data/deaths-by-age_all-releases", release_dates[2], ".png"), width = 12, height = 8)
    
    
    
    # ggplot options ----
    # scale_color_brewer(direction = 1, palette = "Reds") +
    
    #   scale_x_date(date_labels = "%b %d", date_breaks = "1 month") +
    #   # scale_x_date(date_breaks = "1 week", date_labels = "%W") +
    # # # scale_x_date(date_minor_breaks = "1 week")
    # scale_x_yearquarter(date_breaks = "1 year", date_labels = "%Y") +
    
    # guides(alpha=guide_legend(title="Release")) + 
    
    # # scale_y_continuous(breaks=10*(2:80), limit=c(20,80)) +  
    # scale_x_discrete(labels = function(x) format(as.Date(x), "%b")) +
    # guides(x =  guide_axis(angle = 90)) +
    
    # scale_x_date(guide = guide_axis(n.dodge = 2)) +
    # scale_x_discrete(guide = guide_axis(angle = 90)) +
    # theme(axis.text.x = element_text(angle = 30, vjust = 0.5, hjust=1)) +
    
    # scale_col_manual(r.show_what(), values=c("orange","red")) +
    # scale_color_discrete(name = "New Legend Title") +
    


    
    # geom_line(aes(linetype=method)) +
    #   scale_linetype_manual(breaks=c("a","b"), values=c(5,3))
    
    scale_y_discrete(limits=rev)
  })
  
  
  renderPlotly({
    ggplotly(r$g)
  })
  
  
  
  
  
  dtS <- dt0 [ , .(
    # `Weekly lowest`=min(value, na.rm = T) %>% round(0),  
    `Total`=sum(value, na.rm=T), 
    `Weekly average`=mean(value, na.rm = T) %>% round(0),   
    `Weekly variation`=sd(value, na.rm = T) %>% round(1),
    # `Weekly highest`=max(value, na.rm = T) %>% round(0),
    
    # LM = list(list(lm(value ~ as.integer( Date - min(Date))),  na.action=na.omit)),
    # `Weekly increase`=( lm(value ~ as.integer( Date - min(Date)),  na.action=na.omit)$coefficients[2] * 7 ) %>% round(1),
    Weeks=as.integer( max(Date) - min(Date))/7
  ),    by=.(Age,GEO)]
  
  
} # end of StatCan plots 

# ontario MOST SIMPLE CODE -----


# death 1980-04-01	2022-06-30	2022-12-09
"f46643ca-eaaf-40a6-a545-11bc4cc45279"



# "deaths" 2020-04-01	2022-12-08
"58e648f1-ae1e-4ed7-9003-7da5983b0a77"

# "vital"
"97622ce6-c06a-4970-afe5-be540c748f24"

if (F) {
  
  # for ivim.substack.com ------
  
  install.packages(cansim)
  
  install.packages(magrittr,ggplot2,lubridate, data.table)
  library(magrittr,ggplot2,lubridate, data.table)
  #other libraries used: cansim, ckanr
  
  dt <- cansim::get_cansim("13-10-0768-01")
  names(dt)
  
  ggplot(dt, aes(Date, val_norm, col=Sex)) + 
    geom_line() + 
    facet_grid(`Age at time of death` ~ GEO) 
  
  
  
}

if (F) { # OLD WAY - WITH EXCESS DEATHS #### 
  
  release_dates <- c("2022-11-10", "2022-09-08", "2022-08-11", "2022-07-14", "2022-06-09", "2022-05-12", "2022-04-14", "2022-03-30")
  
  # read data latest release  ----
  release_date <- release_dates[1]
  
  OFF_LINE = T
  
  if (OFF_LINE) {
    dtAll <- fread(paste0("13100768-", release_date, ".csv"), stringsAsFactors = T) 
  } else {
    dtAll <- cansim::get_cansim("13-10-0768-01") %>%  setDT() 
    if (F) {  
      fwrite(dtAll, paste0("13100768-", release_date, ".csv"))
    }
  }
  
  dtAll$Date %>% max(na.rm = T) #"2022-09-03" "2022-07-02" "2022-06-04"
  dtAll$Date %>% min(na.rm = T) # "2010-01-09"
  dtAll[1:2]
  dtAll %>% summary
  dtAll %>% names
  # dt <- dtAll[, c("Date", "GEO", "val_norm","Age at time of death", "Sex")]
  dt <- dtAll[, c("REF_DATE", "GEO", "VALUE","Age at time of death", "Sex")]
  setnames(dt, "VALUE", "value")
  setnames(dt, "REF_DATE", "Date")
  setnames(dt, "Age at time of death", "Age")
  dt[, GEO := as.ordered(gsub(", place of occurrence", "", GEO))]
  dt[, Age := as.ordered(gsub("Age at time of death, ", "", Age))]
  dt[, Date :=ymd(Date)]
  
  from <- "2015"
  dt <- dt[Date>=ymd(paste0(from, "-01-01"))]
  if (F) {
    fwrite(dt, paste0("data/13100768-since", from, "-", release_date, ".csv"))
  }
  dt$release <- release_date
  
  
  
  aSex <- dt$Sex %>% u
  aAge <- dt$Age %>% u
  aGeo <- dt$GEO %>% u
  aRelease <- dt$release %>% u
  
  input <- list()
  
  input$geo <- aGeo[11]
  input$age <- aAge[2]
  input$granularity  = 0
  
  
  if (input$granularity == "week") {
    
    colFactors <- c( "GEO" , "week",  "Age", "Sex", "release" )
    # colFactors <- c( "GEO" , "week",  "Age", "release" ) # we should remove this column
    
    # dtHistorical <- dt [Date <= ymd("2019-12-31") ][ , week:=week(Date)
    # ][ ,.(historical=as.integer(mean(value, na.rm=T))), by=.(GEO, Age, week, Sex, release) ]
    dtHistorical <- dt [Date < ymd("2020-01-01") ][ , week:=week(Date)
    ][ ,.(historical=as.integer(mean(value, na.rm=T))), by=colFactors ]
    
    dtPandemic <- dt [Date >= ymd("2020-01-01") ][, week:=week(Date)]
    
    # dtExcess <- dtHistorical[dtPandemic, on=c( "GEO" , "week",  "Age", "Sex", "release" ) ]
    dtExcess <- dtHistorical[dtPandemic, on=colFactors  ]
    
    colFactors <- colFactors %wo% "week"
    
    weeks_ave = 4
    # deaths.ave === deaths
    dtExcess[, deaths.ave := round(frollmean(value, weeks_ave, align = "center", fill = NA, na.rm=T), 1), by= colFactors ]
    dtExcess[, historical.ave := round(frollmean(historical, weeks_ave, align = "center", fill = NA, na.rm=T), 1), by=colFactors]
    
  } 
  
  
  dtExcess[GEO=="Canada" & Date> "2020-10-01" & Sex == "Both sexes" &
             Age %in%  c("all ages", "0 to 44 years")] %>% datatable.title("Canada, Both sexes")
  
  
  
  dt$release = NULL
  dt000 <- dt[GEO=="Canada" & Sex == "Both sexes" &
                Age %in%  c("all ages", "0 to 44 years")]
  dt000$Sex = NULL
  dt000$GEO = NULL
  dt000[ , month:=month(Date)][, year:=year(Date)][, week:=week(Date)]
  
  
  colFactors <- c("Age","month","year")
  setkeyv(dt000, colFactors)
  dt000
  
  
  if (T) { # monthly prepandemic
    dt000.monthly <- copy(dt000)
    dt000.monthly[ , monthly:=as.integer(sum(value, na.rm=F)),  by=colFactors ]
    
    dt000.monthly <- dt000.monthly %>% unique (by = colFactors)
    dt000.monthly$Date = NULL; dt000.monthly$value = NULL; dt000.monthly$week  = NULL
    setkeyv(dt000.monthly, c("Age","month","year"))
    dt000.monthly
    
    dt000.monthly <- dt000.monthly[year<=2019, .(monthly=mean(monthly)), by=.(Age,month)] %>% 
      .[,year:="'2015-2019 mean'"] %>% 
      setcolorder(dt000.monthly %>% names) %>% rbind(dt000.monthly)
    dt000.monthly
    
    
    
    dt000.monthly <- dt000.monthly %>% dcast(Age + month ~ year, value.var="monthly")
    
    dt000.monthly$`2022-historical` <- as.integer( dt000.monthly$`2022`-  dt000.monthly$`'2015-2019 mean'`)
    dt000.monthly$`2021-historical` <- as.integer( dt000.monthly$`2021`-  dt000.monthly$`'2015-2019 mean'`)
    dt000.monthly$`2020-historical` <- as.integer( dt000.monthly$`2020`-  dt000.monthly$`'2015-2019 mean'`)
    dt000.monthly$`(2021-hist)/hist` <- as.integer( 100* dt000.monthly$`2021-historical` / dt000.monthly$`'2015-2019 mean'`)
    dt000.monthly$`(2022-hist)/hist` <- as.integer( 100* dt000.monthly$`2022-historical` / dt000.monthly$`'2015-2019 mean'`)
    
    
    dt000.monthly %>% fwrite(paste0("data/13100768-monthly-Canada-both_sexes-since", from, "-", release_date, ".csv"))
  }
  
  if (T) { # weekly prepandemic
    dt000.weekly <- copy(dt000)
    dt000.weekly$month = NULL
    dt000.weekly$monthly = NULL
    dt000.weekly$Date = NULL
    dt000.weekly
    dt000.weekly <- dt000.weekly[year<=2019, .(value=mean(value, na.rm=T)), by=.(Age,week )]  %>% 
      .[,year:="'2015-2019 mean'"] %>% 
      setcolorder(dt000.weekly %>% names) %>% rbind(dt000.weekly) 
    dt000.weekly 
    
    dt000.weekly <- dt000.weekly %>% dcast(Age + week ~ year, value.var="value")
    dt000.weekly
    dt000.weekly[, Date:=ymd( "2022-01-01" ) + weeks( week )]
    # dt000.weekly[, `2022-historical`:= `2022` - `2015-2019 mean`   ]   
    dt000.weekly$`2022-historical` <- as.integer( dt000.weekly$`2022`-  dt000.weekly$`'2015-2019 mean'`)
    dt000.weekly$`2021-historical` <- as.integer( dt000.weekly$`2021`-  dt000.weekly$`'2015-2019 mean'`)
    dt000.weekly$`2020-historical` <- as.integer( dt000.weekly$`2020`-  dt000.weekly$`'2015-2019 mean'`)
    dt000.weekly$`(2021-hist)/hist` <- as.integer( 100* dt000.weekly$`2021-historical` / dt000.weekly$`'2015-2019 mean'`)
    dt000.weekly$`(2022-hist)/hist` <- as.integer( 100* dt000.weekly$`2022-historical` / dt000.weekly$`'2015-2019 mean'`)
    
    dt000.weekly %>% fwrite(paste0("data/13100768-weekly-Canada-both_sexes-since", from, "-", release_date, ".csv"))
  }
  
  dt000.casted%>% fwrite(paste0("data/13100768-hor-Canada-both_sexes-since", from, "-", release_date, ".csv"))
  
  if (input$granularity == "month") {
    dt$release <- NULL
    
    colFactors <- c( "GEO" , "month", "year", "Age", "Sex" )
    # colFactors <- c( "GEO" , "week",  "Age", "release" ) # we should remove this column
    
    # dtHistorical <- dt [Date <= ymd("2019-12-31") ][ , week:=week(Date)
    # ][ ,.(historical=as.integer(mean(value, na.rm=T))), by=.(GEO, Age, week, Sex, release) ]
    dtHistorical <- dt [Date < ymd("2020-01-01") ][ , month:=month(Date)][, year:=2019]
    dtHistorical[ ,.(historical=as.integer(mean(value, na.rm=T)*30/7)), by=colFactors ]
    dtHistorical$Date <- NULL
    
    dtPandemic <- dt [Date >= ymd("2020-01-01") ][, month:=month(Date)][,year:=year(Date)] 
    dtPandemic[ ,.(pandemic=as.integer(mean(value, na.rm=T)*30/7)), by=colFactors ]
    dtPandemic$Date <- NULL
    
    # dtExcess <- dtHistorical[dtPandemic, on=c( "GEO" , "week",  "Age", "Sex", "release" ) ]
    dtExcess <- rbind (dtPandemic, dtHistorical)
    
    
  }
  # dt <- dt %>% deaths.addExcess(weeks_ave = input$convolution_window )
  
  setcolorder(dtExcess, c("Date"))
  dtExcess <- dtExcess [order(-Date)]
  
  
  
  dtAll <- dtExcess
  
  title = "Weekly mortality rates by age group" 
  subtitle=paste0(input$geo, ": ", input$age);subtitle
  
  
  
  # dtExcess0  <- dtExcess  [    GEO %in% input$geo  & 
  #                         Sex %in% "Both sexes" & #in0$sex & 
  #                         # release %in% input$release & 
  #                         Age %in% input$age ]
  
  
  
  
  
  dtAll$week <- NULL
  dtAll$release <- NULL
  
  dtAll <- dtAll  [  Sex %in% "Both sexes"  ]
  dtAll$Sex <- NULL
  setnames(dtAll, c("value"), c("deaths"))
  
  dtAll[, Date :=ymd(Date)]
  
  dtAll[!is.na(deaths), max(Date), by = GEO]
  
  dtAll %>% datatable.title()
  
  
  geo = "British Columbia"
  geo = "Alberta"
  geo = "Quebec"
  geo = "Ontario"
  
  geo = "New Brunswick"
  geo = "Saskatchewan"
  geo = "Nova Scotia"
  geo = "Newfoundland and Labrador"
  
  geo = c("Alberta", "British Columbia", "Quebec", "Ontario")
  geo = c("New Brunswick", "Saskatchewan", "Nova Scotia", "Newfoundland and Labrador")
  
  for( geo in dt$GEO %>% unique){
    
    dt0 <-  dtAll[GEO != "Canada"]
    dt0 <-  dtAll[GEO == "Canada"]
    dt0 <-  dtAll[GEO %in% geo]
    
    
    dt0 %>% datatable.title()
    
    g <- ggplot( dt0 ) + theme_bw() +
      #   scale_x_date(date_labels = "%b %d", date_breaks = "1 month") +
      #   # scale_x_date(date_breaks = "1 week", date_labels = "%W") +
      # # scale_x_date(date_minor_breaks = "1 week")
      theme(legend.position = "bottom")  +
      
      # scale_y_continuous(breaks=10*(2:80), limit=c(20,80)) +  
      guides(x =  guide_axis(angle = 60)) +
      # scale_x_discrete(labels = function(x) format(as.Date(x), "%b")) +
      labs( title = "Weekly mortality rates by age group",
            subtitle=geo,
            # x=NULL,
            x = "Black line: pre-pandemic 2018-2019 average",
            
            y="Deaths per week", # 13-10-0768-01 (by age); 13-10-0810-01 (by cause)
            caption = "Source: Statistics Canada - Table 13-10-0768-01
        \n Data release: 2022-09-08"     ) +
      geom_vline(xintercept = ymd("2020-12-14"), linetype=1, size=2,  alpha=0.3) +
      geom_vline(xintercept = ymd("2021-05-01"), linetype=1, size=2, alpha=0.4)  +
      # geom_label(aes(x = ymd("2021-05-01"), y=max(deaths), label="1%" ), alpha=0.4)  +
      
      
      scale_color_brewer(direction = 1, palette = "Reds") +
      
      # geom_line(aes(Date, value, col=release),   alpha=0.2) +
      # geom_line(aes(Date, deaths, col=release), size=1) +
      geom_line(aes(Date, deaths),  col="red", alpha=0.2) +
      geom_line(aes(Date, deaths.ave), col="red") +
      
      geom_line(aes(Date, historical.ave), size=1, col="black", alpha=0.5) +
      
      
      facet_grid(Age ~ GEO, scales =  "free" , space="fixed") 
    
    ggsave(paste0("data/deaths-by-age_", geo, "_2022-09-08.png"), width = 5, height = 9)
    
    g %>% print
  }
  
}


