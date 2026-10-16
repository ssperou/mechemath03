function plot_global_truncation(step_func, var_test, rate_func, sol, t_span, num_iter)
    arguments
        step_func (1,:) string
        var_test (1,:) string = "Step Size"
        rate_func (1,:) function_handle = @rate_func02
        sol (1,:) function_handle = @solution02
        t_span (1,:) double = [0, 20]
        num_iter (1,:) double = 100
    end

    X0 = sol(t_span(1));
    h_list = logspace(-5,-3,num_iter);
    log_h_list = log10(h_list)';
    iter = 0;
    
    clf
    figure(1)

    if any(contains(step_func, "Explicit Methods"))
        explicit_midpoint_error = zeros(num_iter,1);
        explicit_evals = zeros(num_iter,1);

        forward_evals = zeros(num_iter,1);
        forward_euler_error = zeros(num_iter, 1);

          for i = 1:num_iter
            h = h_list(i);
            [~, explicit_midpoint_list, ~, explicit_iter] = explicit_midpoint_fixed_step_integration(rate_func, t_span, X0, h);
            [~, forward_euler_list, ~, forward_iter] = forward_euler_fixed_step_integration(rate_func, t_span, X0, h);
            
            % calculate error
            x_true = sol(t_span(end));
            explicit_midpoint_error(i) = norm(explicit_midpoint_list(end,:).' - x_true);
            forward_euler_error(i) = norm(forward_euler_list(end,:).' - x_true);

            % save iterations
            explicit_evals(i) = explicit_iter;
            forward_evals(i) = forward_iter;
            iter = iter+1
          end

        if var_test == "Fun Count"
            % fun count p-values
            log_explicit_evals = log10(explicit_evals);
            explicit_midpoint_eval_slope = polyfit(log_explicit_evals, log_explicit_midpoint_error, 1);
            log_forward_evals = log10(forward_evals);
            forward_euler_eval_slope = polyfit(log_forward_evals, log_forward_euler_error, 1);
    
            %%%%%% FUN COUNT FIT LINE CODE
            % Explicit Midpoint fit line
            log_explicit_evals = log10(explicit_evals(1:90));
            log_explicit_midpoint_error = log10(explicit_midpoint_error(1:90));
            explicit_midpoint_slope = polyfit(log_explicit_evals, log_explicit_midpoint_error, 1);
            explicit_midpoint_fit = 10.^polyval(explicit_midpoint_slope, log_explicit_evals);

            % Forward Euler fit line
            log_forward_evals = log10(forward_evals(1:90));
            log_forward_euler_error = log10(forward_euler_error(1:90));
            forward_euler_slope = polyfit(log_forward_evals, log_forward_euler_error, 1);
            forward_euler_fit = 10.^polyval(forward_euler_slope, log_forward_evals);
    
            loglog(explicit_evals(1:90), explicit_midpoint_fit, '-', 'Linewidth', 2, 'Color', [0.5 1 0.5], 'Displayname',"Exp. Mid. Fit");
            hold on;
            loglog(forward_evals(1:90), forward_euler_fit, '-', 'Linewidth', 2, 'Color', [1 0.5 0.5], 'Displayname',"Forw. Euler Fit");
        
        elseif var_test == "Step Size"
            log_explicit_midpoint_error = log10(explicit_midpoint_error);
            explicit_midpoint_step_slope = polyfit(log_h_list, log_explicit_midpoint_error, 1);
            explicit_midpoint_fit = 10.^polyval(explicit_midpoint_slope, log_h_list);
            log_forward_euler_error = log10(forward_euler_error);
            forward_euler_step_slope = polyfit(log_h_list, log_forward_euler_error, 1);
            forward_euler_fit = 10.^polyval(forward_euler_p, log_h_list);
    
    
            loglog(h_list(1:90), explicit_midpoint_fit, '-', 'Linewidth', 2, 'Color', [0.5 1 0.5], 'Displayname',"Exp. Mid. Fit");
            hold on; % call hold on after calling loglog
            loglog(h_list(1:90), forward_euler_fit, '-', 'Linewidth', 2, 'Color', [1 0.5 0.5], 'Displayname',"Forw. Euler Fit");
            loglog(h_list, explicit_midpoint_error, 'o', 'Color', [0 0.5 0], 'Displayname',"Explicit Midpoint");
            loglog(h_list, forward_euler_error, 'o', 'Color', [0.5 0 0], 'Displayname',"Forward Euler");
        
            % plot styling
            title('Global Truncation Error $\epsilon$ against Timestep Size $h$', 'Interpreter', 'Latex', 'FontSize',18);
            legend('Location','northwest', 'Interpreter', 'Latex','FontSize',12);
            xlabel("Step size $h$ (-)", 'Interpreter', 'Latex','FontSize',16);
            ylabel("Global Truncation Error $\epsilon$ (-)", 'Interpreter', 'Latex','FontSize',16);
            set(gca,"TickLabelInterpreter",'latex');
            fontsize(scale=1.5)
            end

    elseif step_func == "Implicit Midopint"
        implicit_midpoint_error = zeros(num_iter,1);
        implicit_evals = zeros(num_iter,1);
        
        for i = 1:num_iter
            h = h_list(i);
            [~, implicit_midpoint_list,~, implicit_iter] = fixed_step_integration(rate_func, 'Implicit Midpoint', t_span, X0, h);  
            
            % calculate error
            x_true = sol(t_span(end));
            implicit_midpoint_error(i) = norm(implicit_midpoint_list(end,:).' - x_true);
            
            % save iterations
            implicit_evals(i) = implicit_iter;
            iter = iter+1
        end

        if var_test == "Fun Count"
        elseif var_test == "Step Size"
        %%%%%%% STEP SIZE P-VALUE CALCULATIONS
    
        % Implicit Midpoint p-value calculation
        log_implicit_midpoint_error = log10(implicit_midpoint_error);
        implicit_midpoint_slope = polyfit(log_h_list, log_implicit_midpoint_error, 1);
        %implicit_midpoint_fit = 10.^polyval(implicit_midpoint_slope, log_h_list);
    
    elseif step_func == "Backward Euler"
        backward_euler_error = zeros(num_iter,1);
        backward_evals = zeros(num_iter,1);
    
        for i = 1:num_iter        
            [~, backward_euler_list, ~, backward_iter] = fixed_step_integration(rate_func, 'Backward Euler', t_span, X0, h);    
    
            % calculate error
            x_true = sol(t_span(end));
            backward_euler_error(i) = norm(backward_euler_list(end,:).' - x_true);
    
            % save iterations
            backward_evals(i) = backward_iter;
            iter = iter+1
        end

        %%%%%%% STEP SIZE P-VALUE CALCULATIONS
        log_h_list = log10(h_list)';
        log_backward_euler_error = log10(backward_euler_error);
        backward_euler_coeff = polyfit(log_h_list, log_backward_euler_error, 1);
    end

    %%%% FIT LINE CODE
    % %backward_euler_fit = 10.^polyval(backward_euler_p, log_h_list);
    
    %%%%%%% FUN COUNT P-VALUES
    %fit_range = 
    % % % Implicit Midpoint p-value calculation
    % log_implicit_midpoint_evals = log10(implicit_evals);
    % log_implicit_midpoint_error = log10(implicit_midpoint_error);
    % implicit_midpoint_coeff = polyfit(log_implicit_midpoint_evals, log_implicit_midpoint_error, 1);
    % % Backward Euler p-value calculation
    % log_backward_euler_evals = log10(backward_evals);
    % log_backward_euler_error = log10(backward_euler_error);
    % backward_euler_coeff = polyfit(log_backward_euler_evals, log_backward_euler_error, 1);
    

    if var_test == "Fun Count"
        %%%%%%% RATE CALL PLOTS
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

    elseif var_test == "Step Size"
        %%%%%%%% STEP SIZE PLOTS
        hold on; % call hold on after calling loglog
        % loglog(h_list, implicit_midpoint_error, '.', 'Color', [0 0.5 0],'Displayname',"Implicit Midpoint");
        % loglog(h_list, backward_euler_error, '.', 'Color', [0.5 0 0],'Displayname',"Backward Euler");
    
        % plot styling
        title('Global Truncation Error $\epsilon$ against Timestep Size $h$', 'Interpreter', 'Latex', 'FontSize',18);
        legend('Location','northwest', 'Interpreter', 'Latex','FontSize',12);
        xlabel("Step size $h$ (-)", 'Interpreter', 'Latex','FontSize',16);
        ylabel("Global Truncation Error $\epsilon$ (-)", 'Interpreter', 'Latex','FontSize',16);
        set(gca,"TickLabelInterpreter",'latex');
        fontsize(scale=1.5)
    
    end
end