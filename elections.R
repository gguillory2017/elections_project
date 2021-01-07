#Load raw 2020 data
raw_2020_data <- read.csv("raw_data/2020_election/president_county_candidate.csv")
georgia_2020_raw <- subset(raw_2020_data, state == "Georgia")

total_votes_by_county <- data.frame(State=character(), County=character(), TotalVotes=integer())
final_names <- c("State", "County", "Total votes in county")
names(total_votes_by_county) <- final_names


for (county_x in unique(georgia_2020_raw$county)){
  temp_df <- data.frame("Georgia", county_x, sum(subset(georgia_2020_raw, county == county_x)$total_votes))
  names(temp_df) <- final_names
  total_votes_by_county <- rbind(temp_df, total_votes_by_county)
}