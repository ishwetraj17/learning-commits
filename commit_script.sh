#!/bin/bash

# Total number of commits
total_commits=130
commit_count=0

# Function to get the max number of days in a month
get_max_day() {
  month=$1
  year=$2
  if [ "$month" == "02" ]; then
    if [ $((year % 4)) -eq 0 ]; then
      echo 29
    else
      echo 28
    fi
  elif [[ "$month" == "04" || "$month" == "06" || "$month" == "09" || "$month" == "11" ]]; then
    echo 30
  else
    echo 31
  fi
}

# Loop through years and months within the desired date range
for year in {2023..2025}
do
  if [ "$year" -eq "2025" ]; then
    months=$(seq -w 1 1)  # Only use January of 2025
  else
    months=$(seq -w 1 12)  # Use all months in 2023 and 2024
  fi

  for month in $months
  do
    # Only use months from January 2023 to January 2025
    if [ "$year" -eq "2023" ] && [ "$month" -lt "01" ]; then
      continue
    fi
    if [ "$year" -eq "2025" ] && [ "$month" -gt "01" ]; then
      continue
    fi

    max_day=$(get_max_day $month $year)
    
    # Select random days for commits in this month
    days_to_commit=$((RANDOM % max_day + 1))
    days=$(shuf -i 1-$max_day -n $days_to_commit)

    # Loop over each randomly selected day
    for day in $days
    do
      if [ "$commit_count" -ge "$total_commits" ]; then
        break 2
      fi

      formatted_day=$(printf '%02d' $day)
      echo "Contribution on $year-$month-$formatted_day" > file.txt
      git add file.txt
      GIT_AUTHOR_DATE="$year-$month-$formatted_day"T12:00:00" \
      GIT_COMMITTER_DATE="$year-$month-$formatted_day"T12:00:00" \
      git commit -m "Contribution on $year-$month-$formatted_day"

      commit_count=$((commit_count + 1))
    done
  done
done

echo "Total commits made: $commit_count"

