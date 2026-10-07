function [error_list, h_list] = local_truncation_error(method, func, sol)
    t_ref = 0.439;
    X0 = sol(t_ref);
    num_iter = 100;
    h_list = logspace(-5,1,num_iter);
    error_list = zeros(num_iter,1);

    for i = 1:num_iter
        h = h_list(i);
        if method == "Midpoint"
            x = explicit_midpoint_step( ...
                func, t_ref, X0, h);
        elseif method == "Euler"
            x = forward_euler_step( ...
                func, t_ref, X0, h);
        end        

        x_true = sol(t_ref + h);
        error_list(i) = norm(x - x_true)

    end

    % loglog(h_list, error_list)
    
end