# defining independent and dependent variables
var_id <- c("SEQN")

vars_indep <- c("RIAGENDR", "RIDAGEEX", "BMXWT", "BMXHT", "BMXARMC", "BMXARML",
    "BMXCALF", "BMXLEG", "BMXSUB", "BMXTHICR", "BMXTRI", "BMXWAIST")

vars_indep_desc <- c("Gender", "Exam Age (year)", "Weight (kg)",
    "Standing Height (cm)", "Arm Circumference (cm)", "Upper Arm Length (cm)",
    "Maximal Calf Circumference (cm)", "Upper Leg Length (cm)",
    "Subscapular Skinfold (mm)", "Thigh Circumference (cm)",
    "Triceps Skinfold (mm)", "Waist Circumference (cm)")

vars_dep <- c("DXXHEFAT", "DXDHETOT", "DXDHEPF", "DXXLAFAT", "DXDLATOT",
    "DXDLAPF", "DXDLLTOT", "DXXLLFAT", "DXDLLPF", "DXXRAFAT", "DXDRATOT",
    "DXDRAPF", "DXXRLFAT", "DXDRLTOT", "DXDRLPF", "DXXTRFAT", "DXDTRTOT",
    "DXDTRPF", "DXDTOBMC", "DXDTOBMD", "DXDTOFAT", "DXDTOPF")

vars_dep_desc <- c("Head Fat (g)", "Head Total (g)", "Head Percent Fat",
    "Left Arm Fat (g)", "Left Arm Total (g)", "Left Arm Percent Fat",
     "Left Leg Total (g)", "Left Leg Fat (g)", "Left Leg Percent Fat",
     "Right Arm Fat (g)", "Right Arm Total (g)", "Right Arm Percent Fat",
    "Right Leg Fat (g)", "Right Leg Total (g)", "Right Leg Percent Fat",
    "Trunk Fat (g)", "Trunk Total (g)", "Trunk Percent Fat",
    "Total Bone Mineral Content (g)", "Total Bone Mineral Density (g/cm^2)",
    "Total Fat (g)", "Total Percent Fat")

all_vars <- c(var_id, vars_indep, vars_dep)

n_indep_vars <- length(vars_indep)
n_dep_vars <- length(vars_dep)

## joining tables
df <- inner_join(df_demograph, df_body_measur, by = var_id)
df <- inner_join(df, df_dxa, by = var_id)

## selecting target variables
df_join <- df[, all_vars]
df_join$RIDAGEEX <- df_join$RIDAGEEX / 12 # converting month to year
# df <- na.omit(df)