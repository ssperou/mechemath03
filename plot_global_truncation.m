function plot_global_truncation(func, sol, t_span, num_iter)
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
    explicit_evals = zeros(num_iter,1);
    forward_evals = zeros(num_iter,1);
    backward_evals = zeros(num_iter,1);
    implicit_evals = zeros(num_iter,1);

    iter = 0;
    for i = 1:num_iter
        h = h_list(i);
        [~, explicit_midpoint_list, ~, explicit_iter] = explicit_midpoint_fixed_step_integration(func, t_span, X0, h);
        [~, forward_euler_list, ~, forward_iter] = forward_euler_fixed_step_integration(func, t_span, X0, h);    
        [~, implicit_midpoint_list,~, implicit_iter] = fixed_step_integration(func, 'Implicit Midpoint', t_span, X0, h);  
        [~, backward_euler_list, ~, backward_iter] = fixed_step_integration(func, 'Backward Euler', t_span, X0, h);    

        % calculate error
        x_true = sol(t_span(end));
        explicit_midpoint_error(i) = norm(explicit_midpoint_list(end) - x_true);
        forward_euler_error(i) = norm(forward_euler_list(end) - x_true);
        implicit_midpoint_error(i) = norm(implicit_midpoint_list(end) - x_true);
        backward_euler_error(i) = norm(backward_euler_list(end) - x_true);

        % save iterations
        explicit_evals(i) = explicit_iter;
        forward_evals(i) = forward_iter;
        implicit_evals(i) = implicit_iter;
        backward_evals(i) = backward_iter;
        iter = iter+1
    end

    %%%%%%% STEP SIZE P-VALUE CALCULATIONS
    log_h_list = log10(h_list)';

    % Explicit Midpoint p-value calculation
    % log_explicit_midpoint_error = log10(explicit_midpoint_error);
    % explicit_midpoint_coeff = polyfit(log_h_list, log_explicit_midpoint_error, 1);
    % % Forward Euler p-value calculation
    % log_forward_euler_error = log10(forward_euler_error);
    % forward_euler_coeff = polyfit(log_h_list, log_forward_euler_error, 1);
    % % % Implicit Midpoint p-value calculation
    % log_implicit_midpoint_error = log10(implicit_midpoint_error);
    % implicit_midpoint_coeff = polyfit(log_h_list, log_implicit_midpoint_error, 1);
    % % Backward Euler p-value calculation
    % log_backward_euler_error = log10(backward_euler_error);
    % backward_euler_coeff = polyfit(log_h_list, log_backward_euler_error, 1);

    %%%% FIT LINE CODE
    %explicit_midpoint_fit = 10.^polyval(explicit_midpoint_p, log_h_list);
    %forward_euler_fit = 10.^polyval(forward_euler_p, log_h_list);
    %implicit_midpoint_fit = 10.^polyval(implicit_midpoint_p, log_h_list);
    % %backward_euler_fit = 10.^polyval(backward_euler_p, log_h_list);
    
    %%%%%%% FUN COUNT P-VALUES
    % Explicit Midpoint p-value calculation
    log_explicit_midpoint_error = log10(explicit_midpoint_error);
    explicit_midpoint_coeff = polyfit(explicit_evals, log_explicit_midpoint_error, 1);
    % Forward Euler p-value calculation
    log_forward_euler_error = log10(forward_euler_error);
    forward_euler_coeff = polyfit(forward_evals, log_forward_euler_error, 1);
    % % Implicit Midpoint p-value calculation
    log_implicit_midpoint_error = log10(implicit_midpoint_error);
    implicit_midpoint_coeff = polyfit(implicit_evals, log_implicit_midpoint_error, 1);
    % Backward Euler p-value calculation
    log_backward_euler_error = log10(backward_euler_error);
    backward_euler_coeff = polyfit(backward_evals, log_backward_euler_error, 1);
    
    %%%% PRINT P-VALUES
    forward_p = forward_euler_coeff(1)
    backward_p = backward_euler_coeff(1)
    explicit_p = explicit_midpoint_coeff(1)
    implicit_p = implicit_midpoint_coeff(1)

    %%%%%%% FUN COUNT FIT LINE CODE
    % % Explicit Midpoint fit line
    % log_explicit_evals = log10(explicit_evals(1:90));
    % log_explicit_midpoint_error = log10(explicit_midpoint_error(1:90));
    % explicit_midpoint_coeff = polyfit(log_explicit_evals, log_explicit_midpoint_error, 1);
    % explicit_midpoint_fit = 10.^polyval(explicit_midpoint_coeff, log_explicit_evals);
    % 
    % % Forward Euler fit line
    % log_forward_evals = log10(forward_evals(1:90));
    % log_forward_euler_error = log10(forward_euler_error(1:90));
    % forward_euler_coeff = polyfit(log_forward_evals, log_forward_euler_error, 1);
    % forward_euler_fit = 10.^polyval(forward_euler_coeff, log_forward_evals);



    %%%%%%%%%% PLOTTING SCHEMING PLANNING FOILING
    % clf()
    % figure(1)
    
    %%%%%%%% FIT LINE PLOTS
    % loglog(explicit_evals(1:90), explicit_midpoint_fit, '-', 'Linewidth', 2, 'Color', [0.5 1 0.5], 'Displayname',"Exp. Mid. Fit");
    % hold on;
    % loglog(forward_evals(1:90), forward_euler_fit, '-', 'Linewidth', 2, 'Color', [1 0.5 0.5], 'Displayname',"Forw. Euler Fit");
    % % % loglog(10.^log_h_list, implicit_midpoint_fit, '-', 'Linewidth', 1, 'Color', [0.5 0.5 1], 'Displayname',"Imp. Mid Fit");
    % % % loglog(10.^log_h_list, backward_euler_fit, '-', 'Linewidth', 1, 'Color', [.75 0.5 1], 'Displayname',"Back. Euler Fit");

    %%%%%%%% STEP SIZE PLOTS
    % loglog(h_list, explicit_midpoint_error, 'o', 'Color', [0 0.5 0], 'Displayname',"Explicit Midpoint");
    % hold on; % call hold on after calling loglog
    % loglog(h_list, forward_euler_error, 'o', 'Color', [0.5 0 0], 'Displayname',"Forward Euler");
    % % loglog(h_list, implicit_midpoint_error, '.', 'Color', [0 0.5 0],'Displayname',"Implicit Midpoint");
    % % loglog(h_list, backward_euler_error, '.', 'Color', [0.5 0 0],'Displayname',"Backward Euler");
    % 
    % % plot styling
    % title('Global Truncation Error $\epsilon$ against Timestep Size $h$', 'Interpreter', 'Latex', 'FontSize',18);
    % legend('Location','northwest', 'Interpreter', 'Latex','FontSize',12);
    % xlabel("Step size $h$ (-)", 'Interpreter', 'Latex','FontSize',16);
    % ylabel("Global Truncation Error $\epsilon$ (-)", 'Interpreter', 'Latex','FontSize',16);
    % set(gca,"TickLabelInterpreter",'latex');
    % fontsize(scale=1.5)
    % 
    %%%%%%%% RATE CALL PLOTS
    loglog(explicit_evals, explicit_midpoint_error, '.', 'Color', [0 0.5 0], 'Displayname',"Explicit Midpoint");
    hold on; % call hold on after calling loglog
    loglog(forward_evals, forward_euler_error, '.', 'Color', [0.5 0 0], 'Displayname',"Forward Euler");
    % loglog(implicit_evals, implicit_midpoint_error, '.', 'Color', [0 0.5 0],'Displayname',"Implicit Midpoint");
    % loglog(backward_evals, backward_euler_error, '.', 'Color', [0.5 0 0],'Displayname',"Backward Euler");

    % plot styling
    title('Global Truncation Error $\epsilon$ vs Function Calls for Explicit Methods', 'Interpreter', 'Latex', 'FontSize',18);
    legend('Location','northeast', 'Interpreter', 'Latex','FontSize',16);
    xlabel("Number of Rate Function Calls", 'Interpreter', 'Latex','FontSize',16);
    ylabel("Global Truncation Error $\epsilon$ (-)", 'Interpreter', 'Latex','FontSize',16);
    set(gca,"TickLabelInterpreter",'latex');
    fontsize(scale=1)
end