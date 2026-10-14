function plot_stability()
    % [t_lists{1}, x_lists{1}] = plot_fixed_integration("Explicit Midpoint");
    % [t_lists{2}, x_lists{2}] = plot_fixed_integration("Implicit Midpoint");
    % [t_lists{3}, x_lists{3}] = plot_fixed_integration("Backward Euler");
    % [t_lists{4}, x_lists{4}] = plot_fixed_integration("Forward Euler");
    % 
    % 
    % for i = 1:4
    %     subplot(4, 1, i);
    %     plot(t_lists{i}, x_lists{i},'--','LineWidth', 1.5,'DisplayName', sprintf('h = 0.45'));
    % end

    methods = ["Explicit Midpoint", "Implicit Midpoint", "Backward Euler", "Forward Euler"];

    figure; 
    
    for i = 1:4
        hiddenFig = figure('Visible', 'off'); 
        
        plot_fixed_integration(methods(i)); 
        
        sourceLine = findobj(hiddenFig, 'Type', 'line');
        subplot(4, 1, i); 
        mainAxis = gca;
        
        copyobj(sourceLine, mainAxis);
        
        close(hiddenFig);
    end
end