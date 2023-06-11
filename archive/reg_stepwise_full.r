source("clean_data.r")

## computing results
df_coeffs <- data.frame(
    matrix(NA, length(vars_dep), length(vars_indep) + 3,
        dimnames = list(vars_dep, c("(Intercept)", vars_indep, "R2", "RMSE"))),
        check.names = FALSE)

df_pval <- data.frame(
    matrix(NA, length(vars_dep), length(vars_indep) + 1,
        dimnames = list(vars_dep, c("(Intercept)", vars_indep))),
        check.names = FALSE)

for (var_dep in vars_dep) {
    f  <- as.formula(
        paste(var_dep, paste(vars_indep, collapse = " + "), sep = " ~ ")
    )

    full_model <- lm(f, data = df)

    step_model <- stepAIC(full_model, direction = "both", trace = FALSE)

    for (name in names(step_model$coefficients)) {
        df_coeffs[var_dep, name] <- step_model$coefficients[name]
        df_pval[var_dep, name] <-
            summary(step_model)[4]$coefficients[name, "Pr(>|t|)"]
    }

    df_coeffs[var_dep, "R2"]  <- summary(step_model)[9]
    df_coeffs[var_dep, "RMSE"] <- sqrt(mean(step_model$residuals^2))
}

print(df_coeffs)

row.names(df_coeffs) <- vars_dep_desc
row.names(df_pval) <- vars_dep_desc
colnames(df_coeffs) <- c("(Intercept)", vars_indep_desc, "Adj. R2", "RMSE")
colnames(df_pval) <- c("(Intercept)", vars_indep_desc)

write.xlsx(df_coeffs,
    file = "../../out/R/raw results.xlsx",
    row.names = TRUE, sheetName = "reg-stepwise-full-coeffs",
    append = TRUE, showNA = FALSE)

write.xlsx(df_pval,
    file = "../../out/R/raw results.xlsx",
    row.names = TRUE, sheetName = "reg-stepwise-full-pval",
    append = TRUE, showNA = FALSE)

# tasks: cocoeffsty, lasso, only sex, height, age and circumferences, RMSE
