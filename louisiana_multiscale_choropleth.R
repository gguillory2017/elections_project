library(ggplot2)
library(sf)
library(data.table)
library(geojsonsf)
library(ggnewscale)

setwd("C:/Users/Alex/Desktop/elections_project")

#Setting up Georgia state map geometry
us_map_sf <- geojson_sf("state_shapes_500k.json")
georgia_map_sf <- subset(us_map_sf, STATE=="22")
names(georgia_map_sf) <- c("Total land area (sq mi)", "LSAD code", "GEO_ID", "County", "County code", "State code", "geometry")


#Load raw 2020 data, subset to Georgia
raw_2020_data <- read.csv("raw_data/2020_election/president_county_candidate.csv")
georgia_2020_raw <- subset(raw_2020_data, state == "Louisiana")


#Create empty data frame, and names 
total_votes_by_county <- data.frame(State=character(), County=character(), 
                                    TotalVotes=integer(), CandidateVotes=integer(), 
                                    VoteRatio=numeric(), CandidateName=character(),
                                    CandidateParty=character())

#Renaming dataframe to have nicer names
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
  state_name <- "Louisiana"
  winner_total <- winner_row$total_votes
  winner_name <- winner_row$candidate
  winner_party <- winner_row$party
  winner_ratio <- winner_total/vote_total
  county_name <- gsub(" Parish", "", county_x)
  temp_df <- data.frame(state_name,county_name,vote_total,winner_total,winner_ratio,winner_name,winner_party)
  names(temp_df) <- final_names
  total_votes_by_county <- rbind(temp_df, total_votes_by_county)
}

combined_df <- merge(georgia_map_sf, total_votes_by_county)
trump_df <- subset(combined_df, `Name of winning candidate` == "Donald Trump")
biden_df <- subset(combined_df, `Name of winning candidate` == "Joe Biden")

combined_map <- ggplot() +
  geom_sf(data = trump_df, aes(fill = `Percentage of votes for winning candiate`)) +
  scale_fill_gradient(low="pink",high="darkred", name="Percentage of popular vote for Trump") +
  new_scale("fill") +
  geom_sf(data=biden_df, inherit.aes = FALSE,
          aes(fill = `Percentage of votes for winning candiate`)) +
  scale_fill_gradient(low="skyblue",high="darkblue",name="Percentage of popular vote for Biden") +
  xlab("Longitude") +
  ylab("Latitude") +
  ggtitle("State of Louisiana", subtitle = "2020 US presidential race\nPercentage of popular vote by winner in each county")

print(combined_map)

print("completed")

