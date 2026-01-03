library(rvest)
library(dplyr)
library(stringr)
library(hoopR)
library(jsonlite)

source("conference_lookup.R")

mbb_teams_espn <- espn_mbb_teams()  # No year parameter
mbb_teams <- mbb_teams_espn %>% select(display_name, mascot, team_id)

mbb_teams$Teamnm <- ""
for (i in 1:length(mbb_teams$mascot)) {  
  mascot_length <- nchar(mbb_teams$mascot[i])
  display_length <- nchar(mbb_teams$display_name[i])
  mbb_teams$Teamnm[i] <- str_sub(mbb_teams$display_name[i], 1, display_length - mascot_length)
}

mbb_teams <- mbb_teams %>% select(display_name, Teamnm, team_id)
extra_teams <- data.frame(
  display_name = c("Lindenwood Lions", "Queens University Royals", "Southern Indiana Screaming Eagles"),
  Teamnm = c("Lindenwood", "Queens University", "Southern Indiana"),
  team_id = c(2815, 2511, 88)
)

mbb_teams <- rbind(mbb_teams, extra_teams)
mbb_teams <- mbb_teams %>% rename(Team = display_name, ID = team_id)
mbb_teams <- merge(mbb_teams, conference_lookup, by.x = "Team", by.y = "Team", all.x = TRUE)

espn_teams_url <- read_html("https://www.espn.com/mens-college-basketball/standings")
espn_teams_tibble <- espn_teams_url %>% html_nodes("table") %>% html_table(fill = TRUE)

espn_teams <- data.frame(matrix(nrow = nrow(espn_teams_tibble[[1]]) - 1, ncol = ncol(espn_teams_tibble[[2]]) + 1))

for (i in seq(1, 61, by = 2)) {
  conference <- data.frame(matrix(nrow = nrow(espn_teams_tibble[[i]]) - 1, ncol = ncol(espn_teams_tibble[[i + 1]]) + 1))
  conference_teams <- as.data.frame(espn_teams_tibble[[i]][-1, ])
  colnames(conference_teams) <- c("Team")
  conference_stats <- as.data.frame(espn_teams_tibble[[i + 1]][-1, ])
  colnames(conference_stats) <- espn_teams_tibble[[i + 1]][1, , drop = FALSE]
  colnames(conference_stats)[colnames(conference_stats) == "W-L"][1] <- "CONFW-L"
  colnames(conference_stats)[colnames(conference_stats) == "PCT"][1] <- "CONFPCT"
  conference <- cbind(conference_teams, conference_stats)
  if (i == 1) {espn_teams <- conference}
  else {espn_teams <- rbind(espn_teams, conference)}
}

lowercase <- c('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z')
for (i in 1:length(espn_teams$Team)) {
  str <- espn_teams$Team[i]
  if (grepl("^[0-9]+", str)) {
    str <- str_sub(str, regexpr("[A-Za-z]", str), nchar(str))
    espn_teams$Team[i] <- str
  }
  if (str_sub(str, 3, 3) %in% lowercase) {espn_teams$Team[i] <- str_sub(str, 2, nchar(str))}
  else if (str_sub(str, 4, 4) %in% lowercase) {espn_teams$Team[i] <- str_sub(str, 3, nchar(str))}
  else if (str_sub(str, 5, 5) %in% lowercase) {espn_teams$Team[i] <- str_sub(str, 4, nchar(str))}
  else if (str_sub(str, 6, 6) %in% lowercase) {espn_teams$Team[i] <- str_sub(str, 5, nchar(str))}
  else if (str_sub(str, 1, 3) == str_sub(str, 4, 6)) {espn_teams$Team[i] <- str_sub(str, 4, nchar(str))}
  else if (str_sub(str, 1, 4) == str_sub(str, 5, 8)) {espn_teams$Team[i] <- str_sub(str, 5, nchar(str))}
  else if (str_sub(str, 1, 2) == str_sub(str, 5, 6)) {espn_teams$Team[i] <- str_sub(str, 5, nchar(str))}
  else if (str_sub(str, 1, 2) == str_sub(str, 4, 5)) {espn_teams$Team[i] <- str_sub(str, 4, nchar(str))}
  if (espn_teams$Team[i] == "CONNUConn Huskies") {espn_teams$Team[i] <- "UConn Huskies"}
  if (espn_teams$Team[i] == "RGVUT Rio Grande Valley Vaqueros") {espn_teams$Team[i] <- "UT Rio Grande Valley Vaqueros"}
  if (espn_teams$Team[i] == "Mass Lowell River Hawks") {espn_teams$Team[i] <- "UMass Lowell River Hawks"}
  if (espn_teams$Team[i] == "Albany Great Danes") {espn_teams$Team[i] <- "UAlbany Great Danes"}
}

espn_teams <- merge(espn_teams, mbb_teams, by = "Team", all.x = TRUE)
espn_teams$PCT <- as.numeric(espn_teams$PCT)
espn_teams <- espn_teams %>% select(Teamnm, everything(), -Team) %>% rename(Team = Teamnm)

all_players <- data.frame()

for (i in 1:nrow(espn_teams)) {
  team_id <- espn_teams$ID[i]
  team_name <- espn_teams$Team[i]
  
  # Progress indicator every 50 teams
  if (i %% 50 == 0) {
    cat(sprintf("Progress: %d/%d (%.1f%%) - %d players\n", i, nrow(espn_teams), i/nrow(espn_teams)*100, nrow(all_players)))
  }
  
  tryCatch({
    team_stats_url <- read_html(paste0("https://www.espn.com/mens-college-basketball/team/stats/_/id/", as.character(team_id)))
    team_stats_tibble <- team_stats_url %>% html_nodes("table") %>% html_table(fill = TRUE)
    
    roster_url <- read_html(paste0("https://www.espn.com/mens-college-basketball/team/roster/_/id/", as.character(team_id)))
    roster_tibble <- roster_url %>% html_nodes("table") %>% html_table(fill = TRUE)
    
    if (length(team_stats_tibble) >= 2) {
      team_stats <- as.data.frame(team_stats_tibble[[2]])
      team_players <- as.data.frame(team_stats_tibble[[1]])
      team_stats$Name <- team_players$Name
      team_stats <- team_stats[team_stats$Name != "Total", ]
      team_stats$POS <- substr(team_stats$Name, nchar(team_stats$Name), nchar(team_stats$Name))
      team_stats$Name <- substr(team_stats$Name, 1, nchar(team_stats$Name) - 2)
      team_stats$Class <- NA
      team_stats$HT <- NA
      team_stats$WT <- NA
      if (length(roster_tibble) >= 1) {
        roster <- as.data.frame(roster_tibble[[1]])
        roster$CleanName <- gsub("[0-9]+$", "", roster$Name)
        for (j in 1:nrow(team_stats)) {
          player_name <- team_stats$Name[j]
          roster_match <- which(roster$CleanName == player_name)
          if (length(roster_match) > 0) {
            if ("Class" %in% names(roster)) team_stats$Class[j] <- roster$Class[roster_match[1]]
            if ("HT" %in% names(roster)) team_stats$HT[j] <- roster$HT[roster_match[1]]
            if ("WT" %in% names(roster)) team_stats$WT[j] <- roster$WT[roster_match[1]]
          }
        }
      }
      # Use trimws to fix school names for both regular and manual teams
      team_stats$School <- trimws(team_name)
      team_stats$Conference <- espn_teams$Conference[i]
      team_stats$Record <- espn_teams$`W-L`[i]
      
      # Format stats: PG stats to 0.0 if blank, percentages already as numbers
      team_stats$MIN <- ifelse(is.na(team_stats$MIN) | team_stats$MIN == "", 0, as.numeric(team_stats$MIN))
      team_stats$PTS <- ifelse(is.na(team_stats$PTS) | team_stats$PTS == "", 0, as.numeric(team_stats$PTS))
      team_stats$REB <- ifelse(is.na(team_stats$REB) | team_stats$REB == "", 0, as.numeric(team_stats$REB))
      team_stats$AST <- ifelse(is.na(team_stats$AST) | team_stats$AST == "", 0, as.numeric(team_stats$AST))
      team_stats$STL <- ifelse(is.na(team_stats$STL) | team_stats$STL == "", 0, as.numeric(team_stats$STL))
      team_stats$BLK <- ifelse(is.na(team_stats$BLK) | team_stats$BLK == "", 0, as.numeric(team_stats$BLK))
      team_stats$TO <- ifelse(is.na(team_stats$TO) | team_stats$TO == "", 0, as.numeric(team_stats$TO))
      
      # Percentages - keep as is (already numeric from ESPN)
      team_stats$`FG%` <- ifelse(is.na(team_stats$`FG%`) | team_stats$`FG%` == "", NA, as.numeric(team_stats$`FG%`))
      team_stats$`3P%` <- ifelse(is.na(team_stats$`3P%`) | team_stats$`3P%` == "", NA, as.numeric(team_stats$`3P%`))
      team_stats$`FT%` <- ifelse(is.na(team_stats$`FT%`) | team_stats$`FT%` == "", NA, as.numeric(team_stats$`FT%`))
      
      team_stats <- team_stats %>% select(Name, POS, Class, HT, WT, School, Conference, Record, GP, MIN, PTS, REB, AST, STL, BLK, TO, `FG%`, `FT%`, `3P%`) %>%
        rename(Height = HT, Weight = WT, PPG = PTS, RPG = REB, APG = AST, SPG = STL, BPG = BLK, TOPG = TO)
      
      all_players <- bind_rows(all_players, team_stats)
    }
  }, error = function(e) {
    cat(sprintf("ERROR on team %s (%d): %s\n", team_name, team_id, e$message))
  })
  
  Sys.sleep(0.5)
}

# Add manual players (these will persist through daily updates)
manual_players <- data.frame(
  Name = c("Tyler Nelson"),
  POS = c("F"),
  Class = c("SR"),
  Height = c("6' 6\""),
  Weight = c("220 lbs"),
  School = c("Navy 22-23"),
  Conference = c("Patriot"),
  Record = c("18-13"),
  GP = c(31),
  MIN = c(30.4),
  PPG = c(12.4),
  RPG = c(5.9),
  APG = c(1.7),
  SPG = c(1.1),
  BPG = c(1.0),
  TOPG = c(0.9),
  `FG%` = c(44.5),
  `FT%` = c(70.6),
  `3P%` = c(36.2),
  stringsAsFactors = FALSE
)

# Combine manual players with scraped players
all_players <- bind_rows(all_players, manual_players)

# Filter out invalid entries
all_players <- all_players %>% filter(!is.na(Name))

# Add playerIds to everyone at once
all_players$playerId <- paste0(gsub(" ", "_", all_players$Name), "_", gsub(" ", "_", all_players$School))

# Remove any invalid playerIds
all_players <- all_players %>% filter(!is.na(playerId) & playerId != "_")

# Save to JSON
write_json(all_players, "player_stats.json", pretty = TRUE)

cat(sprintf("\nFINAL: Collected %d players from %d teams + %d manual players\n", 
            nrow(all_players), nrow(espn_teams), nrow(manual_players)))
