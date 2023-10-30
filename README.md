# BrainBehaviourRelationship
Learn common brain-behaviour factors from neuroimaging data already processed through CONN, as done in Shaw et al. 2023

Shaw, S.B., Terpou, B.A., Densmore, M. et al. Large-scale functional hyperconnectivity patterns in trauma-related dissociation: an rs-fMRI study of PTSD and its dissociative subtype. Nat. Mental Health 1, 711–721 (2023). https://doi.org/10.1038/s44220-023-00115-y

# Requirements:
1. SPM12 toolbox
2. CONN toolbox

# How to Run:
1. Update filepath to CONN results folder corresponding to the ROI-to-ROI analysis (e.g. for a CONN project where this analysis is labeled as SBC_01 - \results\firstlevel\SBC_01)
2. Save the Behaviour factors in a variable B of size [num of participants x num of behavioural factors]
3. Provide the group memberships of the participants for plotting Biplot

Run the BrainBehaviourRelationshipAnalysis.m file after updating these values
