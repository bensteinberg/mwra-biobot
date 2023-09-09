mwra-biobot
===========

This repository contains a tool for converting the PDF found at the [Massachusetts Water Resources Authority Wastewater COVID-19 Tracking page](https://www.mwra.com/biobot/biobotdata.htm) into usable data.

To produce `mwra-biobot.csv`, run:

```
poetry install
poetry run extract
```

The script saves the PDF file in the `pdf/` directory, but I am not including these files in the repo.

The repo includes an R file as an example of how to load and plot data from the CSV file.

Similar tools
-------------

See also [nibrivia/mwra-data](https://github.com/nibrivia/mwra-data) and [adalca/covid-mwra-cases](https://github.com/adalca/covid-mwra-cases).
