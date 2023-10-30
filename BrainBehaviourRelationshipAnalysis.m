% Get Brain-Behaviour relationship:

%% Load Data:
% Set path to CONN data:
dataPath = 'F:\Saurabh_files\Research_data\TPJ_Network';

% Set Condition filename to be used from CONN:
dataFile = 'resultsROI_Condition001.mat';
load([dataPath filesep 'NewROIdata' filesep dataFile]);

% Set number of participants to be used for training the model:
numSubs = 180;
numROIs = 132;

%% Define Masks:
diffFiles = {'PTSDds-Control_mod.mat',...
             'PTSD-Control_mod.mat'};

% Get Mask data:
curr_Mask = zeros(numROIs);
for i = 1:length(diffFiles)
    temp = load([dataPath filesep diffFiles{i}]);
    curr_Mask = curr_Mask + temp.R;
end

% Get ROI pairs
Mask_idx = curr_Mask>0;
numROI_pairs = sum(Mask_idx(:))/2;
ROIpair_names = [];
num_pairs = 1;
for i = 1:numROIs
    for j = 1:numROIs
        if (i<j) && Mask_idx(i,j)
            ROIpair_names = cat(1,ROIpair_names,{temp.ColumnNames{i}, temp.ColumnNames{j}});
        end
    end
end

% Get ROI pair IDX in full ROI space:
ROIpair_idx = zeros(size(ROIpair_names));
for i = 1:numROI_pairs
    ROIpair_idx(i,1) = find(cellfun(@(x) strcmp(x,ROIpair_names{i,1}),names));
    ROIpair_idx(i,2) = find(cellfun(@(x) strcmp(x,ROIpair_names{i,2}),names));    
end

% Get ROI2ROI data for these ROI pairs for all participants:
A = nan(size(Z,3),numROI_pairs);
for i = 1:numROI_pairs
    A(:,i) = Z(ROIpair_idx(i,1),ROIpair_idx(i,2),:);   
end

%% Run CCA analysis:

% Load behavoural factors stored in a variable named B:
% B size: [num of participants x num of behavoural factors]
load([dataPath filesep 'AllBehaviourData.mat']);

% Select a subset of the behavioural factors to include in analysis:
selectBehavFactors = [1:5 6 7 9:19 21 22];

% Get training participant indices:
total_pts = size(A,1);
randomized_idx = randperm(total_pts);
train_idx = randomized_idx(1:numSubs);
test_idx = randomized_idx(numSubs+1:end);

% Input data:
A_final = A(train_idx,:);
B_final = B(train_idx,selectBehavFactors);

% Remove missing data (represented by -99):
dataToRemove = sum(A_final==-99,2) | sum(B_final==-99,2);
A_final = A_final(~dataToRemove,:);
B_final = B_final(~dataToRemove,:);

% Standardize the data:
A_final = (A_final - mean(A_final))./std(A_final);
B_final = (B_final - mean(B_final))./std(B_final);

[AA,BB,r,U,V,stats] = canoncorr(A_final,B_final);

numFactors = size(AA,2);

%% Curate factor loadings:
numTopLoadings = 10; % Number of top loadings to assess
BrainLoadingsAll = cell(numFactors,1);
BehaviourLoadingsAll = cell(numFactors,1);
BrainLoadings = cell(numTopLoadings,2);
BehaviourLoadings = cell(numTopLoadings,2);

currBehaviourLabels = BehaviourLabels(selectBehavFactors);

for i = 1:numFactors
    
    % Get Brain Loadings:
    [currAA_sorted, currAA_sortedIDX] = sort(AA(:,i));    
    currBrainIDX_negative = currAA_sortedIDX((end-numTopLoadings+1):end);
    currBrainIDX_positive = currAA_sortedIDX(1:numTopLoadings);
    for j = 1:numTopLoadings 
        BrainLoadings{j,1} = [ROIpair_names{currBrainIDX_negative(j),1} ' 2 ' ROIpair_names{currBrainIDX_negative(j),2}]; % Most negative 10 loadings
        BrainLoadings{j,2} = [ROIpair_names{currBrainIDX_positive(j),1} ' 2 ' ROIpair_names{currBrainIDX_positive(j),2}]; % Most positive 10 loadings
    end
    BrainLoadingsAll{i} = BrainLoadings;
    
    % Get Behaviour Loadings:
    [currBB_sorted, currBB_sortedIDX] = sort(BB(:,i));    
    currBehaviourIDX_negative = currBB_sortedIDX((end-numTopLoadings+1):end);
    currBehaviourIDX_positive = currBB_sortedIDX(1:numTopLoadings);
    Behaviour_values = [currBB_sorted((end-numTopLoadings+1):end) currBB_sorted(1:numTopLoadings)]; 
    %Behaviour_values = Behaviour_values./max(abs(Behaviour_values(:))); % For the scale on the figure
    for j = 1:numTopLoadings 
        BehaviourLoadings{j,1} = currBehaviourLabels{currBehaviourIDX_negative(j)}; % Most negative 10 loadings
        BehaviourLoadings{j,2} = currBehaviourLabels{currBehaviourIDX_positive(j)}; % Most positive 10 loadings
    end
    BehaviourLoadingsAll{i} = BehaviourLoadings;
end

%% Get % Explained Variance:

% Get the held-out participants:
B_final = B(test_idx,selectBehavFactors);
A_final = A(test_idx,:);

% Remove missing data (represented by -99):
dataToRemove = sum(A_final==-99,2) | sum(B_final==-99,2);
A_final = A_final(~dataToRemove,:);
B_final = B_final(~dataToRemove,:);

% Standardize the data:
B_final(2,8) = 4; % To prevent NaN
A_final = (A_final - mean(A_final))./std(A_final);
B_final = (B_final - mean(B_final))./std(B_final);

% Compute variates:
testA = A_final*AA; testB = B_final*BB;

% Compute variance of variates:
testA_var = (std(testA)).^2; testB_var = (std(testB)).^2;

% Compute percentage of variance explained:
testA_pctVar = testA_var./(sum(testA_var)); testB_pctVar = testB_var./(sum(testB_var));

%% Plot Brain Factors:
currFactor_num = 1; % Set the factor number to be plotted
plotBrainBehaviourFactors

%% Plot Factor Correlations:
plot_numFactors = 3; % The number of top factors to include in plot
plotFactorCorrelations

%% Plot Factor Biplot:
plottingFactors = [1:3]; % Factor indices to plot
groupA_idx = [1 0 0 0 1 1 0 0 1 1 0 0 0];
groupB_idx = [0 1 1 0 0 0 0 1 0 0 0 0 1];
groupC_idx = [0 0 0 1 0 0 1 0 0 0 1 1 0];
plotBiplot