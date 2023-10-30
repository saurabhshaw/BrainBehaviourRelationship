%% Plot Brain Factor results:

showTopLoadingsOnly = 1; % Flag to plot top factor loadings only

% Select top factor loadings if indicated:
if showTopLoadingsOnly
    % Get indices of top Brain Loadings
    [currAA_sorted, currAA_sortedIDX] = sort(AA(:,currFactor_num));    
    currBrainIDX_negative = currAA_sortedIDX((end-numTopLoadings+1):end);
    currBrainIDX_positive = currAA_sortedIDX(1:numTopLoadings);
    topLoadingsIDX = [currBrainIDX_negative; currBrainIDX_positive];
end
    
% Load template ROIfile:
load('CCAresults-ROIfile.mat');

% Modify the template ROIfile data:
for i = 1:length(names)
    
    curr_num = zeros(1,length(ROIpair_idx));
    for k = 1:length(ROIpair_idx) 
        curr_num(k) = ismember(i,ROIpair_idx(k,:));
    end
    
    % Initialize ROI h,F,p values:
    ROI(i).h = zeros(1,length(names2));
    ROI(i).F = zeros(1,length(names2));
    ROI(i).p = ones(1,length(names2));
    
    
    if sum(curr_num)>0
        curr_idx = find(curr_num);
                
        for j = 1:length(curr_idx)
            which_idx = find(i == ROIpair_idx(curr_idx(j),:));
            
            if (sum(ismember(curr_idx(j),topLoadingsIDX))>0)|~showTopLoadingsOnly % Only do this if it is in the topLoadings
                
                if which_idx == 1
                    ROI_idx = ROIpair_idx(curr_idx(j),2);
                    ROI(i).h(ROI_idx) = (-1).*AA(curr_idx(j),currFactor_num);
                    %ROI(i).F(ROI_idx) = atanh(AA(curr_idx(j),currFactor_num));
                    ROI(i).F(ROI_idx) = (-1).*AA(curr_idx(j),currFactor_num);
                    ROI(i).p(ROI_idx) = 0;
                end
            end
        end
    end
    
    ROI(i).h(i) = nan;
    ROI(i).F(i) = nan;
    ROI(i).p(i) = nan;
end

% Load the results:
save([dataPath filesep 'tempROI.mat'],'ROI');
conn_displayroi('initfile',[dataPath filesep 'tempROI.mat']);