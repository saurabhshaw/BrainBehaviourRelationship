# BrainBehaviourRelationship
Learn common brain-behaviour factors from neuroimaging data already processed through CONN

# Requirements:
1. SPM12 toolbox
2. CONN toolbox

# How to Run:
1. Update filepath to CONN results folder corresponding to the ROI-to-ROI analysis (e.g. for a CONN project where this analysis is labeled as SBC_01 - \results\firstlevel\SBC_01)
2. Save the Behaviour factors in a variable B of size [num of participants x num of behavioural factors]
3. Provide the group memberships of the participants for plotting Biplot

Run the BrainBehaviourRelationshipAnalysis.m file after updating these values
