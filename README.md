
<!-- README.md is generated from README.Rmd. Please edit that file -->
GoT
===

The goal of GoT is to help scraping some Game of Thrones data from the internet.

Installation
------------

You can install the development version from [GitHub](https://github.com/avalcarcel9/GoT) with:

``` r
# install.packages("devtools")
devtools::install_github("avalcarcel9/GoT")
```

**Warning: This package scrapes data from the internet. Please be mindful of pinging servers too frequently and of the user agreements for sharing data.**

Setup
-----

This package is dependent on the `geniusr` package and you must have an API token. Go [here](https://genius.com/) to create an account or login and obtain an API token. For more information on the API creation you can look at the genius documentation [here](https://docs.genius.com/#!#%2Fgetting-started-h1).

Once you’ve created an account and obtained an API they’ll assign you a token. Be sure to copy the token. With the token copied you can add it to the R environment with some code.

Running the following code will open your .Renviron

``` r
user_renviron = path.expand(file.path("~", ".Renviron"))
if(!file.exists(user_renviron)) # check to see if the file already exists
  file.create(user_renviron)
file.edit(user_renviron) # open with another text editor if this fails
```

Once this file is open paste the following into the script:

``` r
GENIUS_API_TOKEN="your-token-goes-here"
```

If done properly then this code will return your API token.

``` r
Sys.getenv("GENIUS_API_TOKEN")
```

Use
---

``` r
library(GoT)
```

This package helps you scrape a the Game of Thrones scripts from [www.genius.com](www.genius.com) and some character lists online.

To scrape the scripts from genius you can use `GoT::scrape_GoT()`.

``` r
base_url = "https://genius.com/albums/Game-of-thrones"
info = GoT::scrape_GoT(base_url = base_url, season = 7)
head(info)
tail(info)
```

This function will scrape all the seasons up to the season indicated as the function input.

We can also scrape character lists from two websites:

1.  <http://awoiaf.westeros.org/index.php/List_of_characters>
2.  <https://www.hbo.com/game-of-thrones/cast-and-crew>

``` r
# Scrape wiki characters and save
url = "http://awoiaf.westeros.org/index.php/List_of_characters"
wiki_characters = GoT::scrape_characters(url)

head(wiki_characters)

# Scrape HBO characters and save
url = 'https://www.hbo.com/game-of-thrones/cast-and-crew'
hbo_characters = GoT::scrape_HBO_characters(url)

head(hbo_characters)
```

Death Timeline
--------------

We can also obtain death timeline data from <https://deathtimeline.com/>.

``` r
death_times = GoT::get_death_times()
head(death_times)
```

Unfortunately, this timeline only goes up to season 6 so I'll use a this article <http://time.com/3924852/every-game-of-thrones-death/> as a supplement.

``` r
url = 'http://time.com/3924852/every-game-of-thrones-death/'
time.com_deaths = GoT::get_time.com_deaths(url = url)
head(time.com_deaths)
```
