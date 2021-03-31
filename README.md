# Dataviz: Population Movements at Spring 2020 Lockdown in France

[![maps](https://github.com/InseeFrLab/lockdown-maps-R/workflows/maps/badge.svg)](https://github.com/InseeFrLab/lockdown-maps-R/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

[DataViz (:en:)](https://inseefrlab.github.io/lockdown-maps-R/inflows_EN.html)
[DataViz (:fr:)](https://inseefrlab.github.io/lockdown-maps-R/inflows_FR.html)

On the 17th of March 2020, France entered its first strict national lockdown in an effort to curb the covid-19 pandemic. Announced a few days before, the population had some leverage to choose where to spend the period. At this time, INSEE, the French national institutes, estimated that Paris lost about 450,000 metropolitan residents compared to 2020 first months, half of which were usual Paris residents. These population surpluses were broadly distributed across France. As a general stylized fact (Paris set aside), the population was closer to its usual residence during the lockdown: motives for overnight stays in other regions such as tourism, family visits or business trips were strongly restricted. For instance, the winter season ended abruptly in the Alps with the closing of ski resorts: seasonal workers and tourists left. These estimates were produced thanks to the partnerships with three Mobile Network Operators, which provided anonymous counts of nightly presence by usual residency. They were statistically adjusted and combined by INSEE [Galiana et al. (2020)](https://www.insee.fr/fr/statistiques/4635407).

One year after, a richer (though a bit more fragile) [dataset](LINK) was released by Insee based on the same method so as to allow visualization of aggregate overnight stays by residency - comparing the period before and after the lockdown. This dataset feeds the visualization tool built by CBS (the Dutch National Statistical Institute) and used for instance [here](http://www.mtennekes.nl/viz/commutingNL/v8/) on commuting data. This work was presented at the online seminar [__Big Data for timely statistics__](https://www.cbs.nl/en-gb/onze-diensten/unique-collaboration-for-big-data-research/big-data-matters-3-the-need-for-timely-statistics) on the 1st of April 2021.


## Some definitions

Population movements are defined by the number of persons spending the night in _département_ (NUTS3) `d` while being usual resident in _département_ `r`. For instance, Paris attracts a large number of people who are staying overnight for business, tourism or other reasons. These low-frequency ''flows'' are estimated on data of 3 mobile network operators (MNO) covering 16th of January to 16th of March 2020 on one hand (before lockdown) and 17th of March to 11th of May 2020 (during lockdown).

_Overnight Stay département_: For each MNO, a mobile phone is considered as staying overnight if it is stable geographically over a significant period between midnight and 6a.m.. Such counts - provided by usual place of residency - are combined and adjusted with Insee population counts to form three similar time series, one per each MNO.

_Residency département_ It is the _département_ of ''usual'' residency, whose definition may vary from one MNO to the other.

## Method

The method to construct population estimates before and during lockdown was described in  [Galiana et al. (2020)](https://www.insee.fr/fr/statistiques/4635407) (French only). It amounts to running a linear regression for each couple _département_ of residency cross _département_ of overnight stays `(d,r)` to smooth the three adjusted time series in a single average estimate of population before and after lockdown. This is done because the three series may disagree, and daily data are not sufficiently robust to change in mobile phone use or punctual absence of data for some regions.

## Data

### Download

[Aggregated Data, as published in May 2020](https://www.insee.fr/fr/statistiques/fichier/4635407/IA54_Donnees.xlsx): stays the reference for aggregates  

[Dataviz Data, as published in April 2021](https://insee.fr/fr/statistiques/fichier/5350073/mouvements_population_confinement_2020_csv.zip): allows re-use by disseminating flows

### Cautionary note

These two data sets are considered by Insee as **experimental**: the new data sources that constitute aggregated mobile phone data suffer a number of biases which were probably only partially adjusted. In addition, the second data set which feeds the dataviz is disseminated by rounded only at 100, to allow for re-use and aggregation such as these allowing to deploy the [visualisation](LINK). It is however recommended to interpret these numbers and aggregates made from them after rounding at 1,000 (as it is done for the visualisation). In addition, as not all couples of presence/residency `(d,r)` can be estimated (intermittent flows, not enough observations) and because there are irreductible rounding errors, the aggregates which were first published and estimated at a more aggregated level should stay the reference.

## Visualisation

CBS [Statistics Netherlands](https://www.cbs.nl/en-gb) has built the visualization tool.  [More insight into mobility with the doughnut map (cbs.nl)](https://www.cbs.nl/en-gb/over-ons/innovation/project/more-insight-into-mobility-with-the-doughnut-map)  

It was also applied to job communting in the NetherLands [NL Job Commuting Viz](https://dashboards.cbs.nl/v1/commutingNL/) 




To build the visualization from R: 
First make sure all the dependencies have been installed, for instance with the package `renv` which read `renv.lock`:
```
renv::init()
renv::restore()
```
The pipeline can be run with the `targets`: it builds the htmls files with the `_targets.R` workflow.

```
targets::tar_make()
```



## How to cite this work?

Suarez Castillo, M. and M. Tennekes, "Population Movements at Spring 2020 Lockdown in France - Interactive Data Visualizations", Insee & CBS, 2021, https://github.com/InseeFrLab/lockdown-maps-R

## References

Galiana, L. Suarez Castillo, M., Sémécurbe, F. Coudin, E., de Bellefon, M.-P. (2020), "Retour	partiel des mouvements de  population avec le déconfinement", Insee Analyses N°54, INSEE  
		
Tennekes, M. and Chen, M. (2021) Design Space of Origin-Destination Data Visualization.	Forthcoming in Eurographics <br> Conference on Visualization (EuroVis) 2021

[More insight into mobility with the doughnut map - Statistics Netherlands. cbs.nl](https://www.cbs.nl/en-gb/over-ons/innovation/project/more-insight-into-mobility-with-the-doughnut-map)  


Déplacements de population lors du confinement au printemps 2020 - Données expérimentales - INSEE, https://insee.fr/fr/statistiques/5350073

INSEE press release of April 8, “Population présente sur le territoire avant et après le début du confinement : résultats provisoires”, https://www.insee.fr/fr/information/4477356

INSEE press release of May 18, “Population présente sur le territoire avant et après le début du confinement : résultats consolidés”, https://www.insee.fr/fr/information/4493611

[Que peut faire l’Insee à partir des données de téléphonie mobile ? Mesures de population présente en temps de confinement et statistiques expérimentales](https://blog.insee.fr/que-peut-faire-linsee-a-partir-des-donnees-de-telephonie-mobile-mesure-de-population-presente-en-temps-de-confinement-et-statistiques-experimentales/), billet de blog, Insee


# Dataviz: Mouvements de population autour du confinement de mars 2020.

[DataViz (EN)](https://inseefrlab.github.io/lockdown-maps-r/inflows_EN.html)
[DataViz (FR)](https://inseefrlab.github.io/lockdown-maps-r/inflows_FR.html)

Galiana et al. (2020) documentent les mouvements de population autour du confinement de mars 2020 à partir d'indicateurs anonymes issus de la téléphonie mobile fournis à l'Insee par trois opérateurs de téléphonie mobile et que l'Insee a combiné aux estimations annuelles de population. Pour compléter ces résultats, une seconde exploitation a été réalisée en partenariat avec CBS (Institut de Statistiques Néerlandais) permettant une visualisation fine des changements de population observés avant, et pendant, le premier confinement. Celle-ci offre la possibilité d’observer, de façon interactive et département par département, les changements observés (flux entrants et flux sortants). Les données mobilisées dans cette visualisation sont accessibles [ici](LINK).

## Définitions

Les mouvements de population sont définis ici à partir du nombre de personnes présentes en nuitée dans un département `d`, et résidant usuellement dans un département `r`, respectivement avant et après le confinement.

_Département de nuitée_ : Il s'agit du département de présence en nuitée ; un téléphone mobile est considéré en nuitée lorsqu’il apparaît stable géographiquement sur une période de temps significative entre minuit et 6h du matin. Les indicateurs fournis par trois opérateurs de comptage de téléphones mobile actifs sont combinés et retraités par l'Insee.

_Département de résidence_ : Il s'agit du département de résidence "usuelle", dont la définition peut varier d'un opérateur à l'autre.

## Méthode et Source 

La méthode décrite dans Galiana et al. (2020) a été étendue à tous les couples départements de présence, département de résidence. Les sources sont décrites dans Galiana et al. (2020). Les données publiées en mai fournissent une information en différence qui restent la référence, et ventilées pour les seuls résidents parisiens. 


## Données 

Téléchargement: 
[Données agrégées publiées en mai 2020](https://www.insee.fr/fr/statistiques/fichier/4635407/IA54_Donnees.xlsx): stays the reference for aggregates
[Données de la dataviz (données expérimentales), publiées en avril 2021](https://previsualisation.insee.fr/fr/statistiques/fichier/5350073/mouvements_population_confinement_2020_csv.zip): allows re-use by disseminating flows

Voir également:  
[Déplacements de population lors du confinement au printemps 2020 - Données expérimentales - Bases de données](https://insee.fr/fr/statistiques/5350073)

## Précautions d'usage des données

L’Insee considère ces résultats comme **expérimentaux**. Au même titre que dans Galiana et al. (2020), il faut souligner qu'il s'agit de statistiques expérimentales sujettes à des imprécisions du fait du type de données mobilisées et de leurs incertitudes inhérentes. De plus, ces nouvelles estimations réalisées au niveau de chaque couple département de résidence, département de présence, sont publiées arrondies à la centaine afin de permettre des ré-agrégations comme celles permettant de déployer l’outil de visualisation. Il est cependant préférable d'interpréter les croisements et aggrégations obtenues en arrondissant au millier de personnes. La méthodologie retenue amène à tenir constante la population résidente présente sur l'ensemble du territoire (et égale à la population résidente en France métropolitaine estimée au 1er janvier 2021). Pour autant la présence de valeurs manquantes et d'erreurs d'arrondis peut conduire à des légères variations qui ne sont pas interprétables comme un fait statistique.

## Visualisation 

CBS [Statistics Netherlands](https://www.cbs.nl/en-gb) a réalisé l'outil de visualisation. Lien en anglais uniquement :  [More insight into mobility with the doughnut map (cbs.nl)](https://www.cbs.nl/en-gb/over-ons/innovation/project/more-insight-into-mobility-with-the-doughnut-map)  [NL Job Commuting Viz](https://dashboards.cbs.nl/v1/commutingNL/) 

## Comment citer ce travail ?

Suarez Castillo, M. et M. Tennekes, "Mouvements de population autour du confinement de mars 2020 - Data visualisations interactives", Insee & CBS, 2021, https://github.com/InseeFrLab/lockdown-maps-R

## Références

Galiana, L. Suarez Castillo, M., Sémécurbe, F. Coudin, E., de Bellefon, M.-P. (2020), "Retour partiel des mouvements de population avec le déconfinement", Insee Analyses N°54, INSEE

Tennekes, M. and Chen, M. (2021) Design Space of Origin-Destination Data Visualization. Forthcoming in Eurographics
Conference on Visualization (EuroVis) 2021

Déplacements de population lors du confinement au printemps 2020 - Données expérimentales - INSEE, https://insee.fr/fr/statistiques/5350073

INSEE press release of April 8, “Population présente sur le territoire avant et après le début du confinement : résultats provisoires”, https://www.insee.fr/fr/information/4477356

INSEE press release of May 18, “Population présente sur le territoire avant et après le début du confinement : résultats consolidés”, https://www.insee.fr/fr/information/4493611

Que peut faire l’Insee à partir des données de téléphonie mobile ? Mesures de population présente en temps de confinement et statistiques expérimentales, billet de blog, Insee
