function plot_global_truncation(func,sol, t_span, num_iter)
    arguments
        func (1,:) function_handle = @rate_func01
        sol (1,:) function_handle = @solution01
        t_span (1,:) double = [0, 40]
        num_iter (1,:) double = 100
    end

    X0 = sol(t_span(1));
    h_list = logspace(-5,1,num_iter);
    explicit_midpoint_error = zeros(num_iter,1);
    forward_euler_error = zeros(num_iter, 1);

    implicit_midpoint_error = zeros(num_iter,1);
    backward_euler_error = zeros(num_iter,1);

    for i = 1:num_iter
        h = h_list(i);
        % [~, explicit_midpoint_list] = explicit_midpoint_fixed_step_integration(func, t_span, X0, h);
        % [~, forward_euler_list] = forward_euler_fixed_step_integration(func, t_span, X0, h);    
        % 
        [~, backward_euler_list, ~, ~] = fixed_step_integration(func, 'Backward Euler', t_span, X0, h);    
        [~, implicit_midpoint_list,~,~] = fixed_step_integration(func, 'Implicit Midpoint', t_span, X0, h);  

        x_true = sol(t_span(end));
        % explicit_midpoint_error(i) = norm(explicit_midpoint_list(end) - x_true);
        % forward_euler_error(i) = norm(forward_euler_list(end) - x_true);

        backward_euler_error(i) = norm(backward_euler_list(end) - x_true);
        implicit_midpoint_error(i) = norm(implicit_midpoint_list(end) - x_true);
    end

    % % explicit method fit line
    % log_h_list = log10(h_list)';
    % log_explicit_midpoint_error = log10(explicit_midpoint_error);
    % explicit_midpoint_p = polyfit(log_h_list(1:75), log_explicit_midpoint_error(1:75), 1);
    % explicit_midpoint_yfit = 10.^polyval(explicit_midpoint_p, log_h_list);
    % 
    % % Forward Euler fit line
    % log_forward_euler_error = log10(forward_euler_error);
    % forward_euler_p = polyfit(log_h_list(1:75), log_forward_euler_error(1:75), 1);
    % forward_euler_yfit = 10.^polyval(forward_euler_p, log_h_list);
    % 
    figure(1)
    hold on;
    % loglog(10.^log_h_list(1:75), explicit_midpoint_yfit(1:75), '-', 'Linewidth', 1.5, 'Color', [0.5 1 0.5], 'Displayname',"Exp. Mid. Fit");
    % hold on;
    % loglog(10.^log_h_list(1:77), forward_euler_yfit(1:77), '-', 'Linewidth', 1.5, 'Color', [1 0.5 0.5], 'Displayname',"Forw. Euler Fit");
    
    
    % loglog(h_list, explicit_midpoint_error, '.', 'Linewidth', 1.5, 'Color', [0 0.5 0], 'Displayname',"Explicit Midpoint");
    % loglog(h_list, forward_euler_error, '.', 'Linewidth', 1.5, 'Color', [0.5 0 0], 'Displayname',"Forward Euler");
    loglog(h_list, backward_euler_error, '.', 'Linewidth', 1.5, 'Displayname',"Backward Euler");
    loglog(h_list, implicit_midpoint_error, '.', 'Linewidth', 1.5, 'Displayname',"Implicit Midpoint");
    
    title('Global Trunction Error against Timestep Size', 'Interpreter', 'Latex', 'FontSize',18);
    legend('Location','northwest', 'Interpreter', 'Latex','FontSize',12);
    xlabel("Step size (h)", 'Interpreter', 'Latex','FontSize',16);
    ylabel("Measured LT error", 'Interpreter', 'Latex','FontSize',16);
    set(gca,"TickLabelInterpreter",'latex');
end