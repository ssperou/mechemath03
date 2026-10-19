function plot_stability(h_ref)
    arguments
        h_ref (1,:) double = 0.38
    end
    methods = ["Forward Euler", "Explicit Midpoint", "Backward Euler", "Implicit Midpoint"];
    clf
    figure(1); 
    legend('Location', 'southoutside','Interpreter', 'Latex','FontSize',24);

    tspan = [0, 30];
    X0 = 1;
    rate_func = @rate_func01;
    func_sol = @solution01;
    color = [0.8500, 0.30, 0.0980];
    sol_t = linspace(tspan(1), tspan(2), 200);
    x_sols = func_sol(sol_t);

    for i = 1:length(methods)
        method = methods(i);
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
        end
        subplot(4,1,i)
        grid on;
        hold on
        plot(sol_t, x_sols, 'LineWidth', 3, 'color', [0.2 0.2 1],'DisplayName', 'Analytical Solution');
        plot(t_list, X_list, '-o','LineWidth', 2,'MarkerFaceColor', color, ...
            'MarkerSize', 3, 'MarkerEdgeColor', color,'DisplayName', 'Approximation');
        title(sprintf('%s Method', method), 'Interpreter', 'Latex','FontSize',16);
        ylabel('$X(t)$ (-)', 'Interpreter', 'Latex','FontSize',16);
        set(gca,"TickLabelInterpreter",'latex', 'Fontsize',16);
    end
    
    xlabel('Time (-)', 'Interpreter', 'Latex','FontSize',24);
    legend('Location', 'eastoutside','Interpreter', 'Latex','FontSize',16);
    sgtitle(sprintf('Integration Stability for Timestep $h$ = %g', h_ref),'Interpreter','Latex', Fontsize=32)

end