# Projet de compilation - Custom C Compiler

**Equipe 33**
Do Nicolas
Lamhamdi Aymane

Le but du projet est de réaliser un compilateur d'un mini langage appelé Myc vers une variante du PCode.

Dans ce projet, nous avons traiter tous les points du sujet, c'est à dire ;
   -  Calcul d'expressions arithmétiques arbitraires
   -  Déclaration, affectations et réutilisations de variables entières
   -  Conditionnelles (if,et if-else)
   -  Itérateur (while)
   -  Mecanisme de sous-blocs avec déclarations locales et les problèmes de visibilités et de masquages associés
   -  Fonctions à la C avec paramètres entiers et vérification des nombres arguments
   -  Traitement des fonctions récursives



Pour compiler le compilateur en un executable `myc` :
```
make
```

Pour compiler un fichier myc (<filename>.myc) en un fichier pcode (<filename>.c) et un executable (<filename>) issu de la compilation de ce fichier pcode :
```
./compil <filename>.myc
```

Pour compiler tous les tests du projet :
```
make alltest
```

Pour compiler les tests correspond à une partie du projet :
```
make test<numeroDeLaPartie>
```

Pour compiler un test en particulier :
```
make test<numeroDeTest>
```

Pour creer tous les executables des tests du projets :
```
make allexec
```

Pour creer tous les executables des tests correspond à une partie du projet :
```
make exec<numeroDeLaPartie>
```

Pour creer un executable d'un test en particuler :
```
make exec<numeroDeTest>
```


