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

    methods = ["Explicit Midpoint", "Explicit Midpoint", "Implicit Midpoint", ...
        "Forward Euler", "Backward Euler"];

    clf
    figure(1); 
    
    for i = 1:5
        hiddenFig = figure('Visible', 'off'); 
        
        sourceLine = findobj(hiddenFig, 'Type', 'line');
        plot_fixed_integration(methods(i), 0.38); 
        subplot(4, 1, i); 
        mainAxis = gca;
        
        copyobj(sourceLine, mainAxis);
        
        close(hiddenFig);
    end

end