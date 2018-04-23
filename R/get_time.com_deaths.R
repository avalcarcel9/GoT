#' @title GoT Deaths and Times from time.com
#' @description Obtains GoT character deaths and times throughout series
#' @param url The time.com url 'http://time.com/3924852/every-game-of-thrones-death/'
#' @export
#' @importFrom xml2 read_html
#' @importFrom rvest html_text html_nodes
#' @importFrom stringr str_extract str_locate str_split str_to_lower str_to_title str_trim
#' @importFrom dplyr mutate bind_rows
#' @import magrittr
#' @return Returns a cleaned dataset of the deaths in GoT as a tibble
#' @examples \dontrun{
#' url = 'http://time.com/3924852/every-game-of-thrones-death/'
#' time.com_deaths  = get_time.com_deaths()
#'}

get_time.com_deaths <- function(url){

  # Obtain who died first
  who = xml2::read_html(url) %>%
    rvest::html_nodes('.headline') %>%
    rvest::html_text() %>%
    stringr::str_extract("[a-zA-Z]+ [a-zA-Z]+|[a-zA-Z]+") %>%
    dplyr::as_tibble() %>%
    dplyr::slice(-1) %>%
    dplyr::mutate(value = stringr::str_trim(value, side = "both")) %>%
    dplyr::select(who=value)

  # Obtain how they died
  how = xml2::read_html(url) %>%
    rvest::html_nodes('p') %>%
    rvest::html_text() %>%
    dplyr::as_tibble() %>%
    dplyr::mutate(loc_how = str_detect(value, "Mean")) %>%
    dplyr::filter(loc_how == TRUE) %>%
    dplyr::mutate(value = stringr::str_split(value, ": ", simplify = TRUE)[,2],
                  value = stringr::str_trim(value, side = "both"),
                  specific_how = stringr::str_split(value, "by", simplify = TRUE)[,2],
                  specific_how = stringr::str_trim(value, side = "both")) %>%
    dplyr::select(how=value,
                  specific_how)

  # Obtain season and episode that they die
  time = xml2::read_html(url) %>%
    rvest::html_nodes('p') %>%
    rvest::html_text() %>%
    dplyr::as_tibble() %>%
    dplyr::mutate(loc_time = str_detect(value, "Time")) %>%
    dplyr::filter(loc_time == TRUE) %>%
    dplyr::mutate(times = NA,
                  season = as.numeric(stringr::str_extract_all(value, "[0-9]+", simplify = TRUE)[,1]),
                  episode = as.numeric(stringr::str_extract_all(value, "[0-9]+", simplify = TRUE)[,2])) %>%
    dplyr::select(season, episode, times)

  return(dplyr::bind_cols(who, time, how))
}
