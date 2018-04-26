#' @title Clean GoT Script Data
#' @description Cleans GoT data taken from geniusr scrape
#' @param data The data returned by scraping using geniusr
#' @export
#' @importFrom stringr str_extract str_detect str_sub str_replace str_replace_all str_locate str_to_title str_extract_all str_trim
#' @importFrom dplyr mutate filter select
#' @importFrom stats complete.cases
#' @return Returns a semi cleaned dataset
#' @examples \dontrun{
#' base_url = "https://genius.com/albums/Game-of-thrones"
#' info = GoT::scrape_GoT(base_url = base_url, season = 1)
#' cleaned = GoT::cleanGoT(info)
#'}

cleanGoT <- function(data){
  clean_data = data %>%
    mutate(orig_line = line,
           season = as.numeric(stringr::str_extract(album_name, "[:digit:]+")),
           no_colon = !stringr::str_detect(line, ":"),
                      line = ifelse(no_colon,
                         parens_to_colon(line),
                         line),
           line2 = stringr::str_sub(line, str_locate(line, ":")[,2]),
           line2 = stringr::str_replace(line2, "^: |^:", ""),
           line2 = stringr::str_replace_all(line2, "\\(.*\\)", ""),
           line2 = stringr::str_trim(line2),
           line2 = stringr::str_replace_all(line2, "\"", ""),
           line2 = stringr::str_replace_all(line2, '\'', ""),
           line2 = stringr::str_replace_all(line2, "\\:", ""),
           speaker = stringr::str_sub(line, 1, str_locate(line, ":|\\)")[,1]),
           speaker = stringr::str_replace_all(speaker, ":", ""),
           speaker = stringr::str_replace_all(speaker, "\\(.*\\)", ""),
           speaker = stringr::str_to_title(speaker),
           speaker = stringr::str_trim(speaker, side = "both"),
           speaker = stringr::str_to_title(speaker),
           speaker = stringr::str_trim(speaker),
           action = stringr::str_extract_all(line, "\\(.*\\)", simplify = TRUE),
           action = stringr::str_replace_all(action, "\\).*\\(", " "),
           action = stringr::str_replace_all(action, "\\(", ""),
           action = stringr::str_replace_all(action, "\\)", ""),
           action = stringr::str_trim(action, side = "both")) %>%
    filter(complete.cases(.)) %>%
    select(episode = song_number, season = season, line = line2, speaker, action, orig_line)
  return(clean_data)
}
