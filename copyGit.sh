#Origin
$ git clone <origin repo>
$ cd <origin directory>
$ git remote rm origin
$ git filter-branch --subdirectory-filter ./ -- --all
$ git add .
$ git commit
$ pwd

#Target
$ git clone <target repo>
$ cd <target directory>
$ git remote add origin-repo <origin directory>
$ git pull origin-repo master
$ git remote rm origin-repo
$ git push

