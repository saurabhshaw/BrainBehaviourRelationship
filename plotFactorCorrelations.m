%% Plot latent factor correlations:

t = tiledlayout(plot_numFactors,plot_numFactors);
title(t,'Canonical Scores of X vs Canonical Scores of Y')
xlabel(t,'Canonical Variables of X')
ylabel(t,'Canonical Variables of Y')
t.TileSpacing = 'compact';

for i = 1:plot_numFactors
    for j = 1:plot_numFactors
        nexttile
        plot(U(:,i),V(:,j),'.')
        xlabel(['u' num2str(i)])
        ylabel(['v' num2str(j)])        
    end 
end