
kakao <- read.csv("kakao_all.csv", header = TRUE)

#Right skewed
hist(kakao$t_kakao_talk)
hist(kakao$t_kakao_story)

str(kakao)
install.packages("MatchIt")
library(MatchIt)


kakao$age <- as.factor(kakao$age)
kakao$income <- as.factor(kakao$income)
kakao$education<-as.factor(kakao$education)
kakao$gender <- as.factor(kakao$gender)

new.dat = subset(kakao,week == 1)



#The Loop for PSM

ratios <- c(1, 2, 3)
replacements <- c(TRUE, FALSE)
calipers <- c(0.05, 0.1, 0.2, 0.25)

param_grid <- expand.grid(ratio = ratios, replace = replacements, caliper = calipers)
param_grid <- param_grid[c(1:3, 6, 9, 12, 15, 18, 21, 24), ]  # Select the 10 combinations

for (i in 1:10) {
  
  r <- param_grid$ratio[i]
  repl <- param_grid$replace[i]
  c <- param_grid$caliper[i]
  
  match.out <- matchit(tg ~ age + income + education + gender + 
                         t_non_kakao + n_non_kakao + t_kakao_talk + 
                         t_kakao_story, # Exclude variables that are all zero in week 1
                       data = new.dat, method = "nearest", 
                       ratio = r, replace = repl, caliper = c)
  
  assign(paste0("match.out", i), match.out)
  
  m.dat <- get_matches(match.out)
  id.dat <- m.dat[c("panel_id", "weights")]
  
  final.kakao <- merge(kakao, id.dat, by = "panel_id")
  
  assign(paste0("final.kakao", i), final.kakao)
}


plot(match.out1, type = "hist")
plot(match.out2, type = "hist")

summary_list <- list()

#Evaluate each matching
for (i in 1:10) {
  
  match_obj <- get(paste0("match.out", i))
  summ <- summary(match_obj, standardize = TRUE)
  
  treated <- summ$nn["Matched", "Treated"]
  control <- summ$nn["Matched", "Control"]
  
  mean_diff <- summ$sum.matched["distance", "Std. Mean Diff."]
  var_ratio <- summ$sum.matched["distance", "Var. Ratio"]
  
  row <- data.frame(
    Match_ID = i,
    Treated = treated,
    Control = control,
    Mean_Diff_Distance = mean_diff,
    Var_Ratio_Distance = var_ratio
  )
  
  summary_list[[i]] <- row
}

# generate a table
summary_table <- do.call(rbind, summary_list)
print(summary_table)
summary_table$Mean_Diff_Distance <- round(summary_table$Mean_Diff_Distance, 2)
summary_table$Var_Ratio_Distance <- round(summary_table$Var_Ratio_Distance, 2)


#TALK DUMMY
summary(lm(log(t_kakao_talk+1) ~ as.factor(panel_id) + as.factor(week) + ii + t_kakao_story + t_kakao_game
           + t_non_kakao, 
           data = final.kakao4, weights = weights))
library(car)

cor(final.kakao$n_kakao_game, final.kakao$t_kakao_game)
cor(final.kakao$n_non_kakao, final.kakao$t_non_kakao)


model_list <- list()
summary_list <- list()

for (i in 1:10) {
  data_i <- get(paste0("final.kakao", i))
  
  model <- lm(log(t_kakao_talk + 1) ~ as.factor(panel_id) + as.factor(week) + ii + t_kakao_story + t_kakao_game
              + t_non_kakao,
              data = data_i, weights = weights)
  
  assign(paste0("lm_dummy_", i), model)
  
  model_list[[i]] <- model
  
  s <- summary(model)
  coef_df <- as.data.frame(coef(s))
  
  subset_coef <- coef_df[grepl("^ii$|^as.factor\\(week\\)|^t_non_kakao$|^t_kakao_story$|^t_kakao_game$", rownames(coef_df)), ]
  subset_coef$Variable <- rownames(subset_coef)
  subset_coef$Match_ID <- i
  
  summary_list[[i]] <- subset_coef[, c("Match_ID", "Variable", "Estimate", "Pr(>|t|)")]
}

regression_summary <- do.call(rbind, summary_list)
rownames(regression_summary) <- NULL

regression_summary <- regression_summary[, c("Match_ID", "Variable", "Estimate", "Pr(>|t|)")]

print(regression_summary)



#TALK FIXED EFFECT 
#Replacement=FALSE:6, 12, 18, 24 (4,6,7,10)
install.packages("plm")
library(plm)

summary(plm(formula = log(t_kakao_talk+1) ~ as.factor(week) + ii + t_kakao_story + t_kakao_game
            + t_non_kakao, 
            data = final.kakao4, model = "within"))


plm_model_list <- list()
plm_summary_list <- list()

for (i in c(4,6,8,10)) {
  data_i <- get(paste0("final.kakao", i))
  
  pdata_i <- pdata.frame(data_i, index = c("panel_id", "week"))
  
  model <- plm(log(t_kakao_talk + 1) ~ as.factor(week) + ii + age + income + education + gender +
                 t_non_kakao,
               data = pdata_i, model = "within", weights = pdata_i$weights)

  assign(paste0("plm_dummy_", i), model)
  plm_model_list[[i]] <- model
  
  s <- summary(model)
  coef_df <- as.data.frame(s$coefficients)
  
  subset_coef <- coef_df[grepl("^ii$|^as.factor\\(week\\)|^t_non_kakao$|^t_kakao_story$|^t_kakao_game$", rownames(coef_df)), ]
  subset_coef$Variable <- rownames(subset_coef)
  subset_coef$Match_ID <- i
  
  plm_summary_list[[i]] <- subset_coef[, c("Match_ID", "Variable", "Estimate", "Pr(>|t|)")]
}

plm_regression_summary <- do.call(rbind, plm_summary_list)
rownames(plm_regression_summary) <- NULL
plm_regression_summary <- plm_regression_summary[, c("Match_ID", "Variable", "Estimate", "Pr(>|t|)")]

print(plm_regression_summary)




#KAKAO STORY DUMMY

model_list2 <- list()
summary_list2 <- list()

for (i in 1:10) {
  data_i <- get(paste0("final.kakao", i))
  
  model <- lm(log(t_kakao_story + 1) ~ as.factor(panel_id) + as.factor(week) + ii + t_kakao_story + t_kakao_game + t_kakao_talk
              + t_non_kakao,
              data = data_i, weights = weights)
  
  assign(paste0("lm_dummy_", i), model)
  
  model_list2[[i]] <- model
  
  s <- summary(model)
  coef_df <- as.data.frame(coef(s))
  
  subset_coef <- coef_df[grepl("^ii$|^as.factor\\(week\\)|^t_non_kakao$|^t_kakao_talk$|^t_kakao_game$", rownames(coef_df)), ]
  subset_coef$Variable <- rownames(subset_coef)
  subset_coef$Match_ID <- i
  
  summary_list2[[i]] <- subset_coef[, c("Match_ID", "Variable", "Estimate", "Pr(>|t|)")]
}

regression_summary2 <- do.call(rbind, summary_list2)
rownames(regression_summary2) <- NULL

regression_summary2 <- regression_summary2[, c("Match_ID", "Variable", "Estimate", "Pr(>|t|)")]

print(regression_summary2)

