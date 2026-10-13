% plot local truncation errors (currently for explicit methods)
function plot_local_truncation(func, sol, t_ref, num_iter)
    arguments
        func (1,:) function_handle = @rate_func01
        sol (1,:) function_handle = @solution01;
        t_ref (1,:) double = 0.439
        num_iter (1,:) double = 100
    end

    X0 = sol(t_ref);
    h_list = logspace(-5,1,num_iter);
    explicit_midpoint_error = zeros(num_iter,1);
    forward_euler_error = zeros(num_iter, 1);
    implicit_midpoint_error = zeros(num_iter,1);
    backward_euler_error = zeros(num_iter, 1);
    solution_list = zeros(num_iter, 1);

    for i = 1:num_iter
        h = h_list(i);
        explicit_midpoint = explicit_midpoint_step(func, t_ref, X0, h);
        forward_euler = forward_euler_step(func, t_ref, X0, h); 
        implicit_midpoint = implicit_midpoint_step(func, t_ref, X0, h);
        backward_euler = backward_euler_step(func, t_ref, X0, h);

        x_true = sol(t_ref + h);
        solution_list(i) = norm(x_true);
        explicit_midpoint_error(i) = norm(explicit_midpoint - x_true);
        forward_euler_error(i) = norm(forward_euler - x_true);
        implicit_midpoint_error(i) = norm(implicit_midpoint - x_true);
        backward_euler_error(i) = norm(backward_euler - x_true);
    end

    %%%%%%% P-VALUE CALCULATION
    log_h_list = log10(h_list)';
    
    % solution p-value calculation
    log_solution_list = log10(solution_list);
    solution_coeff = polyfit(log_h_list, log_solution_list, 1);

    % Explicit Midpoint p-value calculation
    log_explicit_midpoint_error = log10(explicit_midpoint_error);
    explicit_midpoint_coeff = polyfit(log_h_list, log_explicit_midpoint_error, 1);

    % Forward Euler p-value calculation
    log_forward_euler_error = log10(forward_euler_error);
    forward_euler_coeff = polyfit(log_h_list, log_forward_euler_error, 1);
    
    % % % Implicit Midpoint p-value calculation
    log_implicit_midpoint_error = log10(implicit_midpoint_error);
    implicit_midpoint_coeff = polyfit(log_h_list, log_implicit_midpoint_error, 1);

    % Backward Euler p-value calculation
    log_backward_euler_error = log10(backward_euler_error);
    backward_euler_coeff = polyfit(log_h_list, log_backward_euler_error, 1);

    % % P-VALUES
    solution_p = solution_coeff(1)
    forward_p = forward_euler_coeff(1)
    backward_p = backward_euler_coeff(1)
    explicit_p = explicit_midpoint_coeff(1)
    implicit_p = implicit_midpoint_coeff(1)

    % % FIT LINE CODE
    % explicit_midpoint_fit = 10.^polyval(explicit_midpoint_coeff, log_h_list);
    % forward_euler_fit = 10.^polyval(forward_euler_coeff, log_h_list);

    %%%%%%% FIT LINE PLOTS
    % figure(1)
    % loglog(10.^log_h_list, explicit_midpoint_fit, '-', 'Linewidth', 2, 'Color', [0.5 1 0.5], 'Displayname',"Exp. Mid. Fit");
    % hold on;
    % grid on;
    % loglog(10.^log_h_list, forward_euler_fit, '-', 'Linewidth', 2, 'Color', [1 0.5 0.5], 'Displayname',"Forw. Euler Fit");
    % 
    % %%%%%%% STEP SIZE PLOTS
    % loglog(h_list, explicit_midpoint_error, '.', 'markersize', 7, 'Color', [0 0.5 0], 'Displayname',"Explicit Midpoint");
    % hold on;
    % grid on
    % loglog(h_list, forward_euler_error, '.', 'markersize', 7, 'Color', [0.5 0 0], 'Displayname',"Forward Euler");
    % % loglog(h_list, implicit_midpoint_error, '.', 'markersize', 7, 'Color', [0 0.5 0],'Displayname',"Implicit Midpoint");
    % % loglog(h_list, backward_euler_error, '.', 'markersize', 7, 'Color', [0.5 0 0],'Displayname',"Backward Euler");
    % 
    % 
    % title('Local Trunction Error $\epsilon$ for Explicit Methods vs Timesteps', 'Interpreter', 'Latex', 'FontSize',18);
    % legend('Location','northwest', 'Interpreter', 'Latex','FontSize',12);
    % xlabel("Step size $h$ (-)", 'Interpreter', 'Latex','FontSize',16);
    % ylabel("Local Truncation Error $\epsilon$ (-)", 'Interpreter', 'Latex','FontSize',16);
    % set(gca,"TickLabelInterpreter",'latex');
    % fontsize(scale=1.5)  
   
end