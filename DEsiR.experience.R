#' @name DEsiR package experience
#'
#' @title Wanna feel the full DEsiR package experience?
#'
#' @param experience.level Either \code{"full"} or \code{"dull"}.
#' 
#' @author Thomas Guillerme


DEsiR.experience <- function(experience.level = "full") {

    #Asking for confirmation
    read.key <- function(msg1, msg2, scan = TRUE) {
        message(msg1)
        if(scan == TRUE) {
            scan(n=1, quiet=TRUE)
        }
        silent <- "yes"
        if(!missing(msg2)) {
            message(msg2)
        }
    }
    #dull experience
    if(experience.level == "dull") {
        message("DEsiR experience level set to normal.\nStandard R enjoyment initiated.")
    }

    #
    if(experience.level == "full") {
        message("DEsiR experience level set to full.\nInitiating higher levels of fun...")

        #Library
        if(!require(audio)) install.packages("audio")
        library(audio)

        #Loading the music
        message("Enhancing experience levels.\nHold tight...")
        desir <- tempfile()
        download.file("http://tguillerme.github.io/tmp/U2-Desire.wav", desir, mode = "wb")
        desir <- load.wave(desir)

        #Play!
        read.key("Press [enter] to use DEsiR in full enhanced experience.")
        play(desir)
        message("Enjoy!")
    }
}

