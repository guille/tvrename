# tvrename

![Build Status](https://github.com/guille/tvrename/actions/workflows/crystal.yml/badge.svg)

Crystal command line utility that standardises filenames matching certain patterns. It is meant to support the most usual TV show episode filenames found online.

Example run:

```
$> ls -l
"tv.show.name.s02e01.encoder.ext"
"tv show name - 02x02 encoder.ext"
"Tv Show Name S02E03 blabla.bla.ext"
"Tv Show Name - S02E04.encoder.ext"
"tv show name S02E05.ext"
"tv.show.name.206.ext"
"tv.show.name.1206.ext"
"tv show 2x07 - titles 107.ext"
"tv show s1208 random stuff.ext"
$> ~/tvrename/bin/rename .
$> ls -l
"Tv Show Name S02E01.ext"
"Tv Show Name S02E02.ext"
"Tv Show Name S02E03.ext"
"Tv Show Name S02E04.ext"
"Tv Show Name S02E05.ext"
"Tv Show Name S02E06.ext"
"Tv Show Name S12E06.ext"
"Tv Show S02E07.ext"
"Tv Show S12E08.ext"
```
