Bonnes pratiques Opquast illustrées
===================================

Projet d’illustration de la [check-list de référence qualité web d’Opquast](https://checklists.opquast.com/fr/qualiteweb/).

But du projet
-------------

Fournir un document PDF des 240 bonnes pratiques qualité web d’Opquast, chacune étant accompagnée d’une illustration permettant de mieux visualiser son application.

Objectifs du projet
-------------------

Ce projet vise les objectifs suivants :

- une bonne pratique, un schéma, une page,
- document le plus léger possible,
- uniquement des dessins et schémas vectoriels (pas de bitmap),
- utilisation de logiciels libres,
- diffusion sous licence libre.

Aspects techniques
------------------

### Logiciels utilisés/nécessaires

Le fichier [bonnes-pratiques.pdf](bonnes-pratiques.pdf) est généré à partir d’un export du document [bonnes-pratiques.odp](bonnes-pratiques.odp).

Le fichier [bonnes-pratiques.odp](bonnes-pratiques.odp) a été créé avec LibreOffice Impress 6.4. Il utilise exclusivement la [police IBM Plex](https://www.ibm.com/plex/) sous [licence SIL Open Font](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL_web).

Les illustrations utilisées sont au format SVG et sont traitées par Inkscape. Elles utilisent exclusivement la police IBM Plex.

### Génération des illustrations au format SVG

Pour générer des illustrations au format SVG, ce projet utilise des fichiers HTML.

Processus de conversion HTML en SVG :

- ouverture du HTML dans un navigateur (Firefox ou Chrome),
- impression dans un PDF,
- conversion du PDF en SVG (Inkscape),
- suppression du fond (XSLT),
- rognage automatique (Inkscape),
- optimisation du SVG (XSLT).

Ce processus permet de transformer une page web en SVG tout en conservant les textes et polices de la page HTML source.

Le script Bash [html2svg.bash](good-site-bad-site/html2svg.bash) a été développé pour automatiser cette conversion.

Il utilise les logiciels suivants :

- Firefox ou Chrome,
- Inkscape,
- XSLTProc,
- [XSLClearer](https://github.com/Zigazou/xslclearer).

Licence
-------

Ce travail est fourni sous [licence Creative Commons CC BY-NC-SA 3.0](https://creativecommons.org/licenses/by-nc-sa/3.0/fr/).