#' @title Extract Character Names From Wiki
#' @description Obtain character names from https://www.hbo.com/game-of-thrones/cast-and-crew
#' @param url A valid URL
#' @export
#' @importFrom dplyr mutate
#' @importFrom magrittr "%>%"
#' @importFrom rvest html_text html_nodes
#' @importFrom stringr str_extract str_locate str_split str_split_fixed str_to_lower str_to_title str_trim str_replace_all str_replace
#' @importFrom textclean replace_curly_quote
#' @importFrom xml2 read_html

#' @return Returns a cleaned dataset of the character names from HBO
#' @examples \dontrun{
#' url = 'https://www.hbo.com/game-of-thrones/cast-and-crew'
#' hbo_characters = scrape_HBO_characters(url)
#'}

scrape_HBO_characters <- function(url){
  # HBO xpath to character names
  xpath = as.character('//*[contains(concat( " ", @class, " " ), concat( " ", "components/ThumbnailWithText--primaryText", " " ))]')

  # OBtain Character Names
  characters = xml2::read_html(url) %>%
    rvest::html_nodes(xpath = xpath) %>%
    rvest::html_text()

  # Clean Character Names
  characters = as.data.frame(characters)
  names(characters) = 'scraped_name'

  characters = characters %>%
    dplyr::mutate(scraped_name = textclean::replace_curly_quote(scraped_name),
                  scraped_name = stringr::str_trim(scraped_name, side = "both"),
                  scraped_name = stringr::str_replace_all(scraped_name, "\\(", ""),
                  scraped_name = stringr::str_replace_all(scraped_name, "\\)", ""),
                  scraped_name = stringr::str_replace_all(scraped_name, "Maester", ""),
                  scraped_name = stringr::str_trim(scraped_name, side = "both"),
                  first_name = stringr::str_trim(stringr::str_split_fixed(scraped_name, " ", n = 2)[,1], side = "both"),
                  last_name = stringr::str_trim(stringr::str_split_fixed(scraped_name, " ", n = 2)[,2], side = "both"),
                  nickname = stringr::str_trim(stringr::str_split(last_name, "\"", simplify = TRUE)[,2], side = "both"),
                  last_name = stringr::str_trim(stringr::str_replace_all(last_name, "\"[a-zA-Z]+\"", ""), side = "both"),
                  joined_name = paste0(first_name, " ", last_name, "|", nickname, "|", first_name),
                  joined_name = stringr::str_replace(joined_name, "\\|\\|", "\\|"),
                  full_name = stringr::str_trim(paste0(first_name, " ",last_name), side = "both"))

  return(characters)
}
