#!/bin/bash

git log data/liste_deputes_collaborateurs.csv  | grep -B 100000 0257cc23296952862232f1e941635259e3df675a | grep commit | sed 's/commit //'  > data/turnover-collab.commits.csv.tmp

PREVIOUSCOMMIT=$(tail -n 1 data/turnover-collab.commits.csv.tmp);
tac data/turnover-collab.commits.csv.tmp | while read COMMIT ; do
        DATECOMMIT=$(git log $COMMIT  | grep Date: | head -n 1 | sed 's/Date: *//' )
	git diff $PREVIOUSCOMMIT $COMMIT data/liste_deputes_collaborateurs.csv | grep '^[-+]"' | sed 's/^\+/"AJOUT",/' | sed 's/^-/"SUPPRESSION",/' | sed "s/$/,\"$DATECOMMIT\"/"
	PREVIOUSCOMMIT=$COMMIT 
done > data/turnover-collab.ajoutsuppression.csv.tmp

python bin/collab_mouvements.py data/turnover-collab.ajoutsuppression.csv.tmp
