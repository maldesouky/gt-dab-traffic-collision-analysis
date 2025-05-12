# Traffic Collision Analysis
This project is aimed at testing for the existence of a relationship between several predictors and the occurrence of death/injury. Such findings can help our client to adjust insurance premiums accordingly.
The team has been successful in proving the existence of a relationship between:
1. Driver attributes (sex, age group, being licensed)
2. Vehicle attributes (instate/out-of-state license, safety category, weight, type)
3. Weather (temperature, precipitation, wind speed)
4. Time components (time of day, season)
5. Population density of crash location
and the probability of injury/death. To successfully achieve this result, extensive data manipulation had to take place.

## Inroduction
Hi! If you're reading this, then that means you're the lucky TA who has been assigned to grade group 10's MGT 6203 project. I'm going to try to make this as uncomplicated as possible, since I'm sure you've got a lot of other things you need to be doing, and probably a few others that maybe you'd just enjoy a little more.

## Datasets
We combined information from multiple datasets. Samples from these datasets as well as the completed combined dataset are included.

### Raw Datasets

[**Crashes Dataset Sample**](Data/01_crashes/crashes-raw-sample.7z)
<br/><ins>Source:</ins> NYC OpenData (2023, June).
<br/>For full dataset, click [here](https://catalog.data.gov/dataset/motor-vehicle-collisions-crashes).

[**Vehicles Dataset Sample**](Data/02_vehicles/vehicles-raw-sample.7z)
<br/><ins>Source:</ins> NYC OpenData (2023, June).
<br/>For full dataset, click [here](https://catalog.data.gov/dataset/motor-vehicle-collisions-vehicles).

[**Persons Dataset Sample**](Data/03_persons/persons-raw-sample.7z)
<br/><ins>Source:</ins> NYC OpenData (2023, June).
<br/>For full dataset, click [here](https://catalog.data.gov/dataset/motor-vehicle-collisions-person).

[**Weather Dataset Sample**](Data/04_weather/weather-raw-sample.7z)
<br/><ins>Source:</ins> Visual Crossing API. Data is accessed in parts based on API calls submitted to the provider.
<br/>For API documentation, click [here](https://www.visualcrossing.com/resources/documentation/weather-api/timeline-weather-api/).

[**Zipcode Locations and Geometry Dataset**](Data/05_nyc-zip-codes/ZIP_CODE_040114.zip)
<br/><ins>Source:</ins> NYC OpenData (2023, June).
<br/>For dataset directly from source, click [here](https://catalog.data.gov/dataset/zip-code-boundaries).

[**Astronomical Sunrise/Sunset Data for NYC**](Data/07_time-of-day/time-of-day-full.7z)
<br/><ins>Source:</ins> National Oceanic and Atmospheric Administration, NOAA Solar Calculator.
<br/>For dataset directly from source, click [here](https://gml.noaa.gov/grad/solcalc/).


### Combined Dataset
The raw datasets above were combined and analyzed using several tools to produce one final combined dataset fit for analysis. You can find this one [here](Data/99_combined-final/nyc-collisions-weather-tod-final.7z). For convenience, it is in CSV format.


## The Code
There's only one code file to run once you have the final dataset. It's called [**CrashesSummaryFinal.RMD**](Final%20Code/02_collision-analysis/CrashesSummaryFinal.Rmd).

It's an R markdown file that was created in RStudio. The final output can be seen [here](Final%20Code/02_collision-analysis/CrashesSummaryFinal.html).

### Reproduction of the Output

1. Open [**CrashesSummaryFinal.RMD**](Final%20Code/02_collision-analysis/CrashesSummaryFinal.Rmd) in the latest
version of RStudio. But don't run it yet!
2. ou'll need to install (or have installed) the following
libraries in your version of R (Don't worry about calling the libraries; it's done in the code):
    - `pROC`
    - `car`
3. You'll need to have `nyc-collisions-weather-tod-final.csv` in the same folder as the `.rmd` file. Decompress the [combined dataset](#combined-dataset) using [7-zip](https://www.7-zip.org/download.html) archiver to do so.
    - If you're using a Mac, and you want to keep `nyc-collisions-weather-tod-final.csv` on your desktop,
great!
    - If you'd like to keep the file somewhere else, you'll need to change _Line 19_ of the
`CrashesSummaryFinal.RMD` to point to the location of
`nyc-collisions-weather-tod-final.csv`.
4. Click the _Knit_ button on the RStudio toolbar. It looks like this:
![](Resources/images/readme-knit.png)
5. Finally, the HTML file containing the output of
`CrashesSummaryFinal.RMD` should open automatically.
6. If it doesn't, you should find it saved in the same directory that you saved `CrashesSummaryFinal.RMD`.
7. For your convenience, [here](Final%20Code/02_collision-analysis/CrashesSummaryFinal.html) is a copy of our version of the output.

That's it! Feel free to review the output at your leisure. 

Thanks for reading!
<br/>Team 10 and the [Rubber Duck of New York](https://ducksinthewindow.com/statue-of-liberty-freedom-rubber-duck/) OUT!

<img src="Resources/images/readme-rubber-duck-ny.png" alt="The Rubber Duck of NY" width="299" height="299">
