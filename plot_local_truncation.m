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

    for i = 1:num_iter
        h = h_list(i);
        x_midpoint = explicit_midpoint_step(func, t_ref, X0, h);
        x_euler = forward_euler_step(func, t_ref, X0, h);    

        x_true = sol(t_ref + h);
        explicit_midpoint_error(i) = norm(x_midpoint - x_true);
        forward_euler_error(i) = norm(x_euler - x_true);

    end


    % explicit method fit line
    log_h_list = log10(h_list)';
    log_explicit_midpoint_error = log10(explicit_midpoint_error);

    explicit_midpoint_p = polyfit(log_h_list, log_explicit_midpoint_error, 1);
    explicit_midpoint_yfit = 10.^polyval(explicit_midpoint_p, log_h_list);

    % Forward Euler fit line
    log_forward_euler_error = log10(forward_euler_error);

    forward_euler_p = polyfit(log_h_list, log_forward_euler_error, 1);
    forward_euler_yfit = 10.^polyval(forward_euler_p, log_h_list);
    


    % plot
    figure(1)
    loglog(10.^log_h_list, explicit_midpoint_yfit, '-', 'Linewidth', 1.5, 'Color', [0.5 1 0.5], 'Displayname',"Exp. Mid. Fit");
    hold on;
    loglog(10.^log_h_list, forward_euler_yfit, '-', 'Linewidth', 1.5, 'Color', [1 0.5 0.5], 'Displayname',"Forw. Euler Fit");
    loglog(h_list, explicit_midpoint_error, '.', 'Linewidth', 1.5, 'Color', [0 0.5 0], 'Displayname',"Explicit Midpoint");
    loglog(h_list, forward_euler_error, '.', 'Linewidth', 1.5, 'Color', [0.5 0 0], 'Displayname',"Forward Euler");

    
    title('Local Trunction Error against Timestep Size', 'Interpreter', 'Latex', 'FontSize',18);
    legend('Location','northwest', 'Interpreter', 'Latex','FontSize',12);
    xlabel("Step size (h)", 'Interpreter', 'Latex','FontSize',16);
    ylabel("Measured LT error", 'Interpreter', 'Latex','FontSize',16);
    set(gca,"TickLabelInterpreter",'latex');


   
   
end