if ! (git diff --exit-code origin/main..main > /dev/null) \
  || ! (git diff --exit-code main > /dev/null) \
  || ! [[ -z "$(git status --porcelain)" ]] ; then
  echo "Your local repo has some changes that aren't pushed to origin/master ."
  exit 1
fi