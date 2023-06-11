#--- Step-wise regression model
fit_stepwise_reg_model <- function(df, vars_indep, vars_dep){
    df_coeffs <- data.frame(
        matrix(NA, length(vars_dep), length(vars_indep) + 3,
            dimnames = list(vars_dep, c("(Intercept)", vars_indep, "R2", "RMSE"))),
            check.names = FALSE)
    
    df_pval <- data.frame(
        matrix(NA, length(vars_dep), length(vars_indep) + 1,
            dimnames = list(vars_dep, c("(Intercept)", vars_indep))),
            check.names = FALSE)
    
    for (var_dep in vars_dep) {
        f  <- as.formula(paste(var_dep, paste(vars_indep, collapse = " + "), sep = " ~ "))
    
        full_model <- lm(f, data = df)
    
        step_model <- stepAIC(full_model, direction = "both", trace = FALSE)
    
        for (name in names(step_model$coefficients)) {
            df_coeffs[var_dep, name] <- step_model$coefficients[name]
            df_pval[var_dep, name] <- summary(step_model)[4]$coefficients[name, "Pr(>|t|)"]
        }
    
        df_coeffs[var_dep, "R2"] <- summary(step_model)[9]
        df_coeffs[var_dep, "RMSE"] <- sqrt(mean(step_model$residuals^2))
    }
    
    return(df_coeffs)
}

#---- Ridge regression
fit_elasticnet_reg_model <- function(df, vars_indep, vars_dep, type){
    alpha = switch(type, "ridge" = 0, "lasso" = 1)
    
    x <- df[vars_indep] |> as.matrix()
    
    df_coeffs <- data.frame(matrix(NA, length(vars_dep), length(vars_indep) + 3,
            dimnames = list(vars_dep, c("(Intercept)", vars_indep, "R2", "RMSE"))),
            check.names = FALSE)
    
    # Perform 10-fold cross-validation to select lambda
    lambdas_to_try <- 10^seq(-3, 3, length.out = 100) 
    for (var_dep in vars_dep) {
        y <- df_scaled[var_dep] |> as.matrix()
    
        # Setting alpha = 0 implements ridge regression
        ridge_cross_valid <- cv.glmnet(x, y, alpha = alpha, lambda = lambdas_to_try, 
                              type.measure = "mse", nfolds = 10)
        
        best_lambda <- ridge_cross_valid$lambda.min
        ridge_model <- glmnet(x, y, alpha = alpha, lambda = best_lambda)
        
        y_predicted <- predict(ridge_model, s = best_lambda, newx = x)
        sst <- (y - mean(y))^2 |> sum()
        sse <- (y_predicted - y)^2 |> sum()
        rsq <- 1 - sse/sst #find R-Squared
        rmse <- (y_predicted - y)^2 |> mean() |> sqrt()
        
        mat_coeffs <- coef(ridge_model)
        df_coeffs[var_dep, rownames(mat_coeffs)] <- mat_coeffs[rownames(mat_coeffs),]
        df_coeffs[var_dep, "R2"] <- rsq
        df_coeffs[var_dep, "RMSE"] <- rmse
    }
    
    return(df_coeffs)
}