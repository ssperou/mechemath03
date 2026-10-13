function plot_global_truncation(func,sol, t_span, num_iter)
    arguments
        func (1,:) function_handle = @rate_func01
        sol (1,:) function_handle = @solution01
        t_span (1,:) double = [0, 20]
        num_iter (1,:) double = 100
    end

    X0 = sol(t_span(1));
    h_list = logspace(-5,0,num_iter);
    explicit_midpoint_error = zeros(num_iter,1);
    forward_euler_error = zeros(num_iter, 1);

    implicit_midpoint_error = zeros(num_iter,1);
    backward_euler_error = zeros(num_iter,1);

    for i = 1:num_iter
        h = h_list(i);
        [~, explicit_midpoint_list] = explicit_midpoint_fixed_step_integration(func, t_span, X0, h);
        [~, forward_euler_list] = forward_euler_fixed_step_integration(func, t_span, X0, h);    
        [~, backward_euler_list, ~, ~] = fixed_step_integration(func, 'Backward Euler', t_span, X0, h);    
        [~, implicit_midpoint_list,~,~] = fixed_step_integration(func, 'Implicit Midpoint', t_span, X0, h);  

        x_true = sol(t_span(end));
        explicit_midpoint_error(i) = norm(explicit_midpoint_list(end) - x_true);
        forward_euler_error(i) = norm(forward_euler_list(end) - x_true);
        backward_euler_error(i) = norm(backward_euler_list(end) - x_true);
        implicit_midpoint_error(i) = norm(implicit_midpoint_list(end) - x_true);
    end

    
    log_h_list = log10(h_list)';

    % explicit method fit line
    log_explicit_midpoint_error = log10(explicit_midpoint_error);
    explicit_midpoint_p = polyfit(log_h_list, log_explicit_midpoint_error, 1);
    explicit_midpoint_fit = 10.^polyval(explicit_midpoint_p, log_h_list);

    % Forward Euler fit line
    log_forward_euler_error = log10(forward_euler_error);
    forward_euler_p = polyfit(log_h_list, log_forward_euler_error, 1);
    forward_euler_fit = 10.^polyval(forward_euler_p, log_h_list);

    % implicit method fit line
    log_implicit_midpoint_error = log10(implicit_midpoint_error);
    implicit_midpoint_p = polyfit(log_h_list, log_implicit_midpoint_error, 1);
    implicit_midpoint_fit = 10.^polyval(implicit_midpoint_p, log_h_list);

    % Backward Euler fit line
    log_backward_euler_error = log10(backward_euler_error);
    backward_euler_p = polyfit(log_h_list, log_backward_euler_error, 1);
    backward_euler_fit = 10.^polyval(backward_euler_p, log_h_list);

    % plot the figure
    clf()
    figure(1)

    % plot fit lines
    loglog(10.^log_h_list, explicit_midpoint_fit, '--', 'Linewidth', 1.5, 'Color', [0.5 1 0.5], 'Displayname',"Exp. Mid. Fit");
    hold on; % call hold on after calling loglog
    loglog(10.^log_h_list, forward_euler_fit, '--', 'Linewidth', 1.5, 'Color', [1 0.5 0.5], 'Displayname',"Forw. Euler Fit");
    loglog(10.^log_h_list, implicit_midpoint_fit, '-', 'Linewidth', 1.5, 'Color', [0.5 0.5 1], 'Displayname',"Imp. Mid Fit");
    loglog(10.^log_h_list, backward_euler_fit, '-', 'Linewidth', 1.5, 'Color', [.75 0.5 1], 'Displayname',"Back. Euler Fit");

    % plot error points
    loglog(h_list, explicit_midpoint_error, 'o', 'Linewidth', 1, 'Color', [0 0.5 0], 'Displayname',"Explicit Midpoint");
    loglog(h_list, forward_euler_error, 'o', 'Linewidth', 1, 'Color', [0.5 0 0], 'Displayname',"Forward Euler");
    loglog(h_list, implicit_midpoint_error, '.', 'Linewidth', 1.5, 'Color', [0.3 0 0.5],'Displayname',"Implicit Midpoint");
    loglog(h_list, backward_euler_error, '.', 'Linewidth', 1.5, 'Color', [0 0 0.5],'Displayname',"Backward Euler");
    
    % plot styling
    title('Global Trunction Error against Timestep Size', 'Interpreter', 'Latex', 'FontSize',18);
    legend('Location','northwest', 'Interpreter', 'Latex','FontSize',12);
    xlabel("Step size (h)", 'Interpreter', 'Latex','FontSize',16);
    ylabel("Measured LT error", 'Interpreter', 'Latex','FontSize',16);
    set(gca,"TickLabelInterpreter",'latex');
end