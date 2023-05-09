# -------- Cleaning demographic dataframe ---------
# excluding individuals with age greater than 8 years old as they were not eligible for dxa measurement
df_demograph <- df_demograph %>%
    filter(RIDAGEEX >= 8 * 12)

# removing missing age data
df_demograph <- df_demograph %>%
    filter(!is.na(RIDAGEEX))

# -------- Cleaning body measurement dataframe ----------

# removing missing weight values and values that
# are not measured in appropriate condition
df_body_measur <- df_body_measur %>%
    filter(!is.na(BMXWT) & is.na(BMIWT))

# removing missing stature values and stature values that are not measured in appropriate condition
df_body_measur <- df_body_measur %>%
    filter(!is.na(BMXHT) & is.na(BMIHT))

# removing missing upper leg length values and values that couldn't be obtained
df_body_measur <- df_body_measur %>%
    filter(!is.na(BMXLEG) & is.na(BMILEG))

# removing missing maximum calf values and values that couldn't be obtained
df_body_measur <- df_body_measur %>%
    filter(!is.na(BMXCALF) & is.na(BMICALF))

# removing missing arm length values and values that couldn't be obtained
df_body_measur <- df_body_measur %>%
    filter(!is.na(BMXARML) & is.na(BMIARML))

# removing missing arm circumference values and values that couldn't be obtained
df_body_measur <- df_body_measur %>%
    filter(!is.na(BMXARMC) & is.na(BMIARMC))

# removing missing waist circumference values and ones that couldn't be obtained
df_body_measur <- df_body_measur %>%
    filter(!is.na(BMXWAIST) & is.na(BMIWAIST))

# removing missing thigh circumference values and ones that couldn't be obtained
df_body_measur <- df_body_measur %>%
    filter(!is.na(BMXTHICR) & is.na(BMITHICR))

# removing missing triceps skinfold values and values that couldn't be obtained
df_body_measur <- df_body_measur %>%
    filter(!is.na(BMXTRI) & is.na(BMITRI))

# removing missing Subscapular Skinfold values and ones that couldn't be obtained
df_body_measur <- df_body_measur %>%
    filter(!is.na(BMXSUB) & is.na(BMISUB))

# ----------- Cleaning DXA dataframe -----------
# Because missing or invalid data have been multiply imputed, the DXX_D data release 
# file contains 5 records for each survey participant, 8-69 years of age, 
# who was interviewed and examined. Only 1 record should be used in calculating sample sizes. 
# However, all 5 records must be used in analyses in order to obtain more accurate variance estimates. 
# The records for some survey participants, such as pregnant females, are blank; 
# pregnant females were not eligible for the DXA scan.

# DXA scans were administered to eligible survey participants aged 8-69.

# Only individuals were all of their data were valid and none were imputed, were selected.
df_dxa <- df_dxa %>%
    filter(DXAEXSTS == 1 & DXITOTST == 0 & DXITOTBN == 0)