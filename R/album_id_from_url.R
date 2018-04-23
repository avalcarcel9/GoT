#' @title Extract Album URL ID
#' @description From the URL information extract each album ID of an artist
#' @param url A valid URL
#' @return Returns a glm object containing the trained MIMoSA coefficients.
#' @examples \dontrun{
#' URL = "https://genius.com/albums/Game-of-thrones/Season-1-scripts"
#' info = album_id_from_url(url = URL)
#'}

album_id_from_url <- function(url) {
  cr = info_from_url(url)
  cr$aid
}
