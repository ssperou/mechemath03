function [outputArg1,outputArg2] = local_truncation_error(method, func)

      if method == "Midpoint"
        [t_list,X_list] = explicit_midpoint_fixed_step_integration( ...
            func, [0,10],1,0.2);
     elseif method == "Euler"
        [t_list,X_list] = forward_euler_fixed_step_integration( ...
            func, [0,40],1,.41);
end