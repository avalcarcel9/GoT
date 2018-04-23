#' @title GoT Deaths and Times
#' @description Obtains GoT character deaths and times throughout series
#' @param filename path to store html file extracted
#' @export
#' @importFrom xml2 read_html
#' @importFrom rvest html_text html_nodes
#' @importFrom stringr str_extract str_locate str_split str_to_lower str_to_title str_trim
#' @importFrom dplyr mutate bind_rows
#' @return Returns a cleaned dataset of the deaths in GoT as a tibble
#' @examples \dontrun{
#' filename = "frozen_death_times.html"
#' cleaned_death = get_death_times(filename = filename)
#'}


get_death_times <- function(){

  # Obtain Season, Episode, Character, and Time from various nodes
  doc = xml2::read_html('data/frozen_death_times.html')
  nodes = rvest::html_nodes(doc, "#main-list")
  nodes = rvest::html_nodes(nodes, "li")
  seasons = rvest::html_nodes(nodes, ".season-title")
  eps = rvest::html_nodes(nodes, ".episode-container")
  ep = eps[[1]]

  # Let's obtain the season and episode information from eps
  get_episode_info = function(ep) {
    titles = rvest::html_nodes(ep, ".episode-title")
    titles = rvest::html_text(titles)
    ep_info = dplyr::tibble(season = stringr::str_extract(titles, "Season [:digit:]+"),
                            episode = stringr::str_extract(titles, "Episode [:digit:]+"))

    # make season and episode numeric
    ep_info = ep_info %>%
      mutate(season = as.numeric(stringr::str_extract(season, "[0-9]+")),
             episode = as.numeric(stringr::str_extract(episode, "[0-9]+")))

    return(ep_info)
    # titles = xml2::as_list(titles)[[1]]
    # spans = titles[names(titles) == "span"]
    # spans = lapply(spans, unlist)
    # spans = lapply(spans, function(x) x[ x != "[ comment ]"])
    # spans = sapply(spans, paste, collapse = "")
    # spans
  }

  # Now let's obtain charachter death information
  get_episode_deaths = function(ep) {
    titles = rvest::html_nodes(ep, ".death-container ")
    times = rvest::html_nodes(titles, ".bubble ")
    times = rvest::html_text(times)
    titles = rvest::html_nodes(titles, ".death-inner")
    deaths = rvest::html_nodes(titles, ".death-right")
    who = rvest::html_text(rvest::html_nodes(deaths, "h3"))
    how = rvest::html_text(rvest::html_nodes(deaths, "h4"))
    df = data_frame(who = who, how = how, times = times)
    df
  }

  titles = lapply(eps, get_episode_info)
  deaths = lapply(eps, get_episode_deaths)

  # Bind the two lists so that I have season and episode info
  ## For no deaths in an episode return NULL
  df = mapply(function(title, death) {
    if (nrow(death) == 0) {
      # death = data_frame(who = NA, how = NA, times = NA)
      return(NULL)
    }
    death$season = title$season[1]
    death$episode = title$episode[1]
    death
  }, titles, deaths, SIMPLIFY = FALSE)

  # Create a dataframe
  df = bind_rows(df)
  # Add a column of specific how/who killed
  df = df %>% mutate(
    who = stringr::str_to_title(who),
    how = stringr::str_to_lower(how),
    specific_how = stringr::str_split(how, "by", simplify = TRUE)[,2],
    specific_how = stringr::str_to_title(str_trim(specific_how)),
    length_string = stringr::str_length(times),
    times = if_else(length_string == 4,
                    paste0("00:0", times),
                    paste0("00:", times)),
    times = lubridate::hms(times)) %>%
    select(-length_string)

  return(df)
}
