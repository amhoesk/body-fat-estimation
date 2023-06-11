# defining independent and dependent variables
var_id <- c("SEQN")

vars_indep <- c(
    "BMXWT"   , 
    "BMXHT"   , 
    "RIAGENDR", 
    "RIDAGEEX", 
    "BMXWAIST", 
    "BMXARMC" , 
    "BMXTHICR", 
    "BMXCALF" , 
    "BMXARML" , 
    "BMXLEG"  , 
    "BMXTRI"  , 
    "BMXSUB"
)

vars_indep_desc <- c(
    "Weight (kg)"                    ,
    "Standing Height (cm)"           , 
    "Gender (0 male, 1 female)"      ,
    "Exam Age (year)"                , 
    "Waist Circumference (cm)"       ,
    "Arm Circumference (cm)"         ,
    "Thigh Circumference (cm)"       ,
    "Maximal Calf Circumference (cm)",
    "Upper Arm Length (cm)"          ,
    "Upper Leg Length (cm)"          ,
    "Triceps Skinfold (mm)"          ,
    "Subscapular Skinfold (mm)"
)

vars_dep <- c(
    "DXXHEFAT",
    "DXXLAFAT",
    "DXXLLFAT",
    "DXXTRFAT",
    "DXDTOFAT",
    "DXDHETOT",
    "DXDLATOT",
    "DXDLLTOT",
    "DXDTRTOT",
    "DXDTOBMC",
    "DXDTOBMD",
    "DXDHEPF" ,
    "DXDLAPF" ,
    "DXDLLPF" ,
    "DXDTRPF" ,
    "DXDTOPF"  
)

vars_dep_desc <- c(
    "Head Fat (kg)",
    "Left Arm Fat (kg)",
    "Left Leg Fat (kg)",
    "Trunk Fat (kg)",
    "Total Fat (kg)",
    "Head Total (kg)",
    "Left Arm Total (kg)",
    "Left Leg Total (kg)",
    "Trunk Total (kg)",
    "Total Bone Mineral Content (kg)",
    "Total Bone Mineral Density (g/cm^2)",
    "Head Percent Fat",
    "Left Arm Percent Fat",
    "Left Leg Percent Fat",
    "Trunk Percent Fat",
    "Total Percent Fat"    
)

df_vars_indep <- data.frame(description = vars_indep_desc, row.names = vars_indep)
df_vars_dep <- data.frame(description = vars_dep_desc, row.names = vars_dep)

all_vars <- c(var_id, vars_indep, vars_dep)

n_indep_vars <- length(vars_indep)
n_dep_vars <- length(vars_dep)

# joining tables
df <- inner_join(df_demograph, df_body_measur, by = var_id)
df <- inner_join(df, df_dxa, by = var_id)

# selecting target variables
df_join <- df[, all_vars]

# converting month to year
df_join$RIDAGEEX <- df_join$RIDAGEEX / 12

# converting sex variable to categorical
df_join <- df_join %>% mutate(RIAGENDR = ifelse(RIAGENDR == 1, 0, 1))
# df_join$RIAGENDR <- as.factor(df_join$RIAGENDR)

# converting body fats to kg
vars_gram <- c("DXXHEFAT", "DXDHETOT", "DXXLAFAT", "DXDLATOT", "DXDLLTOT",
              "DXXLLFAT",  "DXXTRFAT", "DXDTRTOT", "DXDTOBMC", "DXDTOFAT")
df_join[vars_gram] <- df_join[vars_gram] / 1e3

# scaling independent variables are necessary for independent (predicting) variable 
# except hot encoded variables like Gender (RIAGENDR)
df_scaled <- df_join
vars_scale <- c("RIDAGEEX", "BMXWT", "BMXHT", "BMXARMC", "BMXARML", "BMXCALF", 
                "BMXLEG", "BMXSUB", "BMXTHICR", "BMXTRI", "BMXWAIST")
df_scaled[vars_scale] <- df_scaled[vars_scale] |> scale(center = TRUE, scale = TRUE) |> as.data.frame()
