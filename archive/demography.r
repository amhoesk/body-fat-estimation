source("get_data.r")
source("clean_data.r")
source("prepare_data.r")

vars_calc <- c("RIDAGEEX", "BMXWT", "BMXHT", "BMXWAIST")
vars_calc_desc <- c("Exam Age (year)", "Weight (kg)",
    "Standing Height (cm)", "Waist Circumference (cm)")

## computing results
vec_sex <- c("Male", "Female")

df_demog <- data.frame(
    matrix("", length(vars_calc), 2,
        dimnames = list(vars_calc, vec_sex)
    ),
    check.names = FALSE)

for (i_sex in c(1, 2)) {
    idx  <- df$RIAGENDR == i_sex
    for (var_calc in vars_calc) {
        df_demog[var_calc, vec_sex[i_sex]] <- paste(
            str_interp("$[.1f]{mean(df[idx, var_calc])}  B1"),
            str_interp("$[.2f]{sd(df[idx, var_calc])} "),
            str_interp("[$[.1f]{min(df[idx, var_calc])} - "),
            str_interp("$[.1f]{max(df[idx, var_calc])}]")
        )
    }
}

vec_sex_desc <- c()
for (i_sex in c(1, 2)) {
    idx  <- df$RIAGENDR == i_sex
    vec_sex_desc[i_sex] <- paste(
        vec_sex[i_sex],
        str_interp("(N = ${length(df[idx, 'RIAGENDR'])})")
    )
}

colnames(df_demog) <- vec_sex_desc
row.names(df_demog) <- vars_calc_desc
print(df_demog)

write.xlsx(df_demog,
    file = "../../out/R/raw results.xlsx",
    row.names = TRUE, sheetName = "demographics",
    append = TRUE, showNA = FALSE)

# tasks: colinearity, lasso, only sex, height, age and circumferences