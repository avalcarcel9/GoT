library(hexSticker)
library(usethis)

hexSticker::sticker("inst/GoT_icon.png",
                    package="",
                    s_x=1,
                    s_y=1,
                    s_width=0.55,
                    s_height=0.55,
                    p_color = "white",
                    p_size = 6,
                    p_x = 1,
                    p_y = 1.7,
                    h_fill = "#000000",
                    h_color = "#5DBCD2",
                    url = "https://github.com/avalcarcel9/GoT",
                    u_x = .26,
                    u_y = 1.49,
                    u_size = 1.2,
                    u_color = "white",
                    filename = "inst/GoT_sticker.png")

usethis::use_build_ignore(
  c("inst/GoT_icon.png",
    "inst/GoT_icon.ai",
    "inst/GoT_sticker.R",
    "inst/GoT_sticker.png",
    "inst/throne.png",
    "inst/GoT_logo.png"))
