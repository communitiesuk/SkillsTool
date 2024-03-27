analyst_data <- read_excel("Q:\\RAP WG\\Analyst survey\\RAP_Analyst_Survey.xlsx")

analyst_data <- analyst_data[, 1:71]

colnames(analyst_data) <- gsub("Rate your (.*) capability", "\\1", colnames(analyst_data))

analyst_data <- analyst_data %>%
  rename(Team = "What Team are you in?")


start_column_index <- 6

analyst_data <- analyst_data %>%
  mutate_at(vars(start_column_index:ncol(analyst_data)),
            ~case_when(. == "Advanced" ~ "5 - Advanced",
                       . == "Proficient" ~ "4 - Proficient",
                       . == "Basic" ~ "3 - Basic",
                       . == "Limited" ~ "2 - Limited",
                       TRUE ~ as.character(.)))

save(analyst_data,file="data/analyst_data.rda")
