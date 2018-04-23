#' @title Scrape GoT Data
#' @description Scrapes all episodes for all seasons of GoT
#' @param base_url The base URL for all seasons of GoT
#' @param seasons The season you would like to scrape data up until
#' @export
#' @importFrom geniusr scrape_tracklist scrape_lyrics_url
#' @importFrom dplyr mutate rowwise group_by do ungroup
#' @return Returns the dataset pulled from genius using geniusr
#' @examples \dontrun{
#' base_url = "https://genius.com/albums/Game-of-thrones"
#' info = scrape_GoT(base_url = base_url, season = 1)
#'}

# Depends on geniusr which did not fully scrape episodes
# scrape_GoT <- function(base_url, seasons){
#   all_urls = file.path(base_url,
#                        paste0("Season-", 1:seasons, "-scripts"))
#   episode_info = as.data.frame(sapply(all_urls, album_id_from_url)) %>%
#     rowwise() %>%
#     do(scrape_tracklist(.)) %>%
#     mutate(song_lyrics_url = toString(song_lyrics_url)) %>%
#     group_by(song_number, album_name) %>%
#     do(geniusr::scrape_lyrics_url(.$song_lyrics_url)) %>%
#     ungroup()
#   return(episode_info)
# }

# Depends on copied function from geniusr that gives us full episode information
scrape_GoT <- function(base_url, seasons){
  all_urls = file.path(base_url,
                       paste0("Season-", 1:seasons, "-scripts"))
  episode_info = as.data.frame(sapply(all_urls, album_id_from_url)) %>%
    dplyr::rowwise() %>%
    dplyr::do(geniusr::scrape_tracklist(.)) %>%
    dplyr::mutate(song_lyrics_url = toString(song_lyrics_url)) %>%
    dplyr::group_by(song_number, album_name) %>%
    dplyr::do(scrape_full_scripts(.$song_lyrics_url)) %>%
    dplyr::ungroup()
  return(episode_info)
}
