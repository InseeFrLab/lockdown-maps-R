# Dataviz: Population Movements at Spring 2020 Lockdown in France

[![maps](https://github.com/InseeFrLab/lockdown-maps-R/workflows/maps/badge.svg)](https://github.com/InseeFrLab/lockdown-maps-R/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

[DataViz (:gb:)](https://inseefrlab.github.io/lockdown-maps-R/inflows_EN.html)
[DataViz (:fr:)](https://inseefrlab.github.io/lockdown-maps-R/inflows_FR.html)

On the 17th of March 2020, France entered its first strict national lockdown in an effort to curb the covid-19 pandemic. Announced a few days before, the population had some leverage to choose where to spend the period. At this time, INSEE, the French national institutes, estimated that Paris lost about 450,000 metropolitan residents compared to 2020 first months, half of which were usual Paris residents. These population surpluses were broadly distributed across France. As a general stylized fact (Paris set aside), the population was closer to its usual residence during the lockdown: motives for overnight stays in other regions such as tourism, family visits or business trips were strongly restricted. For instance, the winter season ended abruptly in the Alps with the closing of ski resorts: seasonal workers and tourists left. These estimates were produced thanks to the partnerships with three Mobile Network Operators, which provided anonymous counts of nightly presence by usual residency. They were statistically adjusted and combined by INSEE [Galiana et al. (2020)](https://www.insee.fr/fr/statistiques/4635407).

One year after, a richer (though a bit more fragile) [dataset](https://www.insee.fr/fr/statistiques/fichier/5350073/mouvements_population_confinement_2020_csv.zip) was released by Insee based on the same method so as to allow visualization of aggregate overnight stays by residency - comparing the period before and after the lockdown. This dataset feeds the visualization tool built by CBS (the Dutch National Statistical Institute) and used for instance [here](http://www.mtennekes.nl/viz/commutingNL/v8/) on commuting data. This work was presented at the online seminar [__Big Data for timely statistics__](https://www.cbs.nl/en-gb/onze-diensten/unique-collaboration-for-big-data-research/big-data-matters-3-the-need-for-timely-statistics) on the 1st of April 2021.


## Some definitions

Population movements are defined by the number of persons spending the night in _d??partement_ (NUTS3) `d` while being usual resident in _d??partement_ `r`. For instance, Paris attracts a large number of people who are staying overnight for business, tourism or other reasons. These low-frequency ''flows'' are estimated on data of 3 mobile network operators (MNO) covering 16th of January to 16th of March 2020 on one hand (before lockdown) and 17th of March to 11th of May 2020 (during lockdown).

_Overnight Stay d??partement_: For each MNO, a mobile phone is considered as staying overnight if it is stable geographically over a significant period between midnight and 6a.m.. Such counts - provided by usual place of residency - are combined and adjusted with Insee population counts to form three similar time series, one per each MNO.

_Residency d??partement_ It is the _d??partement_ of ''usual'' residency, whose definition may vary from one MNO to the other.

## Method

The method to construct population estimates before and during lockdown was described in  [Galiana et al. (2020)](https://www.insee.fr/fr/statistiques/4635407) (French only). It amounts to running a linear regression for each couple _d??partement_ of residency cross _d??partement_ of overnight stays `(d,r)` to smooth the three adjusted time series in a single average estimate of population before and after lockdown. This is done because the three series may disagree, and daily data are not sufficiently robust to change in mobile phone use or punctual absence of data for some regions.

## Data

### Download

[Aggregated Data, as published in May 2020](https://www.insee.fr/fr/statistiques/fichier/4635407/IA54_Donnees.xlsx): stays the reference for aggregates  

[Dataviz Data, as published in April 2021](https://www.insee.fr/fr/statistiques/fichier/5350073/mouvements_population_confinement_2020_csv.zip): allows re-use by disseminating flows

### Cautionary note

These two data sets are considered by Insee as **experimental**: the new data sources that constitute aggregated mobile phone data suffer a number of biases which were probably only partially adjusted. In addition, the second data set which feeds the dataviz is disseminated by rounded only at 100, to allow for re-use and aggregation such as these allowing to deploy the [visualisation](https://inseefrlab.github.io/lockdown-maps-R/inflows_EN.html). It is however recommended to interpret these numbers and aggregates made from them after rounding at 1,000 (as it is done for the visualisation). In addition, as not all couples of presence/residency `(d,r)` can be estimated (intermittent flows, not enough observations) and because there are irreductible rounding errors, the aggregates which were first published and estimated at a more aggregated level should stay the reference.

## Visualisation

CBS [Statistics Netherlands](https://www.cbs.nl/en-gb) has built the visualization tool.  [More insight into mobility with the doughnut map (cbs.nl)](https://www.cbs.nl/en-gb/over-ons/innovation/project/more-insight-into-mobility-with-the-doughnut-map)  

It was also applied to job commuting in the NetherLands [NL Job Commuting Viz](https://dashboards.cbs.nl/v1/commutingNL/) 

To build the visualization from R:  
First, make sure all the dependencies have been installed, for instance with the [renv](https://rstudio.github.io/renv/)  package which reads the `renv.lock` file:

```r
# install.packages("renv")
renv::init()
renv::restore()
```

The pipeline can be run with the rOpenSci's [targets](https://docs.ropensci.org/targets/) package: it builds the HTML files with the `_targets.R` workflow:

```r
targets::tar_make()
```



## How to cite this work?

Suarez Castillo, M. and M. Tennekes, "Population Movements at Spring 2020 Lockdown in France - Interactive Data Visualizations", Insee & CBS, 2021, https://github.com/InseeFrLab/lockdown-maps-R

## References

Galiana, L. Suarez Castillo, M., S??m??curbe, F. Coudin, E., de Bellefon, M.-P. (2020), "Retour	partiel des mouvements de  population avec le d??confinement", Insee Analyses N??54, INSEE  
		
Tennekes, M. and Chen, M. (2021) Design Space of Origin-Destination Data Visualization.	Forthcoming in Eurographics <br> Conference on Visualization (EuroVis) 2021

[More insight into mobility with the doughnut map - Statistics Netherlands. cbs.nl](https://www.cbs.nl/en-gb/over-ons/innovation/project/more-insight-into-mobility-with-the-doughnut-map)  


D??placements de population lors du confinement au printemps 2020 - Donn??es exp??rimentales - INSEE, https://insee.fr/fr/statistiques/5350073

INSEE press release of April 8, ???Population pr??sente sur le territoire avant et apr??s le d??but du confinement : r??sultats provisoires???, https://www.insee.fr/fr/information/4477356

INSEE press release of May 18, ???Population pr??sente sur le territoire avant et apr??s le d??but du confinement : r??sultats consolid??s???, https://www.insee.fr/fr/information/4493611

[Que peut faire l???Insee ?? partir des donn??es de t??l??phonie mobile ? Mesures de population pr??sente en temps de confinement et statistiques exp??rimentales](https://blog.insee.fr/que-peut-faire-linsee-a-partir-des-donnees-de-telephonie-mobile-mesure-de-population-presente-en-temps-de-confinement-et-statistiques-experimentales/), billet de blog, Insee


# Dataviz: Mouvements de population autour du confinement de mars 2020.

[DataViz (:gb:)](https://inseefrlab.github.io/lockdown-maps-R/inflows_EN.html)
[DataViz (:fr:)](https://inseefrlab.github.io/lockdown-maps-R/inflows_FR.html)

Galiana et al. (2020) documentent les mouvements de population autour du confinement de mars 2020 ?? partir d'indicateurs anonymes issus de la t??l??phonie mobile fournis ?? l'Insee par trois op??rateurs de t??l??phonie mobile et que l'Insee a combin?? aux estimations annuelles de population. Pour compl??ter ces r??sultats, une seconde exploitation a ??t?? r??alis??e en partenariat avec CBS (Institut de Statistiques N??erlandais) permettant une visualisation fine des changements de population observ??s avant, et pendant, le premier confinement. Celle-ci offre la possibilit?? d???observer, de fa??on interactive et d??partement par d??partement, les changements observ??s (flux entrants et flux sortants). Les donn??es mobilis??es dans cette visualisation sont accessibles [ici](https://www.insee.fr/fr/statistiques/fichier/5350073/mouvements_population_confinement_2020_csv.zip).

## D??finitions

Les mouvements de population sont d??finis ici ?? partir du nombre de personnes pr??sentes en nuit??e dans un d??partement `d`, et r??sidant usuellement dans un d??partement `r`, respectivement avant et apr??s le confinement.

_D??partement de nuit??e_ : Il s'agit du d??partement de pr??sence en nuit??e ; un t??l??phone mobile est consid??r?? en nuit??e lorsqu???il appara??t stable g??ographiquement sur une p??riode de temps significative entre minuit et 6h du matin. Les indicateurs fournis par trois op??rateurs de comptage de t??l??phones mobile actifs sont combin??s et retrait??s par l'Insee.

_D??partement de r??sidence_ : Il s'agit du d??partement de r??sidence "usuelle", dont la d??finition peut varier d'un op??rateur ?? l'autre.

## M??thode et Source 

La m??thode d??crite dans Galiana et al. (2020) a ??t?? ??tendue ?? tous les couples d??partements de pr??sence, d??partement de r??sidence. Les sources sont d??crites dans Galiana et al. (2020). Les donn??es publi??es en mai fournissent une information en diff??rence qui restent la r??f??rence, et ventil??es pour les seuls r??sidents parisiens. 


## Donn??es 

T??l??chargement: 
[Donn??es agr??g??es publi??es en mai 2020](https://www.insee.fr/fr/statistiques/fichier/4635407/IA54_Donnees.xlsx): stays the reference for aggregates  
[Donn??es de la dataviz (donn??es exp??rimentales), publi??es en avril 2021](https://www.insee.fr/fr/statistiques/fichier/5350073/mouvements_population_confinement_2020_csv.zip): allows re-use by disseminating flows

Voir ??galement:  
[D??placements de population lors du confinement au printemps 2020 - Donn??es exp??rimentales - Bases de donn??es](https://insee.fr/fr/statistiques/5350073)

## Pr??cautions d'usage des donn??es

L???Insee consid??re ces r??sultats comme **exp??rimentaux**. Au m??me titre que dans Galiana et al. (2020), il faut souligner qu'il s'agit de statistiques exp??rimentales sujettes ?? des impr??cisions du fait du type de donn??es mobilis??es et de leurs incertitudes inh??rentes. De plus, ces nouvelles estimations r??alis??es au niveau de chaque couple d??partement de r??sidence, d??partement de pr??sence, sont publi??es arrondies ?? la centaine afin de permettre des r??-agr??gations comme celles permettant de d??ployer l???outil de visualisation. Il est cependant pr??f??rable d'interpr??ter les croisements et aggr??gations obtenues en arrondissant au millier de personnes. La m??thodologie retenue am??ne ?? tenir constante la population r??sidente pr??sente sur l'ensemble du territoire (et ??gale ?? la population r??sidente en France m??tropolitaine estim??e au 1er janvier 2021). Pour autant la pr??sence de valeurs manquantes et d'erreurs d'arrondis peut conduire ?? des l??g??res variations qui ne sont pas interpr??tables comme un fait statistique.

## Visualisation 

CBS [Statistics Netherlands](https://www.cbs.nl/en-gb) a r??alis?? l'outil de visualisation. Lien en anglais uniquement :  [More insight into mobility with the doughnut map (cbs.nl)](https://www.cbs.nl/en-gb/over-ons/innovation/project/more-insight-into-mobility-with-the-doughnut-map)  [NL Job Commuting Viz](https://dashboards.cbs.nl/v1/commutingNL/) 

## Comment citer ce travail ?

Suarez Castillo, M. et M. Tennekes, "Mouvements de population autour du confinement de mars 2020 - Data visualisations interactives", Insee & CBS, 2021, https://github.com/InseeFrLab/lockdown-maps-R

## R??f??rences

Galiana, L. Suarez Castillo, M., S??m??curbe, F. Coudin, E., de Bellefon, M.-P. (2020), "Retour partiel des mouvements de population avec le d??confinement", Insee Analyses N??54, INSEE

Tennekes, M. and Chen, M. (2021) Design Space of Origin-Destination Data Visualization. Forthcoming in Eurographics
Conference on Visualization (EuroVis) 2021

D??placements de population lors du confinement au printemps 2020 - Donn??es exp??rimentales - INSEE, https://insee.fr/fr/statistiques/5350073

INSEE press release of April 8, ???Population pr??sente sur le territoire avant et apr??s le d??but du confinement : r??sultats provisoires???, https://www.insee.fr/fr/information/4477356

INSEE press release of May 18, ???Population pr??sente sur le territoire avant et apr??s le d??but du confinement : r??sultats consolid??s???, https://www.insee.fr/fr/information/4493611

Que peut faire l???Insee ?? partir des donn??es de t??l??phonie mobile ? Mesures de population pr??sente en temps de confinement et statistiques exp??rimentales, billet de blog, Insee
