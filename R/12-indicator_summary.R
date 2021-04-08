#' Creates a Correlation Matrix
#'
#' This takes a raw data file and creates a systems correlation database
#'
#' @param df dataframe in format
#' @param use_geocode_and_time_as_obs dataframe in format
#'
#' @return Returns a correlation matrix
#'
#' @examples
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr summarise
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr filter
#' @importFrom dplyr rename
#' @importFrom dplyr arrange
#' @importFrom dplyr top_n
#' @importFrom tidyr spread 
#' @importFrom rlang .data
#' @importFrom corrr correlate
#' @importFrom corrr stretch
#' @importFrom corrr as_cordf
#' @importFrom stats complete.cases
#' @importFrom igraph graph_from_data_frame
#' @importFrom igraph degree
#' @importFrom igraph E<-
#' @importFrom igraph E
#' @importFrom igraph V<-
#' @importFrom igraph V

#' @author David Hammond
#' @export


systr_indicator_summary = function(indicator, rval = 0.5, pval = 0.1){
        corrs = get_corrs() %>% add_info(get_meta()) %>% 
                filter(variablename.x == indicator) %>%
                top_n(10, abs(r))
        files = list.files()[grepl("granger", list.files())]
        grg = readRDS[files[1]]
        for (i in files[-1]){
                tmp = readRDS(i)
                grg = rbind(grg, tmp) %>% filter(variablename.x == indicator | variablename.y == indicator) %>%
                        filter(f_test < pval)
        }
        grg = grg %>% group_by(variablename.x, variablename.y) %>%
                summarise(n = n()) %>% top_n(10, n)
        x = list(corrs = corrs, granger = grg)
        
        return(x)
        
}