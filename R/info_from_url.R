#' @title Extract Information from URL
#' @description Obtain information from URL like multiple albums and IDs
#' @param url A valid URL
#' @importFrom rvest html_nodes html_attr
#' @importFrom xml2 read_html
#' @importFrom jsonlite fromJSON
#' @return Returns URL info
#' @examples \dontrun{
#' URL = "https://genius.com/albums/Game-of-thrones/Season-1-scripts"
#' info = info_from_url(url = URL)
#'}


info_from_url = function(url) {
  doc = xml2::read_html(url)
  content = rvest::html_nodes(doc,
                       xpath = "//meta")
  content = rvest::html_attr(content, "content")
  # content = content[grepl("^\\{", content)]
  # Select objects that start (^) with {
  content = content[stringr::str_detect(content, pattern = "^\\{")]
  cr = jsonlite::fromJSON(content)
  a_id = switch(cr$page_type,
                album = cr$album$id,
                song = cr$song$album$id
  )
  cr$aid = a_id
  cr
}
