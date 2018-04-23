#' @title Force colon
#' @description Change lines without a colon to have a colon after character name

#' @param x A string
#' @export
#' @importFrom stringr str_replace
#' @return Returns a string with a colon
#' @examples \dontrun{
#' x = "Tywin (to Sansa) Stupid girl"
#' parens_to_colon(x=x)
#'}


# Change lines with parenthesis but no colon to include a colon
parens_to_colon = function(x) {
  stringr::str_replace(string = x, pattern = "\\)", replacement = "\\):")
}
