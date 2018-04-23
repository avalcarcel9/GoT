#' @title Scrape GoT Full Script Data
#' @description Scrapes and episode of GoT given the URL. Copied and adapted from geniusr package scrape_lyrics_url function
#' @param song_lyrics_url url for data to scrape
#' @param access_token The API token
#' @importFrom rvest html_text html_nodes
#' @importFrom xml2 xml_find_all
#' @importFrom stringr str_split str_detect
#' @importFrom dplyr tibble
#' @return Returns the dataset pulled from scraping
#' @examples \dontrun{
#' url = "https://genius.com/albums/Game-of-thrones"
#' script = scrape_full_scripts(url)
#'}

scrape_full_scripts <- function(song_lyrics_url, access_token = genius_token()){
    session <- suppressWarnings(rvest::html(song_lyrics_url))
    song <- rvest::html_nodes(session, ".header_with_cover_art-primary_info-title") %>%
      rvest::html_text()
    artist <- rvest::html_nodes(session, ".header_with_cover_art-primary_info-primary_artist") %>%
      rvest::html_text()
    lyrics <- rvest::html_nodes(session, ".lyrics p")
    xml2::xml_find_all(lyrics, ".//br") %>% xml2::xml_add_sibling("p",
                                                                  "\n")
    xml2::xml_find_all(lyrics, ".//br") %>% xml2::xml_remove()
    lyrics <- rvest::html_text(lyrics)
    #lyrics <- lyrics[1]
    lyrics <- unlist(stringr::str_split(lyrics, pattern = "\n"))
    lyrics <- lyrics[lyrics != ""]
    lyrics <- lyrics[!stringr::str_detect(lyrics, pattern = "\\[|\\]")]
    lyrics <- tibble::tibble(line = lyrics)
    lyrics$song_lyrics_url <- song_lyrics_url
    lyrics$song_name <- song
    lyrics$artist_name <- artist
    return(tibble::as_tibble(lyrics))
}
