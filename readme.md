# Dataviz: Mouvements de population autour du confinement de mars 2020.

**XX Lien vers la visualisation XX**

[Galiana et al. (2020)](https://www.insee.fr/fr/statistiques/4635407) documentent les mouvements de population autour du confinement de mars 2020 à partir d'indicateurs anonymes issus de la téléphonie mobile fournis à l'Insee par trois opérateurs de téléphonie mobile et que l'Insee a combiné aux estimations annuelles de population. Pour compléter ces résultats, une seconde exploitation a été réalisée en partenariat avec CBS (Institut de Statistiques Néerlandais) permettant une visualisation fine des changements de population observés avant, et pendant, le premier confinement. Celle-ci offre la possibilité d’observer, de façon interactive et département par département, les changements observés (flux entrants et flux sortants). Les données mobilisées dans cette visualisation sont accessibles **XX ici XX.** 

## Définitions

Les mouvements de population sont définis ici à partir du nombre de personnes présentes en nuitée dans un département A, et résidant usuellement dans un département B, respectivement avant et après le confinement. 

_Département de nuitée:_ Il s'agit du département de présence en nuitée: un téléphone mobile est considéré en nuitée lorsqu’il apparaît stable géographiquement sur une période de temps significative entre
minuit et 6h du matin. Les indicateurs fournis par trois opérateurs de comptages de téléphones mobile actifs sont combinés et retraités par l'Insee.

_Département de résidence:_ Il s'agit du département de résidence ``usuelle'', dont la définition peut varier d'un opérateur à l'autre. 

## Méthode

La méthode décrite dans  [Galiana et al. (2020)](https://www.insee.fr/fr/statistiques/4635407) a été étendue à tout les couples départements de présence, département de résidence. 

## Source

Les sources sont décrites dans [Galiana et al. (2020)](https://www.insee.fr/fr/statistiques/4635407). Les [données publiées en mai](https://www.insee.fr/fr/statistiques/fichier/4635407/IA54_Donnees.xlsx) 
fournissent une information en différence qui restent la référence, et ventilés pour les seuls résidents Parisiens. **XXX Lien nouvelles données XXX**

## Précautions d'usage des données
L’Insee considère ces résultats comme expérimentaux. Au même titre que dans Galiana et al. (2020), il faut souligner qu'il s'agit de statistiques expérimentales sujettes à des imprécisions du fait du type de données mobilisées et de leurs incertitudes inhérentes. De plus, ces nouvelles estimations réalisées au niveau de chaque couple département de résidence, département de présence, sont publiées arrondies à la centaine afin de permettre des ré-agrégations comme celles permettant de déployer l’outil de visualisation. Il est cependant préférable d'interpréter les croisements et aggréations obtenues en arrondissant au milier de personnes. La méthodologie retenue amène à tenir constante la population résidente présente sur l'ensemble du territoire (et égale à la population résidente en France métropolitaine estimée au 1er janvier 2021). Pour autant la présence de valeurs manquantes et d'erreurs d'arrondis peut conduire à des légères variations qui ne sont pas interprétables comme un fait statistique.


CBS a réalisé l'outil de visualisation. **XX Lien vers la visualisation néerlandaise XX**

## Références

Galiana, L. Suarez Castillo, M., Sémécurbe, F. Coudin, E., de Bellefon, M.-P. (2020), "Retour	partiel des mouvements de  population avec le déconfinement", Insee Analyses N°54, INSEE  
		
Tennekes, M. and Chen, M. (2021) Design Space of Origin-Destination Data Visualization.	Forthcoming in Eurographics <br> Conference on Visualization (EuroVis) 2021

[Que peut faire l’Insee à partir des données de téléphonie mobile ? Mesures de population présente en temps de confinement et statistiques expérimentales](https://blog.insee.fr/que-peut-faire-linsee-a-partir-des-donnees-de-telephonie-mobile-mesure-de-population-presente-en-temps-de-confinement-et-statistiques-experimentales/), billet de blog, Insee


