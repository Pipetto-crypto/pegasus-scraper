# Change author details in all old commits.
# WARNING: Will change all your commit SHA1s.
#!/bin/sh
 
git filter-branch --env-filter '
 
an="$GIT_AUTHOR_NAME"
am="$GIT_AUTHOR_EMAIL"
cn="$GIT_COMMITTER_NAME"
cm="$GIT_COMMITTER_EMAIL"
 
if [ "$GIT_COMMITTER_EMAIL" = "your@email.to.match" ]
then
cn="Pipetto-crypto"
cm="Your New Committer Email"
fi
if [ "$GIT_AUTHOR_EMAIL" = "your@email.to.match" ]
then
an="Your New Author Name"
am="Your New Author Email"
fi
 
export GIT_AUTHOR_NAME=$an
export GIT_AUTHOR_EMAIL=$am
export GIT_COMMITTER_NAME=$cn
export GIT_COMMITTER_EMAIL=$cm
'

# after this, push the repository
# git push origin master --force

# if something goes wrong, remove the last commit
# git push -f origin HEAD^:master
