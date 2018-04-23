
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

For a more thorough walkthrough please see my [blog post](http://www.alessandravalcarcel.com/blog/2018-04-1-r-rmarkdown-got-scrape/).

``` r
library(GoT)
```

This package helps you scrape a the Game of Thrones scripts from [www.genius.com](www.genius.com) and some character lists online.

To scrape the scripts from genius you can use `GoT::scrape_GoT()`.

``` r
base_url = "https://genius.com/albums/Game-of-thrones"
info = GoT::scrape_GoT(base_url = base_url, season = 7)
#> Warning in strptime(x, fmt, tz = "GMT"): unknown timezone 'zone/tz/2018c.
#> 1.0/zoneinfo/America/New_York'
#> Warning: Grouping rowwise data frame strips rowwise nature
head(info)
#> # A tibble: 6 x 6
#>   song_number album_name       line  song_lyrics_url song_name artist_name
#>         <dbl> <chr>            <chr> <chr>           <chr>     <chr>      
#> 1        1.00 Season 1 Scripts WAYM… https://genius… Winter i… Game of Th…
#> 2        1.00 Season 1 Scripts WILL… https://genius… Winter i… Game of Th…
#> 3        1.00 Season 1 Scripts WAYM… https://genius… Winter i… Game of Th…
#> 4        1.00 Season 1 Scripts WILL… https://genius… Winter i… Game of Th…
#> 5        1.00 Season 1 Scripts GARE… https://genius… Winter i… Game of Th…
#> 6        1.00 Season 1 Scripts ROYC… https://genius… Winter i… Game of Th…
tail(info)
#> # A tibble: 6 x 6
#>   song_number album_name       line  song_lyrics_url song_name artist_name
#>         <dbl> <chr>            <chr> <chr>           <chr>     <chr>      
#> 1        10.0 Season 6 Scripts CERS… https://genius… The Wind… Game of Th…
#> 2        10.0 Season 6 Scripts QYBU… https://genius… The Wind… Game of Th…
#> 3        10.0 Season 6 Scripts QYBU… https://genius… The Wind… Game of Th…
#> 4        10.0 Season 6 Scripts QYBU… https://genius… The Wind… Game of Th…
#> 5        10.0 Season 6 Scripts ALL:… https://genius… The Wind… Game of Th…
#> 6        10.0 Season 6 Scripts THEO… https://genius… The Wind… Game of Th…
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
#>                                                                                                      raw
#> 1                                         Abelar Hightower, challenger at the tourney at Ashford Meadow.
#> 2                                                                                       Addam, a knight.
#> 3                             Addam Frey, a knight at the Whitewalls tourney, cousin to Lady Butterwell.
#> 4                          Addam Marbrand, a knight in the service of House Lannister. Heir to Ashemark.
#> 5 Addam Osgrey, son of Eustace Osgrey, slain on the Redgrass Field during the First Blackfyre Rebellion.
#> 6                                         Addam Velaryon, a dragonrider during the Dance of the Dragons.
#>              names
#> 1 Abelar Hightower
#> 2            Addam
#> 3       Addam Frey
#> 4   Addam Marbrand
#> 5     Addam Osgrey
#> 6   Addam Velaryon
#>                                                      description
#> 1                   challenger at the tourney at Ashford Meadow.
#> 2                                                      a knight.
#> 3                             a knight at the Whitewalls tourney
#> 4  a knight in the service of House Lannister. Heir to Ashemark.
#> 5                                          son of Eustace Osgrey
#> 6                 a dragonrider during the Dance of the Dragons.

# Scrape HBO characters and save
url = 'https://www.hbo.com/game-of-thrones/cast-and-crew'
hbo_characters = GoT::scrape_HBO_characters(url)

head(hbo_characters)
#>         scraped_name first_name last_name nickname             joined_name
#> 1 Eddard ?Ned? Stark     Eddard     Stark      Ned Eddard Stark|Ned|Eddard
#> 2   Robert Baratheon     Robert Baratheon          Robert Baratheon|Robert
#> 3   Tyrion Lannister     Tyrion Lannister          Tyrion Lannister|Tyrion
#> 4   Cersei Lannister     Cersei Lannister          Cersei Lannister|Cersei
#> 5      Catelyn Stark    Catelyn     Stark            Catelyn Stark|Catelyn
#> 6    Jaime Lannister      Jaime Lannister            Jaime Lannister|Jaime
#>          full_name
#> 1     Eddard Stark
#> 2 Robert Baratheon
#> 3 Tyrion Lannister
#> 4 Cersei Lannister
#> 5    Catelyn Stark
#> 6  Jaime Lannister
```

Death Timeline
--------------

We can also obtain death timeline data from <https://deathtimeline.com/>.

``` r
death_times = GoT::get_death_times()
head(death_times)
#> # A tibble: 6 x 6
#>   who          how                    times    season episode specific_how
#>   <chr>        <chr>                  <chr>     <dbl>   <dbl> <chr>       
#> 1 Waymar Royce killed by white walker 00:05:52   1.00    1.00 White Walker
#> 2 Gared        killed by white walker 00:06:58   1.00    1.00 White Walker
#> 3 Will         executed by ned stark  00:13:44   1.00    1.00 Ned Stark   
#> 4 Jon Arryn    poisoned by lysa       00:18:34   1.00    1.00 Lysa        
#> 5 Assassin     killed by bran's wolf  00:31:27   1.00    2.00 Bran's Wolf 
#> 6 Mycah        killed by the hound    00:04:37   1.00    2.00 The Hound
```

Unfortunately, this timeline only goes up to season 6 so I'll use a this article <http://time.com/3924852/every-game-of-thrones-death/> as a supplement.

``` r
url = 'http://time.com/3924852/every-game-of-thrones-death/'
time.com_deaths = GoT::get_time.com_deaths(url = url)
head(time.com_deaths)
#> # A tibble: 6 x 6
#>   who               season episode times how           specific_how       
#>   <chr>              <dbl>   <dbl> <lgl> <chr>         <chr>              
#> 1 Will                1.00    1.00 NA    Beheaded for… Beheaded for deser…
#> 2 Jon Arryn           1.00    1.00 NA    Poisoned by … Poisoned by Lysa A…
#> 3 Jory Cassel         1.00    5.00 NA    Stabbed by J… Stabbed by Jaime L…
#> 4 Viserys Targaryen   1.00    6.00 NA    Khal Drogo p… Khal Drogo pours m…
#> 5 Benjen Stark        1.00    7.00 NA    Killed by Wh… Killed by White Wa…
#> 6 Robert Baratheon    1.00    7.00 NA    Mortally wou… Mortally wounded b…
```
