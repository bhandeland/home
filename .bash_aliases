function listinstances() {
  if [ -z $1 ]; then
    echo "you must supply an aws profile name to this function"
    exit 1
  fi
  aws ec2 --profile $1 describe-instances --query 'Reservations[].Instances[].[PrivateIpAddress,Tags[?Key==`Name`].Value[],Placement.AvailabilityZone,InstanceType,State.Name]' --output text | sed '$!N;s/\n/ /'
}


function git_find_file() {
  if [ -z $1 ]; then
          echo "you must supply a file to search for"
          exit 1
  fi
  file=$(git log --all -- $1)
  echo $file
}

function git_search_all_branches() {
  if [ -z $1 ]; then
          echo "you must supply a regexp to search for"
          exit 1
  fi

  for branch in `git for-each-ref --format="%(refname)" $LOC`; do
    found=$(git ls-tree -r --name-only $branch | grep "$1")
      if [ $? -eq 0 ]; then
          echo ${branch#$LOC/}:; echo "  $found"
      fi
  done
}
