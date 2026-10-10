function rate_func_test(method)

    h_values = [0.1, 0.25, 0.45];
    tspan = [0, 10];
    X0 = 1;
    rate_func = @rate_func01;
    func_sol = @solution01;


    figure();
    hold on;
    grid on;
    axis([0 10 -3 2])
     for i = 1:length(h_values)

        h_ref = h_values(i);
        
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

        plot(t_list, X_list, '--','LineWidth', 1.5,'DisplayName', sprintf('h = %g ', h_ref));
        
    end
    
    %plot 
    xlabel('Time (-)', 'Interpreter', 'Latex','FontSize',16);
    ylabel('X(t)', 'Interpreter', 'Latex','FontSize',16);
    hold on;

    x_sols = func_sol(t_list);
    psol = plot(t_list, x_sols, 'LineWidth', 1.5, 'DisplayName', 'Analytical Solution');
    uistack(psol, 'bottom');
    legend('Location', 'best','Interpreter', 'Latex','FontSize',12);
    hold off;

    title(sprintf('%s Example Integration Plot', method), 'Interpreter', 'Latex','FontSize',18)

    set(gca,"TickLabelInterpreter",'latex')
end