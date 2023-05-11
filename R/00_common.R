# 00_common.R


# source ("00_common.R")
#0. Global settings ----
if (T) {  
  library(magrittr); 
  library(ggplot2); 
  library(dtplyr)
  library(lubridate,  quietly=T); options(lubridate.week.start =  1)
  library(data.table); options(datatable.print.class=TRUE)
  library(dygraphs)
  library(plotly); library(DT); 
  # library(heatmaply);  
  library(ggpubr)
  library(stringr); library(forcats) 
  
  options(digits = 3)
  # options(max.print = 100) # 1000
  options(scipen = 999) # remove scientific notation
  
  dateToday <- format(Sys.time(), '%d %B, %Y') %>% dmy; dateToday
  
  "%wo%" <- function(x, y) setdiff(x,y) 
  
  "%wo2%" <-function(x,y) x[ ( ! x %in% y )]
    
  `%ni%` <-  Negate(`%in%`)
  # as.dt <- as.data.table
  
  theme_set(theme_bw())
  # theme_set(theme_minimal())
  # library(ggthemes); 
  # theme_set(theme_economist())
  # theme_set(theme_economist_white())

  # shinybusy::add_busy_bar(color = "Red", height = "40px", centered = T)
  library(shinybusy)
  library(shiny)
  library(shinyBS) 
  # https://stackoverflow.com/questions/33925430/shiny-plot-results-in-popup-window https://stackoverflow.com/questions/61667924/create-a-small-window-to-describe-the-meaning-of-filters-in-shiny
  
}


if ( shiny::isRunning() ) {  
  r <- reactiveValues()
} else {
  r <- list()
}

# reset.reactive0 <- function() {
#   r$dtAll <- NULL # linked, aggregated
#   r$dt <- NULL #
#   r$dt0 <- NULL
#   r$dt00 <- NULL
#   r$filter = NULL
#   r$cols = 1
# }
# reset.reactive <- function() {
#   r$dtAll <-  r$dt <-   r$dt0 <- data.table()
#   r
# }
# 
# r <- reset.reactive() # does it change by reference??

# Does not work yet :()
# This would have been neat idea - so that the same code can be used with reactive (shiny) AND static (non-shiny) execution
# Should ask stackoverfloor
# use observe instead and redefine .observeEvent maybe??
.reactive <- function(A) {
  if (!shiny::isRunning()) {
    A
  }  else reactive(A)
}

u = function(...) {
  unique (...)
}
s = function(...) {
  summary (...)
}

# of <- function (x, range)  { # use negative range to remove
#   if (is.numeric(range)) {
#     # if (bKeep) {
#     return(x[range])
#     # } else {
#     #   #return(x[ which ( (1:length(x)) %ni% range ) ])
#     #   return(x[-range])
#     # }
#   }else { # - for now  assume it is data.table 
#     colsSelect(x, range)
#     # return(x[, range, with=F]) 
#   }
# }

of <- function (dt, cols)  {
  dt[, cols, with=F]
  # Note also other ways to select column(s) in data.table
  # dt[, ..cols] # FOR ONE COLUMN ONLY
  # dt[,.SD, .SDcols=cols] 
}


# USE THIS: %>% .[cols, with=F]
dt.select <- function (dt, cols)  {
  dt[, cols, with=F]
}


# USE THIS: %>% .[(cols) := NULL]
dt.rmCol <- function (dt, cols)  {
  dt[, (cols) := NULL] 
}


setcolorder.fromLast <- function( dt, neworder) {
  # TBD - useful for cast.
  
  # setcolorder.fromLast(dtCached, c("Cause of death (ICD-10)", "value"))
  # setcolorder(dtCached, c("Date",  "GEO", "Cause of death (ICD-10)", "value"))
}




#Found in: stackoverflow:
# Efficient (in place) rows deletion from data.table 

#' #' Title
#' #'
#' #' @param DT 
#' #' @param del.idxs 
#' #'
#' #' @return
#' #' @export
#' #'
#' #' @examples
#' dt.rmRow <- function(DT, del.idxs) {  # pls note 'del.idxs' vs. 'keep.idxs'
#'   if (!is.data.table(dt))
#'     dt <- as.data.table(dt)
#'   
#'   keep.idxs <- setdiff(DT[, .I], del.idxs);  # select row indexes to keep
#'   cols = names(DT);
#'   DT.subset <- data.table(DT[[1]][keep.idxs]); # this is the subsetted table
#'   setnames(DT.subset, cols[1]);
#'   for (col in cols[2:length(cols)]) {
#'     DT.subset[, (col) := DT[[col]][keep.idxs]];
#'     DT[, (col) := NULL];  # delete
#'   }
#'   return(DT.subset); # NB: Original DT is also changed  by reference !
#' }
#' 
#' if (F) {
#'   dt <- readRDS(paste0("13100810.Rds"))
#'   dt
#'   dt %>% dt.rmRow(nrow(dt))
#' }



### Automatically finding / removing common parts in strings 


# https://stackoverflow.com/questions/48701107/find-length-of-overlap-in-strings

#' Title
#'
#' @param str1 
#' @param str2 
#' @param ignore.case 
#'
#' @return
#' @export
#'
#' @examples
str_find_overlap <- function(str1, str2, ignore.case = FALSE) { # , verbose = FALSE
  
  if(ignore.case) {
    str1 <- tolower(str1);    str2 <- tolower(str2)
  }
  if(nchar(str1) < nchar(str2)) {
    x <- str2;    str2 <- str1;    str1 <- x
  }
  
  x <- strsplit(str2, "")[[1L]]
  n <- length(x)
  s <- sequence(seq_len(n))
  s <- split(s, cumsum(s == 1L))
  s <- rep(list(s), n)
  
  for(i in seq_along(s)) {
    s[[i]] <- lapply(s[[i]], function(x) {
      x <- x + (i-1L)
      x[x <= n]
    })
    s[[i]] <- unique(s[[i]])
  }
  
  s <- unlist(s, recursive = FALSE)
  s <- unique(s[order(-lengths(s))])
  
  i <- 1L
  len_s <- length(s)
  while(i < len_s) {
    lcs <- paste(x[s[[i]]], collapse = "")
    # if(verbose) cat("now checking:", lcs, "\n")
    check <- grepl(lcs, str1, fixed = TRUE)
    if(check) {
      # if(verbose) cat(paste0("Found: '",lcs,"' (length =", nchar(lcs), ") \n")) 
      break
    } else {
      i <- i + 1L 
    }
  }
  return (lcs)
}
# 
# str_remove_overlap <- function(aStr) {
#   str0 <- str_find_overlap( aStr[1],  aStr[2]); str0
#   str_replace(aStr, str0, "")
# }
# 
# if (F) {
#   library(data.table)
#   # dt <- cansim::get_cansim("13-10-0810-01") %>% setDT(dt) 
#   dt <- data.table::data.table(
#     GEO=c( # From CANSIM Table
#       "Newfoundland and Labrador, place of occurrence",
#       "Prince Edward Island, place of occurrence",     
#       "Nova Scotia, place of occurrence"
#     ))
#   
#   aStr <- dt$GEO
#   
#   
#   dt[, GEO:=str_remove_overlap(GEO)][]
#   #                         GEO
#   #                      <char>
#   #1: Newfoundland and Labrador
#   #2:      Prince Edward Island
#   #3:               Nova Scotia
# }
# 


dygraph.title <- function(dts, title=NULL, group="1st group") {
  dygraph(dts, main = title, group = group) %>%
    # dySeries(input$var1, color = input$color1, strokePattern = input$stroke1,  axis = input$axis1 )  %>% 
    dyOptions(fillGraph = F, stepPlot = F, drawGrid = T, drawPoints = TRUE, pointSize = 2) %>%
    dyHighlight(highlightCircleSize = 5,highlightSeriesBackgroundAlpha = 0.2, hideOnMouseOut = FALSE) %>%
    # dyAxis("y", label="Deaths / week") %>%
    # dyAnnotation("2021-5-1", text = "3%", tooltip = "Fully Vaccinated Rate 3%") %>%
    # dyAnnotation("2021-4-6", text = "2%", tooltip = "Fully Vaccinated Rate 2%") %>%
    # dyAnnotation("2021-6-10", text = "10%", tooltip = "Fully Vaccinated Rate 10%") %>%
    # dyAnnotation("2021-2-18", text = "1%", tooltip = "Fully Vaccinated Rate 1%") %>%
    dyRangeSelector() 
}


summary.factored <- function (dt0) {
  dt <- copy(dt0)
  cols  <-  which(sapply (dt,is.character)); 
  dt[, (cols):=lapply(.SD, ordered), .SDcols=cols]
  summary(dt)
}


# dt0_wide <- dt0 %>% dcast(GEO    +   Date ~ `Cause of death (ICD-10)`, value.var = "value")


renderTable.with_date <- function (dt0) {
  # dt0_wide <- dt0 %>% dcast(GEO    +   Date ~ `Cause of death (ICD-10)`, value.var = "value")
  # dt0_wide() [, Date:=format(Date,'%Y-%m-%d')] %>% renderTable
  dt0  [, Date:=format(Date,'%Y-%m-%d')] %>% renderTable
}

renderTable.melted <- function (dt0) {
  # dt0_wide <- dt0 %>% dcast(GEO    +   Date ~ `Cause of death (ICD-10)`, value.var = "value")
  # dt0_wide() [, Date:=format(Date,'%Y-%m-%d')] %>% renderTable
}

# Consider also: paged_table(dt), reactable() and https://gt.rstudio.com/
# https://rstudio.github.io/DT/options.html

# Click on column names to sort. Filter by typing in boxes under column names. 
# Press Buttons above to save selected data.
datatable.title <- function(dt0, 
title="Tip: You can rearrange, sort, filter and save selected data by dragging 
column names and using filter boxes."
) {
  
  dt <- copy(dt0)
  cols  <-  which(sapply (dt,is.character)); 
  dt[, (cols):=lapply(.SD, ordered), .SDcols=cols]
  

  dt %>% DT::datatable (
    filter = "top",  
    caption = title,
    rownames=F,   
    extensions =  c('ColReorder', 'Buttons'),
    options = list(
      dom = 'Blfrtip',
      # paging = FALSE, 
      # pageLength=50, scrollX='400px', # horizontal scroll
      scrollX = TRUE,       scrollY = "600px",
      
      colReorder = TRUE,
      lengthMenu = list(c(10,25,100,-1), c(10,25,100,"All")),
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print') 
    ) )
}



datatable.title2 <- function(x){
  DT::datatable(x,
                extensions = 'Buttons',
                options = list(dom = 'Blfrtip',
                               buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                               lengthMenu = list(c(10,25,50,-1),
                                                 c(10,25,50,"All"))))
}


dt.convertColumnToOrdered <- function(dt, cols) {
  # for (col in cols) dt[, (col) := ordered(dt[[col]])] #fastest
  # or 
  dt[, (cols):=lapply(.SD, ordered), .SDcols=cols]
  # dt[, cols] <- lapply(dt[, cols, with = FALSE], ordered)
}

# for (col in which(sapply (dt,is.factor)) )  dt[, (col) := as.character(dt[[col]])] #fastest
#  cols  <-  which(sapply (dt,is.factor)); dt[, (cols):=lapply(.SD, ordered), .SDcols=cols]


dt.findCategoricalColumns <- function (dt) {
  cols  <- c (dt[, which(sapply(.SD, is.factor))], dt[, which(sapply(.SD, is.character))] );cols
}



dt.findColumnsByType <- function (
    dt, is.what=function(x){is.ordered(x) | is.integer(x) | is.character(x)}
) {
  cols <- names(dt[sapply(dt, is.what)]); cols
}

dt.findColumnsByFunctionInNthRow <- function (dt, is.what=function (x) {x>0}, rows_to_use=1) {
  # cols <- names(dt[sapply(dt, is.what)]); cols
  cols  <- dt[rows_to_use, which(sapply(.SD, is.what))];cols
}



dtGeo <- data.table(
  GEO = c(  "Ontario", "Quebec", "British Columbia", "Alberta",
            "Manitoba", "Saskatchewan", 
            "Nova Scotia", "New Brunswick",  "Newfoundland and Labrador", "Prince Edward Island",
            "Northwest Territories", "Nunavut", "Yukon", "Canada"  ),
  population = c( 14826276, 8604495, 
                  5214805, 4442879, 
                  1383765, 1179844, 
                  992055, 789225,  520553, 164318, 
                  45504, 39403, 42986, 38246108 ),
  lat = c( 7,6, 12,11,9,10, 5,4,3,2, 15,16, 17, 0 )

)

aGeo <- dtGeo [order(lat)]$GEO 


try2 <- function(code, silent = FALSE) {
  tryCatch(code, error = function(c) {
    msg <- conditionMessage(c)
    if (!silent) message(c)
    invisible(structure(msg, class = "try-error"))
  })
}
if (F) {
  try2(1)
  #> [1] 1
  try2(stop("Hi"))
  #> Error in doTryCatch(return(expr), name, parentenv, handler): Hi
  try2(stop("Hi"), silent = TRUE)
  try2(setnames(dt, "VALUE", "val_norm"))
}
fread.try <- function(file, ...) {
  tryCatch(fread2(file, ...), error = function(c) {
    c$message <- paste0(c$message, " (in ", file, ")")
    stop(c)
  })
}

