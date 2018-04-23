#' @title Extract Character Names From Wiki
#' @description Obtain character names from http://awoiaf.westeros.org/index.php/List_of_characters
#' @param url A valid URL
#' @export
#' @importFrom rvest html_nodes html_text
#' @importFrom xml2 read_html
#' @importFrom stringr str_split str_replace
#' @importFrom dplyr mutate
#' @import magrittr
#' @return A tibble of character names and description
#' @examples \dontrun{
#' url = "http://awoiaf.westeros.org/index.php/List_of_characters"
#' characters = scrape_characters(url)
#'}


scrape_characters <- function(url){
  doc = xml2::read_html(url)
  content = rvest::html_nodes(doc,
                       xpath = "//li")
  content = trimws(rvest::html_text(content))
  content = as.data.frame(content)
  names(content) = "raw"
  content = content %>%
    dplyr::mutate(names = str_split(raw, ",", simplify = TRUE)[,1],
                  names = str_replace(names, "//.", ""),
                  description = str_split(raw, ",", simplify = TRUE)[,2])
}
