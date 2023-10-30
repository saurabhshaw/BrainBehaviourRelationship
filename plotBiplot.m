%% Plot biplot:

% Provide group membership information to color dots according to group
% membership:
% groupA_idx, groupB_idx, groupC_idx = Binary vectors of size [1 x num of participants]
% 
groupMembership = groupA_idx + 2*groupB_idx + 3*groupC_idx;
finalGroupMem = groupMembership(train_idx);
finalGroupMem = finalGroupMem(~dataToRemove);

tempBB = BB;

% Plot the biplot:
numObs = size(V,1);
figure; hh = biplot([-1*BB(:,plottingFactors)],'Scores',-1*V(:,plottingFactors),'VarLabels',currBehaviourLabels); title('BiPlot of behavioural loadings');
figure; hb = biplot([AA(:,plottingFactors)],'Scores',U(:,plottingFactors)); title('BiPlot of brain loadings');

% Change the color of the marker based on group membership:
for k = length(hh)-numObs:length(hh)-1
    
    hh(k).MarkerSize = 25;
    
    groupIDX = k - (length(hh)-numObs) + 1;
    
    if finalGroupMem(groupIDX) <= 1
        hh(k).MarkerEdgeColor = 'k';  % Specify black color for Group A
        
    elseif finalGroupMem(groupIDX) == 2
        hh(k).MarkerEdgeColor = '#0072BD';  % Specify blue color for Group B
           
    elseif finalGroupMem(groupIDX) == 3
        hh(k).MarkerEdgeColor = '#D95319';  % Specify orange color for Group C
        
    end
end


for k = length(hb)-numObs:length(hb)-1
    
    hb(k).MarkerSize = 25;
    
    groupIDX = k - (length(hb)-numObs) + 1;
    
    if finalGroupMem(groupIDX) <= 1
        hb(k).MarkerEdgeColor = 'k';  % Specify black color for Group A
        
    elseif finalGroupMem(groupIDX) == 2
        hb(k).MarkerEdgeColor = '#0072BD';  % Specify blue color for Group B
           
    elseif finalGroupMem(groupIDX) == 3
        hb(k).MarkerEdgeColor = '#D95319';  % Specify orange color for Group C
        
    end
end