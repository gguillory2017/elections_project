library(geojsonio)


#Load raw 2020 data, subset to Georgia
raw_2020_data <- read.csv("raw_data/2020_election/president_county_candidate.csv")
georgia_2020_raw <- subset(raw_2020_data, state == "Georgia")

#Create empty data frame, and names 
total_votes_by_county <- data.frame(State=character(), County=character(), 
                                    TotalVotes=integer(), CandidateVotes=integer(), 
                                    VoteRatio=numeric(), CandidateName=character(),
                                    CandidateParty=character())
state="State"
county="County"
total_votes="Total votes in county"
candidate_votes="Number of votes for winning candidate"
vote_ratio="Percentage of votes for winning candiate"
name_of_winning_candidate="Name of winning candidate"
winning_candidate_party="Party of winning candidate"
final_names <- c(state, county, total_votes, candidate_votes, vote_ratio, name_of_winning_candidate,
                 winning_candidate_party)
names(total_votes_by_county) <- final_names

#Iterate over unique counties, form rows of new table and bind them together
for (county_x in unique(georgia_2020_raw$county)){
  county_df <- subset(georgia_2020_raw, county==county_x)
  winner_row <- subset(county_df, county_df$won == "True")
  vote_total <- sum(county_df$total_votes)
  state_name <- "Georgia"
  winner_total <- winner_row$total_votes
  winner_name <- winner_row$candidate
  winner_party <- winner_row$party
  winner_ratio <- winner_total/vote_total
  temp_df <- data.frame(state_name,county_x,vote_total,winner_total,winner_ratio,winner_name,winner_party)
  names(temp_df) <- final_names
  total_votes_by_county <- rbind(temp_df, total_votes_by_county)
}