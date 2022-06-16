if ! (git diff --exit-code origin/master..master > /dev/null) \
  || ! (git diff --exit-code master > /dev/null) \
  || ! [[ -z "$(git status --porcelain)" ]] ; then
  echo "Your local repo has some changes that aren't pushed to origin/master ."
  exit 1
fi