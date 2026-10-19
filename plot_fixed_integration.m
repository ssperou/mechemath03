% integration plots for provided method ("Explicit Midpoint",
% "Forward Euler", "Backward Euler", "Implicit Midpoint")
function [t_list, X_list] = plot_fixed_integration(method, href)
    arguments
        method (1,:) string
        href (1,:) double = [0.45 2 3]
    end
    tspan = [0, 10];
    X0 = 1;
    rate_func = @rate_func01;
    func_sol = @solution01;
    colors = [0 0 0.7; 0.5 0.25 0; 0.75 0.6 0];

    clf
    figure(1);
    hold on;
    grid on;
    axis([tspan(1) tspan(2) -3 2]);

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
        
        plot(t_list, X_list, '-o','LineWidth', 2,'MarkerFaceColor', 'k', ... 
    'MarkerSize', 3, 'MarkerEdgeColor', colors(i,:),'DisplayName', sprintf('h = %g ', h_ref));
        
    end
    
    %plot 
    xlabel('Time (-)', 'Interpreter', 'Latex','FontSize',32);
    ylabel('$X(t)$ (-)', 'Interpreter', 'Latex','FontSize',32);
    hold on;
    
    sol_t = linspace(tspan(1), tspan(2), 200);
    x_sols = func_sol(sol_t);
    psol = plot(sol_t, x_sols, 'LineWidth', 3, 'DisplayName', 'Analytical Solution');
    uistack(psol, 'bottom');
    legend('Location', 'southwest','Interpreter', 'Latex','FontSize',16);
    hold off;
    title(sprintf('%s Approximation vs Solution', method), 'Interpreter', 'Latex','FontSize',34);
    set(gca,"TickLabelInterpreter",'latex','FontSize',18);
    fontsize(scale=1.75)

end