#!/bin/sh

echo "== Echoing cmd line arguments."

# Get the kernel parameters
params=`cat /proc/cmdline`
# Split them on spaces
params_split=(${params// / })
# Go through each of them
for p in "${params_split[@]}"; do
  # And if it's a key value pair
  if [[ $p =~ "=" ]]; then
    # And if the key doesn't have a period in it
    p_split=(${p//=/ })
    if [[ !($p_split[0] =~ ".") ]]; then
      # Then set the key to the value
      eval $p;
      echo $p
    fi;
  fi
done

