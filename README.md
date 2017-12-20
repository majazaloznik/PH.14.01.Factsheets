# Populaiton Horizons Factsheet Vol 14 Issues 1
## Global comparison on contraception decision-makeing in married unions based on DHS data

Repository for analysis and design of the factsheet---and any interactive visualisations that may follow--- for the 14(1) issue of Population Horizons.


## Makefile

Notes for deployment: 

1. Manually download the DHS files (from the `data/raw/url.list.txt` list) into `/data/raw/`

2. Then you should be able to run the whole thing with using the makefile. 

The makefile is visualised below---be warned, this is the current state of the project, which is still in progress. 

![state of makefile](figures/make.png)

### Prerequisites

DHS data requires free (for non-commnercial purposes) registration. And the `lodown` package unfortunately didn't work for DHS for me, so the data download is not automated. After the requried zip files are downloaded, the following programmes are also required: 
R, Rstudio (pandoc, make), Python, some sort of unzipping utility... If it works, don't break it.


### Authors

* **Maja Zalo&zcaron;nik**

## License

This project is licensed under the ?

## Acknowledgments

TBC
