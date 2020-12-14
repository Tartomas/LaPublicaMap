# LaPublicaMap

## Intro
This repo was created to give a hand to [LaPublica](https://lapublica.cl/) in order to visualize the Chilean police forcement displacement during the [Oct 2019-2020 Protest](https://en.wikipedia.org/wiki/2019%E2%80%9320_Chilean_protests)

![Front Page](img/logoLapublica.png?raw=true "Pagina web")

## How this repo works

## Main Script
Code to create a story telling of the number of police in each commune

 > tmap_lapublic.R

## Video deployer
Grab the .png files and use the amazing {av} packages to create a video
 > gifTer.R

![Ix Region](IX_map.gif)
et voala!

## To run you use **GGDRIVE_key** variable

create a *.Renviron* or set up by the following code:
 > Sys.setenv(GGDRIVE_key="xxxxxx_google_code")
 
 - [Further reading](https://googlesheets4.tidyverse.org/)


