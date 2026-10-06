function rate_func_test(method)
    if method == "Midpoint"
        [t_list,X_list] = explicit_midpoint_fixed_step_integration( ...
            @rate_func01, [0,10],1,0.2);
    elseif method == "Euler"
        [t_list,X_list] = forward_euler_fixed_step_integration( ...
            @rate_func01, [0,40],1,.41);
    else
        disp("not a valid method. try again")
    end

    figure(1);
    plot(t_list, X_list, 'LineWidth', 1.15);
    xlabel('Time');
    ylabel('State');
    grid on;
    hold on;
    
    x_sols = solution01(t_list);
    plot(t_list, x_sols, 'LineWidth', 1.5)
    legend('Forward Euler', 'Exact Solution', 'Location', 'best');
    hold off;
end