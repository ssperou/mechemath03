% integration plots for provided method ("Explicit Midpoint",
% "Forward Euler", "Backward Euler", "Implicit Midpoint")
function [t_list, X_list] = plot_fixed_integration(method,href)
    %h_values = [0.45];
    tspan = [0, 20];
    X0 = 1;
    rate_func = @rate_func01;
    func_sol = @solution01;

    cla
    figure(1);
    hold on;
    grid on;
    axis([0 10 -3 2]);

    for i = 1:length(href)
        h_ref = href(i);
        if method == "Explicit Midpoint"
            [t_list,X_list] = explicit_midpoint_fixed_step_integration( ...
                rate_func, tspan, X0, h_ref);
        elseif method == "Forward Euler"
            [t_list,X_list] = forward_euler_fixed_step_integration( ...
                rate_func, tspan, X0, h_ref);
        elseif method == "Backward Euler"
            [t_list,X_list, ~,~] = fixed_step_integration(...
                rate_func,method,tspan,X0,h_ref);
        elseif method == "Implicit Midpoint"
            [t_list,X_list, ~,~] = fixed_step_integration(...
                rate_func,method,tspan,X0,h_ref);
        else
            disp("not a valid method. try again")
        end 
        
        plot(t_list, X_list, '-o','LineWidth', 1.5,'MarkerFaceColor', 'b', ... 
    'MarkerSize', 1.75, 'MarkerEdgeColor', 'b','DisplayName', sprintf('h = %g ', h_ref));
        
    end
    
    %plot 
    xlabel('Time (-)', 'Interpreter', 'Latex','FontSize',16);
    ylabel('$X(t) (-)$', 'Interpreter', 'Latex','FontSize',16);
    hold on;

    x_sols = func_sol(t_list);
    psol = plot(t_list, x_sols, 'LineWidth', 1.5, 'DisplayName', 'Analytical Solution');
    uistack(psol, 'bottom');
    legend('Location', 'eastoutside','Interpreter', 'Latex','FontSize',12);
    hold off;
    title(sprintf('%s Example Integration Plot', method), 'Interpreter', 'Latex','FontSize',18);
    set(gca,"TickLabelInterpreter",'latex');

    % save plot as high res
    % myfig = gcf(); %set myfig to the current figure
    % exportgraphics(myfig , 'plot_name.png', 'Resolution', 600); %saves plot to plot_name at high resolution
end